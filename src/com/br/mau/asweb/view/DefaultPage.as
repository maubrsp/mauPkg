package com.br.mau.asweb.view{
	
	import com.br.mau.asweb.WebConfig;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	public class DefaultPage extends Base
	{
		
		private var _id:String;
		public var xml:XML;
		
		public function DefaultPage()
		{
			super();
			visible = false;
		}
		
		override public function create(evt:Event=null):void{
			if(stage == null)destroy();
			try{
				stage.addEventListener(Event.RESIZE, resize);
				if(!id){
					setTimeout(create , 300 , evt);
					return;
				}
				super.create(evt);
				
				var ld:URLLoader = new URLLoader();
				ld.addEventListener(Event.COMPLETE, xmlLoaded);
				ld.load(new URLRequest(WebConfig.xmlPatch + WebConfig.xml..iten.(@id == id).@content));
				
			}catch(e:*){
				destroy();
			}
		}
		
		private function xmlLoaded(evt:Event):void{
			xml = new XML(evt.target.data);
			createComplete();
		}
			
		public function getInternalContent():void{
			
		}
		
		public function createComplete():void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function show():void{
			throw new Error("needs override");
		}
		
		public function hide(completeFunc:Function = null, completeArgs:*=null):void{
			if(completeFunc != null && !completeArgs)completeFunc();
			if(completeFunc != null && completeArgs)completeFunc(completeArgs);
		}

		public function get id():String{
			return _id
		}

		public function set id(p_id:String):void{
			 _id = p_id;
		}
		
		public function getUrl():String{
			return "";
		}
		override public function resize(evt:Event):void{
			super.resize(evt);
		}
		
		override public function destroy():void{
			System.disposeXML(xml);
			xml = null;
			super.destroy();
		}
		
	}
}