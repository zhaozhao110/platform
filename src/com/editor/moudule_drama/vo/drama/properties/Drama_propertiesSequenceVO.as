package com.editor.moudule_drama.vo.drama.properties
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;

	/**
	 * 序列图属性VO
	 * @author sun
	 * 
	 */	
	public class Drama_propertiesSequenceVO extends Drama_PropertiesBaseVO
	{
		public function Drama_propertiesSequenceVO()
		{
			super();
		}
		
		override public function clone():ITimelineViewProperties_BaseVO
		{
			var cloneObj:Drama_propertiesSequenceVO = new Drama_propertiesSequenceVO();
			
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
						
			return cloneObj;
		}
		
	}
}