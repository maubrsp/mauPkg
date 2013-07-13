package com.br.mau.ui.image
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.br.mau.asweb.view.Base;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class RoundedImage extends DefaultImageWithLoader
	{
		public var corners:String;
		
		public function RoundedImage(pLoader:String , pSource:String , pCorners:String)
		{
			super(pLoader , pSource);
			corners = pCorners;
		}
		
		override public function loading(evt:BulkProgressEvent):void{
			super.loading(evt);
		}
		
		override public function createImage(pBitmap:Bitmap):void{
			super.createImage(pBitmap);
			addChild(pBitmap);
		}
		
	}
}