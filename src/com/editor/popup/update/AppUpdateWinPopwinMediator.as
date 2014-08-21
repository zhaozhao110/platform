package com.editor.popup.update
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.popupwin.data.OpenDataProxy;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.URLUtils;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;

	public class AppUpdateWinPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppUpdateWinPopwinMediator"
		public function AppUpdateWinPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get updateWin():AppUpdateWinPopwin
		{
			return viewComponent as AppUpdateWinPopwin;
		}
		public function get textInput():UITextArea
		{
			return updateWin.textInput;
		}
		public function get infoTxt():UIButton
		{
			return updateWin.infoTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			version_xml = XML((getOpenDataProxy() as OpenDataProxy).data);
			
			textInput.htmlText = "有新的版本："+ ColorUtils.addColorTool(version_xml.versionNumber,ColorUtils.red)+"<br>";
			textInput.htmlText += "更新内容：<br>" + version_xml.description;
		}
		
		private var version_xml:XML;
		
		public function reactToInfoTxtClick(e:MouseEvent):void
		{
			URLUtils.openLink(AppGlobalConfig.instance.download);
			setTimeout(function():void{NativeApplication.nativeApplication.exit();},1000);
		}
		
		
		
	}
}