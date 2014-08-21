package com.editor.vo.xml
{
	public class AppXMLListVO
	{
		public function AppXMLListVO(x:XML)
		{
			xml = x;
			parser(x)
		}
		
		public var xml:XML
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g){
				var item:AppXMLGroupVO = new AppXMLGroupVO(p);
				list.push(item)
			}
		}
		
		public function getItem():AppXMLItemVO
		{
			return null;
		}
		
		
	}
}