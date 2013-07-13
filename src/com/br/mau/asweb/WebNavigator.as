package com.br.mau.asweb
{
	import com.adobe.utils.DictionaryUtil;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.br.mau.asweb.command.UrlsExecuteCommand;
	import com.br.mau.asweb.interfaces.IUILoader;
	import com.br.mau.asweb.view.DefaultPage;
	import com.br.mau.browser.ShortCutFlashVars;
	import com.br.mau.events.CustomListener;
	import com.br.mau.gc.UtilsGc;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import sweatless.utils.DictionaryUtils;

	public class WebNavigator extends Sprite
	{
		static protected const NAV_URLS:Dictionary = new Dictionary(true);
		static protected const PAGES:Dictionary = new Dictionary(true);

		static protected const CURRENT_PAGE:String= "currentpage";
		static protected const LAST_PAGE:String= "lastpage";

		static protected const LOADER:String= "loader";
		static protected const PAGE_SCOPE:String= "pagescope";

		static protected const UI_LOADER:String= "uiloader";
		
		private var initialized:Boolean;
		private var loaderContext:LoaderContext;
		private var urlLoader:URLLoader;
		
		public var posX:Number = 0;
		public var posY:Number = 0;
		
		public var maxHeight:Number = 0;
		public var maxWidth:Number = 0;
		
		public function WebNavigator(){
			super();
			UrlsExecuteCommand.addUrls(WebConfig.xml , NAV_URLS , null ,null);
			addEventListener(Event.ADDED_TO_STAGE, rootAded);
		}
		
		private function rootAded(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, rootAded);
			
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			
			maxHeight = maxHeight == 0 ? stage.stageHeight : maxHeight;
			maxWidth = maxWidth == 0 ? stage.stageWidth : maxWidth;
			
			SWFAddress.setStrict(false);
			SWFAddress.setHistory(true);
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE,adressChange);
		}
		
		public function goToId():void{
			
		}
		
		public function goToUrl():void{
			
		}
		
		public function get selectedPageId():String{
			return PAGES[CURRENT_PAGE];
		}
		
		public function show():void{
			DefaultPage(PAGES[PAGES[CURRENT_PAGE]+LOADER].content).show();
		}
		
		public function adressChange(evt:SWFAddressEvent=null):void{
			//trace("adress change..." , SWFAddress.getPath())
			//set to tracker
			if(UrlsExecuteCommand.getIDFromURL(NAV_URLS ,SWFAddress.getPath()).length > 1 ){
				changeToContent(UrlsExecuteCommand.getIDFromURL(NAV_URLS ,SWFAddress.getPath()))
			}else{
				if(!initialized){
					if(String(WebConfig.xml..iten.(@id == ShortCutFlashVars.getVars("STARTCONTENTID"))).length > 2){
						WebConfig.goInternalUrl(WebConfig.xml..iten.(@id == ShortCutFlashVars.getVars("STARTCONTENTID")).label.toString());
						initialized = true;
					}else{
						changeToContent(WebConfig.xml..itens.@default);
					}
				}else{
				}
			}
		}
		
		private function changeToContent(p_id:String):void{
			initialized = true;
			if(p_id == PAGES[CURRENT_PAGE]){
				//dispara verificação para o scopo - ler
				return;
			}
			WebConfig.changeStart();
			if(PAGES[CURRENT_PAGE] != undefined)PAGES[LAST_PAGE] = PAGES[CURRENT_PAGE];
			PAGES[CURRENT_PAGE] = p_id;
			
			if(numChildren >0){
				destroyPage(PAGES[LAST_PAGE]);
			}else{
				getContent(PAGES[CURRENT_PAGE]);
			}
			
		}
			
		private function getContent(p_id:String):void{
			if(PAGES[p_id+LOADER] != undefined){
				contentLoaded(null , p_id);
				addChild(PAGES[p_id+LOADER]);
				DefaultPage(PAGES[p_id+LOADER].content).create(null);
				return;
			}
			//loaderContext.allowCodeImport = true;
			//loaderContext.allowLoadBytesCodeExecution = true;
			PAGES[p_id+LOADER]= new Loader();
			addChild(PAGES[p_id+LOADER]);
			
			CustomListener.addListener(PAGES[p_id+LOADER].contentLoaderInfo , 
										Event.COMPLETE ,
										contentLoaded,
										p_id);

			CustomListener.addListener(PAGES[p_id+LOADER].contentLoaderInfo , 
										ProgressEvent.PROGRESS ,
										distributeLoadingProgress,
										p_id);
			
			
			PAGES[p_id+LOADER].load(new URLRequest(WebConfig.swfPatch+WebConfig.xml..iten.(@id == p_id).file) , loaderContext);
		}
		
		private function distributeLoadingProgress(evt:ProgressEvent , p_id:String):void{
			for (var o:String in PAGES[UI_LOADER]){
				PAGES[UI_LOADER][o].progress(evt);
			}
			
		}
		
		private function contentLoaded(evt:Event, p_id:String):void{
			if(PAGES[p_id+LOADER].contentLoaderInfo.hasEventListener(Event.COMPLETE))CustomListener.removeListener(PAGES[p_id+LOADER].contentLoaderInfo , Event.COMPLETE);
			PAGES[p_id+LOADER].x = posX;
			PAGES[p_id+LOADER].y = posY;
			UtilsGc.clearGc();
			DefaultPage(PAGES[p_id+LOADER].content).id = p_id;
			PAGES[p_id+LOADER].scrollRect = new Rectangle(0,0,maxWidth , maxHeight);
			PAGES[p_id+LOADER].content.scrollRect = new Rectangle(0,0,maxWidth , maxHeight);
			CustomListener.addListener(PAGES[p_id+LOADER].content,Event.COMPLETE,contentReady , p_id);
		}
		
		private function contentReady(evt:Event , p_id:String):void{
			CustomListener.removeListener(PAGES[p_id+LOADER].content,Event.COMPLETE);
			WebConfig.changeEnd();
			show();
			/*for (var st:String in PAGES){
				//trace(st , PAGES[st]);
			}*/
		}
		
		private function destroyPage(p_id:String):void{
			//trace("destroy :",p_id , PAGES[CURRENT_PAGE] , PAGES[LAST_PAGE])
			DefaultPage(PAGES[p_id+LOADER].content).hide(clearLoader , p_id);
		}
		
		public function setUiLoader(pLoader:IUILoader, pId:String=null):void{
			if(PAGES[UI_LOADER] == "undefined" || PAGES[UI_LOADER] == undefined ){
				PAGES[UI_LOADER] = new Dictionary(true);
			}
			if(!pId){
				pId = 'loader'+DictionaryUtils.length(PAGES[UI_LOADER][pId]).toString();
			}
			PAGES[UI_LOADER][pId] = pLoader;
		}
		
		public function removeLoader(pId:String):void{
			
		}
		
		private function onUnload(evt:Event,p_id:String):void{
			
		}
		
		private function clearLoader(p_id:String):void{
			var ld:Loader = PAGES[p_id+LOADER]
			DefaultPage(ld.content).destroy();
			ld.scrollRect = new Rectangle();
			removeChild(ld);
			//ld = null;
			UtilsGc.clearGc();
			
			setTimeout(function():void
			{
				getContent(PAGES[CURRENT_PAGE]);
			},50);
		}
		
		
		private function createUrls():void{
			
		}
		
		
		
	}
}