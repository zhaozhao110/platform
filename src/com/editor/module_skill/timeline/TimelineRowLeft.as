package com.editor.module_skill.timeline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.sandy.manager.data.SandyData;

	public class TimelineRowLeft extends UIHBox
	{
		public function TimelineRowLeft()
		{
			super();
		}
		
		public var txt:UILabel;
		
		public function create_init():void
		{
			styleName = "uicanvas";
			width = 100;
			height = 20;
			
			txt = new UILabel();
			txt.width = 100;
			//txt.color = 0xcc0000;
			addChild(txt);
			
		}
		
		public function reflash():void
		{
			create_init()
			txt.text = (data as SandyData).getValue();
			
		}
	}
}