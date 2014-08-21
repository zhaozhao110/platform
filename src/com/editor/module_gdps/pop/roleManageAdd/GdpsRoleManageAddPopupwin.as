package com.editor.module_gdps.pop.roleManageAdd
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsRoleManageAddPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsRoleManageAddPopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var nameTxt:UITextInput;
		public var descTxt:UITextArea;
		public var saveBtn:UIButton;
		public var closeBtn:UIButton;
		public var resetBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.horizontalAlign = "center";
			vbox.paddingLeft = 15;
			vbox.paddingTop = 0;
			vbox.verticalGap = 0;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			form = new UIForm();
			form.percentWidth = 100;
			form.height = 110;
			form.leftWidth = 75;
			form.verticalGap = 4;
			form.horizontal_gap = 5;
			form.horizontalAlign = "right";
			vbox.addChild(form);
			
			nameTxt = new UITextInput();
			nameTxt.width = 220;
			nameTxt.height = 24;
			nameTxt.formLabel = "角色名称 *";
			form.addFormItem(nameTxt);
			
			descTxt = new UITextArea();
			descTxt.width = 220;
			descTxt.height = 65;
			descTxt.formLabel = "备  注";
			form.addFormItem(descTxt);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 10;
			vbox.addChild(hbox);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存";
			saveBtn.width = 50;
			saveBtn.height = 25;
			hbox.addChild(saveBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭";
			closeBtn.width = 50;
			closeBtn.height = 25;
			hbox.addChild(closeBtn);
			
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
			opts.width = 350;
			opts.height = 200;
			opts.title = "添加角色";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsRoleManageAddPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsRoleManageAddPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsRoleManageAddPopupwinMediator.NAME);
		}
	}
}