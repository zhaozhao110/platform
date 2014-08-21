package com.editor.vo.temple
{
	public class TempleListVO
	{
		public function TempleListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				var d:TempleItemVO = new TempleItemVO(obj);
				all_ls.push(d);
				hash_ls[d.id.toString()] = d;
			}
		}
		
		private var hash_ls:Array = [];
		public var all_ls:Array = [];
		
		public function getTemple(id:int):TempleItemVO
		{
			return hash_ls[id.toString()] as TempleItemVO;
		}
	}
}