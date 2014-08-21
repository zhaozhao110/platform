package com.editor.module_skill.battle.data
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.interfac.ISandyMapBase;

	public class MonsterData extends MapItemData
	{
		public function MonsterData()
		{
		}
		
		
		
		override public function getActionSign(tp:String,imap:ISandyMapBase):String
		{
			return EditSkillManager.currProject.monsterSWFUrl + "/" + resInfoItem.id + ".swf"
		}
		
	}
}