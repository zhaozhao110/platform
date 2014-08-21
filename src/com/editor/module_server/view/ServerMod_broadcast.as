package com.editor.module_server.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_server.component.ServerModePeopleItemRenderer;
	import com.sandy.asComponent.controls.ASHRule;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;

	public class ServerMod_broadcast extends UIHBox
	{
		public function ServerMod_broadcast()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVBox;
		public var tabBar:UITabBar;
		public var clearBtn:UIButton;
		public var broadBtn:UIButton;
		public var broadBtn2:UIButton;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding =10;
			horizontalGap = 10;
			
			var vb:UIVBox = new UIVBox();
			vb.padding = 5;
			vb.width = 500;
			vb.percentHeight = 100;
			vb.styleName = "uicanvas"
			addChild(vb);
			
			tabBar = new UITabBar();
			tabBar.height = 25;
			tabBar.percentWidth = 100;
			vb.addChild(tabBar);
			
			vbox = new UIVBox();
			vbox.percentWidth = 100;
			vbox.percentHeight = 100;
			vbox.styleName = "list"
			vbox.enabeldSelect = true
			vbox.rightClickEnabled = true;
			vbox.itemRenderer = ServerModePeopleItemRenderer;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			vb.addChild(vbox);
			
			vb = new UIVBox();
			vb.verticalGap = 10;
			vb.padding = 5;
			vb.enabledPercentSize = true
			vb.styleName = "uicanvas"
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.horizontalGap = 10;
			hb.height = 30;
			vb.addChild(hb);
			
			clearBtn = new UIButton();
			clearBtn.label = "清空选中人员列表"
			hb.addChild(clearBtn);
			
			broadBtn = new UIButton();
			broadBtn.label = "对所有人发送广播"
			hb.addChild(broadBtn);
			
			broadBtn2 = new UIButton();
			broadBtn2.label = "对选中的人员发送广播"
			hb.addChild(broadBtn2);
			
			var ru:ASHRule = new ASHRule();
			vb.addChild(ru);
			
			hb = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 50;
			vb.addChild(hb);
			
			
			
		}
		
		
	}
}