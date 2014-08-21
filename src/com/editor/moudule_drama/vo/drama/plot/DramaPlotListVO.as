package com.editor.moudule_drama.vo.drama.plot
{
	public class DramaPlotListVO
	{
		public var list:Array = [];
		public function DramaPlotListVO(x:XML)
		{
			parser(x);
		}
		
		private function parser(x:XML):void
		{
			for each(var iX:XML in x.g)
			{
				var note:DramaPlotListNodeVO = new DramaPlotListNodeVO(iX);
				list.push(note);
			}			
		}
		
		/**获取当前剧情所有对话**/
		public function getPlotListNodeById(id:int):DramaPlotListNodeVO
		{
			var outNode:DramaPlotListNodeVO;
			
			var len:int = list.length;
			for(var i:int=0;i<len;i++)
			{
				var node:DramaPlotListNodeVO = list[i] as DramaPlotListNodeVO;
				if(node && node.id == id)
				{
					outNode = node;
					break;
				}
			}			
			return outNode;
		}
		
		/**获取对话BY ID**/
		public function getPlotItem(id:int, nodeId:int):DramaPlotItemVO
		{
			var out:DramaPlotItemVO;
			if(nodeId)
			{
				var node:DramaPlotListNodeVO = getPlotListNodeById(nodeId);
				if(node)
				{
					out = node.getPlotItemById(id);
				}				
			}
			
			return out;
			
		}
		
		
		
	}
}