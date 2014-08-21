package com.editor.module_gdps.pop.colunmProfile
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsColumnProfilePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsColumnProfilePopupwin()
		{
			super();
			create_init();
		}
		
		public var tip_info:UILabel;
		public var profileList:GdpsModuleDataGrid;
		public var profileForm:UIForm;
		public var n_table_id:UITextInput;
		public var s_field:UITextInput;
		public var s_annotation:UITextInput;
		public var s_type:UICombobox;
		public var s_key:UITextInput;
		public var s_state:UICombobox;
		public var n_order:UITextInput;
		public var saveBtn:UIButton;
		public var resetBtn:UIButton;
		public var deleteBtn:UIButton;
		
		private function create_init():void
		{
			var hbox:UIHBox = new UIHBox();
			hbox.enabledPercentSize = true;
			hbox.horizontalGap = 30;
			addChild(hbox);
			
			var vbox:UIVBox = new UIVBox();
			vbox.verticalGap = 3;
			vbox.paddingLeft = 10;
			vbox.paddingBottom = 15;
			vbox.paddingTop = 15;
			vbox.paddingRight = 5;
			vbox.percentHeight = 100;
			vbox.width = 655;
			hbox.addChild(vbox);
			
			tip_info = new UILabel();
			tip_info.percentWidth = 100;
			tip_info.height = 24;
			tip_info.fontSize = 14;
			tip_info.color = 0x008000;
			vbox.addChild(tip_info);
			
			profileList = new GdpsModuleDataGrid();
			profileList.enabledPercentSize = true;
			vbox.addChild(profileList);
			
			var vbox1:UIVBox = new UIVBox();
			vbox1.verticalGap = 5;
			vbox1.height = 580;
			vbox1.percentWidth = 100;
			vbox1.verticalAlign = "middle";
			hbox.addChild(vbox1);
			
			var rightTitle:UILabel = new UILabel();
			rightTitle.text = "数据字段属性操作：";
			rightTitle.height = 50;
			rightTitle.fontSize = 15;
			rightTitle.paddingLeft = 20;
			rightTitle.color = 0x008000;
			vbox1.addChild(rightTitle);
			
			profileForm = new UIForm();
			profileForm.width = 290;
			profileForm.leftWidth = 80;
			profileForm.verticalGap = 30;
			vbox1.addChild(profileForm);
			
			n_table_id = new UITextInput();
			n_table_id.width = 200;
			n_table_id.height = 24;
			n_table_id.formLabel = "数据表ID *";
			profileForm.addFormItem(n_table_id);
			
			s_field = new UITextInput();
			s_field.width = 200;
			s_field.height = 24;
			s_field.formLabel = "字段名称 *";
			profileForm.addFormItem(s_field);
			
			s_annotation = new UITextInput();
			s_annotation.width = 200;
			s_annotation.height = 24;
			s_annotation.formLabel = "字段注释 *";
			profileForm.addFormItem(s_annotation);
			
			s_type = new UICombobox();
			s_type.width = 200;
			s_type.height = 24;
			s_type.labelField = "lab";
			s_type.formLabel = "字段类型 *";
			profileForm.addFormItem(s_type);
			
			s_key = new UITextInput();
			s_key.width = 200;
			s_key.height = 24;
			s_key.formLabel = "字段属性KEY *";
			profileForm.addFormItem(s_key);
			
			s_state = new UICombobox();
			s_state.width = 200;
			s_state.height = 24;
			s_state.labelField = "lab";
			s_state.formLabel = "是否生成 *";
			profileForm.addFormItem(s_state);
			
			n_order = new UITextInput();
			n_order.width = 200;
			n_order.height = 24;
			n_order.formLabel = "生成排序ID *";
			profileForm.addFormItem(n_order);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.percentWidth = 100;
			hbox2.horizontalGap = 10;
			hbox2.horizontalAlign = "center";
			hbox2.height = 27;
			hbox2.paddingTop = 30;
			vbox1.addChild(hbox2);
			
			saveBtn = new UIButton();
			saveBtn.width = 50;
			saveBtn.height = 25;
			saveBtn.label = "保 存";
			hbox2.addChild(saveBtn);
			
			resetBtn = new UIButton();
			resetBtn.width = 50;
			resetBtn.height = 25;
			resetBtn.label = "重 置";
			hbox2.addChild(resetBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.width = 50;
			deleteBtn.height = 25;
			deleteBtn.label = "删 除";
			hbox2.addChild(deleteBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 1028;
			opts.height = 650;
			opts.title = "数据字段属性定义";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsColumnProfilePopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsColumnProfilePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsColumnProfilePopupwinMediator.NAME);
		}
	}
}