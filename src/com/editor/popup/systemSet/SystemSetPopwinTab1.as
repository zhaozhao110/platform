package com.editor.popup.systemSet
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.vo.global.AppStorageConfFile;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.manager.StageManager;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SystemSetPopwinTab1 extends UIVBox
	{
		public function SystemSetPopwinTab1()
		{
			super();
			
		}
		
		public var form:UIVBox;
		public var cb1:UICheckBox;
		public var ti1:UITextInput;
		public var errorBtn:UIButton;
		public var frameCB:UICombobox;
		public var frameBtn:UIButton;
		
		override public function delay_init():Boolean
		{
			form = new UIVBox();
			form.enabledPercentSize = true
			form.padding = 10;
			form.verticalGap = 5
			form.styleName = "uicanvas"
			//form.horizontalAlign = ASComponentConst.horizontalAlign_center;
			this.addChild(form);
			
			cb1 = new UICheckBox();
			cb1.label = "随系统启动打开";
			form.addChild(cb1);
			
			var box:UIHBox = new UIHBox();
			box.styleName = "uicanvas";
			box.height = 60;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			form.addChild(box);
			
			var lb:UILabel = new UILabel();
			lb.text = "缓存目录："
			box.addChild(lb);
			
			ti1 = new UITextInput();
			ti1.width = 300;
			box.addChild(ti1);
			ti1.text = AppStorageConfFile.getStorageDirt()
			
			var btn:UIButton = new UIButton();
			btn.label = "打开目录"
			btn.addEventListener(MouseEvent.CLICK , onBtn1Click);
			box.addChild(btn);
			
			btn = new UIButton();
			btn.label = "清除缓存"
			btn.addEventListener(MouseEvent.CLICK , onBtn2Click);
			box.addChild(btn);
			
			box = new UIHBox();
			box.styleName = "uicanvas";
			box.height = 60;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			box.horizontalGap = 15;
			form.addChild(box);
			
			errorBtn = new UIButton();
			errorBtn.label = "查看错误信息"
			box.addChild(errorBtn);
			errorBtn.addEventListener(MouseEvent.CLICK, errorBtnClick);
			
			lb = new UILabel();
			lb.text = "系统帧频："
			box.addChild(lb);
			
			frameCB = new UICombobox();
			frameCB.width = 100;
			frameCB.height = 22;
			var a:Array = [];
			a.push({label:30,data:30})
			a.push({label:60,data:60})
			a.push({label:120,data:120})
			frameCB.labelField = "label"
			frameCB.dataProvider = a;
			box.addChild(frameCB);
			
			if(SandyEngineGlobal.config.appFrame == 30){
				frameCB.selectedIndex = 0; 
			}else if(SandyEngineGlobal.config.appFrame == 60){
				frameCB.selectedIndex = 1;
			}else if(SandyEngineGlobal.config.appFrame == 120){
				frameCB.selectedIndex = 2;
			}
			
			frameBtn = new UIButton();
			frameBtn.label = "确定修改帧频";
			frameBtn.addEventListener(MouseEvent.CLICK , onChangeFrame);
			box.addChild(frameBtn);
			
			try{
				cb1.selected = NativeApplication.nativeApplication.startAtLogin;
			}catch(e:Error){};
			cb1.addEventListener(ASEvent.CHANGE,cb1_change);
			
			return true;
		}
		
		private function onChangeFrame(e:MouseEvent):void
		{
			SandyEngineGlobal.config.appFrame = Object(frameCB.selectedItem).data;
			StageManager.setSystemFrame(null,SandyEngineGlobal.config.appFrame);
		}
		
		private function cb1_change(e:ASEvent):void
		{
			NativeApplication.nativeApplication.startAtLogin = cb1.selected;
			if(cb1.selected){
				iManager.iSharedObject.put("","startAtLogin","1");
			}else{
				iManager.iSharedObject.put("","startAtLogin","0");
			}
		}
		
		public function errorBtnClick(e:MouseEvent):void
		{
			var file:File = new File(File.applicationStorageDirectory.nativePath+File.separator+"error.txt");
			var read:ReadFile = new ReadFile();
			
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextAreaPopwin_sign
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = "错误信息"
			d.text = read.readFromFile(file);
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			iManager.iPopupwin.openPopupwin(open);
			
			get_SystemSetPopwinMediator().closeWin();
		}
		
		private function onBtn1Click(e:MouseEvent):void
		{
			FileUtils.openFold(AppStorageConfFile.getStorageDirt());
			get_SystemSetPopwinMediator().closeWin();
		}
		
		private function onBtn2Click(e:MouseEvent):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "清除后，所有设置将删除，确定？";
			m.okFunction = onBtn2Click_2;
			SandyManagerBase.getInstance().showConfirm(m);
		}
		
		private function onBtn2Click_2():Boolean
		{
			var fl:File = new File(AppStorageConfFile.getStorageDirt());
			var a:Array = fl.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var ff:File = a[i] as File;
				if(!ff.isDirectory){
					ff.deleteFile();
				}
			}
			return true;
		}

		private function get_SystemSetPopwinMediator():SystemSetPopwinMediator
		{
			return iManager.retrieveMediator(SystemSetPopwinMediator.NAME) as SystemSetPopwinMediator
		}
		
		public function okButtonClick():void
		{
			if(form == null) return ;
		}
	}
}