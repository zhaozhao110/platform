package com.editor.module_actionMix.vo.mix
{
	/**
	 * editor生成的
	 */ 
	public class ActionMixListVO
	{
		public function ActionMixListVO(x:XML,getName_f:Function)
		{
			parser(x,getName_f);
		}
		
		public var list:Array = [];
		public var all_ls:Array = [];
		
		private function parser(x:XML,getName_f:Function):void
		{
			for each(var p:XML in x.i){
				var item:ActionMixGroupVO = new ActionMixGroupVO(p,all_ls,getName_f);
				list[item.actionGroupId.toString()] = item;
			}
		}
		
		public function getItemByActionGroup(actionGroup:int,id:int):ActionMixItemVO
		{
			var g:ActionMixGroupVO = list[actionGroup.toString()] as ActionMixGroupVO;
			if(g!=null){
				return g.getItemByActionGroup(id);
			}
			return null;
		}
		
		public function getGroupByActionGroup(groupId:int):ActionMixGroupVO
		{
			return list[groupId.toString()] as ActionMixGroupVO;
		}
		
		public function getItemById(id:int):ActionMixItemVO
		{
			return all_ls[id.toString()] as ActionMixItemVO;
		}
		
	}
}