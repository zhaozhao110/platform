package com.editor.moudule_drama.battle.data
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.editor.module_skill.battle.data.MapItemData;

	public class EffectData extends MapItemData
	{
		public function EffectData()
		{
			super();
		}
		
		override public function getActionSign(tp:String,imap:ISandyMap2):String
		{
			return EditSkillManager.currProject.effectSWFUrl + "/" + resInfoItem.id + ".swf?"+Math.random();
		}
	}
}