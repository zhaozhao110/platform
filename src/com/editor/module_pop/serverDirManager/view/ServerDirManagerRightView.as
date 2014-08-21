package com.editor.module_pop.serverDirManager.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.component.expand.UIFileManagerToolBar;
	import com.editor.component.expand.UITextInputWithLabelWithSelectFile;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.editor.module_pop.serverDirManager.itemRenderer.ServerDirManagerRightListItemRenderer;

	public class ServerDirManagerRightView extends UIVBox
	{
		public function ServerDirManagerRightView()
		{
			super();
			create_init();
		}
		
		public var toolBar:UIFileManagerToolBar;
		public var listCom:UIVlist;
		public var pathTI:UITextInputWithLabelWithSelectFile;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			width = 420;
			height = 550;
			verticalGap = 5;
			paddingLeft = 3;
			paddingRight = 3

			var lb:UILabel = new UILabel();
			lb.height = 22;
			lb.text = "本地目录"
			addChild(lb);
			
			toolBar = new UIFileManagerToolBar();
			toolBar.percentWidth = 100;
			addChild(toolBar);
			
			pathTI = new UITextInputWithLabelWithSelectFile();
			pathTI.height = 25;
			pathTI.label = "选择目录："
			pathTI.percentWidth = 100;
			pathTI.selected = false;
			addChild(pathTI);
			
			listCom = new UIVlist();
			listCom.height = 450;
			listCom.percentWidth = 100;
			listCom.itemRenderer = ServerDirManagerRightListItemRenderer;
			listCom.enabeldSelect = true;
			listCom.doubleClickEnabled = true
			listCom.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(listCom);
		}
	}
}