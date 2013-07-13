package com.br.mau.commands.draws
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import spark.primitives.Graphic;

	public class ShortcutGraphics
	{
		public static function rectColored(scope:Graphics,w:Number,h:Number,x:Number,y:Number,color:uint,alpha:Number):void{
			scope.clear();
			scope.beginFill(color,alpha);
			scope.drawRect(x,y,w,h);
			scope.endFill();
		}

		public static function circleColored(scope:Graphics,w:Number,h:Number,x:Number,y:Number,color:uint,alpha:Number):void{
			scope.clear();
			scope.beginFill(color,alpha);
			scope.drawEllipse(x,y,w,h);
			scope.endFill();
		}

		
		public static function rectComplexGradient( scope:Graphics , w:Number , h:Number , x:Number , y:Number ,
														colors:Array, alpha:Array , rotation:Number , fillType:String , 
														ratios:Array , corners:Array , openClose:Boolean = true , spreadMethod:String = "pad" ):void{
			var matr:Matrix = new Matrix();
			matr.createGradientBox( w, h, rotation*Math.PI/180 , x, y );
			if(openClose)scope.clear();
			scope.beginGradientFill(fillType , colors , alpha , ratios , matr , spreadMethod );
			scope.drawRoundRectComplex(x , y , w ,h , 
				corners.length > 0 ? corners[0] : 0,
				corners.length > 1 ? corners[1] : 0,
				corners.length > 2 ? corners[2] : 0,
				corners.length > 3 ? corners[3] : 0);
			if(openClose)scope.endFill();
			matr = null;
		}
		
		public static function roundedColored(scope:Graphics,w:Number,h:Number,x:Number,y:Number,color:uint,alpha:Number, corners:Array):void{
			scope.clear();
			scope.beginFill(color,alpha);
			//trace(corners.length >= 0 ? corners[0] : 0)
			scope.drawRoundRectComplex(x , y , w ,h , 
										corners.length >= 0 ? corners[0] : 0,
										corners.length >= 1 ? corners[1] : 0,
										corners.length >= 2 ? corners[2] : 0,
										corners.length >= 3 ? corners[3] : 0)
			scope.endFill();
		}
		
		public static function roundedImagedScaled(scope:Graphics,w:Number,h:Number,x:Number,y:Number, proportion:Number , bitmap:BitmapData , alpha:Number , corners:Array):void{
			scope.clear();
			
			var mat:Matrix = new Matrix();
			mat.scale(proportion , proportion);
			mat.tx = x;
			mat.ty = y;
			
			scope.beginBitmapFill(bitmap, mat , false , true);
			scope.drawRoundRectComplex(x , y , w ,h , 
										corners.length > 0 ? corners[0] : 0,
										corners.length > 1 ? corners[1] : 0,
										corners.length > 2 ? corners[2] : 0,
										corners.length > 3 ? corners[3] : 0)
			scope.endFill();
			mat = null;
			corners = null;
		}
		
		public static function diagonalLines( scope:Graphics, fieldWidth:uint, fieldHeight:uint, lineWeight:uint, lineColor:uint, lineAlpha:Number, angle:Number, spacing:uint):void{
			var lineLength:uint = Math.round( fieldHeight / Math.cos( angle * Math.PI/180 ));
			var offset:uint = Math.round( fieldHeight / Math.tan( angle * Math.PI/180 ));
			var extraLines:uint = offset / spacing;
			var numLines:uint = ( fieldWidth / spacing ) + ( 2 * extraLines );
			var xPos:int = - ( extraLines * spacing );
			var yPos:int= fieldHeight;
			scope.clear();
			for ( var i:uint=0; i<numLines; i++ )
			{
				/**
				 *  NOTE: uncomment next line to randomize transparency of diagonals:  generates between .2 and 1.0
				 */
				//lineAlpha = (Math.round(Math.random() * 8) + 2) * 0.1;
				
				scope.lineStyle( lineWeight, lineColor, lineAlpha );
				scope.moveTo ( xPos, yPos );
				scope.lineTo ( xPos+offset, 0 );
				xPos += spacing;
			}
			
			scope.endFill();
			
		}
		
	}
}