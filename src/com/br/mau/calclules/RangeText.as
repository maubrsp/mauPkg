package com.br.mau.calclules
{
	public class RangeText
	{
		
		public static function getRandomChar(p_st:String , chars:Array):String{
			var n:Number = RangeNumber.getRoundRange( p_st.length , chars.length);
			var result:String = "";
			for (var i:uint = 0 ; i < n ; i++){
				result+=chars[RangeNumber.getRoundRange(0,chars.length-1)]
			}
			return result;
		}
		
		public static function getText():void{
			
		}
	}
}