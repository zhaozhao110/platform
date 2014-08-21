package com.editor.module_pop.serverDirManager.mediator
{
	import com.editor.component.containers.UIVBox;
	import com.editor.module_pop.serverDirManager.itemRenderer.ServerDirManagerBottomRenderer;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerBottomView;
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class ServerDirManagerBottomViewMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ServerDirManagerBottomViewMediator"
		public function ServerDirManagerBottomViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bottomView():ServerDirManagerBottomView
		{
			return viewComponent as ServerDirManagerBottomView
		}
		public function get vbox():UIVBox
		{
			return bottomView.vbox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function createLog(nm:String):void
		{
			var cell:ServerDirManagerBottomRenderer = new ServerDirManagerBottomRenderer();
			vbox.addChild(cell);
			cell.reflash(nm);
		}
	}
}