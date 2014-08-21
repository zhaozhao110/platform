package com.editor.moudule_drama.popup.preview.manager
{
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;

	public class DramaPreviewDataManager
	{
		public function DramaPreviewDataManager()
		{
		}
		
		private static var instance:DramaPreviewDataManager;
		public static function getInstance():DramaPreviewDataManager
		{
			if(!instance)
			{
				instance = new DramaPreviewDataManager();
			}
			return instance;
		}
		
		
		/**预览	获得往后帧的相同显示对象的属性VO**/
		public function getSpriteProperties_InAfterFrame(vo:Drama_PropertiesBaseVO, lastFrame:int=0):Drama_PropertiesBaseVO
		{
			var outVO:Drama_PropertiesBaseVO;
			
			var placeFrameVO:Drama_FrameResRecordVO = vo.placeFrameVO as Drama_FrameResRecordVO;
			if(placeFrameVO)
			{
				var checkVO:Drama_FrameResRecordVO = getAfterKeyframe(placeFrameVO.rowId, placeFrameVO.frame, lastFrame) as Drama_FrameResRecordVO;
				if(checkVO != null)
				{					
					outVO = checkVO.getPropertyVO(vo.targetId);
					
				}
			}			
			
			return outVO;
		}
		
		/**预览	获取后一帧**/
		public function getAfterKeyframe(curRowId:String, curFrame:int, lastFrame:int=0):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;
			
			if(curRowId != "" && curFrame)
			{
				for(var i:int=curFrame+1;i<=lastFrame;i++)
				{
					var getVo:ITimelineKeyframe_BaseVO = getKeyframeByPlace(curRowId, i);
					if(getVo)
					{
						outVO = getVo;
						break;
					}
				}
			}
			return outVO;
		}
		
		/**关键帧列表	rowId:层ID, frame:帧数**/
		public function getKeyframeByPlace(rowId:String, frame:int):ITimelineKeyframe_BaseVO
		{
			var a:Array = DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.keyframeList;
			
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!a) return outVO;
			
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var vo:ITimelineKeyframe_BaseVO = a[i] as ITimelineKeyframe_BaseVO;
				if(vo.rowId == rowId)
				{
					if(vo.frame == frame)
					{
						outVO = vo;
						break;
					}
				}
			}
			
			return outVO;
			
		}
		
		
	}
}