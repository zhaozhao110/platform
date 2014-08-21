package com.editor.module_skill.vo.motion
{
	public class MotionLvlListVO
	{
		public function MotionLvlListVO(x:XML)
		{
			parser(x);			
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.i){
				var g:MotionLvlGroupVO = new MotionLvlGroupVO(p);
				list[g.voc.toString()] = g;
			}
		}
		
		public function getGroup(voc:int):MotionLvlGroupVO
		{
			return list[voc.toString()] as MotionLvlGroupVO
		}
	}
}