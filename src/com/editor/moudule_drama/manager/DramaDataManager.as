package com.editor.moudule_drama.manager
{
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineRow_BaseVO;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutDisplayObject;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_FrameClipVO;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameBaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameDialogVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameMovieVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.layout.IDrama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListNodeVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesNpcVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.HashMap;
	
	import flash.geom.Point;

	public class DramaDataManager extends SandyManagerBase
	{
		/**当前剧情**/
		public var currentSelectedDramaItem:DramaPlotListNodeVO;
		
		
		/**当前	时间轴选择的层**/
		public var selectedRowId:String;
		/**当前	时间轴选择的帧**/
		public var selectedFrame:int;
		
		/**关键帧列表**/
		private var keyframeList:HashMap;
		/**显示资源列表**/
		private var layoutViewList:HashMap;
		
		/**加入所有片断剪辑的数据**/
		public function insertAllFrameClipData():void
		{
			if(!keyframeList)
			{
				keyframeList = new HashMap();
			}
			if(!layoutViewList)
			{
				layoutViewList = new HashMap();
			}
			keyframeList.clear();
			layoutViewList.clear();
			
			var aF:Array = joinFrameClip_keyframeList();
			var lenF:int = aF.length;
			for(var i:int=0;i<lenF;i++)
			{
				var cfVO:ITimelineKeyframe_BaseVO = aF[i] as ITimelineKeyframe_BaseVO;
				keyframeList.put(cfVO.id, cfVO);
			}
			
			var aL:Array = joinFrameClip_layoutViewList();
			var lenL:int = aL.length;
			for(var j:int=0;j<lenL;j++)
			{
				var clVO:IDrama_LayoutViewBaseVO = aL[j] as IDrama_LayoutViewBaseVO;
				layoutViewList.put(clVO.id, clVO);
			}
		}
				
		
		public function DramaDataManager()
		{
			currentFrameClipList = new HashMap();
			layoutViewList = new HashMap();
		}
		private static var instance:DramaDataManager;
		public static function getInstance():DramaDataManager
		{
			if(!instance)
			{
				instance = new DramaDataManager();
			}
			return instance;
		}
		
		
		
		/**关键帧列表	集合**/
		public function joinFrameClip_keyframeList():Array
		{
			var outA:Array = [];
			
			var a:Array = getFrameClipArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var fc:Drama_FrameClipVO = a[i] as Drama_FrameClipVO;
				var fcStartF:int = getFrameClipStartFrame(fc.id);
				if(fc)
				{
					var fcA:Array = fc.keyframeList.toArray();
					fcA.sortOn("frame", Array.NUMERIC);
					
					var len2:int = fcA.length;
					for(var j:int=0;j<len2;j++)
					{
						var cfVO:ITimelineKeyframe_BaseVO = ITimelineKeyframe_BaseVO(fcA[j]).clone();
						if(cfVO)
						{
							cfVO.frame = cfVO.frame + fcStartF;
							
							outA.push(cfVO);
						}
					}
				}
			}
			
			return outA;
		}
		/**显示资源列表	集合**/
		public function joinFrameClip_layoutViewList():Array
		{
			var outA:Array = layoutViewList.toArray();
						
			return outA;
		}
		
		
		
		
		/**剧情片断	当前片断**/
		private var currentFrameClipVO:Drama_FrameClipVO;
		/**剧情片断	当前所有片断列表**/
		private var currentFrameClipList:HashMap;
		/**剧情片断	设置当前片断**/
		public function setCurrentFrameClip(vo:Drama_FrameClipVO):void
		{
			if(vo)
			{
				keyframeList = vo.keyframeList;
				currentFrameClipVO = vo;
			}
			
		}
		/**剧情片断	获取当前片断**/
		public function getCurrentFrameClip():Drama_FrameClipVO
		{
			return currentFrameClipVO;
		}
		/**剧情片断	添加**/
		public function addFrameClip(vo:Drama_FrameClipVO):void
		{
			if(getFrameClip(vo.id))
			{
				removeFrameClip(vo.id);
			}
			
			updataFrameClipIndex();
			vo.index = getFrameClipArray().length;
			
			currentFrameClipList.put(vo.id, vo);
		}
		/**剧情片断	获取**/
		public function getFrameClip(id:String):Drama_FrameClipVO
		{
			return currentFrameClipList.find(id);
		}		
		/**剧情片断	获取前一个**/
		public function getFrameClipBefore(id:String):Drama_FrameClipVO
		{
			var out:Drama_FrameClipVO;
			
			var cur:Drama_FrameClipVO = currentFrameClipList.find(id);
			if(cur)
			{
				var a:Array = currentFrameClipList.toArray();
				a.sortOn("index", Array.NUMERIC);
				var len:int = a.length;
				
				var before:Drama_FrameClipVO;
				var last:Drama_FrameClipVO;
				for(var i:int=0;i<len;i++)
				{
					last = a[i] as Drama_FrameClipVO;
					if(last && last == cur)
					{
						out = before;
						break;
					}else
					{
						before = last;
					}
				}
			}
			
			return out;
		}
		/**剧情片断	获取起始帧**/
		public function getFrameClipStartFrame(id:String):int
		{
			var out:int;
			
			var cur:Drama_FrameClipVO = currentFrameClipList.find(id);
			if(cur)
			{
				var a:Array = currentFrameClipList.toArray();
				a.sortOn("index", Array.NUMERIC);
				var len:int = a.length;
				
				var cVO:Drama_FrameClipVO;
				for(var i:int=0;i<len;i++)
				{
					cVO = a[i] as Drama_FrameClipVO;
					if(cVO != cur)
					{
						out += cVO.lastFrame;
					}else
					{
						break;
					}
				}
			}
			
			return out;
		}		
		/**剧情片断	更新片段数据**/
		public function updateFrameClipData(id:String):void
		{
			var fcVO:Drama_FrameClipVO = getFrameClip(id);
			if(fcVO)
			{
				var a:Array = fcVO.keyframeList.toArray();
				a.sortOn("frame", Array.NUMERIC|Array.DESCENDING);
				var keyf:ITimelineKeyframe_BaseVO = a[0] as ITimelineKeyframe_BaseVO;
				if(keyf)
				{
					fcVO.lastFrame = keyf.frame;
				}
			}
		}
		
		/**剧情片断	移除**/
		public function removeFrameClip(id:String):void
		{
			currentFrameClipList.remove(id);
		}
		/**剧情片断	数组**/
		public function getFrameClipArray():Array
		{
			var a:Array = currentFrameClipList.toArray();
			a.sortOn("index", Array.NUMERIC);
			return a;
		}
		/**剧情片断	清空**/
		public function clearFrameClipList():void
		{
			var a:Array = getFrameClipArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var cvo:Drama_FrameClipVO = a[i] as Drama_FrameClipVO;
				if(cvo)
				{
					cvo.keyframeList.clear();
//					cvo.keyframeList.dispose();
				}
			}
			
			layoutViewList.clear();
			currentFrameClipList.clear();
			currentFrameClipVO = null;
		}
		/**剧情片断	ID**/
		private var frameClipLastId:int;
		/**剧情片断	ID**/
		public function getFrameClipNewId():String
		{
			frameClipLastId = getNewId(getFrameClipArray(), frameClipLastId+1);
			return frameClipLastId + "";
		}
		/**剧情片断	清除ID**/
		public function clearFrameClipNewId():void
		{
			frameClipLastId = 0;
		}
		/**剧情片断	index**/
		public function updataFrameClipIndex():void
		{
			var a:Array = getFrameClipArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var f:Drama_FrameClipVO = a[i] as Drama_FrameClipVO;
				if(f)
				{
					f.index = i;
				}
			}
		}
		/**剧情片段	调整次序**/
		public function swapFrameClipIndex(vo:Drama_FrameClipVO, slot:int):int
		{
			var index:int = vo.index;
			
			updataFrameClipIndex();
			index = index + slot;
			var a:Array = getFrameClipArray();
			var nearVo:Drama_FrameClipVO = a[index] as Drama_FrameClipVO;
			if(nearVo)
			{
				var nearIndex:int = nearVo.index;
				nearVo.index = index - slot;
				vo.index = nearIndex;
			}else
			{
				index = vo.index;
			}
			/**返回当前的索引**/
			return index;
		}
		
		
		
		
		/**层列表**/
		public static var row_ls:Array = [];
		/**层索引1 场景层**/
		public static const frameRow1:String = "1";
		/**层索引2资源层**/
		public static const frameRow2:String = "2";
		/**层索引3  影片层**/
		public static const frameRow3:String = "3";
		/**层索引4 对话层**/
		public static const frameRow4:String = "4";
		
		/**层类型 场景层**/
		public static const frameRowType1:int = 1;
		/**层类型 资源层**/
		public static const frameRowType2:int = 2;
		/**层类型 影片层**/
		public static const frameRowType3:int = 3;
		/**层类型 对话层**/
		public static const frameRowType4:int = 4;
				
		/**初始化数据**/
		public static function init():void
		{
			row_ls.push(new Drama_RowVO(frameRow1, "场景层", frameRowType1, 1));
			row_ls.push(new Drama_RowVO(frameRow2, "资源层", frameRowType2, 2));
			row_ls.push(new Drama_RowVO(frameRow3, "影片层", frameRowType3, 3));
			row_ls.push(new Drama_RowVO(frameRow4, "对话层", frameRowType4, 4));	
		}
		
		/**层列表	获取层**/
		public function getRowById(id:String):Drama_RowVO
		{
			var outVO:Drama_RowVO;
			
			var a:Array = getRowListArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var row:Drama_RowVO = a[i] as Drama_RowVO;
				if(row && row.id == id)
				{
					outVO = row;
					break;
				}
			}
			
			return outVO;
		}
		
		/**层列表	层数组**/
		public function getRowListArray():Array
		{
			return row_ls;
		}
		/**层列表	获得层类型**/
		public function getRowTypeByRowId(id:String):int
		{
			var outType:int;
			
			var len:int = row_ls.length;
			for(var i:int=0;i<len;i++)
			{
				var d:ITimelineRow_BaseVO = row_ls[i] as ITimelineRow_BaseVO;
				if(d && d.id == id)
				{
					outType = d.type;
					break;
				}
			}
			
			return outType;
		}
		
		/**层列表	当前层未显示资源列表**/
		public function getRowNotDisplayLayoutViewList(rowId:String):Array
		{
			var outA:Array = [];
			
			var aL:Array = getLayoutViewArrayByRowId(rowId);
			var aP:Array;
			var keyfVO:Drama_FrameResRecordVO = getCurrentPlaceKeyframe() as Drama_FrameResRecordVO;
			if(!keyfVO)
			{
				keyfVO = getBeforKeyframe(selectedRowId, selectedFrame) as Drama_FrameResRecordVO;
			}
			if(keyfVO)
			{
				aP = keyfVO.getPropertiesListArr();
				
				var len:int = aL.length;
				for(var i:int=0;i<len;i++)
				{
					var layoutVO:Drama_LayoutViewBaseVO = aL[i] as Drama_LayoutViewBaseVO;
					if(layoutVO)
					{
						var hasBool:Boolean = false;
						for each(var prop:Drama_PropertiesBaseVO in aP)
						{
							if(DramaManager.getInstance().getLayoutViewById(prop.targetId).vo == layoutVO)
							{
								hasBool = true;
							}
						}
						if(!hasBool)
						{
							outA.push(layoutVO);
						}
					}
				}
			}
			
			return outA;
		}
		
		/** <<关键帧列表**/
		public function addKeyFrame(vo:ITimelineKeyframe_BaseVO):void
		{
			if(!keyframeList) return;
			if(!currentFrameClipVO) return;
			
			if(getKeyFrame(String(vo.id)))
			{
				removeKeyframe(String(vo.id));
			}
			
			if(vo is Drama_FrameBaseVO)
			{
				(vo as Drama_FrameBaseVO).frameClipId = currentFrameClipVO.id;
				keyframeList.put(String(vo.id), vo);
				
				updateFrameClipData(currentFrameClipVO.id);
			}
			
		}
		/**关键帧列表**/
		public function getKeyFrame(id:String):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			return keyframeList.find(id);
		}
		/**关键帧列表**/
		public function removeKeyframe(id:String):void
		{
			if(!keyframeList) return;
			if(!currentFrameClipVO) return;
			
			keyframeList.remove(id);
			updateFrameClipData(currentFrameClipVO.id);
		}
		/**关键帧列表	清除**/
		public function clearKeyframe():void
		{
			if(!keyframeList) return;
			if(!currentFrameClipVO) return;
			
			keyframeList.clear();
			updateFrameClipData(currentFrameClipVO.id);
		}
		/**关键帧列表**/
		public function getKeyframeListArray():Array
		{
			var out:Array = [];
			if(!keyframeList) return out;
			
			return keyframeList.toArray();
		}
		
		/**关键帧列表	层中所有关键帧**/
		public function getKeyframelistByRowId(rowId:String):Array
		{
			var out:Array = [];
			if(!keyframeList) return out;
			
			var a:Array = getKeyframeListArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var getVo:ITimelineKeyframe_BaseVO = a[i] as ITimelineKeyframe_BaseVO;
				if(getVo && getVo.rowId == rowId)
				{
					out.push(getVo);
				}
			}
			
			return out;
		}
		
		/**关键帧列表	当前位置的关键帧**/
		public function getCurrentPlaceKeyframe():ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			return getKeyframeByPlace(selectedRowId, selectedFrame);
		}
		
		/**关键帧列表	当前范围的关键帧**/
		public function getCurrentRangeKeyframe():ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			outVO = getCurrentPlaceKeyframe();
			if(!outVO)
			{
				outVO = getInstance().getBeforKeyframe(selectedRowId, selectedFrame);
			}
			
			return outVO;
		}
		
		/**关键帧列表	指定范围的关键帧**/
		public function getCurrentRangeKeyframeByPlace(rowId:String, frame:int):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			outVO = getKeyframeByPlace(rowId, frame);
			if(!outVO)
			{
				outVO = getInstance().getBeforKeyframe(rowId, frame);
			}
			
			return outVO;
		}
		
		/**关键帧列表	rowId:层ID, frame:帧数**/
		public function getKeyframeByPlace(rowId:String, frame:int):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			var a:Array = getKeyframeListArray();
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
		/**关键帧列表	获取前一帧**/
		public function getBeforKeyframe(curRowId:String, curFrame:int):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			if(curRowId && curFrame)
			{
				for(var i:int=curFrame-1;i>0;i--)
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
		/**关键帧列表	获取后一帧**/
		public function getAfterKeyframe(curRowId:String, curFrame:int, lastFrame:int=0):ITimelineKeyframe_BaseVO
		{
			var outVO:ITimelineKeyframe_BaseVO;			
			if(!keyframeList) return outVO;
			
			if(curRowId != "" && curFrame)
			{
				var frameLen:int;
				if(lastFrame > 0)
				{
					frameLen = lastFrame;
				}else
				{
					frameLen = DramaManager.getInstance().get_DramaRightContainerMediator().timelinePanel.timeline.lastFrame;
				}
				
				for(var i:int=curFrame+1;i<=frameLen;i++)
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
				
		private var keyframeLastId:int;
		/**关键帧列表	ID**/
		public function getKeyframeNewId():int
		{
			keyframeLastId = getNewId(joinFrameClip_keyframeList(), keyframeLastId+1);
			return keyframeLastId;
		}
		/**关键帧列表	清除ID**/
		public function clearKeyframeNewId():void
		{
			keyframeLastId = 0;
		}
		
		/** <<显示资源列表**/
		public function addLayoutView(vo:IDrama_LayoutViewBaseVO):void
		{
			if(!layoutViewList) return;
			
			if(getLayoutView(vo.id))
			{
				layoutViewList.remove(vo.id);
			}
						
			layoutViewList.put(vo.id, vo);
		}
		/**显示资源列表	获取**/
		public function getLayoutView(id:String):IDrama_LayoutViewBaseVO
		{
			var outVO:IDrama_LayoutViewBaseVO;
			if(!layoutViewList) return outVO;
			
			return layoutViewList.find(id);
		}
		/**显示资源列表	移除**/
		public function removeLayoutView(id:String):void
		{
			if(!layoutViewList) return;
			
			layoutViewList.remove(id);
		}
		/**显示资源列表	清空**/
		public function clearLayoutView():void
		{
			if(!layoutViewList) return;
			
			layoutViewList.clear();
		}
		/**显示资源列表	数组**/
		public function getLayoutViewArray():Array
		{
			var out:Array = [];
			if(!layoutViewList) return out;
			
			return layoutViewList.toArray();
		}
		/**显示资源列表	当前层数组**/
		public function getLayoutViewArrayByRowId(rowId:String):Array
		{
			var out:Array = [];
			if(!layoutViewList) return out;
			
			var outA:Array = [];
			
			var a:Array = getLayoutViewArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var layoutVO:Drama_LayoutViewBaseVO = a[i] as Drama_LayoutViewBaseVO;
				if(layoutVO && layoutVO.rowId == rowId)
				{
					outA.push(layoutVO);
				}
			}
			
			return outA;
		}
		/**显示资源列表	新ID**/
		private var layoutViewLastId:int;
		/**显示资源列表	新ID**/
		public function getLayoutViewNewId():int
		{
			layoutViewLastId = getNewId(getLayoutViewArray(), layoutViewLastId + 1);
			return layoutViewLastId;
		}
		/**显示资源列表	清除ID**/
		public function clearLayoutViewNewId():void
		{
			layoutViewLastId = 0;
		}
				
		/**显示资源属性列表	获取显示对象当前位置的属性VO**/
		public function getLayoutPropertiesVOByLayoutVO(layoutVO:Drama_LayoutViewBaseVO):Drama_PropertiesBaseVO
		{
			var outVO:Drama_PropertiesBaseVO;
			
			var a:Array = getRowListArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var rvo:Drama_RowVO = a[i] as Drama_RowVO;
				if(rvo && rvo.type == frameRowType2)
				{					
					var cRowId:String = rvo.id;
					var keyfVO:Drama_FrameResRecordVO = getKeyframeByPlace(cRowId, selectedFrame) as Drama_FrameResRecordVO;
					if(!keyfVO)
					{
						keyfVO = getBeforKeyframe(cRowId, selectedFrame) as Drama_FrameResRecordVO;
					}
					
					if(keyfVO)
					{
						var propertyVO:Drama_PropertiesBaseVO = keyfVO.getPropertyVOByLayoutVO(layoutVO);
						if(propertyVO)
						{
							outVO = propertyVO;
							break;
						}
					}
					
				}
			}
						
			return outVO;
		}
		
		/**显示资源属性列表	通过属性VO获得显示对象VO**/
		public function getLayoutVOByPropertiesVO(vo:Drama_PropertiesBaseVO):Drama_LayoutViewBaseVO
		{
			var outVO:Drama_LayoutViewBaseVO;
			
			var target:DLayoutDisplayObject = DramaManager.getInstance().getLayoutViewById(vo.targetId) as DLayoutDisplayObject;
			if(target)
			{
				outVO = target.vo as Drama_LayoutViewBaseVO;
			}
			
			return outVO;
		}
		
		/**显示资源属性列表	获得往后帧的相同显示对象的属性VO**/
		public function getLayoutProperties_InAfterFrame(vo:Drama_PropertiesBaseVO, lastFrame:int=0):Drama_PropertiesBaseVO
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
		
		
		
		
		/**
		 * 获取新ID 
		 * @param arr ID所在数组
		 * @param startId 起始位置
		 * 
		 */		
		private function getNewId(arr:Array, startId:int):int
		{
			while(detectNewId(arr, startId) <= 0)
			{
				startId ++;
			}
			
			return startId;
			
		}
		/**检测ID**/
		private function detectNewId(arr:Array, id:int):int
		{
			var outId:int;			
			var bool:Boolean;
			
			var r:RegExp = /\d/igx;
			var len:int = arr.length;
			for(var i:int=0;i<len;i++)
			{
				var obj:Object = arr[i] as Object;
				if(obj && obj.id)
				{
					var idStr:String = String(obj.id);
					var curIdNum:int = int(idStr.match(r).join(""));
					if(curIdNum == id)
					{
						bool = true;
					}
				}
			}
			
			if(!bool)
			{
				outId = id;
			}
			
			return outId;
		}
		
		
		
		
			
		/**导出XML**/
		public function exportXML():XML
		{
			var x:XML = <r></r>;
			
			var fcXML:XML = <fc/>;
			var rXML:XML = <r/>;
			var fXML:XML = <f/>;
			var vXML:XML = <v/>;
			
			var nX:XML;
			
			/**片段剪辑**/
			
			/**
			 * 
			 * fc => frameClip 片断剪辑
					i => 一个剪辑
						@ id => id:String
						@ n => 名称:String
						@ ix => index:int
						@ lf => 最后一帧
			 * 
			 * **/
			var aC:Array = getFrameClipArray();
			for each(var cvo:Drama_FrameClipVO in aC)
			{
				nX = <i/>;
				nX.@id = cvo.id;
				nX.@n = cvo.name;
				nX.@ix = cvo.index;
				updateFrameClipData(cvo.id);
				nX.@lf = cvo.lastFrame;
				fcXML.appendChild(nX);
			}
			
			
			/**层**/
			
			/**
			 * 
			 * r => 层 (每个剪辑的层必须相同，一个剪辑添加了层其它剪辑需添加同样)
					i => 一个层
						@ id => id:String
						@ n => 名称:String
						@ ty => 类型:int
						@ ix => index:int
			 * 
			 * **/
			var aR:Array = getRowListArray();
			for each(var rvo:Drama_RowVO in aR)
			{
				nX = <i/>;
				nX.@id = rvo.id;
				nX.@n = rvo.name;
				nX.@ty = rvo.type;
				nX.@ix = rvo.index;
				rXML.appendChild(nX);
			}
			
			/**关键帧**/
			
			/**
			 * 
			 * f => 关键帧数据
					i => 一个关键帧
						@ id => id:String
						@ t => 帧类型:int (1实帧、2空帧、3补间帧)
						@ fc => 所属剪辑ID:String			
						@ r => 所在层ID:String
						@ f => 帧数
						
						e => extend不同数据类型关键帧的其它数据 =>
						
						if(@ dt == 1:场景)
						{
							@ s => 场景ID
							@ O => 场景偏移
							@ k => 振动
						}
						
						if(@ dt==2:资源)
						{
						 	@ sc => 执行脚本:String(stop为暂停)
							pl => 属性列表
								i => 一个属性
									@ vid => 显示对象ID:String
									@ t => 属性类型:int(1图片、2特效、3NPC、4角色)
									@ x => x:int
									@ y => y:int
									@ al => alpha:Number
									@ ix => index:int
									@ sx => scaleX:Number
									@ sy => scaleY:Number
									@ r => rotation:int
									@ p => 是否播放:int(0=false,1=true)
									@ pm => 播放参数:String(用","号分隔参数 para1=播放类型、para2=动作或技能ID或其它)
									@ lp => loop:int(是否循环播放,例如行走、奔跑要循环,攻击只播放一次)
									@ d => data:*(扩展数据)
									
									@ st => 资源类型:int
									@ tn => 是否过渡:int(0=false,1=true)
									@ mcp => 鼠标点击参数
									@ dr => 方向:int(0=左,1=右)
															
						}
						
						if(@ dt==3:影片)
						{
							@ mid => 影片ID
							@ mx => 影片x
							@ my => 影片y
						}
						
						if(@ dt==4:对话)
						{
							@ did => 对话ID
							@ dr => 左右(0=左,1=右)
						}
			 * 
			 * **/
			var aF:Array = joinFrameClip_keyframeList();
			for each(var fvo:Drama_FrameBaseVO in aF)
			{
				nX = <i/>;
				nX.@id = fvo.id;
				nX.@t = fvo.type;
				nX.@fc = fvo.frameClipId;
				nX.@r = fvo.rowId;
				nX.@f = fvo.frame;
				
				/**1场景数据、2资源数据、3影片数据、4对话数据**/
				var eX:XML = <e/>;
				if(fvo is Drama_FrameSceneVO)
				{
					eX.@s = (fvo as Drama_FrameSceneVO).sceneId;
					eX.@O = (fvo as Drama_FrameSceneVO).sceneOffset;
					eX.@k = (fvo as Drama_FrameSceneVO).shakeNow;
					
				}else if(fvo is Drama_FrameResRecordVO)
				{
					var sc:String = (fvo as Drama_FrameResRecordVO).script;
					eX.@sc = (fvo as Drama_FrameResRecordVO).script ? (fvo as Drama_FrameResRecordVO).script : "";
					
					var plXML:XML = <pl/>;
					
					var aProp:Array = (fvo as Drama_FrameResRecordVO).recordList;
					for each(var propVO:Drama_PropertiesBaseVO in aProp)
					{
						var plIXML:XML = <i/>;
						plIXML.@vid = propVO.targetId;
						
						plIXML.@x = propVO.x;
						plIXML.@y = propVO.y;
						plIXML.@al = propVO.alpha;
						plIXML.@ix = propVO.index;
						plIXML.@sx = propVO.scaleX;
						plIXML.@sy = propVO.scaleY;
						plIXML.@r = propVO.rotation;
						plIXML.@p = 0;
						
						plIXML.@d = "";
						plIXML.@st = propVO.resType;
						plIXML.@tn = propVO.transition;
						plIXML.@mcp = propVO.mouseClickPara;
						
						if(propVO is Drama_PropertiesRoleVO)
						{
							var roleProp:Drama_PropertiesRoleVO = propVO as Drama_PropertiesRoleVO;
							if(roleProp.action && roleProp.action != "" && roleProp.action != "undefined")
							{
								plIXML.@p = 1;
								plIXML.@pm = roleProp.actionType + "," + roleProp.action;
								plIXML.@lp = 0;
							}
							plIXML.@dr = roleProp.direction;
						}
						
						plXML.appendChild(plIXML);
					}
					
					eX.appendChild(plXML);
					
					
				}else if(fvo is Drama_FrameMovieVO)
				{
					eX.@mid = (fvo as Drama_FrameMovieVO).movieId;
					eX.@mx = (fvo as Drama_FrameMovieVO).movieX;
					eX.@my = (fvo as Drama_FrameMovieVO).movieY;
					
				}else if(fvo is Drama_FrameDialogVO)
				{
					eX.@did = (fvo as Drama_FrameDialogVO).dialogId;
					eX.@dr = (fvo as Drama_FrameDialogVO).dialogPlace;
					
				}
				
				nX.appendChild(eX);				
				fXML.appendChild(nX);
			}
			
			
			/**显示对象**/
			
			/**
			 * 
			 * v => 显示对象
					i => 一个显示对象
						@ id => id:String
						@ fc => 所属剪辑ID:String
						@ r => 层ID:String
						@ sid => 资源ID:int
						@ st => 资源类型:int()
			 * 
			 * **/
			var aV:Array = joinFrameClip_layoutViewList();
			for each(var vvo:Drama_LayoutViewBaseVO in aV)
			{
				nX = <i/>;
				nX.@id = vvo.id;
				nX.@r = vvo.rowId;
				nX.@sid = vvo.sourceId;
				nX.@st = vvo.sourceType;
				nX.@sn = vvo.customName;
				vXML.appendChild(nX);
			}
			
			
			x.appendChild(fcXML);
			x.appendChild(rXML);
			x.appendChild(fXML);
			x.appendChild(vXML);
						
			return x;
		}
		
		
	}
}