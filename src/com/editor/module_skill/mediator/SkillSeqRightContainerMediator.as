package com.editor.module_skill.mediator
{
	import com.editor.component.LogContainer;
	import com.editor.mediator.AppMediator;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.view.right.SkillSeqRightContainer;
	
	public class SkillSeqRightContainerMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqRightContainerMediator"
		public function SkillSeqRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get rightContainer():SkillSeqRightContainer
		{
			return viewComponent as SkillSeqRightContainer;
		}
		public function get timeline():TimelineContainer
		{
			return rightContainer.timeline; 
		}
		public function get battle():BattleContainer
		{
			return rightContainer.battle;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			battle.mediator = this;
		}
		
	}
}