package com.editor.moudule_drama.vo.drama.properties
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.TimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutDisplayObject;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.sandy.utils.StringTWLUtil;

	/**
	 * 资源属性 VO
	 * @author sun
	 * 
	 */	
	public class Drama_PropertiesBaseVO extends TimelineViewProperties_BaseVO
	{
		/**所在的关键帧**/
		public var placeFrameVO:Drama_FrameResRecordVO;
		private var _name:String;
		/**资源类型**/
		public var resType:int;
		/**是否过渡	0=false,1=true**/
		public var transition:int;
		/**鼠标点击参数**/
		public var mouseClickPara:String;
		/**锁定	0=false,1=true**/
		public var locked:int;
		public function Drama_PropertiesBaseVO()
		{
			super();
		}
		
		override public function clone():ITimelineViewProperties_BaseVO
		{
			var cloneObj:Drama_PropertiesBaseVO = new Drama_PropertiesBaseVO();
			
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

		/**资源名称**/
		public function get name():String
		{
			if(!_name || _name == "" || _name == "undefined")
			{
				var t:Drama_LayoutViewBaseVO = DramaDataManager.getInstance().getLayoutVOByPropertiesVO(this)
				if(t!=null && !StringTWLUtil.isWhitespace(t.customName)){
					_name = t.customName;
					return _name;
				}
				
				var item:AppResInfoItemVO = resItem;
				if(item)
				{
					_name = item.name;
				}
			}
			return _name;
		}
		
		/**获取资源配置**/
		public function get resItem():AppResInfoItemVO
		{
			var out:AppResInfoItemVO;
			
			var layout:DLayoutDisplayObject = DramaManager.getInstance().getLayoutViewById(targetId);
			if(layout)
			{
				var layoutVO:Drama_LayoutViewBaseVO = layout.vo as Drama_LayoutViewBaseVO;
				if(layoutVO)
				{
					out = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getCloneResInfoItemById(layoutVO.sourceId);
				}
			}
			
			return out;
		}

		/**资源名称**/
		public function set name(value:String):void
		{
			_name = value;
			var t:Drama_LayoutViewBaseVO = DramaDataManager.getInstance().getLayoutVOByPropertiesVO(this)
			if(t!=null && !StringTWLUtil.isWhitespace(t.customName)){
				_name = t.customName;
			}
		}

				
	}
}