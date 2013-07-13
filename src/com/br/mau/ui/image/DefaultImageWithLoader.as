package com.br.mau.ui.image
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.br.mau.asweb.view.Base;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class DefaultImageWithLoader extends Base
	{
		public var loader:BulkLoader;
		private var loaderName:String='';
		public var source:String='';
		
		public function DefaultImageWithLoader(pLoaderName:String , pSource:String){
			loaderName = pLoaderName ;
			source = pSource;
			super();
		}
		
		override public function create(evt:Event=null):void{
			if(BulkLoader.getLoader(loaderName)){
				loader = BulkLoader.getLoader(loaderName);
				if(loader.get(source)){
					loaderComplete(null);
				}else{
					loader.add(source , {id: source});
					loader.get(source).addEventListener(BulkLoader.COMPLETE , loaderComplete );
					loader.get(source).addEventListener(BulkProgressEvent.PROGRESS, loading );
					loader.start();
				}
			}
			super.create(evt);
		}
		
		public function loading(evt:BulkProgressEvent):void{
			//trace('img: % ',evt.percentLoaded);
		}
		
		private function loaderComplete(evt:Event):void{
			if(evt){
				loader.get(source).removeEventListener(BulkLoader.COMPLETE , loaderComplete );
				loader.get(source).removeEventListener(BulkProgressEvent.PROGRESS, loading );
			}
			createImage(loader.getBitmap(source));
		}
		
		public function createImage(pBitmap:Bitmap):void{
			dispatchEvent(new Event (Event.ADDED));
		}
		
	}
}