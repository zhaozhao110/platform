package com.editor.module_avg.pop.txt
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.mediator.AVGModuleMediator;
	import com.editor.module_avg.pop.AVGPopViewBase;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.services.Services;
	import com.sandy.asComponent.controls.ASTextField;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.SandyColorPickerBar;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class AVGEditTxtPopView extends AVGPopViewBase
	{
		public function AVGEditTxtPopView()
		{
			super();
		}
		
		private var nameTi:UITextInput;
		private var nameColBar:SandyColorPickerBar;
		private var contColBar:SandyColorPickerBar;
		private var locCB:UICombobox;
		private var showCB:UICheckBox;
		private var textInput:UITextArea;
		private var okBtn:UIButton;
		
		override protected function get poptitle():String
		{
			return "编辑文本";
		}
		
		override protected function create_init():void
		{			
			var img:UIImage = new UIImage();
			img.width = AVGConfigVO.instance.width;
			img.height = 180;
			img.source = Services.assets_fold_url + "/img/avg/messageBack.png"
			addChild(img);
			img.y=105
			img.x=10
				
			super.create_init();
			
			width = 1000;
			contentBox.width = 995;
			/////////////////////////////////////////////////////////
			
			var h:UIHBox = createHBox();
			
			var lb:UILabel = new UILabel();
			lb.text = "角色名称: "
			h.addChild(lb);
			
			nameTi = new UITextInput();
			nameTi.width = 100;
			h.addChild(nameTi);
			
			nameColBar = new SandyColorPickerBar();
			nameColBar.width = 80;
			nameColBar.height = 22;
			h.addChild(nameColBar);
			
			okBtn = new UIButton();
			okBtn.label = "确定"
			okBtn.addEventListener(MouseEvent.CLICK , onOkClick);
			h.addChild(okBtn);
			
			/////////////////////////////////////////////////////////
			
			h = createHBox();
			
			lb = new UILabel();
			lb.text = "文字颜色: "
			h.addChild(lb);
			
			contColBar = new SandyColorPickerBar();
			contColBar.width = 80;
			contColBar.height = 22;
			contColBar.addEventListener(ASEvent.CHANGE,contColChange);
			h.addChild(contColBar);
			
			var btn2:UIButton = new UIButton();
			btn2.label = "清除所有样式"
			h.addChild(btn2);
			btn2.addEventListener(MouseEvent.CLICK , onClearStyle);
			
			lb = new UILabel();
			lb.text = "对话框位置: "
			h.addChild(lb);
			
			locCB = new UICombobox();
			locCB.width = 50;
			locCB.height = 25;
			h.addChild(locCB);
			locCB.dataProvider = [{label:"上",data:"1"},{label:"中",data:"2"},{label:"下",data:"3"}]
			locCB.labelField = "label"
			locCB.selectedIndex = 2;
			locCB.addEventListener(ASEvent.CHANGE,onLocChange);
			
			showCB = new UICheckBox();
			showCB.selected = true;
			showCB.label = "显示对话框"
			showCB.addEventListener(ASEvent.CHANGE,onShowCBChange);
			h.addChild(showCB);
			
			////////////////////////////////////////////////////////
			
			textInput = new UITextArea();
			textInput.backgroundAlpha = 0;
			textInput.color = ColorUtils.white;
			textInput.alwaysShowSelection = true;
			textInput.width = 780;
			textInput.fontSize = 16;
			textInput.height = 190;
			textInput.letterSpacing = 3;
			textInput.leading = 5
			textInput.x = 80;
			textInput.y = 140
			textInput.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textInput.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(textInput);
			
			reflashContent()
		}
				
		override protected function onCloseHandle(e:MouseEvent):void
		{
			get_AVGModuleMediator().closeEditTxt();
			super.onCloseHandle(e);
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashContent()
		}
		
		private function reflashContent():void
		{
			if(AVGManager.currFrame==null){
				iManager.iPopupwin.showError("请先选择某一帧");
				return ;
			}
			
			getTextField().setSelection(0,0);
			nameTi.text 				= AVGManager.currFrame.peoName;
			nameColBar.selectedColor 	= AVGManager.currFrame.peoColor;
			textInput.text 				= AVGManager.currFrame.content;
			//textInput.color				= AVGManager.currFrame.contentCol;
			locCB.selectedIndex 		= AVGManager.currFrame.backLoc-1
			showCB.selected 			= AVGManager.currFrame.showDialog==1?true:false;
			setColors()
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			AVGManager.currFrame.showDialog 	= showCB.selected==true?1:0;
			AVGManager.currFrame.peoName 		= nameTi.text;
			AVGManager.currFrame.peoColor 		= nameColBar.selectedColor;
			AVGManager.currFrame.content 		= textInput.text;
			//AVGManager.currFrame.contentCol 	= contColBar.selectedColor;
			if(locCB.selectedItem!=null){
				AVGManager.currFrame.backLoc 	= int(locCB.selectedItem.data);
			}
			
			AVGPreview.instance.dialogCont.setContent();
			AVGPreview.instance.dialogCont.showBack(AVGManager.currFrame.showDialog);
			
			iManager.sendAppNotification(AVGEvent.reflashTimeline_inavg_event);
		}
		
		private function onShowCBChange(e:ASEvent):void
		{
			//AVGManager.currFrame.showDialog = showCB.selected==true?1:0;
			//AVGPreview.instance.dialogCont.showBack(AVGManager.currFrame.showDialog);
		}
		
		private function onLocChange(e:ASEvent):void
		{
			
		}
		
		private function contColChange(e:ASEvent):void
		{
			var s1:int = getTextField().selectionBeginIndex;
			var s2:int = getTextField().selectionEndIndex;
			if(s1 == s2){
				//textInput.color = contColBar.selectedColor;
			}else{
				var tf:TextFormat = new TextFormat();
				tf.color = contColBar.selectedColor;
				getTextField().setTextFormat(tf,s1,s2);
				
				var obj:Object = {};
				obj.from = s1;
				obj.end = s2;
				obj.color = tf.color;
				AVGManager.currFrame.addColor(obj)
			}
		}
		
		private function onClearStyle(e:MouseEvent):void
		{
			AVGManager.currFrame.clearColors();
			textInput.text 		= AVGManager.currFrame.content;
			textInput.color		= ColorUtils.white;
		}
		
		private function setColors():void
		{
			if(AVGManager.currFrame.color_ls == null) return ;
			for(var i:int=0;i<AVGManager.currFrame.color_ls.length;i++){
				var obj:Object = AVGManager.currFrame.color_ls[i];
				setColorOne(obj);	
			}
		}
		
		private function setColorOne(obj:Object):void
		{
			var from:int = int(obj.from);
			var end:int = int(obj.end);
			var color:* = obj.color;
			for(var i:int=from;i<end;i++){
				var tf:TextFormat = new TextFormat();
				tf.color = color;
				if(i <= (getTextField().text.length-1)){
					getTextField().setTextFormat(tf,i,i+1);
				}
			}
		}
		
		private function getTextField():ASTextField
		{
			return textInput.getTextField().getTextField();
		}
		
	}
}