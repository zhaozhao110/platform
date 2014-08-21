package com.editor.vo.pop
{
	public class AppPopinfoListVO
	{
		public function AppPopinfoListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				var d:AppPopinfoVO = new AppPopinfoVO(obj);
				all_ls.push(d);
				hash_ls[d.id.toString()] = d;
			}
		}
		
		private var hash_ls:Array = [];
		public var all_ls:Array = [];
		
		public function getData(id:int):AppPopinfoVO
		{
			return hash_ls[id.toString()] as AppPopinfoVO;
		}
	}
}