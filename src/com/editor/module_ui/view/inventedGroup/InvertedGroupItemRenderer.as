package com.editor.module_ui.view.inventedGroup
{
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.component.ComListVO;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.asComponent.layout.IASBoxLayoutTarget;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class InvertedGroupItemRenderer extends ASListItemRenderer
	{
		public function InvertedGroupItemRenderer()
		{
			super()
		}
		
		private var groupVO:InvertedGroupVO;
			
		override protected function item_downHandle(e:MouseEvent):void
		{
			var d:ComponentData = new ComponentData();
			d.name = groupVO.name;
			d.invertedGroup = groupVO;
			d.item = get_AppComponentProxy().com_ls.getItemByName(d.name);
			iManager.sendAppNotification(UIEvent.selectUI_inUI_event,d);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			groupVO = value as InvertedGroupVO;
			textfield.text = "id:"+groupVO.id.toString();
		}
		
		override protected function measuredTextFieldLoc():void
		{
			super.measuredTextFieldLoc();
			if(textfield!=null){
				textfield.x = 20;
			}
		}
		
		private function get_AppComponentProxy():AppComponentProxy
		{
			return iManager.retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
	}
}