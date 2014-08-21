package com.editor.module_pop.serverDirManager
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.module_pop.serverDirManager.mediator.ServerDirManagerBottomViewMediator;
	import com.editor.module_pop.serverDirManager.mediator.ServerDirManagerLeftViewMediator;
	import com.editor.module_pop.serverDirManager.mediator.ServerDirManagerRightViewMediator;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerBottomView;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerLeftView;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerRightView;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.popupwin.mediator.AlonePopWithEmptyWinDestroyPopwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;

	public class ServerDirManagerPopwinMediator extends AlonePopWithEmptyWinDestroyPopwinMediator
	{
		public static const NAME:String = "ServerDirManagerPopwinMediator"
		public function ServerDirManagerPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get serverWin():ServerDirManagerPopwin
		{
			return viewComponent as ServerDirManagerPopwin
		}
		public function get serverURLTI():UITextInputWidthLabel
		{
			return serverWin.serverURLTI;
		}
		public function get connBtn():UIButton
		{
			return serverWin.connBtn;
		}
		public function get leftView():ServerDirManagerLeftView
		{
			return serverWin.leftView;
		}
		public function get rightView():ServerDirManagerRightView
		{
			return serverWin.rightView;
		}
		public function get bottomView():ServerDirManagerBottomView
		{
			return serverWin.bottomView;
		}
		
		
		private var leftViewMediator:ServerDirManagerLeftViewMediator;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(leftViewMediator=new ServerDirManagerLeftViewMediator(leftView));
			registerMediator(new ServerDirManagerRightViewMediator(rightView));
			registerMediator(new ServerDirManagerBottomViewMediator(bottomView));
			
			serverURLTI.text = AppGlobalConfig.instance.serverDirManager;
			
		}
		
		public function getServerURL():String
		{
			return serverURLTI.text;
		}
				
		public function reactToConnBtnClick(e:MouseEvent):void
		{
			leftViewMediator.conn();
		}
		
		
	}
}