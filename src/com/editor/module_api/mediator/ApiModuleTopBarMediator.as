package com.editor.module_api.mediator
{
	import com.editor.model.AppMainModel;
	import com.editor.module_api.ApiModuleMediator;
	import com.editor.module_api.view.ApiModuleTopBar;
	import com.sandy.component.controls.SandyButton;
	import com.sandy.component.controls.text.SandyTextInput;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.popupwin.data.OpenPopupwinDataProxy;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class ApiModuleTopBarMediator extends SandyMediator
	{
		public static const NAME:String = "ApiModuleTopBarMediator"
		public function ApiModuleTopBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get api():ApiModuleTopBar
		{
			return viewComponent as ApiModuleTopBar;
		}
		public function get managerBtn():SandyButton
		{
			return api.managerBtn
		}
		public function get textTi():SandyTextInput
		{
			return api.textTi;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			managerBtn.visible = AppMainModel.getInstance().user.checkInPower(1);
			textTi.enterKeyDown_proxy = onTextKeyDown;
		}
		
		public function reactToManagerBtnClick(e:MouseEvent=null):void
		{
			/*var open:OpenPopupwinDataProxy = new OpenPopupwinDataProxy();
			open.popupwinSign = PopupwinSign.ApiLogPopwin_sign
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
			return;*/
			get_ApiModuleMediator().managerCont.visible = true;
		}
		
		private function get_ApiModuleMediator():ApiModuleMediator
		{
			return retrieveMediator(ApiModuleMediator.NAME) as ApiModuleMediator;
		}
		
		private function get_ApiModuleLeftContMediator():ApiModuleLeftContMediator
		{
			return retrieveMediator(ApiModuleLeftContMediator.NAME) as ApiModuleLeftContMediator;
		}
		
		private function onTextKeyDown():void
		{
			if(StringTWLUtil.isWhitespace(textTi.text)) return ;
			if(textTi.text.length < 2) return ;
			get_ApiModuleLeftContMediator().search(textTi.text);
		}
	}
}