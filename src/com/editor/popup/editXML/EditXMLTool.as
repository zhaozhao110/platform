package com.editor.popup.editXML
{
	import com.sandy.utils.StringTWLUtil;

	public class EditXMLTool
	{
		private static var instance:EditXMLTool ;
		public static function getInstance():EditXMLTool{
			if(instance == null){
				instance =  new EditXMLTool();
			}
			return instance;
		}
		
		//删除换行
		public function clear(s:String):String
		{
			var out:String = "";
			var a:Array = StringTWLUtil.splitNewline(s);
			for(var i:int=0;i<a.length;i++){
				out += StringTWLUtil.trim(a[i]);
			}
			return out;
		}
		
		//添加换行
		public function add(s:String):String
		{
			var x1:XML = XML(s);
			var s1:String = x1.toXMLString();
			return s1;
		}
		
	}
}