package com.editor.moudule_drama.battle.data
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.vo.EditSkillConfigVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.sandy.render2D.map2.interfac.ISandyMap2;

	public class PlayerRoleData extends MapItemData
	{
		public function PlayerRoleData()
		{
			super();
		}
		
		override public function getActionSign(tp:String,imap:ISandyMap2):String
		{
			return EditSkillManager.currProject.userSWFUrl + "/swf/" +  resInfoItem.id + ".swf"
		}
		
	}
}