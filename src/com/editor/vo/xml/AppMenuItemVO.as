package com.editor.vo.xml
{
	public class AppMenuItemVO
	{
		public function AppMenuItemVO(x:XML)
		{
			xml = x;
			label = x.@label;
			data = x.@data;
			popId = x.@popId;
			key = x.@key;
		}
		
		public var xml:XML
		public var label:String;
		public var data:*;
		public var popId:String;
		public var key:String;
	}
}