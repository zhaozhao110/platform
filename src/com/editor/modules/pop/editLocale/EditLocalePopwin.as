package com.editor.modules.pop.editLocale
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.manager.DataManager;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.core.ASSprite;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;

	public class EditLocalePopwin extends AppPopupWithEmptyWin
	{
		public function EditLocalePopwin()
		{
			super()
			create_init();
		}
		
		public var form:UIVBox;
		public var pathTi:UITextInput;
		public var eventTi:UITextInput;
		public var infoTi:UITextArea;
		public var editBtn:UIButton;
		public var event_vb:UIVlist;
		public var addBtn:UIButton;
		public var pubBtn:UIButton;
		public var textCan:UIVBox;
		public var lb3:UIText;
		public var cls_vb:UIVBox;
		public var infoLB:UILabel;
		public var backBtn:UIButton;
		
		private function create_init():void
		{
			form = new UIVBox();
			form.verticalGap = 5;
			form.y = 20;
			form.x = 10
			form.width = 470;
			form.height = 400;
			this.addChild(form);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			hb1.styleName = "uicanvas"
			hb1.verticalAlignMiddle = true
			form.addChild(hb1);
			
			var lb:UILabel = new UILabel();
			lb.text = "文件路径：";
			hb1.addChild(lb);
			
			pathTi = new UITextInput();
			pathTi.editable = false;
			pathTi.width = 380;
			hb1.addChild(pathTi);
			
			infoLB = new UILabel();
			infoLB.height = 25;
			form.addChild(infoLB);
			
			
			var hb2:UIVBox = new UIVBox();
			hb2.paddingLeft = 10;
			hb2.paddingTop = 4;
			hb2.height = 100;
			hb2.percentWidth = 100;
			hb2.styleName = "uicanvas"
			form.addChild(hb2);
			
			
			var hb3:UIHBox = new UIHBox();
			hb3.height = 30;
			hb3.verticalAlignMiddle = true
			hb3.percentWidth = 100;
			hb2.addChild(hb3);
			
			lb = new UILabel();
			lb.text = "文字key：";
			hb3.addChild(lb);
			
			eventTi = new UITextInput();
			eventTi.width = 250;
			hb3.addChild(eventTi);
			
			editBtn = new UIButton();
			editBtn.label = "修改"
			hb3.addChild(editBtn);
						
			var hb4:UIHBox = new UIHBox();
			hb4.enabledPercentSize = true
			hb4.verticalAlignMiddle = true
			hb2.addChild(hb4);
			
			lb = new UILabel();
			lb.text = "文字value：";
			hb4.addChild(lb);
			
			infoTi = new UITextArea();
			infoTi.width = 250;
			infoTi.percentHeight = 100;
			hb4.addChild(infoTi);
			
			addBtn = new UIButton();
			addBtn.label = "新建"
			hb4.addChild(addBtn);
			
			var sp:ASSpace = new ASSpace();
			sp.width = 10;
			hb4.addChild(sp);
			
			pubBtn = new UIButton();
			pubBtn.label = "发布并生成"
			hb4.addChild(pubBtn);
			
			
						
			event_vb = new UIVlist();
			event_vb.styleName = "list";
			event_vb.itemRenderer = EditLocaleWinItemRenderer;
			event_vb.width = 470;
			event_vb.height = 280;
			event_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(event_vb);
			
			
			///////////////////////////////////////////////////////////////////////
			
			textCan = new UIVBox();
			textCan.padding = 5;
			textCan.backgroundColor = DataManager.def_col
			textCan.styleName = "uicanvas"
			textCan.width = 500;
			textCan.height = 500;
			textCan.visible = false;
			addChild(textCan);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 50;
			hb.percentWidth=100;
			hb.horizontalGap = 10;
			textCan.addChild(hb);
			
			backBtn = new UIButton();
			backBtn.label = "返回"
			backBtn.addEventListener(MouseEvent.CLICK , backBtnClick)
			hb.addChild(backBtn);
			
			lb3 = new UIText();
			lb3.color = ColorUtils.black;
			lb3.width = 500
			hb.addChild(lb3);
									
			cls_vb = new UIVBox();
			cls_vb.styleName = "list"
			cls_vb.itemRenderer = EditLocaleWinClassItemRenderer
			cls_vb.width = 475;
			cls_vb.doubleClickEnabled = true;
			cls_vb.height = 410;
			cls_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textCan.addChild(cls_vb);
			
			
			
			initComplete();
		}
		
		private function backBtnClick(e:MouseEvent):void
		{
			textCan.visible = false;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 500;
			opts.height = 500;
			opts.title = "编辑locale,多国语言版本"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.EditLocalePopwin_sign;
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new EditLocalePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(EditLocalePopwinMediator.NAME)
		}
		
	}
}