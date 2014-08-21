package com.editor.module_actionMix.vo.mix
{
	import com.sandy.utils.StringTWLUtil;

	public class ActionMixTypeVO
	{
		public function ActionMixTypeVO(x:XML)
		{
			parser(x);
		}
		
		public var actionType:String;
		public var frameIndex:int;
		public var total:int;
		
		public var actionGroupId:int;
		public var id:int;
		
		private function parser(x:XML):void
		{
			var a:String = x.@i;
			var aa:Array = a.split("-");
			actionType = aa[0];
			frameIndex = int(aa[1]);
			
			total = int(x.@t);
		}
		
		public function getSign():String
		{
			return actionType + " - " + frameIndex;
		}
		
		/**
		 * 空白帧
		 */ 
		public function checkIsEmptyFrame():Boolean
		{
			if(StringTWLUtil.isWhitespace(actionType)){
				return true;
			}
			return false;
		}
	}
}