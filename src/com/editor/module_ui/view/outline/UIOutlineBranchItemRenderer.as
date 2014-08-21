package com.editor.module_ui.view.outline
{
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.vo.UITreeNode;
	import com.sandy.asComponent.itemRenderer.ASTreeItemRenderer;
	
	import flash.events.MouseEvent;

	public class UIOutlineBranchItemRenderer extends ASTreeItemRenderer
	{
		public function UIOutlineBranchItemRenderer()
		{
			super();
			addEventListener(MouseEvent.RIGHT_CLICK,onRightClick)
		}
		
		private function onRightClick(e:MouseEvent):void
		{
			UIEditManager.getInstance().openRightMenu(UITreeNode(data).obj as UIShowCompProxy)
		}
		
		override protected function item_downHandle(e:MouseEvent):void
		{
			if(data is UITreeNode && UITreeNode(data).obj is UIShowCompProxy ){
				UIEditManager.currEditShowContainer.setTransToolTarget((UITreeNode(data).obj as UIShowCompProxy));
			}
			super.item_downHandle(e);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			if(value == null){
				toolTip = "";
				return ;
			}
			if(Object(UITreeNode(data).obj).hasOwnProperty("toolTip")){
				toolTip = Object(UITreeNode(data).obj).toolTip;
			}
		}
		
	}
}