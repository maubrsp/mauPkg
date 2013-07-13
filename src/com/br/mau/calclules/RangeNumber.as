package com.br.mau.calclules
{
	public class RangeNumber
	{
		public static function getRange(min:Number,max:Number):Number{
			return Number(( Math.random()*(max-min))+min);
		}
		public static function getRoundRange(min:Number,max:Number):Number{
			return Number(Math.round( Math.random()*(max-min))+min);
		}
	}
}