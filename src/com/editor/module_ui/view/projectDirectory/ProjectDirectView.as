package com.editor.module_ui.view.projectDirectory
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UITreeVList;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.component.controls.UIVlist;
	import com.sandy.asComponent.vo.ASComponentConst;

	/**
	 * 目前只支持一次编辑一个项目，类似于fdt
	 */ 
	public class ProjectDirectView extends UIVBox
	{
		public function ProjectDirectView()
		{
			super();
			create_init();
		}
		
		
		//list列表模式
		public var listModeBox:ProjectDirectList;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			mouseEnabled = true;
			mouseChildren = true
			
			listModeBox = new ProjectDirectList();
			addChild(listModeBox);
			
		}
		
	}
}