package com.editor.modules.view.console
{
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.vo.xml.AppXMLItemVO;
	import com.sandy.asComponent.event.ASEvent;
	
	public class ConsoleDockPopwinMediator extends AppMediator
	{
		public static const NAME:String = "ConsoleDockPopwinMediator"
		public function ConsoleDockPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get consoleView():ConsoleDockPopView
		{
			return viewComponent as ConsoleDockPopView;
		}
		public function get cb():UIComboBoxWithLabel
		{
			return consoleView.cb;
		}
		public function get txtArea():UITextArea
		{
			return consoleView.txtArea;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			cb.labelField = "name"
			cb.dataProvider = get_AppGlobalProxy().action_ls.list;
			cb.addEventListener(ASEvent.CHANGE , _cbChangeHandle)
		}
		
		private function _cbChangeHandle(e:ASEvent):void
		{
			var item:AppXMLItemVO = cb.selectedItem as AppXMLItemVO;
			if(item.data == "1"){
				txtArea.htmlText = iPopupwin.pringAllManager();
			}
		}
		
		private function get_AppGlobalProxy():AppModuleProxy
		{
			return retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy;
		}
		
	}
}