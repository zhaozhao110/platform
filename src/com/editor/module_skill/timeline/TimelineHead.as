package com.editor.module_skill.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_skill.manager.EditSkillManager;

	public class TimelineHead extends UICanvas
	{
		public function TimelineHead()
		{
			super();
			create_init()
		}
		
		public var num_hb:UIHBox;
		
		private function create_init():void
		{
			name = "TimelineHead"
			this.height = 20;
			this.width = EditSkillManager.timeline_w
			
			for(var i:int=1;i<=EditSkillManager.total_frames;i++)
			{
				if( i%5 == 0 || i == 1){
					var txt:UILabel = new UILabel();
					txt.text = i.toString();
					txt.x = (i-1)*TimelineRect.rectWidth + 0;
					addChild(txt);
				}
				if( i%5 == 0 || i == 1){
					var bot:TimelineHeadBot = new TimelineHeadBot();
					bot.x = (i-1)*TimelineRect.rectWidth + 0 + TimelineRect.rectWidth/2;
					bot.y = this.height - 4
					addChild(bot);
				}
			}
		}
		
		
	}
}