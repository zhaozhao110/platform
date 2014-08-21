package com.editor.project_pop.serverCode
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class CreateServerCodePopwin extends AppPopupWithEmptyWin
	{
		public function CreateServerCodePopwin()
		{
			super()
			create_init();
		}
		
		public var ti:UITextInput;
		public var form:UIForm;
		public var ti2:UITextInput;
		public var ti4:UITextArea;
		public var dg:UIVBox;
		public var text:UITextArea;
		public var closeBtn:UIButton;
		public var textCan:UIVBox;
		public var pubBtn:UIButton;
		public var parserBtn:UIButton;
		public var ti5:UITextInput;
		public var addBtn1:UIAssetsSymbol;
		public var addBtn2:UIAssetsSymbol;
		public var addBtn3:UIAssetsSymbol;
		public var addBtn4:UIAssetsSymbol;
		public var delBtn:UIAssetsSymbol;
		public var ti6:UITextInput;
		public var pathTi:UITextInput;
		public var selectBtn:UIButton
		
		
		private function create_init():void
		{
			var can:UICanvas = new UICanvas();
			can.y = 10;
			can.x = 10;
			can.width = 570;
			can.height = 600;
			can.styleName = "uicanvas";
			addChild(can);
			
			var vb:UIVBox = new UIVBox();
			vb.padding = 5;
			vb.enabledPercentSize = true;
			can.addChild(vb);
			
			form = new UIForm();
			form.verticalGap = 5;
			form.percentWidth = 100;
			form.height = 230;
			form.leftWidth = 70;
			vb.addChild(form);
			
			var form_a:Array = [];
			
			ti = new UITextInput();
			ti.formLabel = "项目前缀："
			ti.width = 450 ;
			ti.height = 22 ;
			form_a.push(ti);
			
			ti2 = new UITextInput();
			ti2.formLabel = "消息名："
			ti2.width = 450 ;
			ti2.height = 22 ;
			form_a.push(ti2);
			
			ti6 = new UITextInput();
			ti6.formLabel = "AS函数名："
			ti6.width = 450 ;
			ti6.height = 22 ;
			form_a.push(ti6);
			
			ti4 = new UITextArea();
			ti4.formLabel = "返回格式："
			ti4.width = 450 ;
			ti4.height = 100 ;
			form_a.push(ti4);
			
			ti5 = new UITextInput();
			ti5.formLabel = "选中行："
			ti5.width = 450 ;
			ti5.height = 22 ;
			form_a.push(ti5);
			
			form.areaComponent = form_a;
			
			var hb:UIHBox = new UIHBox();
			hb.horizontalGap = 5;
			hb.horizontalAlign = ASComponentConst.horizontalAlign_right;
			hb.percentWidth = 100;
			hb.height = 30;
			vb.addChild(hb);
			
			addBtn1 = new UIAssetsSymbol();
			addBtn1.source = "add_a"
			addBtn1.toolTip = "在选中行之前插入新行";
			addBtn1.buttonMode = true;
			hb.addChild(addBtn1);
			
			addBtn2 = new UIAssetsSymbol();
			addBtn2.source = "add_a"
			addBtn2.toolTip = "在选中行之后插入新行";
			addBtn2.buttonMode = true;
			hb.addChild(addBtn2);
			
			addBtn3 = new UIAssetsSymbol();
			addBtn3.source = "add_a"
			addBtn3.toolTip = "在选中行之前插入循环体开头";
			addBtn3.buttonMode = true;
			hb.addChild(addBtn3);
			
			addBtn4 = new UIAssetsSymbol();
			addBtn4.source = "add_a"
			addBtn4.toolTip = "在选中行之前插入循环体结束";
			addBtn4.buttonMode = true;
			hb.addChild(addBtn4);
			
			delBtn = new UIAssetsSymbol();
			delBtn.source = "close2_a"
			delBtn.toolTip = "删除选中行";
			delBtn.buttonMode = true;
			hb.addChild(delBtn);
			
			parserBtn = new UIButton();
			parserBtn.label = "解析"
			hb.addChild(parserBtn);
			
			pubBtn = new UIButton();
			pubBtn.label = "发布"
			hb.addChild(pubBtn);
			
			dg = new UIVBox();
			dg.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			dg.enabeldSelect = true
			dg.styleName = "list";
			dg.enabledPercentSize= true;
			vb.addChild(dg);
			
			////////////////////////////////////////////////////////////////////////////////
			
			textCan = new UIVBox();
			textCan.padding = 5;
			textCan.backgroundColor = 0x444444;
			textCan.styleName = "uicanvas"
			textCan.width = 570;
			textCan.height = 600;
			textCan.visible = false;
			can.addChild(textCan);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.percentWidth=100;
			textCan.addChild(hb);
			
			var copyBtn:UIButton = new UIButton();
			copyBtn.label = "复制"
			copyBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{System.setClipboard(text.text);});
			hb.addChild(copyBtn);
				
			closeBtn = new UIButton();
			closeBtn.label = "关闭";
			closeBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{textCan.visible=false;});
			hb.addChild(closeBtn);
			
			text = new UITextArea();
			text.enabledPercentSize = true;
			textCan.addChild(text);
			
			var hb3:UIHBox = new UIHBox();
			hb3.percentWidth = 100;
			hb3.height = 30;
			hb3.verticalAlignMiddle = true
			textCan.addChild(hb3);
			
			var lb:UILabel = new UILabel();
			lb.text = "选择复制到的文件："
			lb.color = ColorUtils.white;
			hb3.addChild(lb);
			
			pathTi = new UITextInput();
			pathTi.width = 330;
			hb3.addChild(pathTi);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择文件复制"
			hb3.addChild(selectBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 600;
			opts.height = 650;
			opts.title = "生成serverCode"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.CreateServerCodePopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new CreateServerCodePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(CreateServerCodePopwinMediator.NAME);
		}
		
	}
}