package com.editor.vo.pop
{
	public class AppPopinfoVO
	{
		public function AppPopinfoVO(obj:Object)
		{
			id = int(obj.id);
			name = obj.name;
			info = obj.info;
			webId = int(obj.webid);
		}
		
		public var webId:int;
		public var id:int;
		public var name:String;
		public var info:String;
		
	}
}