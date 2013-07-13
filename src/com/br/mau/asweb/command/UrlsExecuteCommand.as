package com.br.mau.asweb.command
{
	import flash.utils.Dictionary;
	
	public class UrlsExecuteCommand
	{
		public static function addUrls(xml:XML,dic:Dictionary, obj:* , father:String):void{
			//trace(xml, dic)
			for each ( var o:* in xml..iten ){
			//	trace(o.@id)
				register( xml , dic, o , "");		
			};
		}
		
		private static function register(xmls:XML,dic:Dictionary, obj:* , father:String):void{
			var ids:String = obj.@id
			var result:String = father + "/" + String(xmls..iten.(@id == ids).label) ;
			dic[result] = ids;
			//trace(result,dic[result] , ids)
			if(obj.iten){	
			for each ( var o:* in obj.iten ){		register( xmls , dic, o , result);		};
			};
			
		}
		
		public static function checkUrlVariations(dic:Dictionary ,st:String):Boolean{
			st = String(st.slice(st.length-1 , st.length)) == "/" ?st.slice(0,st.length-1) :st;
			//trace(st2 , st , URLS[st] != undefined || URLS["/"+st] != undefined || URLS[st+"/"] != undefined || URLS["/"+st+"/"] || URLS["/"+st2] != undefined || URLS[st2] != undefined != undefined ? true : false)
			return dic[st] != undefined || dic["/"+st] != undefined || dic["/"+st+"/"] != undefined  ? true : false
		}
		
		public static function getIDFromURL(dic:Dictionary ,st:String):String{
			var result:String = String(st.slice(st.length-1 , st.length)) == "/" ?st.slice(0,st.length-1) :st;

			result = dic[st] != undefined ? dic[st] : "";
			result= result.length <1 && dic["/"+st] != undefined ? dic["/"+st] : result
			result = result.length <1 && dic["/"+st+"/"] != undefined ? dic["/"+st+"/"] : result
			result = result.length <1 && dic[st+"/"] != undefined ? dic[st+"/"] : result
			
			if(result.length > 1) return result;
			
			for(var sts:String in dic){
				if(String("/"+st).search(sts) != -1) return dic[sts]
			}
			
			return result;
		}
		
		public static function getFatherURL(dic:Dictionary , childs:String):String{
			//st = String(st.slice(0,1)) == "/" ? st.slice(1,st.length) : st;
			childs = childs.slice(0,1) == "/" ? childs : "/"+childs
				for (var sts:String in dic){
				//	trace(st , String(st).slice(1, st.length))
					if(childs.search(sts) >= 0){
						var trat:String = childs.slice(childs.search(sts)+sts.length , childs.length);
						//trace(sts , trat)
						if(trat.search("/") ==-1 || trat.search("/") == 0 || trat.search("/") == trat.length){
							//trace("...................................:::::::::::::::::::"+sts + ",.," + trat )
							return sts + "," + trat ;
						}
//					trace("urls registrada com acréscimo")
					}
				}
			return "";
		}
		
		public static function getURLFromID(dic:Dictionary , p_id:String):String{
			for(var s:String in dic){
				//trace(p_id , s , dic[s])		
				if(dic[s] == p_id) return dic[s]			
			}
			return null
		}
	}
}