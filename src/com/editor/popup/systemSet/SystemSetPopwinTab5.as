package com.editor.popup.systemSet
{
	import com.air.io.DownloadFile;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.air.io.queue.download.DownloadQueue;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.popup.systemSet.component.SystemSetPopwinTab5ItemRenderer;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.services.Services;
	import com.editor.vo.plus.PlusItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SystemSetPopwinTab5 extends UIVBox
	{
		public function SystemSetPopwinTab5()
		{
			super();
			//create_init();
		}
		
		public static var isChange:Boolean;
		
		private var form:UIVBox;
		private var downBtn:UIButton;
		private var logTxt:UITextArea;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas";
			padding = 5;
			
			form = new UIVBox();
			form.percentWidth = 100;
			form.percentHeight = 100;
			form.padding = 10;
			form.verticalGap = 5
			form.styleName = "uicanvas"
			form.itemRenderer = SystemSetPopwinTab5ItemRenderer;
			form.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			this.addChild(form);
			
			if(get_AppPlusProxy()!=null){
				if(get_AppPlusProxy().serverList!=null){
					form.dataProvider = get_AppPlusProxy().serverList.list;
				}
			}
			
			downBtn = new UIButton();
			downBtn.label = "更新所有插件";
			downBtn.addEventListener(MouseEvent.CLICK , copyDB);
			addChild(downBtn);
			
			logTxt = new UITextArea();
			logTxt.height = 80;
			logTxt.wordWrap = false;
			logTxt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			logTxt.percentWidth = 100;
			addChild(logTxt);
			
			return true;
		}
		
		public function okButtonClick():void
		{
			
		}
		
		private var downQ:DownloadQueue = new DownloadQueue();
		
		private function copyDB(e:MouseEvent=null):void
		{
			var a:Array = get_AppPlusProxy().serverList.list;
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var d:PlusItemVO = PlusItemVO(a[i]);
				if(d.checkNewVersion() || d.oldItem == null){
					var obj:Object = {};
					obj.from = d.swf_url;
					obj.to = d.locale_url;
					out.push(obj);
				}
			}
			if(out.length > 0){
				downBtn.enabled = false;
				downQ.queueFinish_f = downComplete;
				downQ.downOneComplete_f = downOneComplete;
				downQ.downError_f = downError;
				downQ.start(out);
			}
		}
		
		private function downError(d:Object):void
		{
			iManager.iPopupwin.showError("下载出错,"+d.from);
		}
		
		private function downOneComplete(d:Object):void
		{
			logTxt.appendHtmlText("下载完成:"+d.from);
		}
		
		private function downComplete():void
		{
			reflashLocalPlusXML();			
			downBtn.enabled = true;
			form.dataProvider = null;
			form.dataProvider = get_AppPlusProxy().serverList.list;
			iManager.iPopupwin.showMessage("如果要使用更新后 插件，请重启下平台");
		}
		
		private function reflashLocalPlusXML():void
		{
			var local_fl:File = new File(File.applicationDirectory.nativePath+File.separator+"plus"+File.separator+"plus.xml");
			var c:String = '<?xml version="1.0" encoding="utf-8"?>'+NEWLINE_SIGN;
			c += '<l>'+NEWLINE_SIGN;
			var a:Array = get_AppPlusProxy().serverList.list;
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var d:PlusItemVO = PlusItemVO(a[i]);
				d.update();
			}
			c += "</l>"+NEWLINE_SIGN;
			get_AppPlusProxy().cloneServerXml();
			var write:WriteFile = new WriteFile();
			write.write(local_fl,get_AppPlusProxy().serverList.org_xml);
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return iManager.retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy
		}
	}
}