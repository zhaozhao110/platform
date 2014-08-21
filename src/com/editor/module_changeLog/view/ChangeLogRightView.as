package com.editor.module_changeLog.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIEditTextToolBar;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.StringTWLUtil;

	public class ChangeLogRightView extends UIVBox
	{
		public function ChangeLogRightView()
		{
			super();
			create_init();
		}
		
		public var toolBar:UIEditTextToolBar;
		public var txtArea:UITextArea;
		public var okButton:UIButton;
		public var infoTi:UILabel;
		public var infoTi2:UILabel;
		
		private function create_init():void
		{
			padding = 5;
			verticalGap = 5;
			
			toolBar = new UIEditTextToolBar();
			addChild(toolBar);
			toolBar.showHtmlBool  = false
			if(!AppMainModel.getInstance().user.checkIsSystem()){
				toolBar.visible = false; 
			}
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas"
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			infoTi = new UILabel();
			infoTi.width = 350
			hb.addChild(infoTi);
			
			okButton = new UIButton();
			okButton.label = "保存"
			hb.addChild(okButton);
			if(!AppMainModel.getInstance().user.checkIsSystem()){
				okButton.visible = false; 
			}			
			
			infoTi2 = new UILabel();
			infoTi2.width = 350
			hb.addChild(infoTi2);
			
			txtArea = new UITextArea();
			txtArea.fontSize = 14;
			txtArea.verticalScrollPolicy=ASComponentConst.scrollPolicy_auto;
			txtArea.horizontalScrollPolicy=ASComponentConst.scrollPolicy_auto;
			txtArea.editable = true;
			txtArea.enabledPercentSize = true
			addChild(txtArea);
			if(!AppMainModel.getInstance().user.checkIsSystem()){
				txtArea.editable = false;
			}
			
			hb = new UIHBox();
			hb.height = 30;
			hb.paddingLeft = 20;
			hb.percentWidth = 100;
			addChild(hb);
			
		}
		
		public function setContent(obj:Object):void
		{
			if(obj == null) return ;
			toolBar.reset();
			if(!StringTWLUtil.isWhitespace(obj.content)){
				txtArea.htmlText = ByteArrayUtil.convertByteArrayToString(obj.content);
			}else{
				txtArea.htmlText = "";
			}
			infoTi.text = obj.time;
			
		}
		
	}
}