package com.editor.module_ui.css
{
	
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.ComFileVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.utils.FilterTool;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	import flashx.textLayout.compose.ISWFContext;

	public class CreateCSSFileItemVO
	{
		public function CreateCSSFileItemVO(x:XML)
		{
			xml = x;
			key = x.@key;
			value = XML(x.text()[0]).toString()
			if(StringTWLUtil.isWhitespace(x.@type)){
				type = "String";
			}else{
				type = x.@type;
			}
			if(type == "Boolean"){
				if(value == "false"){
					value = false;
				}else if(value == "true"){
					value = true;
				}
			}else if(type == "Array"){
				if(String(value).substring(0,1) == "["){
					value = String(value).substring(1,String(value).length-1);
				}
				value = String(value).split(";");
			}else{
				if(String(value).indexOf(";")!=-1){
					value = String(value).split(";");
				}
			}
		}
		
		public static function isFilters(ky:String):Boolean
		{
			if(ky == "selectedUiFilter" || ky == "filters" || ky == "uiFilter"){
				return true
			}
			return false;
		}
		
		public static function convertToFilterArray(v:Array):Array
		{
			var filter_a:Array = v as Array;
			var filter_aa:Array = [];
			for(var i:int=0;i<filter_a.length;i++){
				if(!StringTWLUtil.isWhitespace(filter_a[i])){
					filter_aa.push(FilterTool.createFilterByString(filter_a[i]));
				}
			}
			return filter_aa;
		}
		
		public var xml:XML;
		public var key:String;
		public var value:*;
		public var type:String;
		private var file:CreateCSSFile;
		
		public function getCSSName():String
		{
			if(String(value).substring(0,4) == "CSS_"){
				return String(value).substring(4,String(value).length);
			}
			return value;
		}
		
		public function getCSSFile(d:CreateCSSFile):String
		{
			file = d;
			var c:String="";
			c = _createSkin();
			if(!StringTWLUtil.isWhitespace(c)) return c;
			c = _createAttri();
			if(!StringTWLUtil.isWhitespace(c)) return c;
			return c;
		}
		
		private function getValue(key:String):*
		{
			return file.getValue(key);
		}
		
		private function haveValue(key:String):Boolean
		{
			return file.haveValue(key);
		}
		
		public static function checkIsSkin(v:String):Boolean
		{
			if(StringTWLUtil.endsWith(v,"skin")) return true;
			if(StringTWLUtil.endsWith(v,"Skin")) return true;
			if(StringTWLUtil.endsWith(v,"Image")) return true;
			return false
		}
		
		//0:embed,1:图片的地址路径,2:fla库中导出类 
		private function _createSkin():String
		{
			var s:String ="" ;
			if(checkIsSkin(key)){
				if(haveValue("embedType")){
					if(int(getValue("embedType"))==0){
						s += getVO().getCSSFile();
					}else if(int(getValue("embedType"))==1){
						s += createSpace(2)+'public'+" "+"var"+" "+key+':String="'+String(value).split(File.separator).join("/")+'";'+NEWLINE_SIGN;
					}else if(int(getValue("embedType"))==2){
						s += createSpace(2)+'public'+" "+"var"+" "+key+':String="'+value+'";'+NEWLINE_SIGN;
					}
				}
			}
			return s;
		}
		
		private function _createAttri():String
		{
			if(StringTWLUtil.isWhitespace(value)) return "";
			if(type == "String"){
				if(String(value).indexOf(File.separator)!=-1){
					return createSpace(2)+"public"+" "+"var"+" "+key+':'+type+'="'+String(value).split(File.separator).join("/")+'";';	
				}
				return createSpace(2)+"public"+" "+"var"+" "+key+':'+type+'="'+value+'";';
			}else if(type == "Array"){
				return createSpace(2)+"public"+" "+"var"+" "+key+':'+type+"="+"["+(value as Array).join(",")+"]"+";";
			}else{
				return createSpace(2)+"public"+" "+"var"+" "+key+':'+type+"="+value+";";
			}
			return "";
		}
		
		public function getVO():IComBaseVO
		{
			if(checkIsSkin(key)){
				var d:ComFileVO = new ComFileVO();
				d.value = value;
				d.key = key;
				d.scaleGridTop = int(xml.@scaleGridTop);
				d.scaleGridBottom = int(xml.@scaleGridBottom);
				d.scaleGridLeft = int(xml.@scaleGridLeft);
				d.scaleGridRight = int(xml.@scaleGridRight);
				return d;
			}else{
				var d2:ComBaseVO = new ComBaseVO();
				d2.key = key;
				d2.value = value;
				return d2
			}
			return null
		}
			
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
		
	}
}