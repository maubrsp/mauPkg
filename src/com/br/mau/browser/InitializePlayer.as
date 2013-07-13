package com.br.mau.browser
{
	import flash.system.Capabilities;
	import flash.system.Security;

	public class InitializePlayer
	{
		public static function execute(p_end:Function = null , 
									   p_browser:Function=null,
									   p_remote:Function = null,
									   p_standalone:Function= null,
									   p_desktop:Function= null,
									   p_external:Function= null):void{
			
			if(Security.sandboxType == Security.REMOTE){
				if(p_browser != null)p_browser();
				return;
			}
			if(Capabilities.playerType == "StandAlone"){
				//redirect to load local and define patch hadcoded declared in code
				if(p_standalone != null)p_standalone();
				return;
			}else if(Capabilities.playerType == "Desktop"){
				//redirect to load local and define patch  - analize air integration
				if(p_desktop != null)p_desktop();
				return;
			}else if(Capabilities.playerType == "External"){
				//future to do implements test and debug modes
				if(p_external != null)p_external();
				return;
			}else{
				if(p_browser!= null)p_browser();
			}
			if(p_end != null)p_end();
		}
	}
}