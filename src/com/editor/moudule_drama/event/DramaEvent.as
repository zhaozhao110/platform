package com.editor.moudule_drama.event
{
	public class DramaEvent
	{
		/** <<**/
		
		/**更新时间轴事件**/
		public static const drama_updataTimeline_event:String = "dramaUpdataTimelineEvent";
		
		/**选择一个帧事件 body:{id:关键帧ID, rowId:层id, frame:帧数} **/
		public static const drama_selectOneFrame_event:String = "dramaSelectOneFrameEvent";
		/**插入一个关键帧事件 body:{vo:关键帧VO}**/
		public static const drama_insertKeyframe_event:String = "dramaInsertKeyframeEvent";		
		/**删除一个关键帧事件 body:{vo:关键帧VO}**/
		public static const drama_removeKeyframe_event:String = "dramaRemoveKeyframeEvent";
		
		/** <<**/
		
		/**选择一个层事件 body:{rowId:层id, frame:帧数} **/
		public static const drama_selectOneRow_event:String = "dramaSelectOneRowEvent";
		
		/** <<**/
		
		/**新添加一个布局显示对象在关键帧上事件  body{keyframeVO:关键帧VO}**/
		public static const drama_addNewLayoutViewToKeyFrame_event:String = "dramaAddNewLayoutViewToKeyFrameEvent";
		/**选择了一个显示对象事件 body{target:显示对象自身, vo:显示对象vo}**/
		public static const drama_selectedView_event:String = "dramaSelectedViewEvent";
		/**编辑显示对象属性事件 body{vo:显示对象VO}**/
		public static const drama_editViewProperties_event:String = "dramaEditViewPropertiesEvent";
		/**布局显示对象属性改变事件 body{vo:显示对象属性VO}**/
		public static const drama_viewPropertiesChange_event:String = "dramaViewPropertiesChangeEvent";
		/**更新布局显示对象事件**/
		public static const drama_updataLayoutViewList_event:String = "dramaUpdataLayoutViewListEvent";
		
	}
}