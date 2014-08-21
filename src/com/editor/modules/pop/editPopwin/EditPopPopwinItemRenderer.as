package com.editor.modules.pop.editPopwin
{
	import com.asparser.ClsAttri;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.model.PopupwinSign;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.MouseEvent;

	public class EditPopPopwinItemRenderer extends ASHListItemRenderer
	{
		public function EditPopPopwinItemRenderer()
		{
			super();
			create_init();
		}
		
		private var ti:UILabel;
		private var img:UIAssetsSymbol;
		private var addImg:UIAssetsSymbol;
		private var addImg3:UIAssetsSymbol;
		
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
			addImg.toolTip = "查看"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			addChild(addImg);
			
			addImg3 = new UIAssetsSymbol();
			addImg3.source = "add_a"
			addImg3.buttonMode = true;
			addImg3.toolTip = "编辑view"
			addImg3.addEventListener(MouseEvent.CLICK , onAddClick3);
			addChild(addImg3);
		}
		
		private function onAddClick3(e:MouseEvent):void
		{
			get_EditPopPopwinMediator().tool.edit(item)
			iManager.iPopupwin.closePoupwin(PopupwinSign.EditPopPopwin_sign)
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			get_EditPopPopwinMediator().tool.open(item)
			iManager.iPopupwin.closePoupwin(PopupwinSign.EditPopPopwin_sign)
		}
		
		private function onClick(e:MouseEvent):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要删除"+item.name+"?"
			m.okFunction = confirm_del;
			iManager.iPopupwin.showConfirm(m);
		}
		
		private function confirm_del():Boolean{
			get_EditPopPopwinMediator().tool.del(item)
			return true
		}
		
		private function get_EditPopPopwinMediator():EditPopPopwinMediator
		{
			return iManager.retrieveMediator(EditPopPopwinMediator.NAME) as EditPopPopwinMediator;
		}
		
		private var item:ClsAttri;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as ClsAttri;
			ti.text = item.name.split("_")[0];
			ti.toolTip = item.info;
		}
		
	}
}