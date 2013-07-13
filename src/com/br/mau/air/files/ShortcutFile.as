package com.br.mau.air.files
{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class ShortcutFile
	{
		
		public static function getFolderFileCreateIfInexist(patch:String):File{
			var result:File = File.documentsDirectory.resolvePath(patch);
			
			
			
			
			
			return result;
		}
		
		public static function getXml(p_file:String):XML{
			
			var file:File = File.applicationDirectory.resolvePath(p_file);
			if(!file.exists) file = File.documentsDirectory.resolvePath(p_file);
			//trace(file.exists , file.url , file.nativePath);
			//trace("getxml", p_file);
			if(!file.exists) return null;
			///= UniversalCommons.DIRECTORY.resolvePath(UniversalCommons.STORAGE_DIRECTORY + p_file); 
			//file.downl;
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);//UniversalCommons.DIRECTORY.resolvePath(UniversalCommons.DATA_DIRECTORY+p_file);
			var result:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			
			return result;
		}
		
		public static function downloadAndReplaceXml():void{
			
			
			
		}
	}
}