package com.editor.moudule_drama.vo.drama.plot
{
	public class DramaPlotItemVO
	{
		/**
		 d:对白ID
	     t:头像类型
	     h:头像ID(当头像类型为玩家时为空,NPC或者怪物时对应头像ID)
	     f:表情ID
	     CDATA:对白内容
		 * **/
		public var id:int;
		public var type:int;
		public var avatarType:int;
		public var avatarId:int;
		public var faceId:int;
		public var content:String;
		public function DramaPlotItemVO(x:XML)
		{
			parser(x);
		}
		
		private function parser(x:XML):void
		{
			id = int(x.@d);
			type = int(x.@y);
			avatarType = int(x.@t);
			avatarId = int(x.@h);
			faceId = int(x.@f);
			content = String(x);
		}
		
		public function get name1():String
		{
			return id + " / " + type + " / " + content.substr(0,20) + "  。。。";
		}
		
		
	}
}