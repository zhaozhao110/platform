package com.editor.module_skill.battle.data
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.vo.EditSkillConfigVO;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.interfac.ISandyMapBase;

	public class PlayerRoleData extends MapItemData
	{
		public function PlayerRoleData()
		{
			super();
		}
		
		override public function getActionSign(tp:String,imap:ISandyMapBase):String
		{
			return EditSkillManager.currProject.userSWFUrl + "/swf/" +  resInfoItem.id + ".swf"
		}
		
	}
}