package com.editor.modules.pop.editServerInterface
{
	import com.asparser.ClsAttri;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;
	
	public class EditServerInterfaceItemRenderer extends ASHListItemRenderer
	{
		public function EditServerInterfaceItemRenderer()
		{
			super();
			create_init();
		}
		
		private var ti:UILabel;
		private var img:UIAssetsSymbol;
		private var addImg:UIAssetsSymbol;
		
		override protected function renderTextField():void{};
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			ti = new UILabel();
			ti.width = 380;
			addChild(ti);
			
			img = new UIAssetsSymbol();
			img.source = "close2_a"
			img.buttonMode = true;
			img.toolTip = "删除"
			img.addEventListener(MouseEvent.CLICK , onClick);
			addChild(img);
			
			addImg = new UIAssetsSymbol();
			addImg.source = "add_a"
			addImg.buttonMode = true;
			addImg.toolTip = "生成serverCode函数<br>系统将会自动生成解析socket的函数"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			addChild(addImg);
			
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			get_AppEditEventPopWinMediator().tool.createSocketCode(item);
		}
		
		private function onClick(e:MouseEvent):void
		{
			get_AppEditEventPopWinMediator().tool.del(item.name);
		}
		
		private function get_AppEditEventPopWinMediator():EditServerInterfacePopwinMediator
		{
			return iManager.retrieveMediator(EditServerInterfacePopwinMediator.NAME) as EditServerInterfacePopwinMediator;
		}
		
		private var item:ClsAttri;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as ClsAttri;
			ti.text = item.name;
			ti.toolTip = item.info;
		}
	}
}