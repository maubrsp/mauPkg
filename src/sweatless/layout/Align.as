/**
 * Licensed under the MIT License and Creative Commons 3.0 BY-SA
 *
 * Copyright (c) 2009 Sweatless Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.opensource.org/licenses/mit-license.php
 *
 * THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC
 * LICENSE ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW.
 * ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS
 * PROHIBITED.
 * BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE
 * TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE
 * LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH
 * TERMS AND CONDITIONS.
 *
 * http://creativecommons.org/licenses/by-sa/3.0/legalcode
 *
 * http://www.sweatless.as/
 *
 * Original class by Pedro Moraes (http://pedromoraes.net/)
 * Thanks a lot dudes!
 *
 */
package sweatless.layout {

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class Align {
		public static const NONE : int = 0;
		public static const TOP : int = 1;
		public static const MIDDLE : int = 2;
		public static const BOTTOM : int = 4;
		public static const LEFT : int = 8;
		public static const CENTER : int = 16;
		public static const RIGHT : int = 32;
		private static const H : String = 'h';
		private static const V : String = 'v';
		private static var targets : Dictionary = new Dictionary(true);
		private static var stage : Stage;

		public static function add(object : *, anchors : uint, params : Object = null) : void {
			if (object is Array) {
				for each (var obj : Object in object) {
					add(obj, anchors, params);
				}
			} else {
				targets[object] = new RuleSet(object, anchors, params || new Object());

				if (!stage) {
					if (object.stage) {
						stage = object.stage;
						init();
					} else {
						object.addEventListener(Event.ADDED_TO_STAGE, init);
					}
				} else {
					place(object, targets[object]);
				}
			}
		}

		public static function remove(object : *, ... rest : Array) : void {
			if (object is Array) {
				object.forEach(remove);
			} else {
				delete targets[object];
			}
		}

		private static function getValue(value : *, axis : String) : Number {
			if (value == undefined) {
				return 0;
			} else if (typeof value == 'string' && String(value).indexOf('%') > -1) {
				switch(axis) {
					case V:
						return stage.stageHeight * parseInt(value) / 100;
					case H:
						return stage.stageWidth * parseInt(value) / 100;
				}
			}
			return Number(value);
		}

		public static function getStageBox() : Rectangle {
			if (!stage) {
				return null;
			} else {
				return new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
		}

		public static function place(object : DisplayObject, ... rest : Array) : void {
			if (!stage) {
				if (object.stage) {
					stage = object.stage;
				} else {
					var placeCb : Function = function(pEvt : Event) : void {
						init(pEvt);
						place(object, new RuleSet(object, rest[0], rest[1] || new Object()));
						object.removeEventListener(Event.ADDED_TO_STAGE, placeCb);
					};
					object.addEventListener(Event.ADDED_TO_STAGE, placeCb);
					return;
				}
			}

			var ruleSet : RuleSet;

			if (rest[0] is RuleSet) {
				ruleSet = rest[0];
			} else {
				ruleSet = new RuleSet(object, rest[0], rest[1] || new Object());
			}

			var boundingBox : Rectangle = ruleSet.box || getStageBox();

			var sw : Number = boundingBox.width;
			var sh : Number = boundingBox.height;
			var sw2 : Number = sw * .5;
			var sh2 : Number = sh * .5;

			var x : Number = boundingBox.x + getValue(ruleSet.margin_left, H) - getValue(ruleSet.margin_right, H);
			var y : Number = boundingBox.y + getValue(ruleSet.margin_top, V) - getValue(ruleSet.margin_bottom, V);

			if (ruleSet.resizeH) {
				object.width = getValue(ruleSet.width, H);
			}
			if (ruleSet.resizeV) {
				object.height = getValue(ruleSet.height, V);
			}

			switch(ruleSet.h) {
				case CENTER:
					x += sw2 - ruleSet.width / 2;
					break;
				case RIGHT:
					x += sw - ruleSet.width;
					break;
				case NONE:
					x += object.x;
			}

			switch(ruleSet.v) {
				case MIDDLE:
					y += sh2 - ruleSet.height / 2;
					break;
				case BOTTOM:
					y += sh - ruleSet.height;
					break;
				case NONE:
					y += object.y;
			}

			x = ruleSet.constrainX(x);
			y = ruleSet.constrainY(y);

			object.x = x;
			object.y = y;
		}

		public static function debug() : String {
			var msg : String = "Align targets : ";
			for (var object : * in targets) {
				msg += '[ Object ' + object + ' ' + targets[object] + ' ], ';
			}
			return msg.substring(0, msg.length - 2);
		}

		private static function init(event : Event = null) : void {
			if (!stage) {
				stage = event.currentTarget.stage;
			}

			for (var object : * in targets) {
				object.removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			stage.addEventListener(Event.RESIZE, arrange);

			arrange();
		}

		private static function arrange(event : Event = null) : void {
			for (var object : * in targets) {
				place(object, targets[object]);
			}
		}
	}
}

import sweatless.layout.Align;

import flash.display.DisplayObject;
import flash.geom.Rectangle;

internal class RuleSet {
	public var h : int = 0;
	public var v : int = 0;
	public var width : * = 0;
	public var height : * = 0;
	public var margin_bottom : * = 0;
	public var margin_top : * = 0;
	public var margin_left : * = 0;
	public var margin_right : * = 0;
	public var max_x : Number;
	public var max_y : Number;
	public var min_y : Number;
	public var min_x : Number;
	public var resizeH : Boolean;
	public var resizeV : Boolean;
	public var box : Rectangle;
	public var rounded : Boolean = true;

	public function RuleSet(object : DisplayObject, anchors : int, params : Object) {
		v = match(anchors, Align.TOP, Align.MIDDLE, Align.BOTTOM);
		h = match(anchors, Align.LEFT, Align.CENTER, Align.RIGHT);

		for (var prop : String in params) {
			this[prop] = params[prop];
		}

		if (!params.ignore_dimensions) {
			width = (params.width == undefined) ? object.width : params.width;
			height = (params.height == undefined) ? object.height : params.height;
		}

		if (width) {
			resizeH = String(width).indexOf('%') > -1;
		}
		if (height) {
			resizeV = String(height).indexOf('%') > -1;
		}
	}

	public function constrainX(x : Number) : Number {
		if (!isNaN(max_x))
			x = Math.min(max_x, x);
		if (!isNaN(min_x))
			x = Math.max(min_x, x);
		if (rounded)
			x = Math.round(x);
		return x;
	}

	public function constrainY(y : Number) : Number {
		if (!isNaN(max_y))
			y = Math.min(max_y, y);
		if (!isNaN(min_y))
			y = Math.max(min_y, y);
		if (rounded)
			y = Math.round(y);
		return y;
	}

	public function toString() : String {
		var msg : String = '(Rules ';
		if (h)
			msg += getAnchorDescription(h) + ' ';
		if (v)
			msg += getAnchorDescription(v) + ' ';
		msg += ')';
		return msg;
	}

	private function getAnchorDescription(anchor : int) : String {
		switch(anchor) {
			case Align.TOP:
				return "top";
			case Align.MIDDLE:
				return "middle";
			case Align.BOTTOM:
				return "bottom";
			case Align.LEFT:
				return "left";
			case Align.CENTER:
				return "center";
			case Align.RIGHT:
				return "right";
		}
		return '';
	}

	private function match(value : int, ... options : Array) : int {
		var option : int;
		while (option = options.pop()) {
			if ((value & option) == option) {
				return option;
			}
		}
		return 0;
	}
}