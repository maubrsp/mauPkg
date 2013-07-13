package com.br.mau.asweb.view
{
	import com.br.mau.asweb.WebConfig;
	import com.br.mau.asweb.interfaces.IUILoader;
	import com.br.mau.browser.InitializePlayer;
	import com.br.mau.browser.ShortCutFlashVars;
	import com.br.mau.browser.SwfConfigure;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class DefaultPreloader extends Sprite
	{
		
		private var loading:*;
		public var area:DefaultSite;
		
		private var _preloaderOk:Boolean;
		
		public function DefaultPreloader()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, rootLoaded);	
		}
		
		private function rootLoaded(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, rootLoaded);
			stage.addEventListener(Event.RESIZE,  resize);
			
			SwfConfigure.defaultWeb(this);
			InitializePlayer.execute();
			ShortCutFlashVars.execute(this);
			
			WebConfig.start(this , changeLang);
			create();
			WebConfig.lang = ShortCutFlashVars.getVars("LANGPATCH").toString();
		}
		
		public function creationComplete():void{
			var lc:Loader = new Loader();
			lc.load(new URLRequest(WebConfig.swfPatch + ShortCutFlashVars.getVars("DEFAULTSWF").toString()));
			lc.contentLoaderInfo.addEventListener(Event.COMPLETE,appLoaded);
			lc.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , (WebConfig.getIten("loader1")as IUILoader).progress)
			
		}
		
		public function create():void{
			creationComplete();
			//throw new Error("nedds override")
		}
		
		private function appLoaded(evt:Event):void{
			evt.currentTarget.removeEventListener(ProgressEvent.PROGRESS , (WebConfig.getIten("loader1")as IUILoader).progress);
			area = evt.currentTarget.content as DefaultSite;
			addChild(area);
			onAppLoaded();
		}
		
		public function onAppLoaded():void{
			
		}
		
		public function hideLoader():void{
			trace("hiding loader")
			
		}
		
		private function setLang(p_lang:String):void{
			WebConfig.lang = p_lang;
		}
		
		public function resize(evt:Event=null):void{
			
		}
		
		private function changeLang():void{
			if(area){
				trace("changing lang")
				area.setLang(ShortCutFlashVars.getVars("LANGPATCH").toString());
			}else{
				setTimeout(changeLang , 500);
			}
		}
	}
}