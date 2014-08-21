package com.editor.moudule_drama.vo.drama.properties
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;

	/**
	 * 角色属性VO
	 * @author sun
	 * 
	 */	
	public class Drama_PropertiesRoleVO extends Drama_propertiesSequenceVO
	{
		/**武器**/
		public var armId:int;
		/**武器名称**/
		public var armName:String;
		/**方向 0左 1右**/
		public var direction:int;
		/**动作**/
		public var action:String;
		/**动作名**/
		public var actionName:String;
		/**动作类型(普通\混合\技能)**/
		public var actionType:int;
		public function Drama_PropertiesRoleVO()
		{
			super();
		}
		
		override public function clone():ITimelineViewProperties_BaseVO
		{
			var cloneObj:Drama_PropertiesRoleVO = new Drama_PropertiesRoleVO();
			
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
			cloneObj.armId = armId;
			cloneObj.armName = armName;
			cloneObj.direction = direction;
			cloneObj.action = action;
			cloneObj.actionName = actionName;
			cloneObj.actionType = actionType;
			
			return cloneObj;
		}
		
	}
}