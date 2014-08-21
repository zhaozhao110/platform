package com.editor.module_pop.serverDirManager.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ServerDirManagerBottomView extends UICanvas
	{
		public function ServerDirManagerBottomView()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			width = 850;
			height = 100;
				
			vbox = new UIVBox();
			vbox.enabledPercentSize = true
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(vbox)
		}
	}
}