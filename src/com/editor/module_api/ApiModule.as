package com.editor.module_api
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.ui.layout2.EditorPlugContainer;
	
	import com.editor.module_api.view.ApiModuleLeftCont;
	import com.editor.module_api.view.ApiModuleManager;
	import com.editor.module_api.view.ApiModuleRightCont;
	import com.editor.module_api.view.ApiModuleTopBar;
	
	public class ApiModule extends UICanvas
	{
		public function ApiModule()
		{
			super();
			EditorApiFacade.getInstance().module = this;
			EditorApiFacade.getInstance().moduleFacade = iManager.ifabrication.getFacade("");
			create_init()
		}
		
		public static const MODULENAME:String = "ApiModule";
		
		public var toolCont:ApiModuleTopBar;
		public var leftCont:ApiModuleLeftCont;
		public var rightCont:ApiModuleRightCont;
		public var managerCont:ApiModuleManager
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
						
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			vb.cornerRadius = 10;
			vb.verticalGap = 5
			addChild(vb);
			
			toolCont = new ApiModuleTopBar();
			vb.addChild(toolCont);
			
			var hb:UIHBox = new UIHBox();
			hb.enabledPercentSize = true;
			hb.horizontalGap = 5
			vb.addChild(hb);
			
			leftCont = new ApiModuleLeftCont();
			hb.addChild(leftCont);
						
			rightCont = new ApiModuleRightCont();
			hb.addChild(rightCont);	
			
			managerCont = new ApiModuleManager();
			addChild(managerCont);
		}
		
	}
}