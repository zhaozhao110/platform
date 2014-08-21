package com.editor.module_sql.pop.createDB
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class CreateDBPopWin extends AppPopupWithEmptyWin
	{
		public function CreateDBPopWin()
		{
			super()
			create_init()
		}


		public var pathTi:UITextInput;
		public var pwdTi:UITextInput;
		public var button22:UIButton;
		public var button26:UIButton
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 438;
			opts.height = 160;
			opts.title = "Create New DB"	
			return opts;
		}

		//程序生成
		private function create_init():void
		{
			var vb:UIVBox = new UIVBox();
			vb.styleName = "uicanvas"
			vb.paddingLeft = 25;
			vb.paddingTop = 25;
			vb.enabledPercentSize = true;
			addChild(vb);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			vb.addChild(hb1);
			
			var label21:UILabel = new UILabel();
			label21.text="Database File"
			hb1.addChild(label21);

			pathTi = new UITextInput();
			pathTi.id="pathTi"
			pathTi.width = 200;
			//pathTi.text= filePath.toString()
			//pathTi.addEventListener('change',function(e:*):void{ filePath = pathTi.text;});
			hb1.addChild(pathTi);
			
			button22 = new UIButton();
			button22.label="Browse"
			//button22.addEventListener('click',function(e:*):void{ browse();});
			hb1.addChild(button22);

			var hb2:UIHBox = new UIHBox();
			hb2.height = 30;
			hb2.percentWidth = 100;
			vb.addChild(hb2);
			
			var label23:UILabel = new UILabel();
			label23.text="Password (Optional)*"
			hb2.addChild(label23);

			pwdTi = new UITextInput();
			pwdTi.id="pwdTi"
			pwdTi.width = 200;
			
			//pwdTi.addEventListener('change',function(e:*):void{ pwd = pwdTi.text;});
			hb2.addChild(pwdTi);
			
			button26 = new UIButton();
			button26.label="Create"
			//button26.addEventListener('click',function(e:*):void{ submit();});
			vb.addChild(button26);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		override protected function __init__() : void
		{
			//useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.CreateDBDialog_sign
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new CreateDBPopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(CreateDBPopWinMediator.NAME);
		}
		
		
	}
}