package com.editor.module_skill.vo.motion
{
	public class MotionLvlGroupVO
	{
		public function MotionLvlGroupVO(x:XML)
		{
			parser(x);
		}
		
		public var action_ls:Array = [];
		public var voc:int;
		
		private function parser(x:XML):void
		{
			voc = int(x.@i);	
			for each(var p:XML in x.i){
				var item:MotionLvlItemVO = new MotionLvlItemVO(p);
				action_ls[item.action] = item;
			}
		}
		
		public function getItemByAction(act:String):MotionLvlItemVO
		{
			return action_ls[act] as MotionLvlItemVO
		}
	}
}