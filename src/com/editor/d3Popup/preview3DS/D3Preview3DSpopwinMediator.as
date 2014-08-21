package com.editor.d3Popup.preview3DS
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class D3Preview3DSpopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "D3Preview3DSpopwinMediator"
		public function D3Preview3DSpopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():D3Preview3DSpopwin
		{
			return viewComponent as D3Preview3DSpopwin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}