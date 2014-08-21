package com.editor.modules.common.layout2.right
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout2.AppLayout2Container;
	
	import flash.display.DisplayObject;

	public class AppLayout2RightContainer extends UICanvas
	{
		public function AppLayout2RightContainer(_module:AppLayout2Container)
		{
			super();
			module = _module;
			create_init();
		}
		
		private var module:AppLayout2Container;
		public var logContainer:LogContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			
			if(module.addLogBool){
				logContainer = new LogContainer();
				addChild(logContainer);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var ds:DisplayObject = super.addChild(child);
			if(logContainer!=null){
				setChildIndex(logContainer,this.numChildren-1);
			}
			return ds;
		}
	}
}