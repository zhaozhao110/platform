package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class COMCacheUIItemRenderer extends ASHListItemRenderer
	{
		public function COMCacheUIItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var txt:UILabel;
		private var addBtn:UIAssetsSymbol;
		private var cb:UIRadioButton;
		public static var cbGroup:UIRadioButtonGroup = new UIRadioButtonGroup();
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			cbGroup.multipleSelect = true;
			
			cb = new UIRadioButton();
			cb.selected = false;
			cb.label = " "
			cb.value = item;
			cb.group = cbGroup;
			addChild(cb);
			
			txt = new UILabel();
			txt.selectable = false;
			txt.width = 185;
			addChild(txt);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "复制单个到当前窗口"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			addChild(addBtn);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			UIEditManager.getInstance().globalParse(item);
		}
		
		private var item:UIShowCompProxy;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			item = value;
			txt.text = item.name;
			this.toolTip = item.toolTip;
			
		}
		
		
	}
}