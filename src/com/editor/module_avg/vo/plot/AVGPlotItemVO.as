package com.editor.module_avg.vo.plot
{
	public class AVGPlotItemVO
	{
		public function AVGPlotItemVO(x:XML)
		{
			id = int(x.@i);
			name = x.@b;
		}
		
		public var id:int;
		public var name:String;
		
		public function get name1():String
		{
			return id + " / " + name;
		}
	}
}