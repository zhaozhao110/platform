package com.editor.modules.app.view.ui.topBar
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.component.controls.UIToggleButtonBar;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class AppTopBarContainer extends UIVBox
	{
		public function AppTopBarContainer()
		{
			super();
			create_init();
		}
		
		
		
		public var menuBar:UIMenuBar;
		public var stackBar:UIToggleButtonBar;
		public var toolBarCanvas:UIHBox;
		public var projectHB:UIHBox;
		public var txt:UILabel;
		public var setBtn:UIButton;
		public var to3DBtn:UIButton;
		public var toGDPSBtn:UIButton;
		
		private function create_init():void
		{
			//background_red = true
			height = 60;
			percentWidth = 100;
			
			var h:UIHBox = new UIHBox();
			h.percentWidth = 100;
			h.height = 25;
			addChild(h);
			
			menuBar = new UIMenuBar();
			menuBar.percentWidth = 100;
			menuBar.height = 25
			h.addChild(menuBar);
			
			toolBarCanvas = new UIHBox();
			toolBarCanvas.name = "toolBarCanvas"
			toolBarCanvas.paddingLeft = 20;
			toolBarCanvas.paddingRight = 20;
			toolBarCanvas.height = 30;
			toolBarCanvas.percentWidth = 100;
			//toolBarCanvas.background_red = true
			addChild(toolBarCanvas);
			
			projectHB = new UIHBox();
			projectHB.height = 30;
			projectHB.percentWidth = 100
			projectHB.horizontalGap = 5;
			//projectHB.visible = false;
			toolBarCanvas.addChild(projectHB);
			
			setBtn = new UIButton();
			setBtn.label = "项目设置"
			setBtn.visible = false
			projectHB.addChild(setBtn);
			
			txt = new UILabel();
			projectHB.addChild(txt);
			
			
			
			stackBar = new UIToggleButtonBar();
			stackBar.name = "AppTopBarContainer";
			stackBar.enabledTabClose = true;
			stackBar.percentWidth = 100;
			//stackBar.background_red = true
			stackBar.labelField = "value"
			stackBar.enabled_anchor = true;
			//stackBar.tabWidth = 80;
			stackBar.horizontalAlign = ASComponentConst.horizontalAlign_right;
			projectHB.addChild(stackBar);
			
			to3DBtn = new UIButton();
			to3DBtn.label = "切换到3D场景";
			to3DBtn.right = 20;
			h.addChild(to3DBtn);
			
			toGDPSBtn = new UIButton();
			toGDPSBtn.label = "切换到GDPS"
			toGDPSBtn.right = 100;
			h.addChild(toGDPSBtn);
			
			initComplete();
		}
		
	}
}