package com.editor.module_skill.timeline
{
	import com.sandy.asComponent.core.ASComponent;

	public class TimelineHeadBot extends ASComponent
	{
		public function TimelineHeadBot()
		{
			super();
			
		}
		
		override protected function __init__():void
		{
			super.__init__();
			
			backgroundColor = 0x808080;
			width = 2;
			height = 5;
		}
	}
}