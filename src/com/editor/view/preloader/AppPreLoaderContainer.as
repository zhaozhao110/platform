package com.editor.view.preloader
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.text.SandyTextField;
	import com.sandy.utils.ColorUtils;
	
	import flash.text.TextFieldAutoSize;
	
	public class AppPreLoaderContainer extends UICanvas
	{
		public function AppPreLoaderContainer()
		{
			super();
			create_init();
		}
		
		override protected function setEnabledEffect():void
		{
			
		}
		
		[Embed(source="/assets/img/logo.jpg")]
		private var logo_cls:Class;
		
		public var img:UIImage;
		public var txt:SandyTextField;
		public var vbox:UIVBox;
		public var nameTI:UITextInput;
		public var passTI:UITextInput;
		public var projectCB:UICombobox;
		public var loginBtn:UIButton;
		public var quitBtn:UIButton;
		public var minBtn:UIButton;
		public var enter3DBtn:UICheckBox;
		
		private function create_init():void
		{
			//visible = false;
			mouseChildren = false;
			width = 657
			height = 199
			
			img = new UIImage();
			img.source = logo_cls;
			addChild(img);
			
			txt = new SandyTextField();
			txt.selectable=false
			txt.wordWrap = true;
			txt.multiline = true;
			txt.x = 10;
			txt.y = 70;
			txt.width = 200;
			txt.height = 115;
			txt.color = ColorUtils.white;
			txt.autoSize = TextFieldAutoSize.NONE;
			addChild(txt);
			
			nameTI = new UITextInput();
			nameTI.width = 150
			nameTI.height = 22;
			nameTI.x = 470;
			nameTI.y = 95
			addChild(nameTI);
			
			/*passTI = new UITextInput();
			passTI.width = 200
			passTI.height = 22;
			passTI.label = "密码：";
			vbox.addChild(passTI);*/
			
			projectCB = new UICombobox();
			projectCB.width = 150
			projectCB.height = 22;
			projectCB.x = 470;
			projectCB.y = 45;
			projectCB.dropDownWidth = 140
			addChild(projectCB);
			
			enter3DBtn = new UICheckBox();
			enter3DBtn.label = "进入3D编辑"
			enter3DBtn.x = 470;
			enter3DBtn.y = 125;
			enter3DBtn.color = 0xffffff;
			addChild(enter3DBtn);
			
			loginBtn = new UIButton();
			loginBtn.label = "login";
			loginBtn.x = 460;
			loginBtn.bottom = 22;
			loginBtn.visible = false;
			addChild(loginBtn);
			
			quitBtn = new UIButton();
			quitBtn.label = "quit"
			quitBtn.x = 510;
			quitBtn.bottom = 22;
			addChild(quitBtn);
			quitBtn.visible = false;
			
			minBtn = new UIButton();
			minBtn.label = "进入GDPS"
			addChild(minBtn);
			minBtn.x = 560;
			minBtn.bottom = 22
			minBtn.visible=false
							
			initComplete();
		}
		
	}
}