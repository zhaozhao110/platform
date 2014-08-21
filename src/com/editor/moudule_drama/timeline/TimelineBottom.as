package com.editor.moudule_drama.timeline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.sandy.utils.ColorUtils;

	public class TimelineBottom extends UIHBox
	{
		public function TimelineBottom()
		{
			super();
			create_init();
		}
		
		private var txt:UILabel;
		private var txt2:UILabel;
		
		private function create_init():void
		{
			paddingLeft = 100;
			height = 20;
			percentWidth =100;
			
			txt = new UILabel();
			txt.width = 320;
			addChild(txt);
			
			txt2 = new UILabel();
			txt2.width = 320;
			txt2.color = ColorUtils.blue;
			addChild(txt2);
			
		}
		
		public function setInfo(s:String):void
		{
			txt.text = s;
		}
		
		
	}
}