package com.editor.module_map.manager
{
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;

	public class MapEditorManager
	{
		public static var currProject:MapEditorProjectItemVO;
		
		
		/**2<=NPC、6<=场景动画、9<=场景背景**/
		public static function getResClassName(id:int, type:int):String
		{
			var outStr:String = "";
			if(type == 9)
			{
				outStr = "scene" + id;
			}else if(type == 6)
			{
				outStr = "sceneEffect" + id;
			}else if(type == 2)
			{
				outStr = "npc" + "Default";
			}
			
			return outStr;
		}
		
		/**2<=NPC、6<=场景动画、9<=场景背景**/
		public static function getResSubpath(type:int):String
		{
			var subpath:String = "";
			
			switch(type)
			{
				case 2:
					subpath = "npc/swf/";
					break;
				case 6:
					subpath = "map/effect/";
					break;
				case 9:
					subpath = "map/scene/";
					break;
			}
			
			return subpath;
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}