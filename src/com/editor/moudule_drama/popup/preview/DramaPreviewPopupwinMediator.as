package com.editor.moudule_drama.popup.preview
{
	import avmplus.getQualifiedSuperclassName;
	
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILoader;
	import com.editor.component.controls.UIText;
	import com.editor.mediator.AppMediator;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Container;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Movie;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_RowLayer;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Sprite;
	import com.editor.moudule_drama.popup.preview.component.rowLayers.DramaPreview_RowLayerDialog;
	import com.editor.moudule_drama.popup.preview.component.rowLayers.DramaPreview_RowLayerMovie;
	import com.editor.moudule_drama.popup.preview.component.rowLayers.DramaPreview_RowLayerResRecord;
	import com.editor.moudule_drama.popup.preview.component.rowLayers.DramaPreview_RowLayerScene;
	import com.editor.moudule_drama.popup.preview.manager.DramaPreviewManager;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewSequenceVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class DramaPreviewPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "DramaPreviewPopupwinMediator";
		
		public function DramaPreviewPopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get mainUI():DramaPreviewPopupwin
		{
			return viewComponent as DramaPreviewPopupwin;
		}
		/**预览区**/
		public function get previewContainer():DramaPreview_Container
		{
			return mainUI.previewContainer;
		}
		/**当前帧**/
		public function get frameTxt():UIText
		{
			return mainUI.frameTxt;
		}
		/**按钮容器**/
		public function get buttonContainer():UIHBox
		{
			return mainUI.buttonContainer;
		}
		/**重播按钮**/
		public function get replayButton():UIButton
		{
			return mainUI.replayButton;
		}
		/**关闭按钮**/
		public function get closeButton2():UIButton
		{
			return mainUI.closeButton2;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			showReflash();
		}
		
		private function showReflash():void
		{
			renderView();
		}
		
		/**渲染**/
		private function renderView():void
		{
			previewContainer.keyframeList = DramaDataManager.getInstance().joinFrameClip_keyframeList();
			renderRows();
			renderSprites();
			
			previewContainer.run();
		}
		
		/**渲染层**/
		private function renderRows():void
		{
			var a:Array = DramaDataManager.getInstance().getRowListArray();
			a.sortOn("index", Array.NUMERIC);
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var layer:DramaPreview_RowLayer;
				var rowVO:Drama_RowVO = a[i] as Drama_RowVO;
				if(rowVO)
				{
					/**1场景层、2资源层、3影片层、4对话层**/
					switch(rowVO.type)
					{
						case 1:
							layer = new DramaPreview_RowLayerScene();
							break;
						case 2:
							layer = new DramaPreview_RowLayerResRecord();
							break;
						case 3:
							layer = new DramaPreview_RowLayerMovie();
							break;
						case 4:
							layer = new DramaPreview_RowLayerDialog();
							break;
							
						default:
							break;
					}
					
					layer.vo = rowVO;
					previewContainer.addChild(layer);
				}
			}
		}
		
		/**渲染资源**/
		private function renderSprites():void
		{
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			var mc:MovieClip;
			
			/**场景层**/
			renderSpritesScene();
			
			/**资源层**/
			var a:Array = DramaDataManager.getInstance().joinFrameClip_layoutViewList();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var lVO:Drama_LayoutViewBaseVO = a[i] as Drama_LayoutViewBaseVO;
				if(lVO)
				{
					var containerLayer:DramaPreview_RowLayer = previewContainer.getRowLayerById(lVO.rowId);
					if(containerLayer)
					{
						var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(lVO.sourceId);
						if(resInfoItem)
						{
							var sprite:DramaPreview_Sprite = new DramaPreview_Sprite();
							sprite.vo = lVO;								
							if(lVO is Drama_LayoutViewSequenceVO)
							{
								sprite.isBottomCoordModel = true;
							}
							
							
							if(lVO.fileType == DramaConst.file_jpg)
							{
								var loader:UILoader = new UILoader();
								loader.complete_args = [loader, sprite];
								loader.complete_fun = loaderCompleteHandle;
								loader.load(DramaManager.getResFilePath(resInfoItem.type));
								sprite.addRes(loader);
								
								containerLayer.layoutList.push(sprite);
								
							}else
							{
								var className:String = DramaManager.getResClassName(resInfoItem.id, resInfoItem.type);
								var getClass:Class = iResource.getClass(className);
								if(getClass)
								{
									var classType:String = getQualifiedSuperclassName(getClass).split("::")[1];
									if(classType && classType == "BitmapData")
									{
										bitmapData = new getClass() as BitmapData;
										if(bitmapData)
										{
											bitmapData = DramaManager.getRoleStaticBitmapData(bitmapData, resInfoItem);									
											if(bitmapData)
											{
												bitmap = new Bitmap(bitmapData);											
												sprite.addRes(bitmap);
												
												containerLayer.layoutList.push(sprite);
											}
										}
										
									}else if(classType == "MovieClip")
									{
										mc = new getClass() as MovieClip;
										sprite.addRes(mc);
										UIComponentUtil.stopAllInMovieClip(mc);
										
										containerLayer.layoutList.push(sprite);
									}
								}
							}					
						}
						
					}
										
				}
			}
			
			/**影片层**/
			renderSpritesMovie();
			
			/**对话层**/
			
					
		}
		
		private function loaderCompleteHandle(arg:Array):void
		{
			if(arg)
			{
				var loader:UILoader;
				var sprite:DramaPreview_Sprite;
				if(arg.length > 0) loader = arg[0] as UILoader;
				if(arg.length > 1) sprite = arg[1] as DramaPreview_Sprite;
				if(loader && sprite)
				{
					sprite.updatePosition();
				}
			}
				
			
		}
		
		/**渲染资源	场景层**/
		private function renderSpritesScene():void
		{
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
						
			var containerLayer:DramaPreview_RowLayer = previewContainer.getRowLayerById(DramaDataManager.frameRow1);
			if(containerLayer)
			{
				var a:Array = previewContainer.getKeyframes_ByRowId(DramaDataManager.frameRow1);
				a = DramaPreviewManager.getSceneDefLayerSourceIdList_ByKeyframeList(a);
				var len:int = a.length;
				for(var i:int=0;i<len;i++)
				{
					var sceneDefLayerSourceId:int = int(a[i]);
					
					var sprite:DramaPreview_Sprite = new DramaPreview_Sprite();
					sprite.ident = sceneDefLayerSourceId + "";
					containerLayer.layoutList.push(sprite);
					
					
					if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_pictrue)
					{
						var loader:UILoader = new UILoader();
						loader.load(DramaConfig.currProject.mapResUrl+ "map/" + sceneDefLayerSourceId + ".jpg");
						sprite.addRes(loader);
						
					}else if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_inXMLByDefinition)
					{
						var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(sceneDefLayerSourceId);
						if(resInfoItem)
						{
							var className:String = DramaManager.getResClassName(resInfoItem.id, resInfoItem.type);
							var getClass:Class = iResource.getClass(className);
							if(getClass)
							{
								var classType:String = getQualifiedSuperclassName(getClass).split("::")[1];
								if(classType && classType == "BitmapData")
								{
									bitmapData = new getClass() as BitmapData;
									if(bitmapData)
									{
										bitmapData = DramaManager.getRoleStaticBitmapData(bitmapData, resInfoItem);									
										if(bitmapData)
										{
											bitmap = new Bitmap(bitmapData);											
											sprite.addRes(bitmap);
										}
									}
								}
							}
						}
					}
						
				}
			}
			
		}
		
		/**渲染资源	影片层**/
		private function renderSpritesMovie():void
		{
			var containerLayer:DramaPreview_RowLayer = previewContainer.getRowLayerById(DramaDataManager.frameRow3);
			if(containerLayer)
			{
				var a:Array = previewContainer.getKeyframes_ByRowId(DramaDataManager.frameRow3);
				a = DramaPreviewManager.getMovieSourceIdList_ByKeyframeList(a);
				var len:int = a.length;
				for(var i:int=0;i<len;i++)
				{
					var movieSId:int = int(a[i]);					
					var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(movieSId);
					if(resInfoItem)
					{
						var className:String = DramaManager.getResClassName(resInfoItem.id, resInfoItem.type);
						var getClass:Class = iResource.getClass(className);
						if(getClass)
						{
							var classType:String = getQualifiedSuperclassName(getClass).split("::")[1];
							if(classType && classType == "MovieClip")
							{
								var mc:MovieClip = new getClass() as MovieClip;
								if(mc)
								{
									var movie:DramaPreview_Movie = new DramaPreview_Movie();
									movie.movie = mc;
									movie.ident = movieSId + "";
									containerLayer.layoutList.push(movie);
								}
							}
						}
					}
				}
			}
		}
		
				
		
		/** << clicks**/
		
		/**重播按钮点击**/
		public function reactToReplayButtonClick(e:MouseEvent):void
		{
			previewContainer.run();
		}
		
		/**关闭按钮点击**/
		public function reactToCloseButton2Click(e:MouseEvent):void
		{
			closeWin();
		}
		
		/**关闭窗口**/
		override public function delPopwin() : void
		{
			super.delPopwin();
			
			sendNotification(DramaEvent.drama_updataTimeline_event);
			sendNotification(DramaEvent.drama_updataLayoutViewList_event);
			
		}
		
		
	}
}