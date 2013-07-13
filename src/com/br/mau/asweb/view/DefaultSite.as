package com.br.mau.asweb.view
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class DefaultSite extends Base
	{
		public function DefaultSite()
		{
			registerFonts();
			super();
		}
		
		public function addNavigator():void{
			
		}
		
		public function setLang(p_lang:String):void{
			throw new Error("needs override");
		}
		
		override public function create(evt:Event=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			stage.addEventListener(Event.RESIZE, resize);
			resize(null);
		}
		
		public function registerFonts():void{
			throw new Error("needs override")
		}
		override public function resize(evt:Event):void{
			throw new Error("needs override")
		}
	}
}