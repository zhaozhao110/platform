package com.editor.module_ui.view.cssAttri
{
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.css.CSSShowContainer;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.view.uiAttri.ComTypeManager;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.ColorUtils;

	public class CSSEditorAttriCellItemRenderer extends SandyHBoxItemRenderer
	{
		public function CSSEditorAttriCellItemRenderer()
		{
			super();
			height = 25
			horizontalGap = 3;
			
		}
		
		private var item:ComAttriItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			item = value as ComAttriItemVO;
			
			renderComp();
		}
		
		public var comp:IComBase;
		
		private function renderComp():void
		{
			if(comp == null){
				comp = ComTypeManager.getComByType(item.value) as IComBase;
				addChild(comp as ASComponent);
			}
			if(comp == null) return ;
			this.height = ASComponent(comp).height;
			comp.item = item;
			comp.reflashFun = uiReflash;
		}
		
		public function setCompValue(d:IComBaseVO):void
		{
			if(comp!=null){
				comp.setValue(d);
			}
		}
		
		private function uiReflash(ui:IComBase):void
		{
			iManager.sendAppNotification(UIEvent.reflash_cssInfo_event);
		}
		
	}
}