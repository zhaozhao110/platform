package com.editor.moudule_drama.timeline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineRow_BaseVO;
	
	public class TimelineRow extends UIHBox
	{
		public var vo:ITimelineRow_BaseVO;
		public function TimelineRow()
		{
			super();
		}
		
		private var txt:UILabel;
		private var tile:TimelineTile;
		
		private function create_init():void
		{
			styleName = "uicanvas";
			width = 100;
			height = 20;
			paddingLeft = 10;
			backgroundColor = 0xA6A6A6;
			buttonMode = true;
			mouseChildren = false;
			
			txt = new UILabel();
			txt.y = 2;
			txt.width = 65;
			txt.color = 0xffffff;
			addChild(txt);
			
			var lable:UILabel = new UILabel();
			lable.y = 2;
			lable.width = 45;
			lable.fontSize = 10;
			lable.color = 0x454545;
			lable.htmlText = "<u>选择</u>";
			addChild(lable);
			
			
		}
		
		public function reflash():void
		{
			create_init()
			txt.text = vo.name;
			
		}
		
		override public function select():void
		{
			txt.color = 0x454545;
			backgroundColor = 0xCCCCCC;
		}
		
		override public function noSelect():void
		{
			txt.color = 0xffffff;
			backgroundColor = 0xA6A6A6;
		}
		
		
	}
}