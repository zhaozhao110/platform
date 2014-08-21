package com.editor.module_avg.vo.plot
{
	public class AVGPlotListVO
	{
		public function AVGPlotListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.i){
				var item:AVGPlotItemVO = new AVGPlotItemVO(p);
				list.push(item);
			}
		}
		
	}
}