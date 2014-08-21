package com.editor.module_skill.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UITile;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.asComponent.core.ASSprite;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class TimelineTile extends ASSprite
	{
		public function TimelineTile()
		{
			super();
			//create_init()
		}
		
		public var row:TimelineRow;
		
		public function create_init():void
		{
			width = EditSkillManager.timeline_w;
			height = 20
			name = "TimelineTile";
			
			time_u = setInterval(createTile,1000)
		}
		
		private var add_i:int;
		private var time_u:uint;
		
		private function createTile():void
		{
			if(add_i >= (EditSkillManager.total_frames-20)){
				clearInterval(time_u);
				return ;
			}
			for(var i:int=0;i<EditSkillManager.total_frames/6;i++)
			{
				var rect:TimelineRect = new TimelineRect();
				rect.data = data;
				rect.row = row;
				rect.listIndex = i+add_i;
				addChild(rect);
				rect.create_init();
				rect.x = (i+add_i)*TimelineRect.rectWidth;
			}
			add_i += i;
		}
		
	}	
}