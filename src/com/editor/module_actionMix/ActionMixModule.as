package com.editor.module_actionMix
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_actionMix.view.ActionMixContent;

	public class ActionMixModule extends UICanvas
	{
		public function ActionMixModule()
		{
			super();
			create_init();
		}
		
		public static const MODULENAME:String = "actionMix"
		
		public var content:ActionMixContent;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			
			content = new ActionMixContent();
			addChild(content);
		}
		
	}
}