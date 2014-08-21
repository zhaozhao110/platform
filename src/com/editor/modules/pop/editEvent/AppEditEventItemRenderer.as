package com.editor.modules.pop.editEvent
{
	import com.asparser.ClsAttri;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;

	public class AppEditEventItemRenderer extends ASHListItemRenderer
	{
		public function AppEditEventItemRenderer()
		{
			super();
			create_init();
		}
		
		private var ti:UILabel;
		private var img:UIAssetsSymbol;
		private var addImg:UIAssetsSymbol;
		private var addImg2:UIAssetsSymbol;
		
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
			addImg.toolTip = "生成command<br>系统将会自动在src/rpg/command/action目录里创建代码"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			addChild(addImg);
			
			addImg2 = new UIAssetsSymbol();
			addImg2.source = "add_a"
			addImg2.buttonMode = true;
			addImg2.toolTip = "生成interceptor<br>系统将会自动在src/rpg/command/interceptor目录里创建代码"
			addImg2.addEventListener(MouseEvent.CLICK , onAddClick2);
			addChild(addImg2);
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			get_AppEditEventPopWinMediator().tool.createCommand(item);
		}
		
		private function onAddClick2(e:MouseEvent):void
		{
			get_AppEditEventPopWinMediator().tool.createInterceptor(item);
		}
		
		private function onClick(e:MouseEvent):void
		{
			get_AppEditEventPopWinMediator().tool.del(item.name);
		}
		
		private function get_AppEditEventPopWinMediator():AppEditEventPopWinMediator
		{
			return iManager.retrieveMediator(AppEditEventPopWinMediator.NAME) as AppEditEventPopWinMediator;
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