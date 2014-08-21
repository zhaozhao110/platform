package com.editor.module_actionMix.vo
{
	public class ActionMixActionVO
	{
		public function ActionMixActionVO()
		{
		}
		
		//动作类型,
		public var actionType:String ;
		//动作的第几帧
		public var frame:int;
		
		public function getInfo():String
		{
			return actionType + "/" + frame;
		}
		
	}
}