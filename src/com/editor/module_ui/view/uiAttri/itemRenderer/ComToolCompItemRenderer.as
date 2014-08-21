package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.ComToolAttriCell;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	
	import flash.events.MouseEvent;
	
	public class ComToolCompItemRenderer extends ASListItemRenderer
	{
		public function ComToolCompItemRenderer()
		{
			super();
		}
		
		override protected function renderTextField():void{};
		
		private var proxy:UIShowCompProxy;
		private var hb2:UIHBox;
		private var text:UILabel;
		private var upBtn:UIAssetsSymbol;
		private var downBtn:UIAssetsSymbol;
		private var selectedBtn:UIAssetsSymbol;
		private var openBtn:UIAssetsSymbol 
		public var toolCell:BoxCell;
		private var delBtn:UIAssetsSymbol;
		
		override protected function __init__():void
		{
			super.__init__();
			
			width = 260;
			height = 25;
			
			var hb1:UIHBox = new UIHBox();
			hb1.percentWidth = 100;
			hb1.horizontalGap = 3;
			hb1.height = 25;
			addChild(hb1);
			
			text = new UILabel();
			text.width = 220;
			hb1.addChild(text);
			
			openBtn = new UIAssetsSymbol();
			openBtn.source = "openFold_a";
			openBtn.buttonMode = true;
			openBtn.toolTip = "展开";
			openBtn.addEventListener(MouseEvent.CLICK , onOpenClick)
			hb1.addChild(openBtn);
			
			hb2 = new UIHBox();
			hb2.horizontalGap = 5;
			hb2.visible = false;
			hb2.includeInLayout = false;
			hb2.percentWidth = 100;
			hb2.height = 25;
			hb2.y = 25;
			addChild(hb2);
			
			upBtn = new UIAssetsSymbol();
			upBtn.source = "up_arr_a"
			upBtn.width = 20;
			upBtn.height = 20;
			upBtn.toolTip = "上升一层"
			upBtn.buttonMode = true;
			upBtn.addEventListener(MouseEvent.CLICK , onUpHandle);
			hb2.addChild(upBtn);
			
			downBtn = new UIAssetsSymbol();
			downBtn.source = "down_arr_a"
			downBtn.width =20;
			downBtn.height = 20;
			downBtn.toolTip = "下降一层"
			downBtn.buttonMode = true;
			downBtn.addEventListener(MouseEvent.CLICK , onDownHandle)
			hb2.addChild(downBtn);
			
			selectedBtn = new UIAssetsSymbol();
			selectedBtn.source = "right_a"
			selectedBtn.toolTip = "选中"
			selectedBtn.buttonMode = true;
			selectedBtn.addEventListener(MouseEvent.CLICK,onSelectHandle);
			hb2.addChild(selectedBtn);
			
			delBtn = new UIAssetsSymbol();
			delBtn.source = "close2_a"
			delBtn.toolTip = "删除"
			delBtn.buttonMode = true;
			delBtn.addEventListener(MouseEvent.CLICK , onDelHandle);
			hb2.addChild(delBtn);
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			proxy.target.swapToUpLevel();
			toolCell.reflash();
		}
		
		private function onUpHandle(e:MouseEvent):void
		{
			proxy.target.swapToDownLevel();
			toolCell.reflash();
		}
		
		private function onSelectHandle(e:MouseEvent):void
		{
			UIEditManager.currEditShowContainer.setTransToolTarget(proxy);
		}
		
		private function onOpenClick(e:MouseEvent):void
		{
			hb2.visible = !hb2.visible;
			hb2.includeInLayout = !hb2.includeInLayout;
			if(hb2.visible){
				height = 50;
				openBtn.toolTip = "收缩"
			}else{
				height = 25;
				openBtn.toolTip = "展开"
			}
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			mouseChildren = true;
			
			height = 25;
			hb2.visible = false;
			hb2.includeInLayout = false;
			openBtn.toolTip = "展开"
			
			proxy = Object(value).data;
			text.text = proxy.name;
			text.toolTip = proxy.name;
		}
		
		override protected function item_downHandle(e:MouseEvent):void
		{
		}
		
		private function onDelHandle(e:MouseEvent):void
		{
			UIEditManager.getInstance().delComp(UIEditManager.currEditShowContainer.selectedUI);
			toolCell.reflash();
		}
		
	}
}