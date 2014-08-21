package com.editor.model
{
	
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.view.popup.AppConfirmPopwin;
	import com.sandy.core.InjectClassProcessor;
	import com.sandy.module.interfac.IOpenModuleDataProxy;
	import com.sandy.net.interfac.ISandyByteArray;
	import com.sandy.net.interfac.ISandySocketReceiveDataProxy;
	import com.sandy.net.interfac.ISandySocketSendDataProxy;
	import com.sandy.popupwin.interfac.IConfirmPopWin;
	import com.sandy.popupwin.interfac.IOpenMessageData;
	import com.sandy.popupwin.interfac.IOpenPopupDataProxy;
	
	public class AppInjectClassProcessor extends InjectClassProcessor
	{
		public function AppInjectClassProcessor()
		{
			super();
		}
		
		override public function createSandySocketReceiveDataProxy():Class
		{
			return AppSocketReceiveDataProxy
		}
		
		override public function createSandySocketSendDataProxy():Class
		{
			return AppSocketSendDataProxy;
		}
		
		override public function createXMLSocketData():Class
		{
			return GDPSXmlSocketData;
		}
		/*
		override public function createOpenModuleDataProxy():Class
		{
			return OpenModuleData
		}
		
		override public function createOpenPopupDataProxy():Class
		{
			return OpenPopwinData
		}
		
		override public function createOpenMessageData():Class
		{
			return HuntOpenMessageData
		}
		
		override public function createConfirmPopWin():Class
		{
			return HuntConfirmPopwin
		}*/
		
		
		/*override public function createConfirmPopWin():Class
		{
			return AppConfirmPopwin;
		}*/
		
	}
}