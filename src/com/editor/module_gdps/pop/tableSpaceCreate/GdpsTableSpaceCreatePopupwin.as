package com.editor.module_gdps.pop.tableSpaceCreate
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.controls.SandySpace;
	
	import flash.display.NativeWindowType;

	public class GdpsTableSpaceCreatePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsTableSpaceCreatePopupwin()
		{
			super();
			create_init();
		}
		
		public var content:UITextArea;
		public var menuName:UITextInput;
		public var path:UITextInput;
		public var configFilename:UITextInput;
		public var zipFilename:UITextInput;
		public var saveTableBtn:UIButton;
		public var resetTableBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.horizontalAlign = "center";
			vbox.paddingLeft = 50;
			vbox.paddingTop = 0;
			vbox.verticalGap = 15;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			var hbox3:UIHBox = new UIHBox();
			hbox3.horizontalGap = 0;
			vbox.addChild(hbox3);
			
			var lab:UILabel = new UILabel();
			lab.text = "PD语句 *";
			lab.width = 60;
			hbox3.addChild(lab);
			
			content = new UITextArea();
			content.width = 480;
			content.height = 320;
			content.horizontalScrollPolicy = "auto";
			content.verticalScrollPolicy = "auto";
			hbox3.addChild(content);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.horizontalGap = 2;
			hbox1.verticalAlign = "middle";
			vbox.addChild(hbox1);
			
			var lab1:UILabel = new UILabel();
			lab1.text = "生成的菜单名称 *";
			lab1.width = 115;
			lab1.textAlign = "right";
			hbox1.addChild(lab1);
			
			menuName = new UITextInput();
			menuName.width = 150;
			menuName.height = 24;
			hbox1.addChild(menuName);
			
			var space1:SandySpace = new SandySpace();
			space1.width = 10;
			hbox1.addChild(space1);
			
			var lab2:UILabel = new UILabel();
			lab2.text = "生成的配置文件路径";
			lab2.width = 115;
			lab2.textAlign = "right";
			hbox1.addChild(lab2);
			
			path = new UITextInput();
			path.width = 150;
			path.height = 24;
			path.text = "config/config2";
			hbox1.addChild(path);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 2;
			vbox.addChild(hbox2);
			
			var lab3:UILabel = new UILabel();
			lab3.text = "生成的配置文件名称";
			lab3.width = 115;
			lab3.textAlign = "right";
			hbox2.addChild(lab3);
			
			configFilename = new UITextInput();
			configFilename.width = 150;
			configFilename.height = 24;
			hbox2.addChild(configFilename);
			
			var space2:SandySpace = new SandySpace();
			space2.width = 10;
			hbox2.addChild(space2);
			
			var lab4:UILabel = new UILabel();
			lab4.text = "打包压缩的文件名";
			lab4.width = 115;
			lab4.textAlign = "right";
			hbox2.addChild(lab4);
			
			zipFilename = new UITextInput();
			zipFilename.width = 150;
			zipFilename.height = 24;
			zipFilename.text = "config/config2.swf";
			hbox2.addChild(zipFilename);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 30;
			vbox.addChild(hbox);
			
			saveTableBtn = new UIButton();
			saveTableBtn.label = "保存";
			saveTableBtn.width = 50;
			saveTableBtn.height = 25;
			hbox.addChild(saveTableBtn);
			
			resetTableBtn = new UIButton();
			resetTableBtn.label = "重置";
			resetTableBtn.width = 50;
			resetTableBtn.height = 25;
			hbox.addChild(resetTableBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 580;
			opts.height = 500;
			opts.title = "创建表对象";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsTableSpaceCreatePopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsTableSpaceCreatePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsTableSpaceCreatePopupwinMediator.NAME);
		}
	}
}