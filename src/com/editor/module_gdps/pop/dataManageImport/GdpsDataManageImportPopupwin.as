package com.editor.module_gdps.pop.dataManageImport
{
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.air.io.FileUtils;
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.FileFilterUtils;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsDataManageImportPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataManageImportPopupwin()
		{
			super();
			create_init();
		}
		
		public var truncateCbox:UICheckBox;
		public var truncateTestdbCbox:UICheckBox;
		public var selectFileBtn:SandyTextInputWithLabelWithSelectFile;
		public var saveFileBtn:UIButton;
		public var cancelBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.padding = 20;
			vbox.verticalGap = 12;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			var lb:UILabel = new UILabel();
			lb.text = "请选择上传文件";
			lb.percentWidth = 100;
			lb.textAlign = "left";
			vbox.addChild(lb);
			
			truncateCbox = new UICheckBox();
			truncateCbox.label = "清空“编辑”表数据";
			truncateCbox.selected = true;
			truncateCbox.color = 0xDC1111;
			truncateCbox.toolTip = "选择后，系统会自动先清空当前“编辑”表的所有数据。请保证上传excel数据的完整性。";
			vbox.addChild(truncateCbox);
			
			truncateTestdbCbox = new UICheckBox();
			truncateTestdbCbox.label = "清空“游戏开发调试服”表数据";
			truncateTestdbCbox.selected = false;
			truncateTestdbCbox.color = 0xDC1111;
			truncateTestdbCbox.toolTip = "选择后，系统会自动先清空当前表对应的“游戏开发调试服”的数据。" +
				"请保证上传excel数据的完整性，“慎重”选择清理。";
			vbox.addChild(truncateTestdbCbox);
			
			selectFileBtn = new SandyTextInputWithLabelWithSelectFile();
			selectFileBtn.width = 300;
			selectFileBtn.height = 25;
			selectFileBtn.label = "选择文件:";
			selectFileBtn.buttonLabel = "浏览";
			vbox.addChild(selectFileBtn);
			selectFileBtn.fileFilter = FileFilterUtils.parser(["xls","xlsx"]);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalGap = 10;
			hbox.horizontalAlign = "center";
			hbox.height = 27;
			hbox.paddingTop = 10;
			vbox.addChild(hbox);
			
			saveFileBtn = new UIButton();
			saveFileBtn.width = 50;
			saveFileBtn.height = 25;
			saveFileBtn.label = "保 存";
			hbox.addChild(saveFileBtn);
			
			cancelBtn = new UIButton();
			cancelBtn.width = 50;
			cancelBtn.height = 25;
			cancelBtn.label = "取 消";
			hbox.addChild(cancelBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 350;
			opts.height = 240;
			opts.title = "导入EXCEL";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataManageImportPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataManageImportPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataManageImportPopupwinMediator.NAME);
		}
	}
}