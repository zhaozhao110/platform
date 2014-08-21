package com.editor.module_ui.view.projectDirectory
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITreeVList;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_ui.view.projectDirectory.component.ProjectDirectListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ProjectDirectList extends UIVBox
	{
		public function ProjectDirectList()
		{
			super();
			create_init()
		}
		
		public var toolBar:UIHBox;
		public var projectPath_ti:UITextInput;
		public var selectBtn:UIButton;
		public var file_box:UIVlist;
		public var syncedBtn:UIImage;
		public var module_cb:UICombobox;
		public var tree:UITreeVList;
		public var viewCan:UICanvas;
		public var modeBtn:UIAssetsSymbol;
		public var helpBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			paddingLeft = 2
			paddingRight = 2;
			verticalGap = 2;
			enabledPercentSize = true;
			styleName = "uicanvas";
			
			toolBar = new UIHBox();
			toolBar.styleName = "uicanvas"
			toolBar.verticalAlignMiddle = true;
			toolBar.percentWidth = 100;
			toolBar.height = 30;
			addChild(toolBar);
			
			projectPath_ti = new UITextInput();
			projectPath_ti.name = "projectPath_ti"
			projectPath_ti.editable = false;
			projectPath_ti.width = 230;
			projectPath_ti.height = 23;
			toolBar.addChild(projectPath_ti);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择项目";
			//selectBtn.visible = false
			toolBar.addChild(selectBtn);
			
			var bar:UIHBox = new UIHBox();
			bar.verticalAlignMiddle = true;
			bar.percentWidth = 100;
			bar.horizontalGap = 5;
			bar.height = 25;
			bar.paddingLeft = 10;
			addChild(bar);
			
			var lb:UILabel = new UILabel();
			lb.text = "跳转:"
			bar.addChild(lb);
			
			module_cb = new UICombobox();
			module_cb.width = 180;
			module_cb.height = 23;
			module_cb.dropDownWidth = 400;
			module_cb.dropDownHeight = 400
			bar.addChild(module_cb);
			
			syncedBtn = new UIImage();
			syncedBtn.buttonMode = true;
			syncedBtn.source = "synced_a"
			syncedBtn.toolTip = "与编辑器连接"
			bar.addChild(syncedBtn);
			
			modeBtn = new UIAssetsSymbol();
			modeBtn.buttonMode = true
			modeBtn.source = "web_ref_a"
			modeBtn.toolTip = "切换模式"
			bar.addChild(modeBtn);
			
			helpBtn = new UIAssetsSymbol();
			helpBtn.buttonMode = true
			helpBtn.source = "help2_a"
			helpBtn.toolTip = "打开帮助窗口"
			bar.addChild(helpBtn);
			
			viewCan = new UICanvas();
			viewCan.enabledPercentSize = true;
			addChild(viewCan);
						
			file_box = new UIVlist();
			//file_box.background_red = true;
			file_box.enabeldSelect = true;
			file_box.doubleClickEnabled = true; 
			file_box.rightClickEnabled = true
			file_box.itemRenderer = ProjectDirectListItemRenderer;
			file_box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			file_box.enabledPercentSize = true;
			viewCan.addChild(file_box);
			file_box.visible = true;
			
			tree = new UITreeVList();
			tree.doubleClickEnabled = true;
			tree.enabledPercentSize = true;
			tree.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			viewCan.addChild(tree);
			tree.visible = false;
		}
		
	}
}