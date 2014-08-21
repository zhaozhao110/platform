package com.editor.module_actionMix.vo.mix
{
	public class ActionMixGroupVO
	{
		public function ActionMixGroupVO(x:XML,_all_ls:Array,getName_f:Function)
		{
			parser(x,_all_ls,getName_f);
		}
		
		public var list:Array = [];
		public var all_ls:Array = [];
		//动作组ID
		public var actionGroupId:int;
		
		private function parser(x:XML,_all_ls:Array,getName_f:Function):void
		{
			actionGroupId = int(x.@i);
			
			for each(var p:XML in x.i){
				var item:ActionMixItemVO = new ActionMixItemVO(p,actionGroupId,getName_f);
				list[item.id.toString()] = item;
				all_ls.push(item);
				_all_ls[item.id.toString()] = item;
			}
		}
		
		public function getIndexById(id:int):int
		{
			for(var i:int=0;i<all_ls.length;i++){
				if(ActionMixItemVO(all_ls[i]).id == id){
					return i;
				}
			}
			return -1;
		}
		
		public function getItemByActionGroup(id:int):ActionMixItemVO
		{
			return list[id.toString()] as ActionMixItemVO;
		}
		
	}
}