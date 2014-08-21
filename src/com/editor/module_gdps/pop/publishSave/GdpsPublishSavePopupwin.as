package com.editor.module_gdps.pop.publishSave
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	
	public class GdpsPublishSavePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPublishSavePopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var SBid:UITextInput;
		public var oprTxt:UITextInput;
		public var oprBtn:UILinkButton;
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
			form.leftWidth = 100;
			form.verticalGap = 6;
			form.horizontalAlign = "right";
			vbox.addChild(form);
			
			SBid = new UITextInput();
			SBid.formLabel = "批次号 *";
			SBid.editable = false;
			SBid.width = 200;
			SBid.height = 24;
			form.addFormItem(SBid);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.formLabel = "更新指定平台 *";
			hbox1.width = 200;
			hbox1.verticalAlign = "middle";
			hbox1.horizontalGap = 0;
			form.addFormItem(hbox1);
			
			oprTxt = new UITextInput();
			oprTxt.width = 200;
			oprTxt.height = 24;
			oprTxt.editable = false;
			hbox1.addChild(oprTxt);
			
			oprBtn = new UILinkButton();
			oprBtn.color = 0x0000FF;
			oprBtn.text = "点此选择平台";
			oprBtn.bold = true;
			oprBtn.width = 120;
			oprBtn.visible = false;
			oprBtn.includeInLayout = false;
			hbox1.addChild(oprBtn);
			
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
			opts.width = 400;
			opts.height = 340;
			opts.title = "添加基础数据更新批次号";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPublishSavePopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPublishSavePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPublishSavePopupwinMediator.NAME);
		}
	}
}