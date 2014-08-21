package com.editor.project_pop.parserSwf
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.NativeWindowType;

	public class ParserSwfPopwin extends AppPopupWithEmptyWin
	{
		public function ParserSwfPopwin()
		{
			super()
			create_init()
		}
		
		public var fileTI1:UITextInput;
		public var button24:UIButton;
		public var vb1:UIVBox;
		public var vb2:UIVBox;
		public var vb3:UIVlist;
		public var swfBtn:UIButton;
		public var cont:UICanvas;
		public var swfHBox:UIHBox;
		public var swfHBox2:UIHBox;
		public var projectHBox:UIHBox;
		public var txt:UITextArea;
		
		private function create_init():void
		{			
			var vbox6:UIVBox = new UIVBox();
			vbox6.width = 780
			vbox6.height = 580
			vbox6.verticalGap=10
			addChild(vbox6);
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth=100
			hb.height = 30;
			hb.styleName = "uicanvas";
			hb.verticalAlignMiddle = true;
			vbox6.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text="选择swf文件："
			hb.addChild(lb);
			
			fileTI1 = new UITextInput();
			fileTI1.id="fileTI1"
			fileTI1.width=300
			fileTI1.editable=false
			fileTI1.text=""
			hb.addChild(fileTI1);
			
			button24 = new UIButton();
			button24.label="选择"
			hb.addChild(button24);
			
			swfBtn = new UIButton();
			swfBtn.label = "解析项目的swf资源利用情况"
			hb.addChild(swfBtn);
			
			lb = new UILabel();
			lb.color = ColorUtils.red;
			lb.text = "(请选择当前打开项目的资源)"
			hb.addChild(lb);
			
			cont = new UICanvas();
			cont.enabledPercentSize = true;
			vbox6.addChild(cont);
			
			/////////////////////////////////// project ////////////////////////////////////////////
			
			projectHBox = new UIHBox();
			projectHBox.enabledPercentSize = true;
			cont.addChild(projectHBox);
			projectHBox.visible = false;
			projectHBox.styleName = "uicanvas";
			
			txt = new UITextArea();
			txt.enabledPercentSize = true;
			txt.editable = false;
			txt.verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			projectHBox.addChild(txt);
			
			/////////////////////////////////// swf ///////////////////////////////////////////////
			
			swfHBox = new UIHBox();
			swfHBox.percentWidth=100
			swfHBox.height = 30;
			swfHBox.styleName = "uicanvas";
			swfHBox.verticalAlignMiddle = true;
			cont.addChild(swfHBox);
			
			lb = new UILabel();
			lb.text="文件列表"+StringTWLUtil.createSpace_en2(5)+"导出类列表"+StringTWLUtil.createSpace_en2(8)+"所被使用的类列表"
			swfHBox.addChild(lb);
			
			swfHBox2 = new UIHBox();
			swfHBox2.percentWidth = 100;
			swfHBox2.height = 480;
			swfHBox2.styleName = "uicanvas";
			swfHBox2.horizontalGap = 10;
			swfHBox2.y = 32
			cont.addChild(swfHBox2);
			
			vb1 = new UIVBox();
			vb1.width = 200;
			vb1.percentHeight = 100;
			vb1.styleName = "list"
			vb1.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			swfHBox2.addChild(vb1);
			
			vb2 = new UIVBox();
			vb2.width = 200;
			vb2.percentHeight = 100;
			vb2.styleName = "list"
			vb2.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			swfHBox2.addChild(vb2);
			
			vb3 = new UIVlist();
			vb3.enabledPercentSize = true
			vb3.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			swfHBox2.addChild(vb3);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		public function showSwf():void
		{
			swfHBox.visible = true;
			swfHBox2.visible = true
			projectHBox.visible = false;
		}
		
		public function showProject():void
		{
			swfHBox.visible = false;
			swfHBox2.visible = false;
			projectHBox.visible = true
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 800;
			opts.height = 600;
			opts.title = "解析swf"	
			return opts;
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.ParserSwfPopwin_sign
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new ParserSwfPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ParserSwfPopwinMediator.NAME);
		}
		
	}
}