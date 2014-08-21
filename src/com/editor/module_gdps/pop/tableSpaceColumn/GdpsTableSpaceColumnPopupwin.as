package com.editor.module_gdps.pop.tableSpaceColumn
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsTableSpaceColumnPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsTableSpaceColumnPopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var NId:UITextInput;
		public var SField:UITextInput;
		public var SName:UITextInput;
		public var SType:UICombobox;
		public var NTableId:UITextInput;
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
			form.percentHeight = 90;
			form.leftWidth = 100;
			form.verticalGap = 6;
			form.horizontalAlign = "right";
			vbox.addChild(form);
			
			NId = new UITextInput();
			NId.formLabel = "字段ID *";
			NId.editable = false;
			NId.width = 200;
			NId.height = 24;
			form.addFormItem(NId);
			
			SField = new UITextInput();
			SField.formLabel = "字段英文名 *";
			SField.width = 200;
			SField.height = 24;
			form.addFormItem(SField);
			
			SName = new UITextInput();
			SName.formLabel = "字段中文名 *";
			SName.width = 200;
			SName.height = 24;
			form.addFormItem(SName);
			
			SType = new UICombobox();
			SType.width = 200;
			SType.height = 24;
			SType.formLabel = "字段类型 *";
			SType.labelField = "value";
			form.addFormItem(SType);
			
			NTableId = new UITextInput();
			NTableId.formLabel = "所属表名ID *";
			NTableId.width = 200;
			NTableId.height = 24;
			form.addFormItem(NTableId);
			
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
			opts.title = "添加表字段对象";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsTableSpaceColumnPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsTableSpaceColumnPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsTableSpaceColumnPopupwinMediator.NAME);
		}
	}
}