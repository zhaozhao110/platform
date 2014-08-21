package com.editor.module_actionMix.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_actionMix.component.ActionMixFrameImage;
	import com.editor.module_actionMix.component.ActionMixPreviewImage;
	import com.editor.module_actionMix.component.ActionMixPreviewImageContainer;
	import com.editor.module_actionMix.component.ActionMixQueueItemRenderer;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ActionMixContent extends UIVBox
	{
		public function ActionMixContent()
		{
			super();
			create_init();
		}
		
		public var toolBar:ActionMixToolBar;
		public var infoText:UILabel;
		public var previewImg:ActionMixPreviewImageContainer;
		public var queueBox:UIVBox;
		public var imgListBox:UIVBox;
		public var previewBtn:UIButton;
		public var previewBtn2:UIButton;
		public var actionTypeCB:UICombobox;
		public var logTxt:UITextArea;
		public var insertBtn:UIButton;
		public var insertTypeCB:UICombobox
		public var infoTxt:UILabel;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			//cornerRadius = 10;
			
			toolBar = new ActionMixToolBar();
			toolBar.id="toolBar";
			addChild(toolBar);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			infoText = new UILabel();
			infoText.id="infoText";
			infoText.percentWidth=100;
			infoText.height = 30;
			infoText.text = ActionMixManager.topInfoTxt.toString()
			hb.addChild(infoText);
			
			var hb1:UIHBox = new UIHBox();
			hb1.padding = 10;
			hb1.horizontalGap = 10;
			hb1.enabledPercentSize = true;
			addChild(hb1);
			
			previewImg = new ActionMixPreviewImageContainer();
			previewImg.width = 500;
			previewImg.height = 500;
			hb1.addChild(previewImg);
			
			
			
			
			var vb1:UIVBox = new UIVBox();
			vb1.width = 200;
			vb1.percentHeight = 100;
			vb1.paddingTop = 20;
			vb1.verticalGap = 10;
			hb1.addChild(vb1);
			
			var hb2:UIHBox = new UIHBox();
			hb2.percentWidth =100;
			hb2.height = 30;
			hb2.horizontalGap = 5;
			vb1.addChild(hb2);
			
			previewBtn = new UIButton();
			previewBtn.label = "预览合成动作"
			hb2.addChild(previewBtn);
			
			previewBtn2 = new UIButton();
			previewBtn2.label = "预览基本动作"
			hb2.addChild(previewBtn2);
						
			var lb1:UILabel = new UILabel();
			lb1.text = "动作类型：";
			lb1.height = 20;
			vb1.addChild(lb1);
						
			actionTypeCB = new UICombobox();
			actionTypeCB.width = 150;
			actionTypeCB.height = 25;
			vb1.addChild(actionTypeCB);
			
			var hb3:UIHBox = new UIHBox();
			hb3.percentWidth =100;
			hb3.height = 30;
			hb3.horizontalGap = 5;
			vb1.addChild(hb3);
			
			insertBtn = new UIButton();
			insertBtn.label = "插入空白帧"
			hb3.addChild(insertBtn);
			
			insertTypeCB = new UICombobox();
			insertTypeCB.width = 120;
			insertTypeCB.height = 25;
			insertTypeCB.labelField = "label"
			hb3.addChild(insertTypeCB);
			
			var a:Array = [];
			a.push({label:"在选中的后面插入",data:1})
			a.push({label:"在选中的前面插入",data:2})
			insertTypeCB.dataProvider = a;
			
			infoTxt = new UILabel();
			infoTxt.height = 22;
			vb1.addChild(infoTxt);
			
			queueBox = new UIVBox();
			queueBox.padding = 2;
			queueBox.width = 200;
			queueBox.height = 300;
			queueBox.enabeldSelect = true;
			queueBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			//queueBox.itemRenderer = ActionMixQueueItemRenderer;
			queueBox.borderStyle = ASComponentConst.borderStyle_solid;
			queueBox.borderColor = 0x000000;
			vb1.addChild(queueBox);
			
			
			
			
			
			imgListBox = new UIVBox();
			imgListBox.enabledPercentSize = true;
			imgListBox.itemRenderer = ActionMixFrameImage;
			imgListBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			imgListBox.borderStyle = ASComponentConst.borderStyle_solid;
			imgListBox.borderColor = 0x000000;
			hb1.addChild(imgListBox); 
			
			var lb:UILabel = new UILabel();
			lb.text = "记录log";
			lb.height = 20
			addChild(lb);
			
			logTxt = new UITextArea();
			logTxt.id="logTxt"
			logTxt.editable = false;
			logTxt.percentWidth=100
			logTxt.height=100
			addChild(logTxt);
		}
	}
}