package com.editor.module_roleEdit{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_roleEdit.view.PeopleImageContent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class PeopleImageModule extends UICanvas
	{
		public function PeopleImageModule()
		{
			super()
			create_init()
		}

		public static const MODULENAME:String = "roleEdit"
		
		public var popContent:PeopleImageContent;

		//程序生成
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			
			popContent = new PeopleImageContent();
			popContent.id="popContent"
			popContent.enabledPercentSize = true;
			this.addChild(popContent);
			
			//dispatchEvent creationComplete
			initComplete();
		}

		
	}
}