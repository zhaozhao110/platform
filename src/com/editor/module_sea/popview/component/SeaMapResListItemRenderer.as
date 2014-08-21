package com.editor.module_sea.popview.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;

	public class SeaMapResListItemRenderer extends ASHListItemRenderer
	{
		public function SeaMapResListItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var lb:UILabel;
		private var vcb:UICheckBox;
		private var upBtn:UIAssetsSymbol;
		private var downBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			horizontalGap = 5;
			
			lb = new UILabel();
			lb.selectable = false;
			lb.mouseChildren = false;
			lb.mouseEnabled = false;
			lb.width = 100;
			lb.height = 22
			addChild(lb);
			
			vcb = new UICheckBox();
			vcb.label = "显示"
			vcb.width = 50;
			vcb.selected = true;
			vcb.addEventListener(ASEvent.CHANGE,onVisibleChange);
			addChild(vcb);
			
			upBtn = new UIAssetsSymbol();
			upBtn.source = "up_arr_a"
			upBtn.width = 20;
			upBtn.height = 20;
			upBtn.toolTip = "上升一层"
			upBtn.buttonMode = true;
			upBtn.addEventListener(MouseEvent.CLICK , onUpHandle);
			addChild(upBtn);
			
			downBtn = new UIAssetsSymbol();
			downBtn.source = "down_arr_a"
			downBtn.width =20;
			downBtn.height = 20;
			downBtn.toolTip = "下降一层"
			downBtn.buttonMode = true;
			downBtn.addEventListener(MouseEvent.CLICK , onDownHandle)
			addChild(downBtn);
		}
		
		private var item:SeaMapItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as SeaMapItemVO;
			lb.text = item.name2;
		}
		
		private function onUpHandle(e:MouseEvent):void
		{
			item.container.swapToUpLevel()
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			item.container.swapToDownLevel();
		}
		private function onVisibleChange(e:ASEvent):void
		{
			item.container.visible = !item.container.visible 
		}
		
		
	}
}