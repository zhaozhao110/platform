package com.editor.modules.pop.recentOpenProject
{
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class AppRecentOpenProjectItemRenderer extends ASListItemRenderer
	{
		public function AppRecentOpenProjectItemRenderer()
		{
			super();
			mouseEnabled = true
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			this.toolTip = File(value).nativePath;
			label = this.toolTip;
		}
		
	}
}