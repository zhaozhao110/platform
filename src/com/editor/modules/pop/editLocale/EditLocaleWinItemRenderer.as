package com.editor.modules.pop.editLocale
{
	import com.asparser.Field;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.vo.LocaleData;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;

	public class EditLocaleWinItemRenderer extends ASHListItemRenderer
	{
		public function EditLocaleWinItemRenderer()
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
			addImg.toolTip = "查看该locale所被使用的类列表"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			addChild(addImg);
			
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			get_EditLocalePopwinMediator().tool.findBindClass(item);
		}
		
		private function onClick(e:MouseEvent):void
		{
			get_EditLocalePopwinMediator().tool.del(item);
		}
		
		private function get_EditLocalePopwinMediator():EditLocalePopwinMediator
		{
			return iManager.retrieveMediator(EditLocalePopwinMediator.NAME) as EditLocalePopwinMediator;
		}
		
		private var item:LocaleData;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as LocaleData;
			ti.text = item.toString();
		}
		
	}
}