package com.editor.project_pop.getLocale.component
{
	import com.air.io.SandyFileProxy;
	import com.editor.component.controls.UILinkButton;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2_tab;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;

	public class AppGetLocaleActionRenderer extends ASHListItemRenderer
	{
		public function AppGetLocaleActionRenderer()
		{
			super();
			horizontalAlign = ASComponentConst.horizontalAlign_center;
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var openBtn:UILinkButton;
		private var fileName:*;
		private var file:SandyFileProxy;
		
		private function create_init():void
		{
			
			openBtn = new UILinkButton();
			openBtn.label = "打开"
			openBtn.addEventListener(MouseEvent.CLICK , onOpen)
			addChild(openBtn);
		}
		
		override public function poolChange(value:*):void
		{
			if(value == "file_up"){
				fileName = "file_up"
				file = null
			}else{
				file = value as SandyFileProxy;
				fileName = file.name;
			}
			
			super.poolChange(value);
			
			mouseEnabled = false;
			mouseChildren = true
		}
		
		private function onOpen(e:MouseEvent):void
		{
			if(file == null){
				get_AppGetLocaleTab2_tab().gotoParent();
			}else if(file.isDirectory){
				get_AppGetLocaleTab2_tab().setPath(file.nativePath);
			}else{
				file.getFile().openWithDefaultApplication();
			}
		}
		
		private function get_AppGetLocaleTab2_tab():AppGetLocaleTab2_tab
		{
			return AppGetLocaleTab2_tab(uiowner.uiowner.uiowner.uiowner);
		}
		
	}
}