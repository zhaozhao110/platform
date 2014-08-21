package com.editor.moudule_drama.mediator.right.timePanel
{
	import com.editor.mediator.AppMediator;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.timeline.TimelineContainer;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelinePostFrameVO;
	import com.editor.moudule_drama.view.right.timePanel.DrameTimelinePanel;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class DramaTimelinePanelMediator extends AppMediator
	{	
		public static const NAME:String = "DramaTimelinePanelMediator";
		
		public function DramaTimelinePanelMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DrameTimelinePanel
		{
			return viewComponent as DrameTimelinePanel;
		}
		public function get timeline():TimelineContainer
		{
			return mainUI.timeline;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			timeline.updataData(DramaDataManager.row_ls, DramaDataManager.getInstance().getKeyframeListArray());
			timeline.selectedOneFrame_func = onSelectedOneFrame;
			timeline.selectedOneRow_func = onSelectedOneRow;
			timeline.changeOneKeyFrame_func = onChangeOneKeyFrame;
			timeline.deleteOneKeyFrame_func = onDeleteOneKeyFrame;
			
		}
		
		/**时间轴选择了一帧	触发函数**/
		private function onSelectedOneFrame(vo:ITimelinePostFrameVO):void
		{
			var id:String = vo.id;
			var rowId:String = vo.rowId;
			var frame:int = vo.frame;
						
			sendNotification(DramaEvent.drama_selectOneFrame_event, {id:id, rowId:rowId, frame:frame});
			
		}
				
		/**时间轴选择了一层	触发函数**/
		private function onSelectedOneRow():void
		{
			var rowId:String = timeline.currentSelected_RowId;
			var frame:int = timeline.currentSelected_Frame;
			
			sendNotification(DramaEvent.drama_selectOneRow_event, {rowId:rowId, frame:frame});
		}
		
		/**时间轴改变了一帧	触发函数**/
		private function onChangeOneKeyFrame(vo:ITimelinePostFrameVO):void
		{
			if(!vo) return;
			
			var getVO:ITimelineKeyframe_BaseVO = DramaDataManager.getInstance().getKeyFrame(vo.id);
			if(getVO)
			{
//				trace("change:" + getVO.rowId + "_" + vo.rowId + ":::" + getVO.frame + "_" + vo.frame)
				getVO.rowId = vo.rowId;
				getVO.frame = vo.frame;
			}
		}
		
		/**时间轴删除了一帧	触发函数**/
		private function onDeleteOneKeyFrame(vo:ITimelinePostFrameVO):void
		{
			if(!vo) return;
			
			var getVO:ITimelineKeyframe_BaseVO = DramaDataManager.getInstance().getKeyFrame(vo.id);
//			trace("delete:" + getVO.rowId + "_" + getVO.frame)
			
			DramaDataManager.getInstance().removeKeyframe(vo.id);
		}
		
		/**更新时间轴事件**/
		public function respondToDramaUpdataTimelineEvent(noti:Notification):void
		{
			timeline.updataKeyframes(DramaDataManager.getInstance().getKeyframeListArray());
		}
		
		/**插入一个关键帧事件**/
		public function respondToDramaInsertKeyframeEvent(noti:Notification):void
		{
			var data:Object = noti.getBody();
			if(data)
			{
				var vo:ITimelineKeyframe_BaseVO = data.vo as ITimelineKeyframe_BaseVO;
				if(vo)
				{
					timeline.addKeyframe(vo);
				}
			}
			
		}
		/**删除一个关键帧事件**/
		public function respondToDramaRemoveKeyframeEvent(noti:Notification):void
		{
			var data:Object = noti.getBody();
			if(data)
			{
				var vo:ITimelineKeyframe_BaseVO = data.vo as ITimelineKeyframe_BaseVO;
				if(vo)
				{
					timeline.removeKeyframe(vo);
				}
			}
		}
		
		/**选择了一个显示对象事件**/
		public function respondToDramaSelectedViewEvent(noti:Notification):void
		{
			var data:Object = noti.getBody();
			if(data)
			{
				var lvo:Drama_LayoutViewBaseVO;
				if(data.vo && data.vo is Drama_LayoutViewBaseVO)
				{
					lvo = data.vo as Drama_LayoutViewBaseVO;
					if(lvo)
					{
						timeline.setSelectRow(lvo.rowId);
					}
				}
			}
		}
		
		
		
	}
}