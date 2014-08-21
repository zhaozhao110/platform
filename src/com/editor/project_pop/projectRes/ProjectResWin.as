package com.editor.project_pop.projectRes
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;

	public class ProjectResWin extends AppPopupWithEmptyWin
	{
		public function ProjectResWin()
		{
			super()
			create_init()
		}
		
		public var selectBtn:UIButton;
		public var textInput:UITextInputWidthLabel;
		public var clientBtn:UIButton;
		public var config3Btn:UIButton;
		public var txt:UITextArea;
		public var openPackBtn:UIButton;
		public var reZipBtn:UIButton;
		public var createBtn:UIButton
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.minimizable = true;
			opts.width = 800;
			opts.height = 400;
			opts.title = "项目资源压缩"	
			return opts;
		}
		
		private function create_init():void
		{
			var gdpsvbox2:UIVBox = new UIVBox();
			gdpsvbox2.enabledPercentSize=true
			gdpsvbox2.padding = 20;
			gdpsvbox2.verticalGap = 10;
			addContentChild(gdpsvbox2);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			gdpsvbox2.addChild(hb1);
			
			textInput = new UITextInputWidthLabel();
			textInput.label = "选择项目的目录:";
			textInput.width = 500
			hb1.addChild(textInput);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择";
			hb1.addChild(selectBtn);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 30;
			hb2.percentWidth = 100;
			gdpsvbox2.addChild(hb2);
			
			clientBtn = new UIButton();
			clientBtn.label = "打包客户端资源";
			hb2.addChild(clientBtn);
			
			openPackBtn = new UIButton();
			openPackBtn.label = "打开客户端资源目录";
			hb2.addChild(openPackBtn);
			
			config3Btn = new UIButton();
			config3Btn.label = "打包配置文件";
			hb2.addChild(config3Btn);
			
			reZipBtn = new UIButton();
			reZipBtn.label = "解压配置文件";
			hb2.addChild(reZipBtn);
			
			createBtn = new UIButton();
			createBtn.label = "执行fla编译成swf的jsfl";
			createBtn.toolTip = "将在桌面上生成fla编译成swf的jsfl,然后在flash里执行"
			hb2.addChild(createBtn);
			
			txt = new UITextArea();
			txt.percentWidth = 100;
			txt.height = 200;
			gdpsvbox2.addChild(txt);
			
			
			
			initComplete();
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.ProjectResWin_sign
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new ProjectResWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectResWinMediator.NAME);
		}
		
		
	}
}