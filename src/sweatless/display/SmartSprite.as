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

package sweatless.display {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 
	 * The <code>SmartSprite</code> is a substitute class for the native <code>Sprite</code> class. With dynamic registration points and a internal manager for <code>IEventDispatcher</code>.
	 * 
	 * @see Sprite
	 * @see IEventDispatcher
	 * 
	 */
	public class SmartSprite extends Sprite{
		
		private var _debug : Boolean;
		private var _anchors : Point;
		private var _temp : Point;
		private var listeners : Array;
		
		/**
		 * 
		 * Dynamic <code>Object</code> to store any temp values.
		 * @see Object
		 *  
		 */
		public var data : Object = new Object();
		
		/**
		 * Constant default value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const NONE : int = 0;
		/**
		 * Constant vertical value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const TOP : int = 1;
		/**
		 * Constant vertical value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const MIDDLE : int = 2;
		/**
		 * Constant vertical value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const BOTTOM : int = 4;
		/**
		 * Constant horizontal value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const LEFT : int = 8;
		/**
		 * Constant horizontal value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const CENTER : int = 16;
		/**
		 * Constant horizontal value to apply in the <code>SmartSprite</code> registration point <code>anchors</code>.
		 * @see int
		 * @see #anchors()
		 */
		public static const RIGHT : int = 32;

		/**
		 * 
		 * The <code>SmartSprite</code> is a substitute class for the native <code>Sprite</code> class. With dynamic registration points and a internal manager for <code>IEventDispatcher</code>.
		 * 
		 * @see Sprite
		 * @see IEventDispatcher
		 * 
		 */
		public function SmartSprite() {
			super();
			
			listeners = new Array();
			
			addEventListener(Event.ADDED, update);
			addEventListener(Event.ADDED_TO_STAGE, update);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_anchors = new Point();
			_temp = new Point(super.x, super.y);
		}
		
		/**
		 * Set the <code>anchors</code> of the <code>SmartSprite</code> to predefined registration point. 
		 * @default <code>SmartSprite.MIDDLE+SmartSprite.CENTER</code>
		 * @param p_anchors Adds horizontal, vertical or both predefined values to registration point. Valid values: SmartSprite.TOP, SmartSprite.CENTER, SmartSprite.LEFT, SmartSprite.MIDDLE, SmartSprite.RIGHT and SmartSprite.BOTTOM
		 * @see #NONE
		 * @see #TOP
		 * @see #LEFT
		 * @see #MIDDLE
		 * @see #CENTER
		 * @see #RIGHT
		 * @see #BOTTOM
		 * @example <listing version="3.0">
var smartsprite : SmartSprite = new SmartSprite();
addChild(smartsprite);

smartsprite.anchors(SmartSprite.BOTTOM+SmartSprite.CENTER);
 		 * </listing>
		 * 
		 */
		public function anchors(p_anchors:int=SmartSprite.MIDDLE+SmartSprite.CENTER):void{
			var p_x : Number = 0;
			var p_y : Number = 0;
			
			switch(match(p_anchors, LEFT, CENTER, RIGHT)){
				case CENTER:
					p_x = getBounds(this).width/2;
					break;
					
				case RIGHT:
					p_x = getBounds(this).width;
					break;
					
				case LEFT:
				case NONE:
					p_x = 0;
					break;
			}
			
			switch(match(p_anchors, TOP, MIDDLE, BOTTOM)){
				case MIDDLE:
					p_y = getBounds(this).height/2;
					break;
					
				case BOTTOM:
					p_y = getBounds(this).height;
					break;
				
				case TOP:
				case NONE:
					p_y = 0;
					break;
			}
			
			_anchors = new Point(p_x, p_y);
			update();
		}
		
		/**
		 * 
		 * Indicates the <code>x</code> coordinate of the <code>DisplayObject</code> instance relative to the local coordinates of the parent <code>DisplayObjectContainer</code>. The object's coordinates refer to the registration point position.
		 * @see Number
		 * 
		 */
		override public function get x():Number{
			return _temp.x;
		}

		override public function set x(p_value:Number):void{
			_temp.x = p_value;
			update();
		}
		
		/**
		 * 
		 * Indicates the <code>y</code> coordinate of the <code>DisplayObject</code> instance relative to the local coordinates of the parent <code>DisplayObjectContainer</code>. The object's coordinates refer to the registration point position.
		 * @see Number
		 * 
		 */
		override public function get y():Number{
			return _temp.y;
		}
		
		override public function set y(p_value:Number):void{
			_temp.y = p_value;
			update();
		}

		/**
		 * 
		 * Indicates the horizontal scale (percentage) of the object as applied from the registration point. The default registration point is (0,0). 1.0 equals 100% scale. Scaling the local coordinate system changes the <code>x</code> and <code>y</code> property values, which are defined in whole pixels.
		 * @see Number
		 * 
		 */
		override public function set scaleX(p_value:Number):void{
			super.scaleX = p_value;
			update();
		}

		/**
		 * 
		 * Indicates the vertical scale (percentage) of the object as applied from the registration point. The default registration point is (0,0). 1.0 equals 100% scale. Scaling the local coordinate system changes the <code>x</code> and <code>y</code> property values, which are defined in whole pixels.
		 * @see Number
		 * 
		 */
		override public function set scaleY(p_value:Number):void{
			super.scaleY = p_value;
			update();
		}
		
		/**
		 * 
		 * Indicates the <code>rotation</code> of the <code>DisplayObject</code> instance, in degrees, from its original orientation. Values from 0 to 180 represent clockwise rotation; values from 0 to -180 represent counterclockwise rotation. Values outside this range are added to or subtracted from 360 to obtain a value within the range. 
		 * For example, the statement <code>my_video.rotation = 450</code> is the same as <code>my_video.rotation = 90</code>.
		 * @see Number
		 * 
		 */
		override public function set rotation(p_value:Number):void{
			super.rotation = p_value;
			update();
		}
		
		/**
		 * 
		 * Indicates the <code>x</code> coordinate of the mouse position, in pixels.
		 * @see Number
		 * 
		 */
		override public function get mouseX():Number{
			return Math.round(super.mouseX - _anchors.x);
		}
		
		/**
		 * 
		 * Indicates the <code>y</code> coordinate of the mouse position, in pixels.
		 * @see Number
		 * 
		 */
		override public function get mouseY():Number{
			return Math.round(super.mouseY - _anchors.y);
		}
		
		/**
		 * Set/Get the value in pixels of <code>anchorX</code> to defined positions. 
		 * @param p_anchors The values to be applied to the <code>SmartSprite</code> registration point.
		 * @example <listing version="3.0">
var smartsprite : SmartSprite = new SmartSprite();
addChild(smartsprite);

smartsprite.anchorX = 50;
		 * </listing>
		 * @see Number
		 * 
		 */
		public function get anchorX():Number{
			return _anchors.x;
		}

		public function set anchorX(p_value:Number):void{
			_anchors.x = p_value;
			update();
		}
		
		/**
		 * Set/Get the value in pixels of <code>anchorY</code> to defined positions. 
		 * @param p_anchors The values to be applied to the <code>SmartSprite</code> registration point.
		 * @example <listing version="3.0">
var smartsprite : SmartSprite = new SmartSprite();
addChild(smartsprite);

smartsprite.anchorY = 50;
		 * </listing>
		 * @see Number
		 * 
		 */
		public function get anchorY():Number{
			return _anchors.y;
		}

		public function set anchorY(p_value:Number):void{
			_anchors.y = p_value;
			update();
		}
		
		/**
		 * Is only to view the registration point position.
		 * @param p_value is <code>true</code> or <code>false</code>
		 * 
		 */
		public function set debug(p_value:Boolean):void{
			_debug = p_value;
			update();
		}
		
		/**
		 * 
		 * Registers an event listener object with an <code>EventDispatcher</code> object so that the listener receives notification of an event. You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 * @see IEventDispatcher
		 * 
		 */
		override public function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void{
			listeners.push({type:p_type, listener:p_listener, capture:p_useCapture});
			
			super.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		
		/**
		 * 
		 * Removes a listener from the <code>EventDispatcher</code> object. If there is no matching listener registered with the <code>EventDispatcher</code> object, a call to this method has no effect.
		 * @see IEventDispatcher
		 * 
		 */
		override public function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void{
			for (var i:uint=0; i<listeners.length; i++) {
				if (listeners[i].type == p_type && listeners[i].listener == p_listener && listeners[i].capture == p_useCapture) {
					listeners[i] = null;
					listeners.splice(i, 1);
					
					break;
				};
			}
			
			super.removeEventListener(p_type, p_listener, p_useCapture);
		}
		
		/**
		 * Returns a <code>Array</code> of registered events in <code>SmartSprite</code>
		 * @return 
		 * @see Array
		 * 
		 */
		public function getAllEventListeners():Array{
			return listeners;
		}
		
		/**
		 * Remove all events registered in <code>SmartSprite</code>
		 * 
		 * @see #removeEventListener()
		 */
		public function removeAllEventListeners():void{
			var i:uint = listeners.length;
			
			while (i) {
				super.removeEventListener(listeners[i-1].type, listeners[i-1].listener, listeners[i-1].capture);
				
				listeners[i-1] = null;
				listeners.splice(i-1, 1);
				
				i--;
			}
		}

		/**
		 * By default call <code>removeAllEventListeners()</code> and clear <code>data</code>, but is very recommend override this method and call the <code>super()</code> after.
		 * 
		 * @default <code>null</code>
		 * @param evt
		 * @see #removeAllEventListeners()
		 */
		public function destroy(evt:Event=null):void{
			removeAllEventListeners();
			getChildByName("debug-point") && getChildByName("debug-point") is Shape && getChildByName("debug-point").name == "debug-point" ? removeChild(getChildByName("debug-point")) : null;
			
			data = null;
			data = new Object();
		}
		
		private function update(evt:Event=null):void{
			var oldPoint:Point = new Point(0, 0);
			var newPoint:Point = new Point(_anchors.x, _anchors.y);
			
			newPoint = parent.globalToLocal(localToGlobal(newPoint));
			oldPoint = parent.globalToLocal(localToGlobal(oldPoint));
			
			super.x = _temp.x - (newPoint.x - oldPoint.x);
			super.y = _temp.y - (newPoint.y - oldPoint.y);
			
			if(_debug){
				var circle : Shape = getChildByName("debug-point") ? Shape(getChildByName("debug-point")) : new Shape();
				
				circle.name = "debug-point";
				addChild(circle);
				
				circle.graphics.clear();
				circle.graphics.lineStyle(.1, 0x000000);
				circle.graphics.drawEllipse(_anchors.x - 2, _anchors.y - 2, 4, 4);
				circle.graphics.endFill();
			}
		}
		
		private function match(p_value:int, ...p_options:Array):int{
			var option : int;
			
			while (option = p_options.pop()) if((p_value & option)==option) return option;
			
			return 0;
		}
	}
}