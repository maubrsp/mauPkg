package com.br.mau.gc
{
	import flash.net.LocalConnection;
	import flash.system.System;

	public class UtilsGc
	{
		public static function clearGc():void{
			
			try{
				new LocalConnection().connect("clear_gc");
				new LocalConnection().connect("clear_gc");
			} catch(e:Error){
				
			}
			System.gc();
		}
	}
}