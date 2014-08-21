package com.editor.module_gdps.pop.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;

	public class GdpsLeftContainer extends UICanvas
	{
		public function GdpsLeftContainer()
		{
			super();
			create_init();
		}
		
		public var searchTxt:UITextInput;
		public var searchBtn:UIButton;
		public var resetBtn:UIButton;
		public var myTree:UITree;
		
		private function create_init():void
		{
			percentHeight = 100;
			width = 202;
			visible = false;
			
			var hbox:UIHBox = new UIHBox();
			hbox.horizontalGap = 2;
			hbox.verticalAlign = "middle";
			hbox.horizontalAlign = "center";
			hbox.width = 202;
			hbox.height = 30;
			addChild(hbox);
			
			searchTxt = new UITextInput();
			searchTxt.height = 25;
			searchTxt.width = 100;
			hbox.addChild(searchTxt);
			
			searchBtn = new UIButton();
			searchBtn.label = "搜索";
			hbox.addChild(searchBtn);
			
			resetBtn = new UIButton();
			resetBtn.label = "重置";
			hbox.addChild(resetBtn);
			
			myTree = new UITree();
			myTree.y = 30;
			myTree.width = 202;
			myTree.percentHeight = 100;
			myTree.backgroundColor = 0xF8F8F8;
			myTree.labelField = "name";
			myTree.verticalScrollPolicy = "auto";
			myTree.horizontalScrollPolicy = "off";
			addChild(myTree);
				
			initComplete();
		}
	}
}