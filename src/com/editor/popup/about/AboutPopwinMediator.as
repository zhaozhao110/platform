package com.editor.popup.about
{
	import com.air.utils.AIRUtils;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.global.AppGlobalConfig;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class AboutPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AboutPopwinMediator"
		public function AboutPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get aboutWin():AboutPopwin
		{
			return viewComponent as AboutPopwin;
		}
		public function get txt():UITextArea
		{
			return aboutWin.txt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			aboutWin.addEventListener(MouseEvent.CLICK , onCloseHandle)
			
			txt.appendHtmlText('下载地址: <a href="' + get_AppConfigProxy().download + '">' + get_AppConfigProxy().download + "</a>");
			txt.appendHtmlText('版本: ' + AIRUtils.getAPP_version());
			txt.appendHtmlText('帮助文档: <a href="' + get_AppConfigProxy().help_website + '">' + get_AppConfigProxy().help_website + "</a>");
			txt.appendHtmlText('AIR版本: ' + NativeApplication.nativeApplication.runtimeVersion);
		}
		
		private function get_AppConfigProxy():AppGlobalConfig
		{
			return AppGlobalConfig.instance;
		}
		
		private function onCloseHandle(e:MouseEvent):void
		{
			aboutWin.removeEventListener(MouseEvent.CLICK , onCloseHandle)
			closeWin();
		}
		
	}
}