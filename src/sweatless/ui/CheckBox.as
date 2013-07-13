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
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.ui {

	import sweatless.graphics.SmartRectangle;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CheckBox extends Sprite{
		
		private var fill : SmartRectangle;
		private var background : SmartRectangle;
		private var clicked : Boolean;
		
		private var _width : Number = 0;
		private var _height : Number = 0;
		
		public function CheckBox(){
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		private function create(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			background = new SmartRectangle();
			addChild(background);
			
			fill = new SmartRectangle();
			addChild(fill);
			fill.visible = false;
		}

		private function click(evt:MouseEvent):void{
			clicked = fill.visible = clicked ? false : true;
		}

		public function addListeners():void{
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, click);
		}

		public function removeListeners():void{
			buttonMode = false;
			
			removeEventListener(MouseEvent.CLICK, click);
		}

		public function get value():Boolean{
			return clicked;
		}
		
		public function set backgroundColor(p_value:uint):void{
			background.colors = [p_value, p_value];
		}
		
		public function set fillColor(p_value:uint):void{
			fill.colors = [p_value, p_value];
		}
		
		override public function set width(p_value:Number):void{
			background.width = _width = p_value;
			
			fill.width = p_value/2;
			fill.x = (background.width-fill.width)/2;
		}
		
		override public function set height(p_value:Number):void{
			background.height = _height = p_value;
			
			fill.height = p_value/2;
			fill.y = (background.height-fill.height)/2;
		}
		
		override public function get width():Number{
			return _width;
		}
		
		override public function get height():Number{
			return _height;
		}
		
		public function destroy():void{
			removeListeners();
			
			fill.destroy();
			background.destroy();
		}
	}
}

