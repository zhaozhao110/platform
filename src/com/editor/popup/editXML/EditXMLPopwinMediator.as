package com.editor.popup.editXML
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.MouseEvent;

	public class EditXMLPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "EditXMLPopwinMediator"
		public function EditXMLPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get editWin():EditXMLPopwin
		{
			return viewComponent as EditXMLPopwin;
		}
		public function get btn1():UIButton
		{
			return editWin.btn1;
		}
		public function get btn2():UIButton
		{
			return editWin.btn2;
		}
		public function get upTxt():UITextArea
		{
			return editWin.upTxt;
		}
		public function get downTxt():UITextArea
		{
			return editWin.downTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToBtn1Click(e:MouseEvent):void
		{
			downTxt.text = EditXMLTool.getInstance().add(upTxt.text);
		}
		
		public function reactToBtn2Click(e:MouseEvent):void
		{
			downTxt.text = EditXMLTool.getInstance().clear(upTxt.text);
		}
	}
}