package com.editor.module_gdps.pop.userManageProduct
{
	import com.editor.component.controls.UICheckBox;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.utils.interfac.IObjectPoolInterface;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GdpsUserManageProductRenderer extends SandyBoxItemRenderer
	{
		public function GdpsUserManageProductRenderer()
		{
			super();
			
			create_init();
		}
		
		private var cb:UICheckBox;
		private var item:Object;
		
		private function create_init():void
		{
			cb = new UICheckBox();
			cb.enabledPercentSize = true;
			cb.selected = false;
			cb.addEventListener(MouseEvent.CLICK , onChangeHandler);
			addChild(cb);
		}
		
		private function onChangeHandler(e:MouseEvent):void
		{
			item.checked = cb.selected;
		}
		
		override public function poolChange(value:*):void
		{
			if(value == null || cb == null) return;
			
			item = value;
			cb.label = item.NId + " - " + item.SName;
			cb.selected = item.checked;
		}
		
		public function getData():Object
		{
			return item;
		}
		
		override public function poolSetValue(value:*):void
		{
			poolChange(value);
		}
		
		override public function poolDispose():void
		{
			item = null;
			cb.removeEventListener(ASEvent.CHANGE , onChangeHandler);
		}
	}
}