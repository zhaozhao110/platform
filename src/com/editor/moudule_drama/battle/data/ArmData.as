package com.editor.moudule_drama.battle.data
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.editor.module_skill.battle.data.MapItemData;

	public class ArmData extends MapItemData
	{
		public function ArmData()
		{
			super();
		}
		
		override public function getActionSign(tp:String,imap:ISandyMap2):String
		{
			return EditSkillManager.currProject.userSWFUrl + "/arm/swf/" + resInfoItem.id + ".swf"
		}
		
		
	}
}