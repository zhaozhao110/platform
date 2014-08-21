package com.editor.vo.xml
{
	public class AppXMLItemVO
	{
		public function AppXMLItemVO(x:XML)
		{
			label = x.@label;
			data = x.@data;
		}
		
		public var label:String;
		public var data:*;
	}
}