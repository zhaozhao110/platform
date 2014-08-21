package com.editor.module_gdps.pop.resSave
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsResSavePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsResSavePopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var SBid:UITextInput;
		public var res_svn_version:UITextInput;
		public var svnBtn:UILinkButton;
		public var STopic:UITextInput;
		public var SDesc:UITextArea;
		public var saveBtn:UIButton;
		public var resetBtn:UIButton;
		
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
			
			form = new UIForm();
			form.percentWidth = 100;
			form.percentHeight = 80;
			form.leftWidth = 80;
			form.verticalGap = 6;
			form.horizontalAlign = "right";
			vbox.addChild(form);
			
			SBid = new UITextInput();
			SBid.formLabel = "更新批次号 *";
			SBid.editable = true;
			SBid.width = 200;
			SBid.height = 24;
			form.addFormItem(SBid);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.formLabel = "更新版本号 *";
			hbox2.width = 200;
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 0;
			form.addFormItem(hbox2);
			
			res_svn_version = new UITextInput();
			res_svn_version.width = 90;
			res_svn_version.editable = false;
			hbox2.addChild(res_svn_version);
			
			svnBtn = new UILinkButton();
			svnBtn.color = 0x0000FF;
			svnBtn.text = "点此修改SVN版本";
			svnBtn.bold = true;
			svnBtn.width = 110;
			hbox2.addChild(svnBtn);
			
			STopic = new UITextInput();
			STopic.formLabel = "批次主题 *";
			STopic.width = 200;
			STopic.height = 24;
			form.addFormItem(STopic);
			
			SDesc = new UITextArea();
			SDesc.formLabel = "更新内容描述 *";
			SDesc.width = 200;
			SDesc.height = 80;
			form.addFormItem(SDesc);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 20;
			vbox.addChild(hbox);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存";
			saveBtn.width = 50;
			saveBtn.height = 25;
			hbox.addChild(saveBtn);
			
			resetBtn = new UIButton();
			resetBtn.label = "重置";
			resetBtn.width = 50;
			resetBtn.height = 25;
			hbox.addChild(resetBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 370;
			opts.height = 300;
			opts.title = "添加RES数据更新批次号";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsResSavePopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsResSavePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsResSavePopupwinMediator.NAME);
		}
	}
}