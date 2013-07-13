package com.br.mau.browser
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.LocalConnection;
	
	import sweatless.debug.FPS;

	public class SwfConfigure
	{
		public static function defaultWeb(p_scope:* , p_fr:Number=30):void
		{
			p_scope.stage.scaleMode = StageScaleMode.NO_SCALE;
			p_scope.stage.align = StageAlign.TOP_LEFT;
			p_scope.stage.showDefaultContextMenu = false;
			p_scope.stage.stageFocusRect = false;
			p_scope.stage.frameRate = p_fr;
			
			var host : LocalConnection = new LocalConnection();
			var offline : Boolean = String(host.domain).indexOf("localhost") != -1 ? true : false;
			
			if(offline) {
				var fps : FPS = new FPS();
				p_scope.addChild(fps);
			};
		}
	}
}