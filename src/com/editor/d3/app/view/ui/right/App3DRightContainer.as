package com.editor.d3.app.view.ui.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class App3DRightContainer extends UICanvas
	{
		public function App3DRightContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		public var saveTxt:UILabel;
		public var saveTxtBtn:UIButton;
		public var preBtn:UIButton;
		public var playBtn:UIButton;
		public var pauseBtn:UIButton;
		public var openBtn:UIButton;
		
		private function create_init():void
		{
			mouseEnabled = true;
			styleName = "uicanvas"
			backgroundColor = DataManager.def_col;
			
			tabBar = new UITabBarNav();
			//tabBar.background_red = true
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			tabBar.tabHeight = 25;
			addChild(tabBar);
			
			var h:UIHBox = new UIHBox();
			h.horizontalGap = 5;
			h.paddingRight = 5;
			h.verticalAlignMiddle = true
			//h.visible = false;
			h.height = 25;
			h.percentWidth = 100;
			h.horizontalAlign = ASComponentConst.horizontalAlign_right;
			addChild(h);
			
			saveTxt = new UILabel();
			h.addChild(saveTxt);
			
			openBtn = new UIButton();
			openBtn.label = "打开"
			h.addChild(openBtn);
						
			playBtn = new UIButton();
			playBtn.label = "播放"
			h.addChild(playBtn);
			playBtn.toolTip = "暂停后再播放"
			
			pauseBtn = new UIButton();
			pauseBtn.label = "暂停"
			h.addChild(pauseBtn);
			
			preBtn = new UIButton();
			preBtn.label = "预览"
			h.addChild(preBtn);
			preBtn.toolTip = "属性改变后的重新播放"
			
			saveTxtBtn = new UIButton();
			saveTxtBtn.label = "保存"
			h.addChild(saveTxtBtn);
			
			initComplete();
		}
	}
}