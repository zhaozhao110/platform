package com.editor.module_ui.vo.component
{
	import com.editor.manager.DataManager;
	import com.editor.vo.dict.DictListVO;

	public class ComGroupVO
	{
		public function ComGroupVO()
		{
			
		}
		
		public var id:int;
		public var list:Array = [];
		public var name:String;
		
		public function parser():void
		{
			name = DictListVO.getGroup(DataManager.com_enumType).getValue(id);
		}
		
		public function addItem(item:ComItemVO):void
		{
			list.push(item);
		}
		
	}
}