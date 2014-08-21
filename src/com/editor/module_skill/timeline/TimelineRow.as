package com.editor.module_skill.timeline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.manager.data.SandyData;

	public class TimelineRow extends UIHBox
	{
		public function TimelineRow()
		{
			super();
			//create_init()
		}
		
		public var leftRow:TimelineRowLeft;
		private var tile:TimelineTile;
		public var frame_ls:Array = [];
		
		private function create_init():void
		{
			name = "TimelineRow"
			styleName = "uicanvas";
			width = EditSkillManager.timeline_w;
			height = 20;
			
			tile = new TimelineTile();
			tile.data = data;
			tile.row = this
			addChild(tile);
			tile.create_init();
			
			TimelineContainer.instance.row_ls[(data as SandyData).getKey()] = this;
		}
		
		public function reflash():void
		{
			create_init()
		}
		
		public function getTimeRect(frame:int):TimelineRect
		{
			return frame_ls[frame.toString()] as TimelineRect
		}
		
		override public function select():void
		{
			leftRow.txt.color = 0xcc0000;
		}
		
		override public function noSelect():void
		{
			leftRow.txt.color = 0x000000;
		}
		
		override public function reset():void
		{
			for each(var rect:TimelineRect in frame_ls){
				if(rect!=null){
					rect.reset();
				}
			}
			noSelect()
		}
	}
}