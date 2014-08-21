package com.editor.d3.app.view.ui.top
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.component.controls.UIToggleButtonBar;
	import com.editor.manager.DataManager;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.URLUtils;
	
	import flash.events.MouseEvent;

	public class App3DTopBarContainer extends UIVBox
	{
		public function App3DTopBarContainer()
		{
			super();
			create_init();
		}
				
		public var menuBar:UIMenuBar;
		public var stackBar:UIToggleButtonBar;
		public var toolBarCanvas:UIHBox;
		public var projectHB:UIHBox;
		public var txt:UILinkButton;
		public var demo1:UILinkButton;
		
		public var saveTXT:UILabel;
		public var saveTxtBtn:UIButton;
		public var preBtn:UIButton;
		
		private function create_init():void
		{
			mouseEnabled = true;
			backgroundColor = DataManager.def_col;
			height = 60;
			percentWidth = 100;
			
			var h:UIHBox = new UIHBox();
			h.percentWidth = 100;
			h.height = 25;
			addChild(h);
			
			menuBar = new UIMenuBar();
			menuBar.width = 500;
			menuBar.height = 25
			h.addChild(menuBar);
			
			demo1 = new UILinkButton();
			demo1.label = "下载demo1项目";
			demo1.width = 100;
			demo1.addEventListener(MouseEvent.CLICK , onDemo1Click);
			h.addChild(demo1);
			
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
			projectHB.width = 200
			projectHB.horizontalGap = 5;
			projectHB.verticalAlignMiddle = true
			//projectHB.visible = false;
			toolBarCanvas.addChild(projectHB);
			
			var lb:UILabel = new UILabel();
			lb.text = "当前打开项目："
			projectHB.addChild(lb);
			
			txt = new UILinkButton();
			projectHB.addChild(txt);
			
			saveTXT = new UILabel();
			projectHB.addChild(saveTXT);
			
			saveTxtBtn = new UIButton();
			//saveTxtBtn.visible = false;
			saveTxtBtn.label = "保存"
			projectHB.addChild(saveTxtBtn);
			
			preBtn = new UIButton();
			preBtn.label = "预览"
			projectHB.addChild(preBtn);
			
			stackBar = new UIToggleButtonBar();
			stackBar.name = "AppTopBarContainer";
			stackBar.enabledTabClose = true;
			stackBar.percentWidth = 100;
			//stackBar.background_red = true
			stackBar.labelField = "value"
			stackBar.enabled_anchor = true;
			//stackBar.tabWidth = 80;
			stackBar.horizontalAlign = ASComponentConst.horizontalAlign_right;
			toolBarCanvas.addChild(stackBar);
			
			
			
			
			initComplete();
		}
		
		private function onDemo1Click(e:MouseEvent):void
		{
			URLUtils.openLink("http://192.168.0.4:11111/3d/3d_demo1.rar");
		}
		
	}
}