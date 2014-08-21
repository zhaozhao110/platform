package com.editor.module_gdps.login
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.MouseEvent;

	public class GdpsLoginCell extends UICanvas
	{
		public function GdpsLoginCell()
		{
			super();
			create_init();
		}
		public var addressCBox:UICombobox;
		public var username:UITextInput;
		public var password:UITextInput;
		public var rememberUserNameCbox:UICheckBox;
		public var rememberPasswordCbox:UICheckBox;
		public var loginBtn:UIButton;
		public var exitBtn:UIButton;
		public var settingBtn:UIButton;
		public var enterCB:UICheckBox;
		
		private function create_init():void
		{
			width = 400;
			height = 300;
			enabledPercentSize = true;
			visible = false;
			borderStyle = "solid";
			borderThickness = 1;
			borderColor = 0x898C95;
			backgroundColor = 0xEDEDED;
			
			
			var vb:UIVBox = new UIVBox();
			vb.verticalGap = 15;
			vb.horizontalGap = 10;
			vb.horizontalAlign = "center";
			vb.verticalAlign = "middle";
			vb.width = 400;
			vb.height = 300;
			this.addChild(vb);
			
			var titleLb:UILabel = new UILabel();
			titleLb.text = "宝将游戏开发-发布系统";
			titleLb.fontSize = 16;
			titleLb.bold = true;
			vb.addChild(titleLb);
			
			var form:UIForm = new UIForm();
			form.width = 300;
			form.height = 100;
			form.leftWidth = 80;
			form.horizontalGap = 5;
			form.verticalGap = 10;
			form.horizontalAlign = "right";
			vb.addChild(form);
			
			addressCBox = new UICombobox();
			addressCBox.formLabel = "服务器地址：";
			addressCBox.width = 214;
			addressCBox.height = 25;
			form.addFormItem(addressCBox,0);
			
			username = new UITextInput();
			username.formLabel = "登录帐号：";
			username.width = 214;
			username.height = 25;
			form.addFormItem(username,1);
			
			password = new UITextInput();
			password.formLabel = "登录密码：";
			password.displayAsPassword = true;
			password.width = 214;
			password.height = 25;
			form.addFormItem(password,2);
			
			var hb:UIHBox = new UIHBox();
			hb.verticalGap = 5;
			hb.horizontalGap = 10;
			hb.percentWidth = 100;
			hb.horizontalAlign = "center";
			vb.addChild(hb);
			
			rememberUserNameCbox = new UICheckBox();
			rememberUserNameCbox.label = "记住登录帐号";
			hb.addChild(rememberUserNameCbox);
			
			rememberPasswordCbox = new UICheckBox();
			rememberPasswordCbox.label = "记住登录密码";
			hb.addChild(rememberPasswordCbox);
			
			hb = new UIHBox();
			hb.verticalGap = 5;
			hb.horizontalGap = 10;
			hb.percentWidth = 100;
			hb.horizontalAlign = "center";
			vb.addChild(hb);
			
			enterCB = new UICheckBox();
			enterCB.label = "下次直接进入"
			enterCB.addEventListener(ASEvent.CHANGE,onEnterCBChange);
			hb.addChild(enterCB);
			
			var hb1:UIHBox = new UIHBox();
			hb1.verticalGap = 10;
			hb1.horizontalGap = 60;
			hb1.percentWidth = 100;
			hb1.horizontalAlign = "center";
			vb.addChild(hb1);
			
			loginBtn = new UIButton();
			loginBtn.width = 50;
			loginBtn.height = 22;
			loginBtn.label = "登录";
			hb1.addChild(loginBtn);
			
			settingBtn = new UIButton();
			settingBtn.width = 50;
			settingBtn.height = 22;
			settingBtn.label = "设置";
			settingBtn.visible = false;
			hb1.addChild(loginBtn);
			
			exitBtn = new UIButton();
			exitBtn.width = 50;
			exitBtn.height = 22;
			exitBtn.label = "退出";
			hb1.addChild(exitBtn);
			
			initComplete();
		}
		
		private function onEnterCBChange(e:ASEvent):void
		{
			if(enterCB.selected){
				iManager.iSharedObject.put("","enterGDPS","1");
			}else{
				iManager.iSharedObject.put("","enterGDPS","0");
			}
		}
		
		override public function set visible(value:Boolean):void
		{
			if(value){
				enterCB.setSelect(iManager.iSharedObject.find("","enterGDPS") == "1"?true:false,false);
				engineEditor.instance.getNativeWindow().width=402;
				engineEditor.instance.getNativeWindow().height=302;
				engineEditor.instance.getNativeWindow().activate();
				engineEditor.instance.getNativeWindow().toCenter();
			}
			
			super.visible = value;
		}
	}
}