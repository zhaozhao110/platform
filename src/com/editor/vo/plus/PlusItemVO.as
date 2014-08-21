package com.editor.vo.plus
{
	import com.editor.services.Services;
	
	import flash.filesystem.File;

	public class PlusItemVO
	{
		public function PlusItemVO(x:XML)
		{
			parser(x);
		}
		
		public var name:String;
		public var url:String;
		public var width:int;
		public var height:int;
		public var version:Number;
		public var toolTip:String;
		public var info:String;
		public var oldItem:PlusItemVO;
		public var swf_url:String;
		public var locale_url:String;
		public var org_xml:XML;
		public var author:String;
		
		private function parser(x:XML):void
		{
			org_xml = x;
			name = x.@name;
			url = x.@url;
			width = int(x.@width);
			height = int(x.@height);
			version = Number(x.@version);
			author = x.@author;
			toolTip = x.@tip + "<br>by:"+author;
			info = "by:"+author+"<br>"+x.text();
			swf_url = Services.server_res_url+"plus/"+url;
			locale_url = File.applicationDirectory.nativePath+File.separator+"plus"+File.separator+url;
		}
		
		public function update():void
		{
			if(oldItem == null) return ;
			oldItem.version = version;
			oldItem.org_xml.@version = version;
		}
		
		public function checkNewVersion():Boolean
		{
			if(oldItem == null) return false;
			if(oldItem.version<version) return true;
			return false;
		}
	}
}