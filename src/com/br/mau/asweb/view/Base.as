package com.br.mau.asweb.view{
	import com.br.mau.gc.UtilsGc;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import sweatless.events.Broadcaster;
	import sweatless.interfaces.IBase;
	
	public class Base extends Sprite{
		
		protected var events : Dictionary;
		
		public function Base(){
			events = new Dictionary(true);
			addEventListener( Event.ADDED_TO_STAGE, create );	
		}
		
		public function create(evt:Event=null):void{
			removeEventListener( Event.ADDED_TO_STAGE, create );
			stage.addEventListener(Event.RESIZE, resize);
			//throw new Error("Please, override this method.");
		}
		
		public function destroy():void{
			removeAllEventListeners();
			stage.removeEventListener(Event.RESIZE, resize);
			graphics.clear();
			var obj:*
			for(var i:uint = 0 ; i < numChildren;i++){
				obj = getChildAt(i);
				removeChild(obj);
				obj = null;
			}
			UtilsGc.clearGc();
		}
		
		public function resize(evt:Event):void{
			
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};
			events[key] = listener;
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			var key : Object = {type:type, listener:listener, capture:useCapture};

			events[key] = null;
			delete events[key];
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		public function removeAllEventListeners():void{
			for(var key:* in events){
				removeEventListener(key.type, key.listener, key.capture);	
			}
		}
		
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}

