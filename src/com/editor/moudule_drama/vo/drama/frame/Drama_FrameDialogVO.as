package com.editor.moudule_drama.vo.drama.frame
{
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotItemVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListNodeVO;

	/**
	 * 对话	关键帧
	 * 
	 */	
	public class Drama_FrameDialogVO extends Drama_FrameBaseVO
	{
		/**左右位置	0左1右**/
		public var dialogPlace:int;
		/**对话ID**/
		public var dialogId:int;
				
		public function Drama_FrameDialogVO()
		{
		}
		
		override public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:Drama_FrameDialogVO = new Drama_FrameDialogVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			/**base**/
			cloneObj.frameClipId = frameClipId;
			
			/**self**/
			cloneObj.dialogPlace = dialogPlace;
			cloneObj.dialogId = dialogId;
			
			return cloneObj;
		}
		
		override public function parseExtendXML(x:XML):void
		{
			this.dialogId = x.@did;
			this.dialogPlace = x.@dr;
						
		}
				
				
		
	}
}