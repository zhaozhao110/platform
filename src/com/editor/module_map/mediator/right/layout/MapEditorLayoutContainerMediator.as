package com.editor.module_map.mediator.right.layout
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.mediator.MapEditorModuleMediator;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.view.right.layout.MapEditorLayoutContainer;
	import com.editor.module_map.view.right.layout.component.LayoutDisplayObject;
	import com.editor.module_map.view.right.layout.component.LayoutSprite;
	import com.editor.module_map.view.right.layout.component.LayoutSpriteContainer;
	import com.editor.module_map.vo.map.MapResConfigItemVO;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_map.vo.map.interfaces.IMapSceneVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.services.Services;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.LoadSourceData;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	import com.sandy.utils.LoadContextUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;

	public class MapEditorLayoutContainerMediator extends AppMediator
	{
		public static const NAME:String = "MapEditorLayoutContainerMediator";
		
		private var layoutSpriteList:Array = [];
		private var onlyShowSeleSceneBool:Boolean;
		
		private var loadingRes_List:Array = [];
		private var loadingRes_Item:AppResInfoItemVO;
		private var loadingRes_config:MapResConfigItemVO;
		private var loadingRes_Vo:IMapSceneVO;
		private var loadingRes_SelectStatus:int;
		private var loadingRes_StatusBool:Boolean;
		private var loadingURL:String;
		
		public function MapEditorLayoutContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorLayoutContainer
		{
			return viewComponent as MapEditorLayoutContainer;
		}
		public function get sceneContainer():UICanvas
		{
			return mainUI.sceneContainer;
		}
		public function get rangeMask():UICanvas
		{
			return mainUI.rangeMask;
		}
		public function get rangeMask_VisibleButton():UIButton
		{
			return mainUI.rangeMask_VisibleButton;
		}
		public function get onlyShowSeleSceneButton():UIButton
		{
			return mainUI.onlyShowSeleSceneButton;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			rangeMask.x = MapConst.layoutSceneContainerOffsetX;
			rangeMask.y = MapConst.layoutSceneContainerOffsetY;
		}
		
		/**
		 * 
		 * @param item 资源
		 * @param vo 数据
		 * @param selectStatus 是否选中状态
		 * @param configItem 资源配置数据
		 * 
		 */		
		public function loadSourceByItme(item:AppResInfoItemVO, vo:IMapSceneVO = null, selectStatus:int = 0, configItem:MapResConfigItemVO = null):void
		{
			loadingRes_List.push({item:item, vo:vo, selectStatus:selectStatus, configItem:configItem});
			loadSourceByItmeProcess();
		}
		
		private function loadSourceByItmeProcess():void
		{
			if(loadingRes_StatusBool) return;
			if(loadingRes_List.length <= 0)
			{
				sendNotification(MapEditorEvent.mapEditor_loadingComplete_event);
				sendNotification(MapEditorEvent.mapEditor_updateSceneList_event);
				sendNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
				get_MapEditorModuleMediator().addLog2("渲染场景画面成功！");
				return;
			}
			
			loadingRes_StatusBool = true;
			
			var obj:Object = loadingRes_List[0];
			loadingRes_Item = obj.item;
			loadingRes_Vo = obj.vo;
			loadingRes_SelectStatus = obj.selectStatus;
			loadingRes_config = obj.configItem;
			
			/**id<0的是空白层**/
			if(loadingRes_Item.id < 0)
			{
				processRes(loadingRes_Item, loadingRes_Vo, loadingRes_SelectStatus, loadingRes_config);
				return;
			}
			
			/**加载**/
			var subpath:String = MapEditorManager.getResSubpath(loadingRes_Item.type);
			var fileName:String = (loadingRes_Item.type == 2) ? "npcDefault.swf" : loadingRes_Item.id + ".swf";
			var resUrl:String = MapEditorManager.currProject.mapResUrl + subpath + fileName;
			loadingURL = resUrl;
			var className:String = MapEditorManager.getResClassName(loadingRes_Item.id, loadingRes_Item.type);
			get_MapEditorModuleMediator().addLog2("load source at: " + resUrl);
			
			if(iResource.haveClass(className))
			{
				processRes(loadingRes_Item, loadingRes_Vo, loadingRes_SelectStatus, loadingRes_config);
			}else
			{
				var loadData:ILoadSourceData = iResource.getLoadSourceData();
				loadData.url = resUrl;
				loadData.type = LoadQueueConst.swf_type;
				loadData.loadSwf_contextType = LoadContextUtils.TARGET_SAME;
				
				var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
				dt.sourceData = loadData;
				dt.loadCompleteF = loadSourceComplete;
				dt.loadErrorF = loadSourceError;
				iResource.loadSingleResource(dt);
				
			}
		}
		
		
		private function loadSourceComplete(e:*=null):void
		{				
			var className:String = MapEditorManager.getResClassName(loadingRes_Item.id, loadingRes_Item.type);
						
			if(iResource.getClass(className))
			{
				processRes(loadingRes_Item, loadingRes_Vo, loadingRes_SelectStatus, loadingRes_config);
				
			}else
			{
				loadingRes_StatusBool = false;
				removeCurLoadingItem();
				loadSourceByItmeProcess();
//				if(loadingRes_Item)
//				{
//					get_MapEditorModuleMediator().addLog2("获取资源定义失败：" + loadingRes_Item.name1+"/assets:" + className);
//				}
				
			}
			
			
		}
		private function loadSourceError(e:*=null):void
		{			
			loadingRes_StatusBool = false;
			removeCurLoadingItem();
			loadSourceByItmeProcess();
			
			get_MapEditorModuleMediator().addLog2("加载资源失败：" + loadingRes_Item.name1);
		}
		
		private function removeCurLoadingItem():void
		{
			if(!loadingRes_Item) return;
			
			var len:int = loadingRes_List.length;
			for(var i:int=0;i<len;i++)
			{
				var obj:Object = loadingRes_List[i];
				if(obj.item)
				{
					var item:AppResInfoItemVO = obj.item as AppResInfoItemVO;
					if(item)
					{
						if(item.id == loadingRes_Item.id)
						{
							loadingRes_List.splice(i,1);
							
							loadingRes_Item = null;
							loadingRes_Vo = null;
							loadingRes_SelectStatus = 0;
							
							break;
						}
					}
					
				}
				
				
			}
		}
		
		/**处理加载好的资源**/
		private function processRes(item:AppResInfoItemVO, vo:IMapSceneVO = null, selectStatus:int = 0, config:MapResConfigItemVO = null):void
		{
			loadingRes_StatusBool = true;
			
			var className:String = MapEditorManager.getResClassName(item.id, item.type);
			var getClass:Class = iResource.getClass(className);
			var classType:String;
						
			var vo1:MapSceneItemVO;
			var vo2:MapSceneResItemVO;
			
			var bitmapData:BitmapData;
			var bitmap:Bitmap;			
			var mc:MovieClip;			
			
			var container:LayoutSpriteContainer;			
			var sprite:LayoutSprite;
			var getSceneVo:MapSceneItemVO;
			var layoutObject:LayoutDisplayObject;
						
			if(getClass)
			{
				classType = getQualifiedSuperclassName(getClass).split("::")[1];
				if(classType == "BitmapData")
				{
					bitmapData = new getClass() as BitmapData;
				}				
			}
			
			/**2<=NPC、6<=场景动画、9<=场景背景**/
			if(item.type == 9)
			{
				/**场景层次类型**/				
				if(vo)
				{
					if(vo is MapSceneItemVO)
					{
						vo1 = vo as MapSceneItemVO;
					}else if(vo is MapSceneResItemVO)
					{
						vo2 = vo as MapSceneResItemVO;
					}
				}else
				{
					var containerDefaultY:int = bitmapData ? -(bitmapData.height - rangeMask.height)/2 : 0;
					
					vo1 = new MapSceneItemVO();
					vo1.id = item.id + "";
					vo1.sourceId = item.id + "";
					vo1.sourceName = item.name1 ? item.name1 : "空层";
					vo1.index = MapEditorDataManager.getInstance().getSceneNewIndex();
					vo1.x = 0;
					vo1.y = containerDefaultY;
					vo1.width = bitmapData ? bitmapData.width : 0;
					vo1.height = bitmapData ? bitmapData.height : 0;
					MapEditorDataManager.getInstance().addScene(vo1);
					vo1.useHDefaultSpeed = 1;
					sendAppNotification(MapEditorEvent.mapEditor_updateSceneList_event);
					
					/**空白层没有背景**/
					if(item.id > 0)
					{
						vo2 = new MapSceneResItemVO();
						vo2.id = "s" + item.id;
						vo2.name = item.name;
						vo2.sceneId = vo1.sourceId;
						vo2.sourceType = item.type;
						vo2.sourceId = item.id + "";
						vo2.sourceName = item.name1;
						vo2.index = MapEditorDataManager.getInstance().getSceneResNewIndex(vo2.sceneId);
						vo2.x = 0;
						vo2.y = 0;
						vo2.scaleX = 1;
						vo2.scaleY = 1;
						vo2.rotation = 0;
						MapEditorDataManager.getInstance().addSceneRes(vo2);
					}
					
					
				}
				
												
				if(vo1)
				{
					container = new LayoutSpriteContainer();
					container.x = vo1.x + MapConst.layoutSceneContainerOffsetX;
					container.y = vo1.y + MapConst.layoutSceneContainerOffsetY;
					container.width = vo1.width;
					container.height = vo1.height;
					container.vo = vo1;
					sceneContainer.addChild(container);
					layoutSpriteList.push(container);
										
				}
				
				
												
				if(vo2)
				{
					if(!container)
					{
						getSceneVo = MapEditorDataManager.getInstance().getSceneBySource(vo2.sceneId);
						layoutObject = getLayoutObjByVO(getSceneVo);
						if(layoutObject && layoutObject is LayoutSpriteContainer)
						{
							container = layoutObject as LayoutSpriteContainer;
						}
					}
					
					if(container)
					{
						if(bitmapData)
						{
							sprite = new LayoutSprite();
							sprite.mouseEnabled = false;
							sprite.mouseChildren = false;
							sprite.vo = vo2;
							
							bitmap = new Bitmap(bitmapData);
							bitmap.smoothing = false;
							sprite.addRes(bitmap);
							layoutSpriteList.push(sprite);
							container.addSprite(sprite);
						}
						
					}
					
				}
				
				
				
			}else if(item.type == 2 || item.type == 6)
			{
				/**场景资源类型**/
				if(vo)
				{
					if(vo is MapSceneResItemNpcVO)
					{
						vo2 = vo as MapSceneResItemNpcVO;
						
					}else if(vo is MapSceneResItemEffVO)
					{
						vo2 = vo as MapSceneResItemEffVO;
					}else
					{
						vo2 = vo as MapSceneResItemVO;
					}
				}else
				{
					if(item.type == 2)
					{
						/**NPC**/
						vo2 = new MapSceneResItemNpcVO();				
						
					}else if(item.type == 6)
					{
						/**场景动画**/
						vo2 = new MapSceneResItemEffVO();
						
					}
					
					vo2.id = config ? config.id + "" : "s" + MapEditorDataManager.getInstance().getSceneResNewId();
					vo2.sceneId = get_MapEditorLeftContainerMediator().getSceneSelectedVO().sourceId;
					vo2.sourceId = item.id + "";
					vo2.sourceName = item.name1;
					vo2.sourceType = item.type;
					vo2.index = MapEditorDataManager.getInstance().getSceneResNewIndex(vo2.sceneId);
					vo2.x = MapConst.layoutSceneContainerOffsetX + 100;
					vo2.y = MapConst.layoutSceneContainerOffsetY + 100;
					vo2.scaleX = 1;
					vo2.scaleY = 1;
					vo2.rotation = 0;
					MapEditorDataManager.getInstance().addSceneRes(vo2);
				}
				
				
				if(vo2)
				{
					if(getClass && classType)
					{
						sprite = new LayoutSprite();
						sprite.vo = vo2;
						sprite.x = vo2.x;
						sprite.y = vo2.y;
						
						/**add res**/
						if(classType == "BitmapData")
						{
							if(bitmapData)
							{
								bitmap = new Bitmap(bitmapData);
								sprite.addRes(bitmap);
							}						
							
						}else if(classType == "MovieClip")
						{
							mc = new getClass() as MovieClip;
							sprite.addRes(mc);
						}
						
						
						getSceneVo = MapEditorDataManager.getInstance().getSceneBySource(vo2.sceneId);
						layoutObject = getLayoutObjByVO(getSceneVo);
						if(layoutObject && layoutObject is LayoutSpriteContainer)
						{
							container = layoutObject as LayoutSpriteContainer;
							container.addSprite(sprite);
							layoutSpriteList.push(sprite);
							
							if(selectStatus > 0)
							{
								sprite.doClick();
								sendAppNotification(MapEditorEvent.mapEditor_editPripertiesDate_event, {vo:vo2});
							}
						}else
						{
							sprite.dispose();
							sprite = null;
						}
					}			
				}
				
				
				
			}
			
			sceneContainer.setChildIndex(rangeMask, sceneContainer.numChildren-1);
			
			loadingRes_StatusBool = false;
			removeCurLoadingItem();
			loadSourceByItmeProcess();
			
		}
		
		/**编辑属性改变事件**/
		public function respondToMapEditorPripertiesDateChangeEvent(noti:Notification):void
		{
			var getData:Object = noti.getBody() as Object;
			if(getData.vo)
			{
				var vo1:MapSceneItemVO;
				var vo2:MapSceneResItemVO;
				var sp1:LayoutSpriteContainer;
				var sp2:LayoutSprite;
				var sprite:LayoutDisplayObject = getLayoutObjByVO(getData.vo);				
				if(sprite)
				{
					var fvo:Object = sprite.vo;
					if(fvo)
					{
						if(fvo is MapSceneItemVO)
						{
							vo1 = fvo as MapSceneItemVO;
							sp1 = sprite as LayoutSpriteContainer;
							if(vo1)
							{
								sp1.x = vo1.x + MapConst.layoutSceneContainerOffsetX;
								sp1.y = vo1.y + MapConst.layoutSceneContainerOffsetY;
							}
							
						}else if(fvo is MapSceneResItemVO)
						{
							vo2 = fvo as MapSceneResItemVO;
							sp2 = sprite as LayoutSprite;
							if(vo2)
							{
								sp2.x = vo2.x;
								sp2.y = vo2.y;
								sp2.scaleX = vo2.scaleX;
								sp2.scaleY = vo2.scaleY;
								sp2.rotation = vo2.rotation;
								sp2.renderGraphics();
								
								/**所在场景改变**/
								if(sp2.parentContainer && sp2.parentContainer.vo)
								{
									var pVO:MapSceneItemVO = sp2.parentContainer.vo as MapSceneItemVO;
									if(pVO)
									{
										if(vo2.sceneId != pVO.sourceId)
										{
											sp2.parentContainer.removeSprite(sp2);											
											var nSceneVO:MapSceneItemVO = MapEditorDataManager.getInstance().getSceneBySource(vo2.sceneId);
											var nScene:LayoutDisplayObject = getLayoutObjByVO(nSceneVO);
											if(nScene is LayoutSpriteContainer)
											{
												(nScene as LayoutSpriteContainer).addSprite(sp2);												
											}
										}
									}
								}								
								
							}
						}
					}
				}
				
				
			}
			
		}
		
		/**通过VO获得场景对象**/
		private function getLayoutObjByVO(vo:Object):LayoutDisplayObject
		{
			var outSprite:LayoutDisplayObject;
			var len:int = layoutSpriteList.length;
			for(var i:int=0;i<len;i++)
			{
				var sprite:LayoutDisplayObject = layoutSpriteList[i] as LayoutDisplayObject;
				if(sprite)
				{
					if(sprite.vo && sprite.vo == vo)
					{
						outSprite = sprite;
						break;
					}
				}
			}
			return outSprite;
			
		}
		
		/**场景层次列表更新事件**/
		public function respondToMapEditorUpdateSceneListEvent(noti:Notification):void
		{
			updataSceneList();
		}
		/**更新场景层次列表**/
		private function updataSceneList():void
		{
			var len:int = layoutSpriteList.length;
			for(var i:int=0;i<len;i++)
			{
				var sprite:LayoutSpriteContainer = layoutSpriteList[i] as LayoutSpriteContainer;
				if(sprite)
				{
					if(sceneContainer.contains(sprite))
					{
						var fvo:MapSceneItemVO = sprite.vo as MapSceneItemVO;
						if(fvo)
						{
							if(MapEditorDataManager.getInstance().getScene(fvo.id))
							{
								
								if((fvo as MapSceneItemVO).index < sceneContainer.numChildren)
								{									
									sceneContainer.setChildIndex(sprite, (fvo as MapSceneItemVO).index);
								}
							}else
							{
								sceneContainer.removeChild(sprite);
								sprite.dispose();
								sprite = null;
								layoutSpriteList.splice(i,1);
							}							
							
						}
					}
					
				}
				
			}
		}
		
		/**更新场景资源列表事件**/
		public function respondToMapEditorUpdateSceneResListEvent(noti:Notification):void
		{
			updataSceneResList();
					
		}
		/**更新场景资源列表**/
		private function updataSceneResList():void
		{
			var len:int = layoutSpriteList.length;
			for(var i:int=len-1;i>=0;i--)
			{
				if(layoutSpriteList[i] is LayoutSprite)
				{
					var sprite:LayoutSprite = layoutSpriteList[i] as LayoutSprite;
					if(sprite)
					{
						var deleBool:Boolean = false;
						if(sprite.parentContainer)
						{
							if(sprite.vo && sprite.vo is MapSceneResItemVO)
							{
								var fVo:MapSceneResItemVO = sprite.vo as MapSceneResItemVO;
								if(fVo && MapEditorDataManager.getInstance().getSceneRes(fVo.id))
								{
									if(sprite.parentContainer is LayoutSpriteContainer)
									{
										var container:LayoutSpriteContainer = sprite.parentContainer as LayoutSpriteContainer;
										if(container)
										{												
											container.setSpriteIndex(sprite, fVo.index);
											
										}
									}
									
								}else
								{
									deleBool = true;
								}
							}
							
							
							
						}else
						{
							deleBool = true;
						}
						
						/**delete**/
						if(deleBool)
						{
							if(sprite.parent)
							{
								sprite.parent.removeChild(sprite);
							}
							sprite.dispose();
							sprite = null;
							layoutSpriteList.splice(i,1);
						}
						
						
						
					}
						
												
				}
				
				
			}
			
			
		}
		
		/**编辑属性事件**/
		public function respondToMapEditorEditPripertiesDateEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data && data.vo)
			{				
				var len:int = layoutSpriteList.length;
				for(var i:int=0;i<len;i++)
				{
					var sprite:LayoutSprite = layoutSpriteList[i] as LayoutSprite;
					if(sprite && sprite.vo && sprite.vo is MapSceneResItemVO)
					{
						if(sprite.vo != data.vo)
						{
							sprite.unClick();
						}
					}
				}
				
			}
		}
		
		/**显示隐藏范围遮罩按钮点击**/
		public function reactToRangeMask_VisibleButtonClick(e:MouseEvent):void
		{
			rangeMask.visible = !rangeMask.visible;
			rangeMask_VisibleButton.label = rangeMask.visible ? "隐藏舞台范围 " : "显示舞台范围 ";
		}
		/**只显示选中层按钮点击**/
		public function reactToOnlyShowSeleSceneButtonClick(e:MouseEvent):void
		{
			onlyShowSeleSceneBool = !onlyShowSeleSceneBool;
			onlyShowSeleSceneButton.label = onlyShowSeleSceneBool ? "显示所有层" : "只显示选中层";
			onlyShowSeleSceneButton.color = onlyShowSeleSceneBool ? 0xCC0000 : 0x333333;
			updateSeleScenStatus();
		}
		/**场景层次列表选择事件**/
		public function respondToMapEditorSelectSceneListEvent(noti:Notification):void
		{
			updateSeleScenStatus();
		}
		/**显示选中层状态更新**/
		private function updateSeleScenStatus():void
		{
			var vo:MapSceneItemVO = get_MapEditorLeftContainerMediator().getSceneSelectedVO();
			
			var len:int = layoutSpriteList.length;
			for(var i:int=0;i<len;i++)
			{
				var sprite:LayoutSpriteContainer = layoutSpriteList[i] as LayoutSpriteContainer;
				if(sprite)
				{
					if(vo)
					{
						if(sprite.vo && sprite.vo is MapSceneItemVO)
						{
							var gVo:MapSceneItemVO = sprite.vo as MapSceneItemVO;
							if(gVo == vo)
							{
								sprite.visible = true;
								
							}else
							{
								sprite.visible = !onlyShowSeleSceneBool;
							}
						}
						
					}else
					{
						sprite.visible = !onlyShowSeleSceneBool;
					}
					
					
				}
			}
		}
		
				
		/** << gets**/
		private function get_MapEditorLeftContainerMediator():MapEditorLeftContainerMediator
		{
			return retrieveMediator(MapEditorLeftContainerMediator.NAME) as MapEditorLeftContainerMediator;
		}
		private function get_MapEditorModuleMediator():MapEditorModuleMediator
		{
			return retrieveMediator(MapEditorModuleMediator.NAME) as MapEditorModuleMediator;
		}
		
		
		
		
	}
}