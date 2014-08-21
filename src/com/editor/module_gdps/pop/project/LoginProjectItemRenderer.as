package com.editor.module_gdps.pop.project
{
	import com.editor.component.controls.UIButton;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class LoginProjectItemRenderer extends SandyBoxItemRenderer
	{
		public function LoginProjectItemRenderer()
		{
			super();
			
			create_init();
		}
		private var btn:UIButton;
		
		private function create_init():void
		{
			height = 50;
			width = 220;
			mouseChildren = true;
			
			btn = new UIButton();
			btn.width = 220;
			btn.height = 50;
			btn.addEventListener(MouseEvent.CLICK , onClickHandler);
			addChild(btn);
			
			initComplete();
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if(btn.data == null) return;
			projectMedi().clickHandler(e);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			if(value == null || btn == null) return;
			var proItem:Object = value;
			btn.id = proItem.alias;
			btn.data = {projectId : proItem.areaId, projectName : proItem.areaName, projectType : proItem.areaType};
			if(int(proItem.areaId) == GDPSDataManager.systemManagerType){
				btn.label = proItem.areaName + "[" +proItem.areaId+ "]";
			}else if(proItem.areaType == "1"){
				btn.label = ColorUtils.addColorTool("[webGame]",0x12722b) + proItem.areaName + "[" +proItem.areaId+ "]";
			}else if(proItem.areaType == "2"){
				btn.label = ColorUtils.addColorTool("[mobileGame]",0xcc0000) + proItem.areaName + "[" +proItem.areaId+ "]";
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(btn){
				btn.removeEventListener(MouseEvent.CLICK , onClickHandler);
			}
		}
		
		private function projectMedi():LoginProjectPopwinMediator
		{
			return iManager.ifabrication.retrieveMediator(LoginProjectPopwinMediator.NAME) 
				as LoginProjectPopwinMediator;
		}
	}
}