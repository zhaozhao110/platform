package com.editor.moudule_drama.popup.preview.component
{
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	
	import flash.events.Event;

	public class DramaPreview_Container extends DramaPreview_DisplayObject
	{
		/**关键帧列表**/
		private var _keyframeList:Array = [];
		private var _lastFrame:int;
		/**当前帧**/
		private var _curFrame:int;
		public function DramaPreview_Container()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			
		}
		
		public function run():void
		{
			DramaManager.getInstance().get_DramaPreviewPopupwinMediator().buttonContainer.visible = false;
			_curFrame = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
				
		public function stop():void
		{
			_curFrame = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
		
		override public function pause():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
		
		public function dePause():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
		
		
		private function onEnterFrameHandle(e:Event):void
		{
			if(_curFrame >= _lastFrame)
			{
				stop();
				DramaManager.getInstance().get_DramaPreviewPopupwinMediator().buttonContainer.visible = true;
				return;
			}
			
			_curFrame ++;
			DramaManager.getInstance().get_DramaPreviewPopupwinMediator().frameTxt.text = "当前帧：" + _curFrame;
			
			var curKeyVOList:Array = getKeyframes_ByCurFrame(_curFrame);
			var len:int = curKeyVOList.length;
			for(var i:int=0;i<len;i++)
			{
				var keyfVO:ITimelineKeyframe_BaseVO = curKeyVOList[i] as ITimelineKeyframe_BaseVO;
				if(keyfVO)
				{
					var layer:DramaPreview_RowLayer = getRowLayerById(keyfVO.rowId);
					if(layer)
					{
						layer.processKeyFrameVO(keyfVO);
					}
				}
			}
			
		}
		/**当前层所有关键帧**/
		public function getKeyframes_ByRowId(rowId:String):Array
		{
			var outA:Array = [];
			
			var len:int = keyframeList.length;
			for(var i:int=0;i<len;i++)
			{
				var fvo:ITimelineKeyframe_BaseVO = keyframeList[i] as ITimelineKeyframe_BaseVO;
				if(fvo && fvo.rowId == rowId)
				{
					outA.push(fvo);
				}
			}
			outA.sortOn("frame", Array.NUMERIC);
			
			return outA;
		}
		/**当前时间所有关键帧**/
		private function getKeyframes_ByCurFrame(frame:int):Array
		{
			var outA:Array = [];
			
			var len:int = keyframeList.length;
			for(var i:int=0;i<len;i++)
			{
				var fvo:ITimelineKeyframe_BaseVO = keyframeList[i] as ITimelineKeyframe_BaseVO;
				if(fvo && fvo.frame == frame)
				{
					outA.push(fvo);
				}
			}
			
			return outA;
			
		}
		
		/**通过ID获取层**/
		public function getRowLayerById(id:String):DramaPreview_RowLayer
		{
			var outLayer:DramaPreview_RowLayer;
			
			var len:int = numChildren;
			for(var i:int=0;i<len;i++)
			{
				var curLayer:DramaPreview_RowLayer = getChildAt(i) as DramaPreview_RowLayer;
				if(curLayer)
				{
					var curLayerVO:Drama_RowVO = curLayer.vo as Drama_RowVO;
					if(curLayerVO && curLayerVO.id == id)
					{
						outLayer = curLayer;
					}
				}
			}
			
			return outLayer;
			
		}

		/**关键帧列表**/
		public function get keyframeList():Array
		{
			return _keyframeList;
		}
		/**关键帧列表**/
		public function set keyframeList(value:Array):void
		{
			_keyframeList = value;
			_keyframeList.sortOn("frame", Array.NUMERIC);
			var lastFrameVO:ITimelineKeyframe_BaseVO = _keyframeList[_keyframeList.length-1] as ITimelineKeyframe_BaseVO;
			if(lastFrameVO)
			{
				_lastFrame = lastFrameVO.frame + 1;
			}
			
		}
		/**最后一帧**/
		public function get lastFrame():int
		{
			return _lastFrame;
		}

		
	}
}