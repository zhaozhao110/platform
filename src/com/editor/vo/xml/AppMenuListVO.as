package com.editor.vo.xml
{
	public class AppMenuListVO
	{
		public function AppMenuListVO(x:XML)
		{
			xml = x;
			parser(x)
		}
		
		public var xml:XML
		public var list:Array = [];
		public var list2:Array = [];
		
		private function parser(x:XML):void
		{
			var a:XMLList = x..menuitem;
			for(var i:int=0;i<a.length();i++){
				if(XML(a[i]).children().length() == 0){
					list2.push(a[i]);
				}
			}
			for each(var p:XML in x.menuitem){
				var item:AppMenuItemVO = new AppMenuItemVO(p);
				list.push(item)
			}
		}
		
		public function getItem():AppMenuItemVO
		{
			return null;
		}
	}
}