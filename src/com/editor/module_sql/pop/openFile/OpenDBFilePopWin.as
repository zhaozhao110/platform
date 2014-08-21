package com.editor.module_sql.pop.openFile
{
	
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.editor.view.popup.AppPopupWithNoTitleWin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.geom.*;
	import flash.utils.*;
	
	public class OpenDBFilePopWin extends AppPopupWithEmptyWin
	{
		public function OpenDBFilePopWin()
		{
			super()
			create_init()
		}
		
		
		public var fileListCmb:UICombobox;
		public var pathTi:UILabel;
		public var keyLbl:UILabel;
		public var hashTi:UITextInput;
		public var button49:UIButton
		public var button46:UIButton
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 446;
			opts.height = 200;
			opts.title = "Open Database"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			var vb:UIVBox = new UIVBox();
			vb.styleName = "uicanvas"
			vb.enabledPercentSize = true;
			vb.paddingLeft = 30;
			vb.paddingTop = 30;
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			var label47:UILabel = new UILabel();
			label47.x=38
			label47.text="DB File"
			label47.width = 70;
			label47.y=14
			hb.addChild(label47);
			
			fileListCmb = new UICombobox();
			fileListCmb.id="fileListCmb"
			fileListCmb.labelField="name"
			fileListCmb.width = 250;
			fileListCmb.height = 22;
			hb.addChild(fileListCmb);
			
			button46 = new UIButton();
			button46.label="select file"
			button46.width=70
			hb.addChild(button46);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 30;
			hb2.percentWidth = 100;
			vb.addChild(hb2);
			
			pathTi = new UILabel();
			pathTi.id="pathTi"
			pathTi.width = 390;
			hb2.addChild(pathTi);
			
			
			var hb3:UIHBox = new UIHBox();
			hb3.height = 30;
			hb3.percentWidth = 100;
			vb.addChild(hb3);
			
			var label21:UILabel = new UILabel();
			label21.text="password"
			label21.width = 70;
			hb3.addChild(label21);
			
			hashTi = new UITextInput();
			hashTi.id="hashTi"
			hashTi.width = 200
			hb3.addChild(hashTi);
			
			button49 = new UIButton();
			button49.label="Open"
			button49.y=72
			button49.width=82
			button49.x=85
			vb.addChild(button49);
			
			//dispatchEvent creationComplete
			initComplete();
		}

		
		override protected function __init__() : void
		{
			//useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.OpenDBFilePopWin_sign
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new OpenDBFilePopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(OpenDBFilePopWinMediator.NAME);
		}
		
	}
}