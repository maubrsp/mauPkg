package com.br.mau.browser
{
	
	import flash.utils.Dictionary;
	
	public class ShortCutFlashVars{
		
		protected static const FLASH_VARS:Dictionary = new Dictionary(true);
		
		public static function execute(p_scope:*):void{
			for(var i:String in p_scope.loaderInfo.parameters){
				setVars(i, p_scope.loaderInfo.parameters[i]);
			}
		}
		
		public static function varsExist(p_name:String):Boolean{
			return FLASH_VARS[p_name] == undefined || FLASH_VARS[p_name] == "undefined" ? false : true;
		}
		
		public static function getVars(p_name:String):Object{
			return FLASH_VARS[p_name];
		}
		
		public static function setVars(p_name:String, p_value:Object):void{
			FLASH_VARS[p_name] = p_value;
		}
		
	}
}