package com.editor.moudule_drama.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.manager.DataManager;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.moudule_drama.timeline.data.TimelineConst;
	import com.editor.moudule_drama.timeline.event.TimelineEvent;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.TimelinePostFrameVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineRow_BaseVO;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
		
	public class TimelineContainer extends UIVBox
	{
		/**层列表**/
		private var row_ls:Array = [];
		/**关键帧列表（所有关键帧）**/
		private var keyframe_ls:Array = [];
		
		/**当前选中帧  <  帧数**/
		public var currentSelected_Frame:int;
		/**当前选中帧  <  层id**/
		public var currentSelected_RowId:String;
		/**时间轴最后一帧**/
		public var lastFrame:int;
		
		/**默认204帧的长度**/
		private var _minTileWidth:int = 204*TimelineConst.FRAME_WIDTH;
		
		/** << functions**/
		
		/**选中一帧  <  函数**/
		public var selectedOneFrame_func:Function;
		/**选中一层  <  函数**/
		public var selectedOneRow_func:Function;
		/**改变了一个帧 <  函数**/
		public var changeOneKeyFrame_func:Function;
		/**删除了一个帧 <  函数**/
		public var deleteOneKeyFrame_func:Function;
		
		
		public function TimelineContainer()
		{
			super();
			create_init();
		}
		
		public var head:TimelineHead;
		public var middleC:UIHBox;
		public var rowsC:UIVBox;
		public var timelineTile:TimelineTile;
		public var bottomC:TimelineBottom;
		private function create_init():void
		{
			name = "TimelineContainer"
			styleName = "uicanvas";
			paddingBottom = 20;
			backgroundColor = DataManager.def_col;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			
			/**刻度**/
			var headC:UICanvas = new UICanvas;
			addChild(headC);
			head = new TimelineHead();
			headC.addChild(head);
			
			/**中间容器**/
			middleC = new UIHBox();
			addChild(middleC);
			
			/**左侧层容器**/
			rowsC = new UIVBox();
			rowsC.width = 100;
			middleC.addChild(rowsC);
			
			/**右侧时间轴格子容器**/
			timelineTile = new TimelineTile();
			timelineTile.width = _minTileWidth;
			middleC.addChild(timelineTile);
			middleC.width = _minTileWidth;
			timelineTile.addEventListener(TimelineEvent.SELECTED_ONE_FRAME, selectOneFrameHandle);
			timelineTile.addEventListener(TimelineEvent.CHANGE_ONE_FRAME, changeOneFrameHandle);
			timelineTile.addEventListener(TimelineEvent.DELETE_ONE_FRAME, deleteOneFrameHandle);
			
			/**间隔**/
			var sp1:ASSpace = new ASSpace();
			sp1.height = 5;
			addChild(sp1);
			
			/**底部**/
			bottomC = new TimelineBottom();
			addChild(bottomC);
			bottomC.setInfo("当前帧：");
			
		}
		
		/**
		 * 更新时间轴数据
		 * @param rowData 层数据 : 
		 * @param keyframeData 关键帧数据 :
		 * 
		 */		
		public function updataData(rowData:Array, keyframeData:Array):void
		{
			row_ls = rowData;
			renderRows();
			
			keyframe_ls = keyframeData;
			renderKeyframes();
		}
		/**
		 * 更新关键帧数据
		 * @param keyframeData 关键帧数据
		 * 
		 */		
		public function updataKeyframes(keyframeData:Array):void
		{
			keyframe_ls = keyframeData;
			renderKeyframes();
		}
		
		/**
		 * 设置当前选中的层
		 * @param rowId 层ID
		 * 
		 */		
		public function setSelectRow(rowId:String):void
		{
			currentSelected_RowId = rowId;
			var row:int = getRowIndexById(rowId) + 1;
			selectRow(row);
			
			if(currentSelected_Frame > 0)
			{
				timelineTile.moveCheckShapeByPlace(row, currentSelected_Frame);
			}
		}
		
		/**
		 * 添加关键帧	或重置关键帧
		 * @param vo:ITimelineKeyframeVO
		 * 
		 */		
		public function addKeyframe(vo:ITimelineKeyframe_BaseVO,needReflash:Boolean=true):void
		{
			var tRect:TimelineRect;
			if(timelineTile.getKeyframe(vo))
			{
				tRect = timelineTile.getKeyframe(vo);
				
			}else
			{
				keyframe_ls.push(vo);
				tRect = new TimelineRect();				
				tRect.parentTimelineTile = timelineTile;
				timelineTile.addKeyframe(tRect);				
			}
			
			tRect.id = vo.id;
			tRect.type = vo.type;
			tRect.frame = vo.frame;
			tRect.rowId = vo.rowId;
			tRect.x = (vo.frame-1)*TimelineConst.FRAME_WIDTH;
			tRect.y = getRowIndexById(vo.rowId)*TimelineConst.FRAME_HEIGHT;
			
			tRect.create_init();
			
			updataTileWidth();
			
			//if(needReflash) laterMeasuredMaxSize();
		}
		
		/**
		 * 删除关键帧
		 * @param vo:ITimelineKeyframeVO
		 * 
		 */		
		public function removeKeyframe(vo:ITimelineKeyframe_BaseVO):void
		{
			var len:int = keyframe_ls.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var iVo:ITimelineKeyframe_BaseVO = keyframe_ls[i] as ITimelineKeyframe_BaseVO;
				if(iVo && iVo.rowId == vo.rowId && iVo.frame == vo.frame)
				{
					keyframe_ls.splice(i,1);
					break;
				}
			}
			
			timelineTile.removeKeyframe(vo);
			
			updataTileWidth();
		}
		
		
		/**渲染层**/
		private function renderRows():void
		{
			clearRows();
			row_ls.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			var len:int = row_ls.length;
			for(var i:int=0;i<len;i++)
			{
				var vo:ITimelineRow_BaseVO = row_ls[i] as ITimelineRow_BaseVO;
				createRow(vo);
			}
						
			timelineTile.height = len*TimelineConst.FRAME_HEIGHT;
			timelineTile.create_init();
			
			head.x = rowsC.width;
			head.width = timelineTile.width;
			head.create_init();
		}
		
		/**渲染关键帧**/
		private function renderKeyframes():void
		{
			clearKeyframes();
			updataTileWidth();
			
			var len:int = keyframe_ls.length;
			for(var i:int=0;i<len;i++)
			{
				var keyVO:ITimelineKeyframe_BaseVO = keyframe_ls[i] as ITimelineKeyframe_BaseVO;
				if(keyVO)
				{
					addKeyframe(keyVO,false);
				}
			}
			
			//laterMeasuredMaxSize()
		}
		
		/**清除关键帧**/
		private function clearKeyframes():void
		{
			timelineTile.clearKeyframes();
		}
		/**更新时间轴宽度**/
		private function updataTileWidth():void
		{
			var lastFrameIndex:int;
			var len:int = keyframe_ls.length;
			for(var i:int=0;i<len;i++)
			{
				var keyVO:ITimelineKeyframe_BaseVO = keyframe_ls[i] as ITimelineKeyframe_BaseVO;
				if(keyVO.frame > lastFrameIndex)
				{
					lastFrameIndex = keyVO.frame;
				}
			}
			lastFrameIndex = lastFrameIndex + 100;
			
			var modNum:int = lastFrameIndex%5;
			if(modNum == 0)
			{
				lastFrameIndex = lastFrameIndex + 4;
				
			}else
			{
				lastFrameIndex = lastFrameIndex-modNum+4;
			}
			
			var needW:int = lastFrameIndex*TimelineConst.FRAME_WIDTH;
			if(needW > _minTileWidth)
			{
				timelineTile.width = needW;
				timelineTile.create_init();
				middleC.width = needW;
				head.width = timelineTile.width;
				head.create_init();
				
				lastFrame = lastFrameIndex;
			}
			
		}
		
		/**选中一帧事件**/
		private function selectOneFrameHandle(e:TimelineEvent):void
		{
			var obj:Object = e.data as Object;
			if(obj)
			{
				var id:String = String(obj.id);
				var row:int = obj.row;
				currentSelected_Frame = obj.col;
				
				var rowVO:ITimelineRow_BaseVO = selectRow(row);
				if(rowVO)
				{
					currentSelected_RowId = rowVO.id;
					bottomC.setInfo("当前帧：" + currentSelected_Frame + "    \    " + "当前层：" + rowVO.name);
					
					if(selectedOneFrame_func!=null)
					{
						var postVO:TimelinePostFrameVO = new TimelinePostFrameVO(id, currentSelected_RowId, currentSelected_Frame);
						selectedOneFrame_func(postVO);
					}
				}
			}
		}
		/**改变一帧事件**/
		private function changeOneFrameHandle(e:TimelineEvent):void
		{
			var obj:Object = e.data as Object;
			if(obj)
			{
				var id:String = String(obj.id);
				var row:int = obj.row;
				var col:int = obj.col;
				var rect:TimelineRect = obj.rect;
								
				var rowVO:ITimelineRow_BaseVO = selectRow(row);
				if(rowVO)
				{
					if(changeOneKeyFrame_func!=null)
					{
						if(rect)
						{
							rect.rowId = rowVO.id;
							rect.frame = col;
						}
						var postVO:TimelinePostFrameVO = new TimelinePostFrameVO(id, rowVO.id, col);
						changeOneKeyFrame_func(postVO);
					}
				}
			}			
		}
		/**删除一帧事件**/
		private function deleteOneFrameHandle(e:TimelineEvent):void
		{
			var obj:Object = e.data as Object;
			if(obj)
			{
				var id:String = String(obj.id);
				if(deleteOneKeyFrame_func!=null)
				{
					var postVO:TimelinePostFrameVO = new TimelinePostFrameVO(id);
					deleteOneKeyFrame_func(postVO);
				}
				
			}
		}
		
		/**选中层	层index 从1开始**/
		private function selectRow(rowIndex:int):ITimelineRow_BaseVO
		{
			var outData:ITimelineRow_BaseVO;
			row_ls.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			var sData:ITimelineRow_BaseVO = row_ls[rowIndex-1] as ITimelineRow_BaseVO;
			if(sData)
			{
				var len:int = rowsC.numChildren;
				for(var i:int=0;i<len;i++)
				{
					var tr:TimelineRow = rowsC.getChildAt(i) as TimelineRow;
					if(tr)
					{
						var tData:ITimelineRow_BaseVO = tr.vo as ITimelineRow_BaseVO;
						if(tData && tData.id == sData.id)
						{
							tr.select();
							outData = tData;
						}else
						{
							tr.noSelect();
						}
					}
					
				}
			}
			
			return outData;
			
		}
		/**通过层id值获得层索引	从0开始**/
		private function getRowIndexById(id:String):int
		{
			var index:int;
			row_ls.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			var len:int = row_ls.length;
			for(var i:int=0;i<len;i++)
			{
				var sVO:ITimelineRow_BaseVO = row_ls[i] as ITimelineRow_BaseVO;
				if(sVO && sVO.id == id)
				{
					index = i;
					break;
				}
			}
			
			return index;
			
		}
		/**清除层**/
		private function clearRows():void
		{
			var len:int = rowsC.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var row:TimelineRow = rowsC.getChildAt(i) as TimelineRow;
				if(row)
				{
					rowsC.removeChild(row);
					row.dispose();
					row = null;
				}
			}
		}
		/**创建层**/
		private function createRow(vo:ITimelineRow_BaseVO):void
		{
			var row:TimelineRow = new TimelineRow();
			row.vo = vo;
			rowsC.addChild(row);
			row.reflash();
			
			row.addEventListener(MouseEvent.CLICK, onRowClickHandle);
		}
		
		private function onRowClickHandle(e:MouseEvent):void
		{
			var curRow:TimelineRow = e.currentTarget as TimelineRow;
			if(curRow)
			{
				curRow.removeEventListener(MouseEvent.CLICK, onRowClickHandle);
				curRow.select();
				setSelectRow(curRow.vo.id);
				
				if(selectedOneRow_func!=null) selectedOneRow_func();
				
				var len:int = rowsC.numChildren;
				for(var i:int=0;i<len;i++)
				{
					var fRow:TimelineRow = rowsC.getChildAt(i) as TimelineRow;
					if(fRow)
					{
						if(fRow != curRow)
						{
							fRow.noSelect();
						}
					}
				}
				
				curRow.addEventListener(MouseEvent.CLICK, onRowClickHandle);
			}
		}
		
	}
}