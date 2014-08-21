package com.editor.moudule_drama.vo.drama.frame
{
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutDisplayObject;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesNpcVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;

	/**
	 * 资源	关键帧VO
	 * 
	 */	
	public class Drama_FrameResRecordVO extends Drama_FrameBaseVO
	{
		/***属性列表*/
		private var _recordList:Array = [];
		/**脚本	stop=停止**/
		public var script:String;
		public function Drama_FrameResRecordVO()
		{
			
		}
		
		override public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:Drama_FrameResRecordVO = new Drama_FrameResRecordVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			/**base**/
			cloneObj.frameClipId = frameClipId;
			
			/**self**/
			cloneObj.script = script;
			var cloneList:Array = [];
			var len:int = _recordList.length;
			for(var i:int=0;i<len;i++)
			{
				var propVO:Drama_PropertiesBaseVO = _recordList[i] as Drama_PropertiesBaseVO;
				if(propVO)
				{
					var cloneProp:Drama_PropertiesBaseVO = propVO.clone() as Drama_PropertiesBaseVO;
					if(cloneProp)
					{
						cloneProp.placeFrameVO = cloneObj;
						cloneList.push(cloneProp);
					}
				}
				
			}
			cloneObj.recordList = cloneList;
			
			return cloneObj;
		}
		
		override public function parseExtendXML(x:XML):void
		{
			/**执行脚本**/
			script = x.@sc ? String(x.@sc) : "";
			if(script == "null" || script == "undefined")
			{
				script = "";
			}
			/**属性列表**/
			if(x.pl)
			{
				_recordList = [];
				
				var propertiesListXML:XML = XML(x.pl);
				for each(var iX:XML in propertiesListXML.i)
				{
					var sourceType:int = iX.@st;
					
					var propVO:ITimelineViewProperties_BaseVO = DramaManager.getInstance().getNewPropertyVO_BySourceType(sourceType);
										
					/**基本数据**/
					if(propVO is Drama_PropertiesBaseVO)
					{
						var propBaseVO:Drama_PropertiesBaseVO = propVO as Drama_PropertiesBaseVO;
																
						/**proto**/
						propBaseVO.targetId = iX.@vid;
						propBaseVO.x = iX.@x;
						propBaseVO.y = iX.@y;
						propBaseVO.alpha = (iX.@al==undefined) ? 1 : iX.@al;
						propBaseVO.index = iX.@ix;
						propBaseVO.scaleX = iX.@sx;
						propBaseVO.scaleY = iX.@sy;
						propBaseVO.rotation = iX.@r;
						propBaseVO.data = iX.@d;
						/**base**/
						propBaseVO.resType = iX.@st;
						propBaseVO.transition = iX.@tn;
						propBaseVO.mouseClickPara = iX.@mcp;
						propBaseVO.placeFrameVO = this;
						propBaseVO.locked = 1;
					}
					
					if(propVO is Drama_PropertiesRoleVO)
					{
						var propRoleVO:Drama_PropertiesRoleVO = propVO as Drama_PropertiesRoleVO;
						
						var playParaArr:Array = String(iX.@pm).split(",");
						if(playParaArr && playParaArr.length > 1)
						{
							propRoleVO.actionType = int(playParaArr[0]);
							propRoleVO.action = String(playParaArr[1]);
							propRoleVO.actionName = DramaManager.getInstance().get_DramaAttributeEditor_LayoutViewMediator().getActionName(propRoleVO.action, propRoleVO.actionType);														
						}
						propRoleVO.direction = iX.@dr;
					}
					
					_recordList.push(propVO);
					
				}
			}
			
		}
		
		/**设置属性列表**/
		public function setPropertiesList(a:Array):void
		{
			_recordList = a;
			
			var len:int = _recordList.length;
			for(var i:int=0;i<len;i++)
			{
				var p:Drama_PropertiesBaseVO = _recordList[i] as Drama_PropertiesBaseVO;
				if(p)
				{
					p.placeFrameVO = this;
				}
			}
		}
		
		/**添加属性**/
		public function addProperty(vo:Drama_PropertiesBaseVO):void
		{
			var getVO:Drama_PropertiesBaseVO = getPropertyVO(vo.targetId);
			if(getVO)
			{
				removePropertyVO(getVO);
			}
			vo.index = _recordList.length;
			_recordList.push(vo);
			resetPropertiesIndex();
		}
				
		/**删除属性**/
		public function removePropertyVO(vo:Drama_PropertiesBaseVO):void
		{
			var len:int = _recordList.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var propertyVO:Drama_PropertiesBaseVO = _recordList[i] as Drama_PropertiesBaseVO;
				if(propertyVO == vo)
				{
					_recordList.splice(i,1);
					resetPropertiesIndex();
					break;
				}
			}
		}
		
		/**获取属性**/
		public function getPropertyVO(targetId:String):Drama_PropertiesBaseVO
		{
			var outVO:Drama_PropertiesBaseVO;
			var len:int = _recordList.length;
			for(var i:int=0;i<len;i++)
			{
				var propertyVO:Drama_PropertiesBaseVO = _recordList[i] as Drama_PropertiesBaseVO;
				if(propertyVO.targetId == targetId)
				{
					outVO = propertyVO;
					break;
				}
			}
			return outVO;
		}
		
		/**重新排序**/
		private function resetPropertiesIndex():void
		{
			var a:Array = getPropertiesListArr();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var p:Drama_PropertiesBaseVO = a[i] as Drama_PropertiesBaseVO;
				if(p)
				{
					p.index = i;
				}
			}
		}
		
		/**次序调整**/
		public function swapSceneResIndex(vo:Drama_PropertiesBaseVO, slot:int):int
		{
			var index:int = vo.index;
			
			resetPropertiesIndex();
			index = index + slot;
			var a:Array = getPropertiesListArr();
			var nearVo:Drama_PropertiesBaseVO = a[index] as Drama_PropertiesBaseVO;
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
		
		/**通过显示对象VO获得显示对象属性VO**/
		public function getPropertyVOByLayoutVO(layoutVO:Drama_LayoutViewBaseVO):Drama_PropertiesBaseVO
		{
			var outVO:Drama_PropertiesBaseVO;
			
			var len:int = _recordList.length;
			for(var i:int=0;i<len;i++)
			{
				var propertyVO:Drama_PropertiesBaseVO = _recordList[i] as Drama_PropertiesBaseVO;
				if(propertyVO)
				{
					var layout:DLayoutDisplayObject = DramaManager.getInstance().getLayoutViewById(propertyVO.targetId);
					if(layout && layout.vo == layoutVO)
					{
						outVO = propertyVO;
					}
				}				
			}
			
			return outVO;
		}
		
		/**获取属性列表数组**/
		public function getPropertiesListArr():Array
		{
			var a:Array = _recordList;
			a.sortOn("index", Array.NUMERIC);
			return a;
		}

		/**属性列表 >	paraType:DramaViewPropertiesBaseVO **/
		public function get recordList():Array
		{
			return _recordList;
		}

		/**属性列表 >	paraType:DramaViewPropertiesBaseVO **/
		public function set recordList(value:Array):void
		{
			_recordList = value;
		}

		
	}
}