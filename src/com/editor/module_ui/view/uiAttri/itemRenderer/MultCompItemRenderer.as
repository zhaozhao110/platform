package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.ComAlignCell;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;

	public class MultCompItemRenderer extends ASHListItemRenderer
	{
		public function MultCompItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var txt:UILabel;
		private var addBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			txt = new UILabel();
			txt.width = 200;
			addChild(txt);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "close2_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "删除"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			addChild(addBtn);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			ComAlignCell.instance.delSelectComp(item);
		}
		
		private var item:UIShowCompProxy;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			item = value;
			txt.text = item.name;
			txt.toolTip = item.toolTip;
			
		}
		
		
	}
}