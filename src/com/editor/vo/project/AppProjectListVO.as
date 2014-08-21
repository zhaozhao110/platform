package com.editor.vo.project
{
	import flash.data.SQLResult;

	public class AppProjectListVO
	{
		public function AppProjectListVO(x:SQLResult)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:SQLResult):void
		{
			var a:Array = x.data;
			var len:int = a.length;
			for(var i:int=0;i<len;i++){
				var item:AppProjectItemVO = new AppProjectItemVO(a[i]);
				list.push(item);
			}
		}
		
		public function getProjectName(en:String):String
		{
			for(var i:int=0;i<list.length;i++){
				if(AppProjectItemVO(list[i]).data == en){
					return AppProjectItemVO(list[i]).label;
				}
			}
			return "";
		}
	}
}