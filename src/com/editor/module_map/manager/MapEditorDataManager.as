package com.editor.module_map.manager
{
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.HashMap;
	
	import flash.geom.Point;

	public class MapEditorDataManager extends SandyManagerBase
	{
		/**当前选中编辑的场景**/
		public var currentSelectedSceneItme:AppMapDefineItemVO;
				
		private var _sceneList:HashMap;
		private var _sceneResList:HashMap;
		public function MapEditorDataManager()
		{
			_sceneList = new HashMap();
			_sceneResList = new HashMap();
		}
		
		private static var instance:MapEditorDataManager;
		public static function getInstance():MapEditorDataManager
		{
			if(!instance)
			{
				instance = new MapEditorDataManager();
			}
			return instance;
		}
		
		public function exportXML():XML
		{
			/**2<=NPC、6<=场景动画、9<=场景背景**/
			
			var x:XML = <root></root>;
			var sXML:XML = <s/>;
			var rXML:XML = <r/>;
			
			
			var a1:Array = getSceneArray();
			var a2:Array = getSceneResArray();
			var nXML:XML;
			var dataStrL:String = "{";
			var dataStrR:String = "}";
			var dataStr:String = "";
			
			/**
			 * 	s => 场景 scene
				i => 场景项
			
				id => 场景ID(同时资源ID)
				ix => 场景index
				x => 初始x
				y => 初始y
				w => 宽
				h => 高
				df => 默认层（角色层）:  0=falsh,1=ture
				r >= 人物可移动范围:string
				hd >= 默认速度 horizontal Default Speed : 0=falsh,1=ture
				hp => 场景左右速度hSpeed:int
				vmq => 场景上下移动序列 vMoveQueue ="startX,startY,endX,endY,speed*startX,startY,endX,endY,speed"
				d => 扩展数据(spawn:产出点坐标)
			 * **/
			for each(var item1:MapSceneItemVO in a1)
			{
				dataStr = "";
				
				nXML = <i/>;
				nXML.@id = item1.sourceId ? item1.sourceId : "";
				nXML.@ix = item1.index ? item1.index : 0;
				nXML.@x = item1.x ? item1.x : 0;
				nXML.@y = item1.y ? item1.y : 0;
				nXML.@w = item1.width ? item1.width : 0;
				nXML.@h = item1.height ? item1.height : 0;
				nXML.@df = item1.isDefault ? item1.isDefault : 0;
				nXML.@r = item1.range ? item1.range : "";
				nXML.@hd = item1.useHDefaultSpeed ? item1.useHDefaultSpeed : 0;
				nXML.@hp = item1.horizontalSpeed ? item1.horizontalSpeed : 0;
				nXML.@vmq = item1.verticalMoveQueue ? item1.verticalMoveQueue : "";
								
				if(item1.isDefault > 0)
				{
					dataStr += '"spawn":' + item1.spawnX + "," + item1.spawnY;
					nXML.@data =  dataStrL + dataStr + dataStrR;
				}
				
				nXML.@data = dataStrL + dataStr + dataStrR;
				
				sXML.appendChild(nXML);
			}
			
			/**
			 * 	r => 资源 res
				i => 资源项
			
			 	id => 唯一ID
				sid => 资源ID
				tp => 资源类型 (2<=NPC、6<=场景动画、9<=场景背景)
				si => 资源所属的场景层ID
				ix => 资源index
				x => 资源x
				y => 资源y
				sx => 资源scaleX
				sy => 资源scaleY
				r => 资源rotation
				d => 扩展数据( startFrame:起始播放帧,npcId:npc的ID)
			 * **/
			for each(var item2:MapSceneResItemVO in a2)
			{
				dataStr = "";
				
				nXML = <i/>;
				nXML.@id = item2.id ? item2.id : "";
				nXML.@sid = item2.sourceId ? item2.sourceId : "";
				nXML.@tp = item2.sourceType ? item2.sourceType : 0;
				nXML.@si = item2.sceneId ? item2.sceneId : "";
				nXML.@ix = item2.index ? item2.index : 0;
				nXML.@x = item2.x ? item2.x : 0;
				nXML.@y = item2.y ? item2.y : 0;
				nXML.@sx = item2.scaleX ? item2.scaleX : 1;
				nXML.@sy = item2.scaleY ? item2.scaleY : 1;
				nXML.@r = item2.rotation ? item2.rotation : 0;
				if(item2 is MapSceneResItemEffVO)
				{
					if((item2 as MapSceneResItemEffVO) .startFrame > 0)
					{
						dataStr += '"startFrame":' + (item2 as MapSceneResItemEffVO) .startFrame;
					}					
				}
				nXML.@data =  dataStrL + dataStr + dataStrR;
				
				rXML.appendChild(nXML);
			}
			
			x.appendChild(sXML);
			x.appendChild(rXML);
						
			return x;
		}
		
		/**场景层次数据*******************************************************************************************************/
		public function addScene(vo:MapSceneItemVO):void
		{
			if(getScene(vo.id))
			{
				removeScene(vo.id);
			}
			_sceneList.put(vo.id.toString(), vo);
		}		
		public function getScene(id:String):MapSceneItemVO
		{
			return _sceneList.find(id.toString());
		}
		public function getSceneBySource(s:String):MapSceneItemVO
		{
			var outVo:MapSceneItemVO;
			var a:Array = getSceneArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(t && t.sourceId == s)
				{
					outVo = t;
					break;
				}
			}
			return outVo;
		}
		public function removeScene(id:String):void
		{
			var sceneSourceId:String = getScene(id).sourceId;
			removeSceneResByScene(sceneSourceId);
			
			_sceneList.remove(id.toString());
			resetSceneListIndex();
		}
		public function clearScene():void
		{
			var a:Array = getSceneArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				removeScene(t.id);
			}
		}
		public function getSceneArray():Array
		{
			var a:Array = _sceneList.toArray();
			a.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			return a;
		}
		public function setSceneBeDefault(vo:MapSceneItemVO):void
		{
			var a:Array = getSceneArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(t)
				{
					t.isDefault = 0;
				}
			}
			vo.isDefault = 1;
		}
		
		private var _sceneLastId:int = 0;
		public function getSceneNewId():int
		{
			var nId:int = _sceneLastId + 1;
			while(!checkSceneNewIdEnable(nId))
			{
				nId ++;
			}
			_sceneLastId = nId;
			return nId;
		}
		private function checkSceneNewIdEnable(newId:int):Boolean
		{
			var a:Array = getSceneArray();
			for each(var item:MapSceneItemVO in a)
			{
				if(item)
				{
					if(item.id == newId.toString())
					{
						return false;
					}
				}
			}
			return true;
		}
		public function getSceneNewIndex():int
		{
			var index:int = 0;
			var a:Array = getSceneArray();						
			index = a.length;
			
			return index;
		}
		private function resetSceneListIndex():void
		{
			var a:Array = getSceneArray();
			a.reverse();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(t)
				{
					t.index = i;
				}
			}
		}
		public function swapSceneIndex(vo:MapSceneItemVO, slot:int):int
		{
			var index:int;
			var a:Array = getSceneArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(t && t==vo)
				{
					index = i;
					break;
				}
			}
			
			index = index - slot;
			var nearVo:MapSceneItemVO = a[index] as MapSceneItemVO;
			if(nearVo)
			{
				var nearIndex:int = nearVo.index;
				nearVo.index = vo.index;
				vo.index = nearIndex;
			}else
			{
				index = index + slot;
			}
			/**返回当前的索引**/
			return index;
			
		}
		public function hasDefaultSceneCount():int
		{
			var count:int = 0;
			var a:Array = getSceneArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(t && t.isDefault)
				{
					count ++;
				}
			}
			
			return count;
		}

		/**场景资源数据*******************************************************************************************************/
		public function addSceneRes(vo:MapSceneResItemVO):void
		{
			if(getSceneRes(vo.id))
			{
				removeSceneRes(vo.id);
			}			
			_sceneResList.put(vo.id.toString(), vo);
		}
		public function getSceneRes(id:String):MapSceneResItemVO
		{
			return _sceneResList.find(id.toString());
		}
		public function removeSceneRes(id:String):void
		{
			var vo:MapSceneResItemVO = getSceneRes(id);
			var sceneId:String = vo.sceneId;
			
			_sceneResList.remove(id.toString());
			resetSceneResListIndexByScene(sceneId);
		}
		public function clearSceneRes():void
		{
			var a:Array = getSceneResArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var fvo:MapSceneResItemVO = a[i] as MapSceneResItemVO;
				removeSceneRes(fvo.id);
			}
		}
		private function removeSceneResByScene(sceneSourceId:String):void
		{
			var a:Array = getSceneResArrayByScene(sceneSourceId);
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var fvo:MapSceneResItemVO = a[i] as MapSceneResItemVO;
				if(fvo)
				{
					removeSceneRes(fvo.id);
				}
			}
			
		}
		public function getSceneResArray():Array
		{
			var a:Array = _sceneResList.toArray();
			a.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			return a;
		}
		public function getSceneResArrayByScene(sceneSourceId:String):Array
		{
			var outA:Array = [];
			var a:Array = getSceneResArray();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var fvo:MapSceneResItemVO = a[i] as MapSceneResItemVO;
				if(fvo && fvo.sceneId == sceneSourceId)
				{
					outA.push(fvo);
				}
			}
			outA.sortOn("index", Array.NUMERIC|Array.DESCENDING);
			return outA;
		}
		private var _sceneResLastId:int = 0;
		public function getSceneResNewId():int
		{
			var nId:int = _sceneResLastId + 1;						
			while(!checkSceneResNewIdEnable(nId))
			{
				nId ++;
//				trace("检测新ID：" + nId);
			}
			
			_sceneResLastId = nId;
			return nId;
		}		
		private function checkSceneResNewIdEnable(newId:int):Boolean
		{
			var a:Array = getSceneResArray();
			for each(var fvo:MapSceneResItemVO in a)
			{
				if(fvo)
				{
					if(fvo.id == newId.toString() || fvo.idNum == newId)
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function getSceneResNewIndex(sceneId:String):int
		{
			var index:int = 0;
			var a:Array = getSceneResArrayByScene(sceneId);
			index = a.length;
			
			return index;
		}
		public function resetSceneResListIndexByScene(sceneId:String):void
		{
			var a:Array = getSceneResArrayByScene(sceneId);
			a.reverse();
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneResItemVO = a[i] as MapSceneResItemVO;
				if(t)
				{
					t.index = i;
				}
			}
		}
		public function swapSceneResIndex(vo:MapSceneResItemVO, slot:int):int
		{
			var index:int;
						
			var a:Array = getSceneResArrayByScene(vo.sceneId);
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var t:MapSceneResItemVO = a[i] as MapSceneResItemVO;
				if(t && t==vo)
				{
					index = i;
					break;
				}
			}
			
			index = index - slot;
			var nearVo:MapSceneResItemVO = a[index] as MapSceneResItemVO;
			if(nearVo)
			{
				var nearIndex:int = nearVo.index;
				nearVo.index = vo.index;
				vo.index = nearIndex;
			}else
			{
				index = index + slot;
			}
			/**返回当前的索引**/
			return index;
			
		}
		
		/** <<gets **/
		private function get_MapEditorProxy():MapEditorProxy
		{			
			return iManager.getAppFacade().retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		
		
		
	}
}