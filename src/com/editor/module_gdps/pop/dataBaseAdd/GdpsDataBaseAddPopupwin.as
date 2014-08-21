package com.editor.module_gdps.pop.dataBaseAdd
{
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.FileFilterUtils;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsDataBaseAddPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataBaseAddPopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var NRid:UITextInput;
		public var truncateCbox:UICheckBox;
		public var SType:UICombobox;
		public var sqlFile:SandyTextInputWithLabelWithSelectFile;
		public var SName:UITextInput;
		public var SDesc:UITextArea;
		public var saveBtn:UIButton;
		public var resetBtn:UIButton;
		public var formItem:UIHBox;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.padding = 20;
			vbox.verticalGap = 12;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			form = new UIForm();
			form.percentWidth = 100;
			form.percentHeight = 90;
			form.leftWidth = 75;
			form.textAlign = "right";
			form.verticalGap = 6;
			form.horizontal_gap = 5;
			vbox.addChild(form);
			
			NRid = new UITextInput();
			NRid.formLabel = "记录ID";
			NRid.width = 200;
			NRid.editable = false;
			form.addFormItem(NRid);
			
			formItem = new UIHBox();
			formItem.verticalAlign = "middle";
			formItem.percentWidth = 100;
			formItem.height = 22;
			form.addFormItem(formItem);
			
			truncateCbox = new UICheckBox();
			truncateCbox.label = "是否清空当前记录数据";
			truncateCbox.selected = false;
			truncateCbox.color = 0xDC1111;
			truncateCbox.toolTip = "选择后会清空当前上传记录表的所有记录信息，保证下次提交版本的记录是最新的。";
			formItem.addChild(truncateCbox);
			
			SType = new UICombobox();
			SType.width = 200;
			SType.height = 22;
			SType.labelField = "value";
			SType.formLabel = "文件类型 *";
			SType.verticalAlign = "middle";
			form.addFormItem(SType);
			
			sqlFile = new SandyTextInputWithLabelWithSelectFile();
			sqlFile.width = 243;
			sqlFile.paddingLeft = 0;
			sqlFile.horizontalAlign = "left";
			sqlFile.buttonLabel = "浏览";
			sqlFile.toolTip = "只能上传后缀名为.sql文件";
			sqlFile.formLabel = "选择文件 *";
			form.addFormItem(sqlFile);
			sqlFile.fileFilter = FileFilterUtils.parser(["sql"]);
			
			SName = new UITextInput();
			SName.width = 200;
			SName.formLabel = "文件名称 *";
			form.addFormItem(SName);
			
			SDesc = new UITextArea();
			SDesc.width = 200;
			SDesc.height = 60;
			SDesc.formLabel = "描述";
			form.addFormItem(SDesc);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalGap = 10;
			hbox.horizontalAlign = "center";
			hbox.height = 27;
			hbox.paddingTop = 10;
			vbox.addChild(hbox);
			
			saveBtn = new UIButton();
			saveBtn.width = 50;
			saveBtn.height = 25;
			saveBtn.label = "保 存";
			hbox.addChild(saveBtn);
			
			resetBtn = new UIButton();
			resetBtn.width = 50;
			resetBtn.height = 25;
			resetBtn.label = "重 置";
			hbox.addChild(resetBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 320;
			opts.title = "添加文件脚本";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataBaseAddPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataBaseAddPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataBaseAddPopupwinMediator.NAME);
		}
	}
}