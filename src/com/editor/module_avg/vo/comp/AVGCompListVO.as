package com.editor.module_avg.vo.comp
{
	public class AVGCompListVO
	{
		public function AVGCompListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++)
			{
				var d:AVGCompItemVO = new AVGCompItemVO(a[i]);
				comp_ls.push(d);
			}
		}
		
		public var comp_ls:Array = [];
		
		public function getItemByType(t:int):AVGCompItemVO
		{
			for(var i:int=0;i<comp_ls.length;i++){
				var d:AVGCompItemVO = comp_ls[i] as AVGCompItemVO;
				if(d.type == t){
					return d;
				}
			}
			return null;
		}
		
		
	}
}