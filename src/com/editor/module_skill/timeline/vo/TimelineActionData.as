package com.editor.module_skill.timeline.vo
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.preview.PreviewBattle;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.timeline.TimelineRect;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.utils.StringTWLUtil;

	public class TimelineActionData extends TimelineDataBase
	{
		public function TimelineActionData()
		{
			isKey = true;
		}
		
		//动作
		public var action:String;
		//动作的总帧数
		public var totalFrame:int;
		
		public function checkIsMixAction():Boolean
		{
			return StringTWLUtil.isNumber(action);
		}
		
		override public function getData():String
		{
			return action;
		}
		
		override public function getLabel():String
		{
			return "动作: " + SandyMapConst.getActionTypeStr(action) + "/" + action + "/总帧数: " + totalFrame;
		}
		
		override public function play():void
		{
			getPlayer().actionType = action;
			
		}
		
		override public function preview():void
		{
			getEditPlayer().actionType = action;
		}
		
		public static function reset():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			var player:RoleBase;
			if(row == EditSkillManager.row2){
				if(BattleContainer.instace.battleItemContainer.attackPlayer!=null){
					player = BattleContainer.instace.battleItemContainer.attackPlayer;
				}
			}else if(row == EditSkillManager.row5){
				if(BattleContainer.instace.battleItemContainer.defendPlayer!=null){
					player = BattleContainer.instace.battleItemContainer.defendPlayer;
				}
			}
			if(player!=null){
				player.actionType = SandyMapConst.status_attackDaiji_type;
			}
		}
			
		override public function save():*
		{
			return frame+"$"+action;
		}
	
		override public function parser(v:String):void
		{
			action = v;
		}
	}
}