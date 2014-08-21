package com.editor.moudule_drama.vo.drama.properties
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.sandy.utils.ToolUtils;

	/**
	 * NPC属性VO
	 * @author sun
	 * 
	 */	
	public class Drama_PropertiesNpcVO extends Drama_PropertiesRoleVO
	{
		public function Drama_PropertiesNpcVO()
		{
			super();
		}
		
		override public function clone():ITimelineViewProperties_BaseVO
		{
			var cloneObj:Drama_PropertiesBaseVO = new Drama_PropertiesNpcVO();
			
			/**supers**/
			cloneObj.targetId = targetId;
			cloneObj.x = x;
			cloneObj.y = y;
			cloneObj.width = width;
			cloneObj.height = height;
			cloneObj.index = index;
			cloneObj.alpha = alpha;
			cloneObj.scaleX = scaleX;
			cloneObj.scaleY = scaleY;
			cloneObj.play = play;
			cloneObj.playParameters = playParameters;
			cloneObj.loop = loop;
			cloneObj.data = data;
			
			/**base**/
			cloneObj.name = name;
			cloneObj.resType = resType;
			cloneObj.placeFrameVO = placeFrameVO;
			cloneObj.transition = transition;
			cloneObj.mouseClickPara = mouseClickPara;
			
			/**role**/
			(cloneObj as Drama_PropertiesNpcVO).armId = armId;
			(cloneObj as Drama_PropertiesNpcVO).armName = armName;
			(cloneObj as Drama_PropertiesNpcVO).direction = direction;
			(cloneObj as Drama_PropertiesNpcVO).action = action;
			(cloneObj as Drama_PropertiesNpcVO).actionName = actionName;
			(cloneObj as Drama_PropertiesNpcVO).actionType = actionType;
			
			return cloneObj;
		}
		
		
	}
}