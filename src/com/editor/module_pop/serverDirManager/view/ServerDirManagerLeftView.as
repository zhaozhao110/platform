package com.editor.module_pop.serverDirManager.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.component.expand.UIFileManagerToolBar;
	import com.editor.module_pop.serverDirManager.itemRenderer.ServerDirManagerLeftListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ServerDirManagerLeftView extends UIVBox
	{
		public function ServerDirManagerLeftView()
		{
			super();
			create_init();
		}
		
		public var toolBar:UIFileManagerToolBar;
		public var listCom:UIVlist;
		public var pathTI:UITextInputWidthLabel;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			width = 420;
			height = 550;
			verticalGap = 5;
			
			var lb:UILabel = new UILabel();
			lb.height = 22;
			lb.text = "远程目录"
			addChild(lb);
			
			toolBar = new UIFileManagerToolBar();
			toolBar.percentWidth = 100;
			addChild(toolBar);
			
			pathTI = new UITextInputWidthLabel();
			pathTI.height = 25;
			pathTI.percentWidth = 100;
			pathTI.label = "服务器地址：";
			pathTI.editable = false;
			addChild(pathTI);
			
			listCom = new UIVlist();
			listCom.height = 450;
			listCom.percentWidth = 100;
			listCom.itemRenderer = ServerDirManagerLeftListItemRenderer;
			listCom.enabeldSelect = true;
			listCom.doubleClickEnabled = true
			listCom.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(listCom);
		}
		
	}
}