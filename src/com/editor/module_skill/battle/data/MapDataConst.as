package com.editor.module_skill.battle.data
{
	import com.sandy.render2D.map.data.SandyMapConst;

	public class MapDataConst
	{
		
		public static function checkIsBattleAction(type:String):Boolean
		{
			if(type == SandyMapConst.status_daiji_type || type == SandyMapConst.status_paodong_type){
				return false
			}
			return true;
		}
		
	}
}