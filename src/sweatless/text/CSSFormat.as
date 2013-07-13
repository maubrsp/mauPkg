/**
 * Licensed under the MIT License and Creative Commons 3.0 BY-SA
 * 
 * Copyright (c) 2009 Sweatless Team 
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC 
 * LICENSE ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. 
 * ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS 
 * PROHIBITED.
 * BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE 
 * TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE 
 * LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH 
 * TERMS AND CONDITIONS.
 * 
 * http://creativecommons.org/licenses/by-sa/3.0/legalcode
 * 
 * http://www.sweatless.as/
 * 
 * @author Valério Oliveira (valck)
 * 
 */

package sweatless.text {

	import sweatless.utils.StringUtils;

	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class CSSFormat{
		public static function getClass(p_sheet:String, p_target:String):Object{
			return getSheet(p_sheet).getStyle(p_target);
		}
		
		public static function toTextFormat(p_sheet:*, p_target:String):TextFormat{
			var sheet : StyleSheet;
			
			if(p_sheet is String){
				sheet = getSheet(p_sheet);
			}else if (p_sheet is StyleSheet){
				sheet = p_sheet;
			}else{
				throw new Error("This method supports only style sheet, but receive this {"+p_sheet+"}");
			}
			
			return sheet.transform(forceParser(sheet.getStyle(p_target)));
		}
		
		public static function toTextFormatGroup(p_sheet:*):Dictionary{
			var results : Dictionary = new Dictionary(true);
			var sheet : StyleSheet;
			
			if(p_sheet is String){
				sheet = getSheet(p_sheet);
			}else if (p_sheet is StyleSheet){
				sheet = p_sheet;
			}else{
				throw new Error("This method supports only style sheet, but receive this {"+p_sheet+"}");
			}
			
			for(var i:uint=0; i<sheet.styleNames.length; i++){
				var style : Object = forceParser(sheet.getStyle(sheet.styleNames[i]));
				results[sheet.styleNames[i]] = sheet.transform(style);
			}
			
			return results;
		}
		
		private static function getSheet(p_sheet:String):StyleSheet{
			var sheet : StyleSheet = new StyleSheet();
			sheet.parseCSS(p_sheet);
			
			return sheet;
		}
		
		private static function forceParser(p_style:Object):Object{
			for (var property : String in p_style){
				property == "fontFamily" || property == "font-family" ? p_style[property] = getFamily(p_style[property]) : null;
				property == "bold" ? p_style[property] = StringUtils.toBoolean(p_style[property]) : null;
				property == "italic" ? p_style[property] = StringUtils.toBoolean(p_style[property]) : null;
				property == "bullet" ? p_style[property] = StringUtils.toBoolean(p_style[property]) : null;
				property == "kerning" ? p_style[property] = StringUtils.toBoolean(p_style[property]) : null;
				property == "underline" ? p_style[property] = StringUtils.toBoolean(p_style[property]) : null;
			}
			
			return p_style;
		}
		
		private static function getFamily(p_family:String):String{
			var results : String = "";
			var family : Array = StringUtils.replace(StringUtils.removeWhiteSpace(p_family), "\"", "").split(",");
			
			for(var i:uint; i<family.length; i++){
				results += (FontRegister.hasAdded(family[i]) ? FontRegister.getName(family[i]) : family[i]) + (i<family.length-1 ? "," : "");
			}
			
			return results;
		}
	}
}