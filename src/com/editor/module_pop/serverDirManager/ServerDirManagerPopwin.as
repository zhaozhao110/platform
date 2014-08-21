package com.editor.module_pop.serverDirManager
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.PopupwinSign;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerBottomView;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerLeftView;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerRightView;
	import com.editor.view.popup.AppAlonePopWithEmptyWin;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.controls.ASSpace;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;
	
	public class ServerDirManagerPopwin extends AppAlonePopWithEmptyWin
	{
		public function ServerDirManagerPopwin()
		{
			super();
			create_init();
		}
		
		public var serverURLTI:UITextInputWidthLabel;
		public var connBtn:UIButton;
		public var leftView:ServerDirManagerLeftView;
		public var rightView:ServerDirManagerRightView;
		public var bottomView:ServerDirManagerBottomView;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 20;
			form.padding = 5;
			form.enabledPercentSize = true;
			this.addChild(form);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			form.addChild(hb1);
			
			serverURLTI = new UITextInputWidthLabel();
			serverURLTI.width = 500;
			serverURLTI.label = "连接服务器:"
			hb1.addChild(serverURLTI);
			
			connBtn = new UIButton();
			connBtn.label = "连接"
			hb1.addChild(connBtn);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 550;
			hb2.percentWidth = 100;
			hb2.horizontalGap = 20
			form.addChild(hb2);
			
			leftView = new ServerDirManagerLeftView();
			hb2.addChild(leftView);
			
			rightView = new ServerDirManagerRightView();
			hb2.addChild(rightView);
			
		/*	var sp:ASSpace = new ASSpace();
			sp.height = 10;
			form.addChild(sp);*/
			
			bottomView = new ServerDirManagerBottomView();
			form.addChild(bottomView);
			
			this.contentArea = [form];
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 900;
			opts.height = 800;
			opts.title = "管理服务器资源目录"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.ServerDirectoryPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ServerDirManagerPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ServerDirManagerPopwinMediator.NAME)
		}
	}
}