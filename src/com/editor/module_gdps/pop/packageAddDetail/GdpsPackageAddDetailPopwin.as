package com.editor.module_gdps.pop.packageAddDetail
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsPackageAddDetailPopwin extends AppPopupWithEmptyWin
	{
		public function GdpsPackageAddDetailPopwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var saveBtn:UIButton;
		public var sourceTypeList:UIVlist;
		public var versionList:GdpsModuleDataGrid;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.padding = 10;
			addChild(vbox);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.height = 25;
			hbox1.percentWidth = 100;
			hbox1.horizontalGap = 5;
			hbox1.verticalAlign = "middle";
			vbox.addChild(hbox1);
			
			choose_tip = new UILabel();
			choose_tip.color = 0x00BB00;
			choose_tip.bold = true;
			hbox1.addChild(choose_tip);
			
			saveBtn = new UIButton();
			saveBtn.label = "添加版本到批次";
			hbox1.addChild(saveBtn);
			
			var add_tip:UILabel = new UILabel();
			add_tip.text = "每个批次中同一张数据表的版本数据只允许存在一份，请勿重复多选。";
			add_tip.color = 0xcc0000;
			hbox1.addChild(add_tip);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.percentHeight = 100;
			hbox2.percentWidth = 100;
			hbox2.horizontalGap = 5;
			hbox2.verticalAlign = "middle";
			vbox.addChild(hbox2);
			
			var vbox1:UIVBox = new UIVBox();
			vbox1.width = 130;
			vbox1.percentHeight = 100;
			vbox1.verticalGap = 3;
			hbox2.addChild(vbox1);
			
			var title:UILabel = new UILabel();
			title.color = 0x698537;
			title.text = "请先选择一个数据类型";
			vbox1.addChild(title);
			
			sourceTypeList = new UIVlist();
			sourceTypeList.enabledPercentSize = true;
			sourceTypeList.textOverColor = 0x0050AA;
			sourceTypeList.labelField = "label";
			sourceTypeList.rowHeight = 30;
			sourceTypeList.enabeldSelect = true;
			sourceTypeList.doubleClickEnabled = true;
			sourceTypeList.styleName = "list";
			sourceTypeList.toolTip = "双击查询对应数据类型的版本数据";
			sourceTypeList.dataProvider = list();
			vbox1.addChild(sourceTypeList);
			
			versionList = new GdpsModuleDataGrid();
			versionList.enabledPercentSize = true;
			hbox2.addChild(versionList);

			initComplete();
		}
		
		private function list():Array
		{
			var arr:Array = [];
			arr.push({label:"基础数据",data:"1"});
			arr.push({label:"文件数据",data:"2"});
			arr.push({label:"DB数据",data:"3"});
			return arr;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 600;
			opts.title = "添加批次明细";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPackageAddDetailPopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPackageAddDetailPopwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPackageAddDetailPopwinMediator.NAME);
		}
	}
}