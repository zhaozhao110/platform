package com.editor.module_changeLog
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.module_changeLog.view.ChangeLogLeftView;
	import com.editor.module_changeLog.view.ChangeLogRightView;

	public class ChangeLogModule extends UIVBox
	{ 
		public function ChangeLogModule()
		{
			super();
			create_init();
		}
	
		public static const MODULENAME:String = "ChangeLogModule";
		
		public var leftView:ChangeLogLeftView;
		public var rightView:ChangeLogRightView;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding = 10;
			
			var hb:UIHBox = new UIHBox();
			hb.enabledPercentSize = true;
			hb.horizontalGap = 10;
			addChild(hb);
			
			leftView = new ChangeLogLeftView();
			leftView.styleName = "uicanvas";
			leftView.width = 200;
			leftView.percentHeight = 100;
			hb.addChild(leftView);
			
			rightView = new ChangeLogRightView();
			rightView.styleName = "uicanvas";
			rightView.enabledPercentSize = true;
			hb.addChild(rightView);
			
			
		}
		
		
	}
}