package com.editor.vo.xml
{
	public class AppXMLGroupVO
	{
		public function AppXMLGroupVO(x:XML)
		{
			parser(x)
		}
		
		public var label:String;
		public var data:*;
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			label = x.@label;
			data = x.@data;
			
			for each(var p:XML in x.i){
				var item:AppXMLItemVO = new AppXMLItemVO(p);
				list.push(item)
			}
		}
		
		public function getItem():AppXMLItemVO
		{
			return null;
		}
	}
}