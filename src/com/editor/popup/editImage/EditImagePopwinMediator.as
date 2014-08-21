package com.editor.popup.editImage
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class EditImagePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "EditImagePopwinMediator"
		public function EditImagePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():EditImagePopwin
		{
			return viewComponent as EditImagePopwin;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}