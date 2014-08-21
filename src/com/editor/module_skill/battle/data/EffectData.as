package com.editor.module_skill.battle.data
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.interfac.ISandyMapBase;

	public class EffectData extends MapItemData
	{
		public function EffectData()
		{
			super();
		}
		
		override public function getActionSign(tp:String,imap:ISandyMapBase):String
		{
			return EditSkillManager.currProject.effectSWFUrl + "/" + resInfoItem.id + ".swf?"+Math.random();
		}
	}
}