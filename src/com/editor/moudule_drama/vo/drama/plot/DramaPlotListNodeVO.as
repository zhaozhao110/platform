package com.editor.moudule_drama.vo.drama.plot
{
	public class DramaPlotListNodeVO
	{
		/**
		  p:剧情ID
	     n:剧情名称
	     c:所属场景ID
	     t:触发条件
		 * **/
		public var id:int;
		public var name:String;
		public var sceneId:int;
		public var conditions:String;
		
		public var list:Array = [];
		public function DramaPlotListNodeVO(x:XML)
		{
			parser(x);
		}
		private function parser(x:XML):void
		{
			id = int(x.@p);
			name = String(x.@n);
			sceneId = int(x.@c);
			conditions = String(x.@t);
			
			for each(var iX:XML in x.i)
			{
				var item:DramaPlotItemVO = new DramaPlotItemVO(iX);
				list.push(item);
			}
			
		}
		
		
		public function get name1():String
		{
			return id + " / " + name;
		}
		
		public function getPlotItemById(id:int):DramaPlotItemVO
		{
			var out:DramaPlotItemVO;
			
			var a:Array = list;
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var item:DramaPlotItemVO = a[i] as DramaPlotItemVO;
				if(item && item.id == id)
				{
					out = item;
					break;
				}
			}
			
			return out;
		}
		
	}
}