package com.editor.modules.pop.editPopwin
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.core.ASSprite;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	
	public class EditPopPopwin extends AppPopupWithEmptyWin
	{
		public function EditPopPopwin()
		{
			super()
			create_init();
		}
		
		public var form:UIVBox;
		public var pathTi:UITextInput;
		public var eventTi:UITextInput;
		public var infoTi:UITextArea;
		public var editBtn:UIButton;
		public var event_vb:UIVBox;
		public var addBtn:UIButton;
		public var pubBtn:UIButton;
		
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
			lb.text = "新建窗口：";
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
			lb.text = "窗口注释：";
			hb4.addChild(lb);
			
			infoTi = new UITextArea();
			infoTi.width = 250;
			infoTi.toolTip = "请输入/** */或者//"
			infoTi.percentHeight = 100;
			hb4.addChild(infoTi);
			
			addBtn = new UIButton();
			addBtn.label = "新建"
			addBtn.toolTip = "系统将在modules下新建窗口结构目录"
			hb4.addChild(addBtn);
			
			var sp:ASSpace = new ASSpace();
			sp.width = 10;
			hb4.addChild(sp);
			
			pubBtn = new UIButton();
			pubBtn.label = "发布并生成AS"
			hb4.addChild(pubBtn);
						
			event_vb = new UIVBox();
			event_vb.styleName = "list";
			event_vb.itemRenderer = EditPopPopwinItemRenderer;
			event_vb.width = 470;
			event_vb.height = 305;
			event_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(event_vb);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 500;
			opts.height = 500;
			opts.title = "编辑窗口"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.EditPopPopwin_sign;
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new EditPopPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(EditPopPopwinMediator.NAME);
		}
		
	}
}