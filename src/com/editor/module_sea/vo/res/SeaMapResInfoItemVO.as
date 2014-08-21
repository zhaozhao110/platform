package com.editor.module_sea.vo.res
{
	import com.sandy.utils.ToolUtils;
	
	public class SeaMapResInfoItemVO
	{
		public function SeaMapResInfoItemVO(xml:XML=null)
		{
			if(xml!=null) parserXML(xml);
		}
		
		public var id:int;
		public var name:String;
		public var resType:int;
		
		private function parserXML(x:XML):void
		{
			id 				= int(x.@i);
			name 			= x.@n;
			resType			= int(x.@a);
		}
		
		public function getSwfURL(s:String):String
		{
			if(resType == 2){
				return s + id + ".swf" 
			}
			return s + id + ".png"
		}
		
		public function clone():SeaMapResInfoItemVO
		{
			var it:SeaMapResInfoItemVO = new SeaMapResInfoItemVO();
			ToolUtils.clone(this,it);
			return it;
		}
		
	}
}