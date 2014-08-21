package com.editor.module_gdps.pop.userManageProduct
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UITile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsUserManageProductPopwin extends AppPopupWithEmptyWin
	{
		public function GdpsUserManageProductPopwin()
		{
			super();
			create_init();
		}
		
		public var tile:UITile;
		public var saveBtn:UIButton;
		public var cancelBtn:UIButton;
		
		private function create_init():void
		{
			tile = new UITile();
			tile.x = 5;
			tile.y = 30;
			tile.width = 532;
			tile.height = 435;
			tile.padding = 20;
			tile.backgroundColor = 0xFFFFFF;
			tile.verticalGap = 15;
			tile.horizontalGap = 20;
			tile.paddingLeft = 80;
			tile.borderStyle = "solid";
			tile.tileWidth = 200;
			tile.tileHeight = 22;
			tile.itemRenderer = GdpsUserManageProductRenderer;
			tile.verticalScrollPolicy = "auto";
			tile.horizontalScrollPolicy = "off";
			addChild(tile);
			
			var titleTxt:UILabel = new UILabel();
			titleTxt.text = "请选择项目";
			titleTxt.y = 9;
			titleTxt.x = 10;
			titleTxt.color = 0x15428B;
			titleTxt.fontSize = 14;
			titleTxt.bold = true;
			addChild(titleTxt);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 20;
			hbox.bottom = 10;
			addChild(hbox);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存";
			saveBtn.width = 60;
			saveBtn.height = 30;
			hbox.addChild(saveBtn);
			
			cancelBtn = new UIButton();
			cancelBtn.label = "取消";
			cancelBtn.width = 60;
			cancelBtn.height = 30;
			hbox.addChild(cancelBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 550;
			opts.height = 540;
			opts.title = "编辑用户绑定的项目";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsUserManageProductPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsUserManageProductPopwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsUserManageProductPopwinMediator.NAME);
		}
	}
}