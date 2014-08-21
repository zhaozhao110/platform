package com.editor.module_skill.view.right
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.timeline.TimelineContainer;
	
	public class SkillSeqRightContainer extends UICanvas
	{
		public function SkillSeqRightContainer()
		{
			super();
			instance = this;
			create_init();
		}
		
		public static var instance:SkillSeqRightContainer;
		
		public var timeline:TimelineContainer
		public var battle:BattleContainer;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			
			battle = new BattleContainer();
			addChild(battle);
			
			timeline = new TimelineContainer();
			addChild(timeline);
		}
		
		override public function validateDisplayList_update():void
		{
			super.validateDisplayList_update();
			if(battle!=null){
				battle.width = width;
				battle.height = height;
			}
		}
	}
}