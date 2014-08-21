package com.editor.module_actionMix.vo.project
{
	public class ActionMixProjectListVO
	{
		public function ActionMixProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:ActionMixProjectItemVO = new ActionMixProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):ActionMixProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(ActionMixProjectItemVO(list[i]).data == tp){
					return ActionMixProjectItemVO(list[i]);
				}
			}
			return null;
		}
	}
}