package com.editor.module_sea
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.view.SeaMapContent;
	import com.editor.module_sea.view.SeaMapModuleTopContainer;

	public class SeaMapModule extends UICanvas
	{
		public function SeaMapModule()
		{
			super();
			create_init();
		}
		
		public static const MODULENAME:String = "SeaMapModule";
		
		public var topContainer:SeaMapModuleTopContainer;
		public var cont:SeaMapContent;
		public var logContainer:LogContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding = 10;
			mouseEnabled = true
			
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb);
			
			topContainer = new SeaMapModuleTopContainer();
			vb.addChild(topContainer);
			
			cont = new SeaMapContent();
			vb.addChild(cont);
			
			logContainer = new LogContainer();
			addChild(logContainer);
			
			SeaMapModuleManager.logCont = logContainer;
			
			initComplete();
		}
		
	}
}