package com.br.mau.air.window
{
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import mx.core.WindowedApplication;

	public class NativeWindowConfig
	{
		public static const POSX:String = "posx";
		public static const POSY:String = "posy";
		public static const WIDTH:String = "Width";
		public static const HEIGHT:String = "height";
		public static const monitor:Number = 1;
		
		public static function maximazeInScreen(p_escope:*,p_monitor:uint=0):void{
			
			p_escope.stage.align = StageAlign.TOP_LEFT; 
			p_escope.stage.scaleMode = StageScaleMode.NO_SCALE; 
			
			
			p_escope.stage.nativeWindow.x = getInScreen(p_monitor , POSX);
			p_escope.stage.nativeWindow.y = getInScreen(p_monitor , POSY);
			p_escope.stage.nativeWindow.width = getInScreen(p_monitor , WIDTH);
			p_escope.stage.nativeWindow.height = getInScreen(p_monitor , HEIGHT);
			NativeWindow(p_escope.stage.nativeWindow).activate();
			
			p_escope.scrollRect = new Rectangle(0,0,getInScreen(p_monitor , WIDTH) , getInScreen(p_monitor , HEIGHT));
			
		}
		public static function centralizeInScreen(p_escope:*,p_monitor:uint=0 , width:uint = 100 , height:uint = 100):void{
			
			p_escope.stage.align = StageAlign.TOP_LEFT; 
			p_escope.stage.scaleMode = StageScaleMode.NO_SCALE; 
			
			p_escope.stage.nativeWindow.width = width;
			p_escope.stage.nativeWindow.height = height;
			
			p_escope.stage.nativeWindow.x =  getInScreen(p_monitor , POSX) + ( getInScreen(p_monitor , WIDTH) - width)*.5;
			p_escope.stage.nativeWindow.y = getInScreen(p_monitor , POSY) + ( getInScreen(p_monitor , HEIGHT) - height)*.5;
			
			NativeWindow(p_escope.stage.nativeWindow).activate();
			
			p_escope.scrollRect = new Rectangle(0,0,getInScreen(p_monitor , WIDTH) , getInScreen(p_monitor , HEIGHT));
			
		}
		
		public static function closeWin(pScope:NativeWindow):void{
			pScope.close();
		}
		
		public static function getInScreen(p_screen:uint , p_param:String):Number{
			if(p_screen > Screen.screens.length)p_screen = Screen.screens[0];
			switch(p_param){
				case WIDTH:
					return Screen.screens[p_screen].bounds.width;
					break;
				case HEIGHT:
					return Screen.screens[p_screen].bounds.height;
					break;
				case POSX:
					return Screen.screens[p_screen].bounds.x;
					break;
				case POSY:
					return Screen.screens[p_screen].bounds.y;
					break;
			}
			return 0;
		} 
	}
}