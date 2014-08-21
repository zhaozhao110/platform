package com.editor.manager
{
	public class XMLCache
	{
		public function XMLCache(xml:String)
		{
			xmlURL = xml;
		}
		
		public var xmlURL:String;
		
		private var list:Array = [];
		
		private var change_ls:Array = [];
		
		public function add(moduleName:String):void
		{
			list.push(moduleName);
		}
		
		/**
		 * 该xml发生改变
		 */ 
		public function change():void
		{
			change_ls = list.slice();
		}
		
		/**
		 * 某个模块已经重新加载过了
		 */ 
		public function noChange(moduleName:String):void
		{
			var ind:int = change_ls.indexOf(moduleName);
			if(ind>=0){
				change_ls.splice(ind,1);
			}
		}
		
		public function checkChange(moduleName:String):Boolean
		{
			var ind:int = change_ls.indexOf(moduleName);
			if(ind>=0){
				return true;
			}
			return false;
		}
		
		
	}
}