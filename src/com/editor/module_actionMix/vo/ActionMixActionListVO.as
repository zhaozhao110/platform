package com.editor.module_actionMix.vo
{
	public class ActionMixActionListVO
	{
		public function ActionMixActionListVO()
		{
		}
		
		public var list:Array = [];
		
		public function add(actionType:String,frame:int):void
		{
			var vo:ActionMixActionVO = new ActionMixActionVO();
			vo.actionType = actionType;
			vo.frame = frame;
			list.push(vo);
		}
		
		public function del(index:int):void
		{
			list.splice(index,1);
		}
	}
}