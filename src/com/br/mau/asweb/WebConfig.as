package com.br.mau.asweb
{
	import com.asual.swfaddress.SWFAddress;
	import com.br.mau.asweb.view.DefaultPreloader;
	import com.br.mau.asweb.view.DefaultSite;
	import com.br.mau.browser.ShortCutFlashVars;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	
	import sweatless.utils.DisplayObjectUtils;
	
	public class WebConfig
	{
		protected static const CONFIGCONTENT:Dictionary = new Dictionary(true);
		protected static const DEFAULT_SCOPE_ITENS:Dictionary = new Dictionary(true);

		protected static const ESCOPE:String = "escope";
		protected static const CHANGE_START:String = "changestart";
		protected static const CHANGE_END:String = "changeend";

		protected static const CHANGE_FUNCTION:String = "changefunction";
		
		public static function start(p_scope:DefaultPreloader,p_change:Function):void{
			root = p_scope;
			CONFIGCONTENT["loader"] = new URLLoader();
			CONFIGCONTENT["changeLang"] = p_change;
		}
		
		public static function addDefaultIten(names:String , iten:* , p_start:Function , p_end:Function ):void{
			DEFAULT_SCOPE_ITENS[names] = new Dictionary(true);
			DEFAULT_SCOPE_ITENS[names][ESCOPE] = iten;
			DEFAULT_SCOPE_ITENS[names][CHANGE_START] = p_start;
			DEFAULT_SCOPE_ITENS[names][CHANGE_END] = p_end;
			iten.name = names;
			root.addChild(iten);
		}
		
		public static function removeDefaultIten(names:String , scope:*):void{
			if(scope){
				for(var s:String in DEFAULT_SCOPE_ITENS){
					if(DEFAULT_SCOPE_ITENS[s][ESCOPE] == scope){
						names = s;
					}
				}
			}
			DEFAULT_SCOPE_ITENS[names][CHANGE_START] = null;
			delete DEFAULT_SCOPE_ITENS[names][CHANGE_START];
			DEFAULT_SCOPE_ITENS[names][CHANGE_END] = null;
			delete DEFAULT_SCOPE_ITENS[names][CHANGE_END];
			DEFAULT_SCOPE_ITENS[names][ESCOPE].parent.removeChild(DEFAULT_SCOPE_ITENS[names][ESCOPE])
			DEFAULT_SCOPE_ITENS[names][ESCOPE] = null;
			delete DEFAULT_SCOPE_ITENS[names][ESCOPE];
			DEFAULT_SCOPE_ITENS[names]=null;
			delete DEFAULT_SCOPE_ITENS[names];
			
		}
		
		
		public static function changeStart():void{
			for(var st:String in DEFAULT_SCOPE_ITENS){
				if(DEFAULT_SCOPE_ITENS[st][CHANGE_START] != null || DEFAULT_SCOPE_ITENS[st][CHANGE_START] != undefined)DEFAULT_SCOPE_ITENS[st][CHANGE_START]()
			}
		}
		
		public static function changeEnd():void{
			for(var st:String in DEFAULT_SCOPE_ITENS){
				if(DEFAULT_SCOPE_ITENS[st][CHANGE_END] != null || DEFAULT_SCOPE_ITENS[st][CHANGE_END] != undefined)DEFAULT_SCOPE_ITENS[st][CHANGE_END]()
			}
			
		}
		
		public static function getIten(p_id:String):*{
			return DEFAULT_SCOPE_ITENS[p_id][ESCOPE];//root.getChildByName(p_id);
		}
		
		public static function set lang(p_lang:String):void{
			CONFIGCONTENT["lang"] = p_lang;
			loadConfig();			
		}
		
		public static function get lang():String{
			return CONFIGCONTENT["lang"];
		}
		
		public static function set root(p_scope:DefaultPreloader):void{
			CONFIGCONTENT["scope"] = p_scope;
		}
		
		public static function get root():DefaultPreloader{
			return CONFIGCONTENT["scope"];
		}
		
		public static function get defaultSite():DefaultSite{
			var scope:DefaultSite;
			for (var i:uint ; i < root.numChildren ; i++){
				if( root.getChildAt(i) is DefaultSite) return  root.getChildAt(i) as DefaultSite
			}
			return null
		}
		
		private static function loadConfig():void{
			changeStart();
			CONFIGCONTENT["loader"].addEventListener (Event.COMPLETE, configLoaded);
			CONFIGCONTENT["loader"].load (xmlConfig);
		}
		
		private static function configLoaded(evt:Event):void{
			CONFIGCONTENT["loader"].removeEventListener(Event.COMPLETE, configLoaded);
			xml = new XML(evt.target.data);
			CONFIGCONTENT["changeLang"]();
		}
		
		public static function get xmlConfig():URLRequest{
			return new URLRequest( xmlPatch + ShortCutFlashVars.getVars("CONTENTXML"));
		}
		
		public static function get xmlPatch():String{
			return ShortCutFlashVars.getVars("XMLPATCH") + "/" + lang+"/";
		}
		
		public static function get videoPatch():String{
			return ShortCutFlashVars.getVars("VIDEOPATCH") + "/" + lang + "/";
		}
		public static function get imagePatch():String{
			return ShortCutFlashVars.getVars("IMAGEPATCH") + "/" + lang + "/";
		}

		public static function get swfPatch():String{
			return ShortCutFlashVars.getVars("SWFPATCH") + "/";
		}
		
		public static function set xml(p_XML:XML):void{
			CONFIGCONTENT["xml"] = p_XML;
		}
		
		public static function get xml():XML{
			return CONFIGCONTENT["xml"];
		}
		
		public static function goInternalUrl(p_adress:String):void{
			SWFAddress.setTitle(p_adress);
			SWFAddress.setValue(p_adress);
			if(CONFIGCONTENT[CHANGE_FUNCTION] != undefined)CONFIGCONTENT[CHANGE_FUNCTION]();
		}
		
		public static function set changeUrlFunction(p_function:Function):void{
			CONFIGCONTENT[CHANGE_FUNCTION] = p_function;
		}
		
		public static function addInternalUrl(p_adress:String):void{
			SWFAddress.setTitle(p_adress);
			SWFAddress.setValue(SWFAddress.getPath()+"/"+p_adress);
		}
		
		public static function goExternalUrl(p_adress:String, p_win:String):void{
			navigateToURL(new URLRequest(root.loaderInfo.url + "#/" + p_adress));
		}
	}
}