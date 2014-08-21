package com.editor.module_gdps.pop.tableSpace
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsTableSpacePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsTableSpacePopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var NId:UITextInput;
		public var SField:UITextInput;
		public var SName:UITextInput;
		public var SSchema:UITextInput;
		public var SExtend:UITextArea;
		public var SDesc:UITextArea;
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
			
			form = new UIForm();
			form.percentWidth = 100;
			form.percentHeight = 80;
			form.leftWidth = 100;
			form.verticalGap = 6;
			vbox.addChild(form);
			
			NId = new UITextInput();
			NId.formLabel = "表名ID *";
			NId.editable = false;
			NId.width = 200;
			NId.height = 24;
			form.addFormItem(NId);
			
			SField = new UITextInput();
			SField.formLabel = "表对象英文名 *";
			SField.width = 200;
			SField.height = 24;
			form.addFormItem(SField);
			
			SName = new UITextInput();
			SName.formLabel = "表对象中文名 *";
			SName.width = 200;
			SName.height = 24;
			form.addFormItem(SName);
			
			SSchema = new UITextInput();
			SSchema.formLabel = "所属表空间";
			SSchema.width = 200;
			SSchema.height = 24;
			form.addFormItem(SSchema);
			
			SExtend = new UITextArea();
			SExtend.formLabel = "扩展信息";
			SExtend.width = 200;
			SExtend.height = 48;
			form.addFormItem(SExtend);
			
			SDesc = new UITextArea();
			SDesc.formLabel = "描述";
			SDesc.width = 200;
			SDesc.height = 48;
			form.addFormItem(SDesc);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 20;
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
			opts.width = 400;
			opts.height = 350;
			opts.title = "添加表名对象";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsTableSpacePopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsTableSpacePupupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsTableSpacePupupwinMediator.NAME);
		}
	}
}