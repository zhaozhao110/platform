package com.editor.module_actionMix.vo
{
	/**
	 * action.xml里的,excel里的
	 */ 
	public class ActionMixActionXMLListVO
	{
		public function ActionMixActionXMLListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		public var list2:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.i){
				var item:ActionMixActionXMLItemVO = new ActionMixActionXMLItemVO(p);
				if(list[item.actionGruopId] == null){
					list[item.actionGruopId] = []
				}
				(list[item.actionGruopId] as Array).push(item);
				list2[item.id.toString()] = item;
			}
		}
		
		public function getActionList(actionGruopId:Number):Array
		{
			return list[actionGruopId];
		}
		
		public function getItemById(id:int):ActionMixActionXMLItemVO
		{
			return list2[id.toString()] as ActionMixActionXMLItemVO
		}
	}
}