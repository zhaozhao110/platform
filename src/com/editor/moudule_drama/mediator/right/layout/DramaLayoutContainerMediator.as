package com.editor.moudule_drama.mediator.right.layout
{
	import avmplus.getQualifiedSuperclassName;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILoader;
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.DramaModuleMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.right.layout.DramaLayoutContainer;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutContainer;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutDisplayObject;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewSequenceVO;
	import com.editor.moudule_drama.vo.drama.layout.IDrama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	import com.sandy.utils.LoadContextUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class DramaLayoutContainerMediator extends AppMediator
	{	
		public static const NAME:String = "DramaLayoutContainerMediator";
		
		/**层列表**/
		private var rowContainerList:Array = [];
		/**布局对象列表**/
		private var layoutViewList:Array = [];
		
		/**是否只显示选中层**/
		private var onlyShowSeleSceneButtonBool:Boolean;
		
		/**加载资源列表**/
		private var loadingRes_List:Array = [];		
		/**当前加载资源数据**/
		private var curLoadingData:Drama_LoadingLayoutResData;						
		/**是否正在加载**/
		private var loadingRes_StatusBool:Boolean;
		
		public function DramaLayoutContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaLayoutContainer
		{
			return viewComponent as DramaLayoutContainer;
		}
		/**显示窗口容器**/
		public function get viewContainer():UICanvas
		{
			return mainUI.viewContainer;
		}
		/**舞台遮罩**/
		public function get rangeMask():UICanvas
		{
			return mainUI.rangeMask;
		}
		/**显示隐藏舞台遮罩按钮**/
		public function get rangeMask_VisibleButton():UIButton
		{
			return mainUI.rangeMask_VisibleButton;
		}
		/**只显示选中层按钮**/
		public function get onlyShowSeleSceneButton():UIButton
		{
			return mainUI.onlyShowSeleSceneButton;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			renderTimelineRows()
		}
		
		/**
		 * 加载布局资源
		 *
		 */		
		public function loadSourceByItme(data:Drama_LoadingLayoutResData):void
		{
			loadingRes_List.push(data);
			loadSourceByItmeProcess();
		}
		
		private function loadSourceByItmeProcess():void
		{
			if(loadingRes_StatusBool) return;
			if(loadingRes_List.length <= 0)
			{
				DramaManager.getInstance().get_DramaModuleMediator().addLog2("渲染场景画面结束！");
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
				loadingRes_StatusBool = false;
				
				return;
			}
			
			loadingRes_StatusBool = true;
			curLoadingData = loadingRes_List[0] as Drama_LoadingLayoutResData;
			if(!curLoadingData)
			{
				DramaManager.getInstance().get_DramaModuleMediator().addLog2("加载数据为空，跳过！");
				loadingNextData();
				return;
			}
			
			
			
			
			/**开始加载**/
			
			var loader:UILoader;
			if(curLoadingData.fileType == DramaConst.file_jpg)
			{
				if(curLoadingData.loadingType == DramaConst.loading_background)
				{
					loader = new UILoader();
					loader.complete_fun = loadSourceComplete;
					loader.ioError_fun = loadSourceError;
					loader.load(curLoadingData.fileUrl);
				}else
				{
					loader = new UILoader();
					loader.complete_fun = loadSourceComplete;
					loader.ioError_fun = loadSourceError;
					loader.load(DramaManager.getResFilePath(curLoadingData.loading_resInfoItemVO.type));
				}
			}else
			{
				var subpath:String = DramaManager.getResSubpath(curLoadingData.loading_resInfoItemVO.type);
				var fileName:String ;
				if(curLoadingData.loading_resInfoItemVO.type == 1){
					fileName = "1003.swf";
				}else{
					fileName = curLoadingData.loading_resInfoItemVO.id + ".swf";
				}
				var resUrl:String = DramaConfig.currProject.mapResUrl + subpath + fileName;
				curLoadingData.loading_url = resUrl;
				var className:String = DramaManager.getResClassName(curLoadingData.loading_resInfoItemVO.id, curLoadingData.loading_resInfoItemVO.type);
				DramaManager.getInstance().get_DramaModuleMediator().addLog2("load source at: " + resUrl);
				
				if(iResource.haveClass(className))
				{
					processRes(curLoadingData);
					loadingNextData();
					
				}else
				{
					var loadData:ILoadSourceData = iResource.getLoadSourceData();
					loadData.url = resUrl;
					loadData.type = LoadQueueConst.swf_type;
					loadData.loadSwf_contextType = LoadContextUtils.TARGET_SAME;
					loadData.cacheMode = LoadQueueConst.sourceCache_mode1
					
					var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
					dt.sourceData = loadData;
					dt.loadCompleteF = loadSourceComplete;
					dt.loadErrorF = loadSourceError;
					iResource.loadSingleResource(dt);
				}
			}
			
		}
				
		private function loadSourceComplete(e:*=null):void
		{
			if(curLoadingData.fileType == DramaConst.file_jpg)
			{
				var displayObj:DisplayObject = e as DisplayObject;
				if(displayObj)
				{
					processRes(curLoadingData, displayObj);
				}
				
			}else
			{
				var className:String = DramaManager.getResClassName(curLoadingData.loading_resInfoItemVO.id, curLoadingData.loading_resInfoItemVO.type);
				if(iResource.getClass(className))
				{
					processRes(curLoadingData);
					
				}else
				{
					if(curLoadingData && curLoadingData.loading_resInfoItemVO)
					{
						DramaManager.getInstance().get_DramaModuleMediator().addLog2("获取资源定义失败：" + curLoadingData.loading_resInfoItemVO.name1+":" + className + "::" + curLoadingData.loading_url);
					}
				}
			}
			
			loadingNextData();
		}
		private function loadSourceError(e:*=null):void
		{
			showMessage("加载资源失败!");
			loadingNextData();
		}
		
		/**完成开始下一个加载**/
		private function loadingNextData():void
		{
			viewContainer.setChildIndex(rangeMask, viewContainer.numChildren-1);
			
			removeCurLoadingItem();
			loadingRes_StatusBool = false;
			loadSourceByItmeProcess();
		}
		
		private function removeCurLoadingItem():void
		{			
			var len:int = loadingRes_List.length;
			for(var i:int=0;i<len;i++)
			{
				var data:Drama_LoadingLayoutResData = loadingRes_List[i] as Drama_LoadingLayoutResData;
				if(data)
				{
					if(data == curLoadingData)
					{
						loadingRes_List.splice(i,1);							
						curLoadingData = null;
						break;
					}
					
				}
			}
			curLoadingData = null;
		}
		
		/**处理加载好的资源**/
		private function processRes(loadingData:Drama_LoadingLayoutResData, spriteRes:DisplayObject=null):void
		{
			var vo:IDrama_LayoutViewBaseVO = loadingData.loading_layoutViewVO;
			var propVO:ITimelineViewProperties_BaseVO = loadingData.loading_propertyVO;
			var keyframeVO:Drama_FrameResRecordVO = loadingData.loading_keyframeVO as Drama_FrameResRecordVO;
			
			var resInfoType:int;
			var className:String = "";
			if(loadingData.loading_resInfoItemVO)
			{
				resInfoType = loadingData.loading_resInfoItemVO.type;
				className = DramaManager.getResClassName(loadingData.loading_resInfoItemVO.id, loadingData.loading_resInfoItemVO.type);
			}else
			{
//				showMessage("资源未配置！");
			}
			
			
			var getClass:Class = iResource.getClass(className);
			var classType:String;
			
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			var mc:MovieClip;
			
			var container:DLayoutContainer;
			var sprite:DLayoutSprite;
			
			
			
			/**添加背景**/
			if(loadingData.loadingType == DramaConst.loading_background)
			{
				if(loadingData.fileType == DramaConst.file_jpg)
				{
					if(loadingData.loading_keyframeVO && loadingData.loading_keyframeVO is Drama_FrameSceneVO)
					{
						/**类型1为场景层**/
						container = getTimelineRowById(DramaDataManager.frameRow1);
						if(container)
						{
							if(!DramaLayoutContainerManager.visiFrameSceneBg(container, (loadingData.loading_keyframeVO as Drama_FrameSceneVO)))
							{
								if(spriteRes)
								{
									sprite = new DLayoutSprite();
									sprite.addRes(spriteRes);
									sprite.ident = (loadingData.loading_keyframeVO as Drama_FrameSceneVO).sceneBackgroundSourceId.toString();																		
									sprite.parentContainer = container;									
//									sprite.y = ((DramaConst.layoutSceneContainerH - spriteRes.height)/2);
									sprite.mouseEnabled = false;
									sprite.mouseChildren = false;
									sprite.locked = 1;
									//sprite.background_red = true;
									
									container.width = spriteRes.width;
									container.height = spriteRes.height;
									container.addSprite(sprite);
									
									DramaLayoutContainerManager.addToFrameSceneBgList(sprite);
								}
								
								
							}
						}
					}
					
					return;
					
					
				}else if(loadingData.fileType == DramaConst.file_swfDefinition)
				{
					if(loadingData.loading_resInfoItemVO.type == 9)
					{
						if(loadingData.loading_keyframeVO && loadingData.loading_keyframeVO is Drama_FrameSceneVO)
						{
							/**类型1为场景层**/
							container = getTimelineRowById(DramaDataManager.frameRow1);
							if(container)
							{
								if(!DramaLayoutContainerManager.visiFrameSceneBg(container, (loadingData.loading_keyframeVO as Drama_FrameSceneVO)))
								{
									bitmapData = new getClass() as BitmapData;
									if(bitmapData)
									{
										bitmap = new Bitmap(bitmapData);
										if(bitmap)
										{
											sprite = new DLayoutSprite();
											sprite.addRes(bitmap);
											sprite.ident = (loadingData.loading_keyframeVO as Drama_FrameSceneVO).sceneBackgroundSourceId.toString();																		
											sprite.parentContainer = container;									
											sprite.y = ((DramaConst.layoutSceneContainerH - bitmapData.height)/2);
											sprite.mouseEnabled = false;
											sprite.mouseChildren = false;
											sprite.locked = 1;
											
											container.width = bitmapData.width;
											container.height = bitmapData.height;
											container.addSprite(sprite);
											
											DramaLayoutContainerManager.addToFrameSceneBgList(sprite);
											
										}
									}
								}
							}
						}
						
						return;
					}
				}
			}
			
			
			/**特殊	添加武器**/
//			if(loadingData.loading_resInfoItemVO.type == 7)
//			{
//				if(loadingData.loading_propertyVO)
//				{
//					var getLayout:DLayoutSprite = getLayoutViewById(loadingData.loading_propertyVO.targetId) as DLayoutSprite;
//					if(getLayout)
//					{
//						bitmapData = new getClass() as BitmapData;
//						if(bitmapData)
//						{
//							bitmapData = DramaManager.getRoleStaticBitmapData(bitmapData, loadingData.loading_resInfoItemVO);
//							bitmap = new Bitmap(bitmapData);
//							if(bitmap)
//							{
//								getLayout.addResReplaceIndex(bitmap, 1);
//								Drama_PropertiesRoleVO(loadingData.loading_propertyVO).armId = loadingData.loading_resInfoItemVO.id;
//								Drama_PropertiesRoleVO(loadingData.loading_propertyVO).armName = loadingData.loading_resInfoItemVO.name1;
//								vo = getLayoutViewById(loadingData.loading_propertyVO.targetId).vo as Drama_LayoutViewBaseVO;
//								sendNotification(DramaEvent.drama_editViewProperties_event, {vo:vo});
//							}
//						}
//					}
//				}
//				
//				return;
//			}
						
			
			/**特殊	添加影片**/
			if(loadingData.loading_resInfoItemVO.type == 12)
			{
				
				
				return;
			}
			
			/**创建布局显示对象数据**/
			if(!vo)
			{
				if(keyframeVO)
				{
					vo = DramaManager.createNewLayoutViewVO(loadingData);
					if(vo)
					{
						if(!propVO)
						{
							propVO = DramaManager.createNewPropertiesVO(loadingData.loading_resInfoItemVO);							
						}
						if(propVO)
						{
							(propVO as Drama_PropertiesBaseVO).placeFrameVO = keyframeVO;
							keyframeVO.addProperty(propVO as Drama_PropertiesBaseVO);
						}
						
						DramaDataManager.getInstance().addLayoutView(vo);
						sendNotification(DramaEvent.drama_addNewLayoutViewToKeyFrame_event, {keyframeVO:loadingData.loading_keyframeVO});
					}
					
				}else
				{
					var resName:String = loadingData.loading_resInfoItemVO ? loadingData.loading_resInfoItemVO.name1 : "";
					showMessage("必须在关键帧上添加资源：" + resName);
					return;
				}
				
			}
			/**创建布局显示对象**/		
			if(vo)
			{
				container = getTimelineRowById(vo.rowId);
				if(container)
				{
					sprite = new DLayoutSprite();
					sprite.vo = vo;
					sprite.onStopDragFunc = onLayoutSpriteStopDragHandle;
					sprite.onClickedFunc = onLayoutSpriteClickHandle;
					sprite.onDoubleClickedFunc = onLayoutSpriteDoubleClickHandle;
					if(vo is Drama_LayoutViewSequenceVO) sprite.isBottomCoordModel = true;
					
					if(propVO)
					{
						propVO.targetId = vo.id;
						sprite.x = propVO.x;
						sprite.y = propVO.y;
						sprite.scaleX = propVO.scaleX;
						sprite.scaleY = propVO.scaleY;
						sprite.rotation = propVO.rotation;
						
						if(sprite.parentContainer)
						{
							sprite.parentContainer.removeChild(sprite);
						}
					}
					
					
					vo.fileType = loadingData.fileType;
					/**生成资源**/
					if(loadingData.fileType == DramaConst.file_jpg)
					{
						if(spriteRes)
						{
							sprite.addRes(spriteRes);
						}
						
					}else
					{
						if(getClass)
						{
							classType = getQualifiedSuperclassName(getClass).split("::")[1];			
							if(classType && classType == "BitmapData")
							{
								bitmapData = new getClass() as BitmapData;
								if(bitmapData)
								{
									if(vo is Drama_LayoutViewSequenceVO)
									{
										bitmapData = DramaManager.getRoleStaticBitmapData(bitmapData, loadingData.loading_resInfoItemVO);
									}
									
									if(bitmapData)
									{
										bitmap = new Bitmap(bitmapData);
										sprite.addRes(bitmap);
									}else
									{
										showMessage("加载资源失败");
									}
								}
								
							}else if(classType == "MovieClip")
							{
								mc = new getClass() as MovieClip;
								sprite.addRes(mc);
							}
						}
					}
					
					
					
					
					
					container.addSprite(sprite);
					sprite.parentContainer = container;
					layoutViewList.push(sprite);
					if(loadingData.loading_selectedStatus > 0)
					{
						sprite.doClick();
						onLayoutSpriteClickHandle(sprite);
					}
					
				}
				
			}
		}
		
		/**拖动布局对象完成	触发函数**/
		private function onLayoutSpriteStopDragHandle(sprite:DLayoutSprite):void
		{
			if(sprite)
			{
				var layoutVO:Drama_LayoutViewBaseVO = sprite.vo as Drama_LayoutViewBaseVO;
				if(layoutVO)
				{
					var propertyVO:Drama_PropertiesBaseVO = DramaDataManager.getInstance().getLayoutPropertiesVOByLayoutVO(layoutVO);
					if(propertyVO)
					{
						propertyVO.x = sprite.x;
						propertyVO.y = sprite.y;
					}
				}
			}
		}
		/**点击布局对象	触发函数**/
		private function onLayoutSpriteClickHandle(sprite:DLayoutSprite):void
		{
			if(sprite)
			{
				sendAppNotification(DramaEvent.drama_selectedView_event, {target:sprite, vo:sprite.vo});
				
				var len:int = layoutViewList.length;
				for(var i:int=0;i<len;i++)
				{
					var pSprite:DLayoutSprite = layoutViewList[i] as DLayoutSprite;
					if(pSprite)
					{
						if(pSprite != sprite)
						{							
							pSprite.unClick();
						}
					}
						
				}
				
			}
		}
		/**所有设置为未选状态**/
		public function unClickAllSprite():void
		{
			var len:int = layoutViewList.length;
			for(var i:int=0;i<len;i++)
			{
				var pSprite:DLayoutSprite = layoutViewList[i] as DLayoutSprite;
				if(pSprite)
				{							
					pSprite.unClick();
				}
				
			}
		}
		
		/**清空布局对象**/
		public function clearLayoutView():void
		{
			var a:Array = layoutViewList;
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var layout:DLayoutSprite = a[i] as DLayoutSprite;
				if(layout)
				{
					if(layout.parentContainer)
					{
						layout.parentContainer.removeSprite(layout);						
					}
					layout.dispose();
					layout = null;
					
					a.splice(i,1);
				}
			}
		}
		
		/**删除布局对象	in layoutViewList**/
		public function removeLayoutViewByVO(vo:Drama_LayoutViewBaseVO):void
		{
			var a:Array = layoutViewList;
			var len:int = a.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var layout:DLayoutSprite = a[i] as DLayoutSprite;
				if(layout)
				{
					if(layout.ident == vo.id)
					{
						if(layout.parentContainer)
						{
							layout.parentContainer.removeSprite(layout);
							layout.dispose();
							layout = null;
							
							a.splice(i,1);
						}
					}
				}
			}
		}
			
		/**双击布局对象	触发函数**/
		private function onLayoutSpriteDoubleClickHandle(sprite:DLayoutSprite):void
		{
			if(sprite)
			{
				var layoutVO:Drama_LayoutViewBaseVO = sprite.vo as Drama_LayoutViewBaseVO;
				if(layoutVO)
				{
					var propertyVO:Drama_PropertiesBaseVO = DramaDataManager.getInstance().getLayoutPropertiesVOByLayoutVO(layoutVO);
					if(propertyVO)
					{
						propertyVO.locked = (propertyVO.locked > 0) ? 0 : 1;
						resetLayoutViewByPropertiesVO(propertyVO);
						sendAppNotification(DramaEvent.drama_selectedView_event, {target:sprite, vo:sprite.vo});
					}
				}
			}
		}
		
		/** <<更新布局对象**/
		private function updataLayoutViewsList():void
		{
			/**资源层**/
			var len:int = layoutViewList.length;
			for(var i:int=0;i<len;i++)
			{
				var sprite:DLayoutSprite = layoutViewList[i] as DLayoutSprite;
				if(sprite)
				{
					var spVO:Drama_LayoutViewBaseVO = sprite.vo as Drama_LayoutViewBaseVO;
					if(spVO)
					{
						var propertyVO:Drama_PropertiesBaseVO = DramaDataManager.getInstance().getLayoutPropertiesVOByLayoutVO(spVO);
						if(propertyVO)
						{
							sprite.visible = true;
							
							sprite.x = propertyVO.x;
							sprite.y = propertyVO.y;
							sprite.scaleX = propertyVO.scaleX;
							sprite.scaleY = propertyVO.scaleY;
							sprite.rotation = propertyVO.rotation;
							sprite.locked = propertyVO.locked;
							sprite.alpha = propertyVO.alpha;
							if(sprite.parentContainer)
							{
								sprite.parentContainer.setSpriteIndex(sprite, propertyVO.index);
							}
							
							/**角色对象翻转**/
							if(propertyVO is Drama_PropertiesRoleVO)
							{
								if((propertyVO as Drama_PropertiesRoleVO).direction > 0)
								{
									sprite.hConversionBool = 1;
								}else
								{
									sprite.hConversionBool = 0;
								}
							}
							
						}else
						{ 
							sprite.visible = false;
						}
						
					}
				}
			}
			
			/**场景层	id=1**/
			var container:DLayoutContainer = getTimelineRowById(DramaDataManager.frameRow1);
			if(container)
			{
				var sceneFrameVo:Drama_FrameSceneVO = DramaDataManager.getInstance().getCurrentRangeKeyframeByPlace(DramaDataManager.frameRow1, DramaDataManager.getInstance().selectedFrame) as Drama_FrameSceneVO;
				DramaLayoutContainerManager.visiFrameSceneBg(container, sceneFrameVo);
			}
			
			
		}
		/**通过显示对象属性VO重置显示对象**/
		private function resetLayoutViewByPropertiesVO(pvo:Drama_PropertiesBaseVO):void
		{
			if(pvo)
			{
				var target:DLayoutSprite = getLayoutViewById(pvo.targetId) as DLayoutSprite;
				if(target)
				{
					target.x = pvo.x;
					target.y = pvo.y;
					target.scaleX = pvo.scaleX;
					target.scaleY = pvo.scaleY;
					target.rotation = pvo.rotation;
					target.locked = pvo.locked;
					target.alpha = pvo.alpha;
					if(target.parentContainer)
					{
						target.parentContainer.setSpriteIndex(target, pvo.index);
					}
					/**角色对象翻转**/
					if(pvo is Drama_PropertiesRoleVO)
					{
						if((pvo as Drama_PropertiesRoleVO).direction > 0)
						{
							target.hConversionBool = 1;
						}else
						{
							target.hConversionBool = 0;
						}
					}
				}
			}
		}
		
		/**选择一个帧事件 body:{rowId:层id, frame:帧数} **/
		public function respondToDramaSelectOneFrameEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data)
			{
				if(data.rowId && data.frame)
				{
					updataLayoutViewsList();
				}
			}
		}
		/**显示对象属性改变事件 body{vo:显示对象属性VO}**/
		public function respondToDramaViewPropertiesChangeEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data)
			{
				if(data.vo)
				{
					var pvo:Drama_PropertiesBaseVO = data.vo as Drama_PropertiesBaseVO;
					if(pvo)
					{
						resetLayoutViewByPropertiesVO(pvo);
					}
				}
			}
		}
		/**更新布局显示对象事件**/
		public function respondToDramaUpdataLayoutViewListEvent(noti:Notification):void
		{
			updataLayoutViewsList();
		}
		
		/**  << 渲染所有时间轴 层**/
		private function renderTimelineRows():void
		{
			var a:Array = DramaDataManager.getInstance().getRowListArray();
			a.sortOn("index", Array.NUMERIC);
			var len:int = a.length;
			
			for(var i:int=0;i<len;i++)
			{
				var rVO:Drama_RowVO = a[i] as Drama_RowVO;
				if(rVO)
				{
					var container:DLayoutContainer = new DLayoutContainer();
					container.vo = rVO;
					viewContainer.addChild(container);
					viewContainer.setChildIndex(container, rVO.index);
					
					rowContainerList.push(container);
				}
			}
						
		}
		
		/**获取时间轴 层**/
		private function getTimelineRowById(id:String):DLayoutContainer
		{
			var outContainer:DLayoutContainer;
			
			var len:int = rowContainerList.length;
			for(var i:int=0;i<len;i++)
			{
				var container:DLayoutContainer = rowContainerList[i] as DLayoutContainer;
				if(container)
				{
					var cVO:Drama_RowVO = container.vo as Drama_RowVO;
					if(cVO.id == id)
					{
						outContainer = container;
						break;
					}
				}
			}
			
			return outContainer;
		}
		
		
		/** << clicks**/
		
		/**显示隐藏舞台遮罩按钮点击**/
		public function reactToRangeMask_VisibleButtonClick(e:MouseEvent):void
		{
			rangeMask.visible = !rangeMask.visible;
			rangeMask_VisibleButton.label = rangeMask.visible ? "隐藏舞台范围" : "显示舞台范围";
			
		}
		/**显示选中层按钮点击**/
		public function reactToOnlyShowSeleSceneButtonClick(e:MouseEvent):void
		{
			onlyShowSeleSceneButtonBool = !onlyShowSeleSceneButtonBool;
			onlyShowSeleSceneButton.label = onlyShowSeleSceneButtonBool ? "显示所有层" : "只显示选中层";
		}
		
		/** << gets**/
		/**获取显示对象 by vo**/
		public function getLayoutViewByVO(pVO:Drama_LayoutViewBaseVO):DLayoutSprite
		{
			var outSprite:DLayoutSprite;
			
			var len:int = layoutViewList.length;
			for(var i:int=0;i<len;i++)
			{
				var sp:DLayoutSprite = layoutViewList[i] as DLayoutSprite;
				if(sp.vo == pVO)
				{
					outSprite = sp;
					break;
				}
			}
			
			return outSprite;
		}
		
		/**获取显示对象 by id**/
		public function getLayoutViewById(id:String):DLayoutSprite
		{
			var outSprite:DLayoutSprite;
			
			var len:int = layoutViewList.length;
			for(var i:int=0;i<len;i++)
			{
				var sp:DLayoutSprite = layoutViewList[i] as DLayoutSprite;
				if(sp.ident == id)
				{
					outSprite = sp;
					break;
				}
			}
			
			return outSprite;
		}
				
	}
}