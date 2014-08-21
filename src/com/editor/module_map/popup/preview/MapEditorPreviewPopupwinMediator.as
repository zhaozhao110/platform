package com.editor.module_map.popup.preview
{
	import avmplus.getQualifiedSuperclassName;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.popup.preview.component.PreviewSceneContainer;
	import com.editor.module_map.popup.preview.component.PreviewSceneLayer;
	import com.editor.module_map.popup.preview.component.PreviewSceneSprite;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class MapEditorPreviewPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "MapEditorPreviewPopupwinMediator";
				
		public function MapEditorPreviewPopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get mainUI():MapEditorPreviewPopupwin
		{
			return viewComponent as MapEditorPreviewPopupwin;
		}
		public function get sceneContainer():PreviewSceneContainer
		{
			return mainUI.sceneContainer;
		}
		public function get moveLButton():UIButton
		{
			return mainUI.moveLButton;
		}
		public function get moveRButton():UIButton
		{
			return mainUI.moveRButton;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			showReflash();		
		}
		
		private function showReflash():void
		{
						
			renderView();
			
			moveLButton.removeEventListener(MouseEvent.MOUSE_DOWN, moveLMouseDownHandle);
			moveLButton.removeEventListener(MouseEvent.MOUSE_UP, moveLMouseUpHandle);
			moveRButton.removeEventListener(MouseEvent.MOUSE_DOWN, moveRMouseDownHandle);
			moveRButton.removeEventListener(MouseEvent.MOUSE_UP, moveRMouseUpHandle);
			
			moveLButton.addEventListener(MouseEvent.MOUSE_DOWN, moveLMouseDownHandle);
			moveLButton.addEventListener(MouseEvent.MOUSE_UP, moveLMouseUpHandle);
			moveRButton.addEventListener(MouseEvent.MOUSE_DOWN, moveRMouseDownHandle);
			moveRButton.addEventListener(MouseEvent.MOUSE_UP, moveRMouseUpHandle);
			
		}
		/**渲染**/
		private function renderView():void
		{
			renderSceneLayers();
			renderSceneSprites();
			
			sceneContainer.run();
					
			
		}
		/**渲染层**/
		private function renderSceneLayers():void
		{
			var defaultVo:MapSceneItemVO = getDefaultLayerVo();
			
			var a:Array = MapEditorDataManager.getInstance().getSceneArray();
			a.reverse();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var vo:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(vo)
				{					
					var sceneLayer:PreviewSceneLayer = new PreviewSceneLayer();
					sceneLayer.sceneId = vo.sourceId;
					sceneLayer.isDefault = vo.isDefault;
					sceneLayer.x = vo.x; sceneLayer.y = vo.y;
					sceneLayer.width = vo.width; sceneLayer.height = vo.height;
					sceneLayer.setVerticalMoveQueue(vo.verticalMoveQueue);
					sceneLayer.setRotationMoveQueue(vo.rotationMoveQueue);
					sceneLayer.useHDefaultSpeed = vo.useHDefaultSpeed;
					if(vo.useHDefaultSpeed > 0)
					{
						if(vo.isDefault)
						{
							sceneLayer.horirontalMoveSpeed = vo.horizontalSpeed;
						}else
						{
							var moveFrames:Number = (defaultVo.width - MapConst.layoutSceneContainerW)/defaultVo.horizontalSpeed;
							sceneLayer.horirontalMoveSpeed = (vo.width - MapConst.layoutSceneContainerW)/moveFrames;							
						}
					
					}
					else
					{
						sceneLayer.horirontalMoveSpeed = vo.horizontalSpeed;						
					}
					
					sceneContainer.addLayer(sceneLayer);
				}
				
			}						
			
		}
		private function getDefaultLayerVo():MapSceneItemVO
		{
			var outVo:MapSceneItemVO;
			
			var a:Array = MapEditorDataManager.getInstance().getSceneArray();
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var vo:MapSceneItemVO = a[i] as MapSceneItemVO;
				if(vo)
				{
					if(vo.isDefault)
					{
						outVo = vo;
						break;
					}
				}
			}
			return outVo;
		}
		/**渲染资源**/
		private function renderSceneSprites():void
		{
			var a:Array = MapEditorDataManager.getInstance().getSceneResArray();
			a.reverse();
			var len:int = a.length;
			for(var j:int=0;j<len;j++)
			{
				var vo:MapSceneResItemVO = a[j] as MapSceneResItemVO;
				if(vo)
				{
					var className:String = MapEditorManager.getResClassName(int(vo.sourceId), vo.sourceType);
					var getClass:Class = iResource.getClass(className);					
					if(getClass)
					{
						var classType:String = getQualifiedSuperclassName(getClass).split("::")[1];
						var bitmapData:BitmapData;
						if(classType == "BitmapData")
						{
							bitmapData = new getClass() as BitmapData;
						}
						
						var layerId:String = vo.sceneId;
						var layer:PreviewSceneLayer = sceneContainer.getLayerById(layerId);
						if(layer)
						{
							var sceneSprite:PreviewSceneSprite = new PreviewSceneSprite();
							sceneSprite.x = vo.x; sceneSprite.y = vo.y;
							if(vo is MapSceneResItemNpcVO)
							{
								sceneSprite.x = vo.x - (bitmapData.width/2);
								sceneSprite.y = vo.y - bitmapData.height;
							}
							sceneSprite.scaleX = vo.scaleX;
							sceneSprite.scaleY = vo.scaleY;
							sceneSprite.rotation = vo.rotation;
														
							if(classType == "BitmapData")
							{
								var bitmap:Bitmap = new Bitmap(bitmapData);
								if(vo.type == 9)
								{
									//								bitmap.smoothing = true;
									var m:Matrix = new Matrix();
									m.scale(1.001, 1.001); // 稍微放大強迫抗鋸齒
									m.rotate(0.001221); // 極小的旋轉量強迫抗鋸齒
									bitmap.transform.matrix = m;									
								}								
								sceneSprite.addRes(bitmap);
								sceneSprite.startFrame = -1;
								
							}else if(classType == "MovieClip")
							{
								var mc:MovieClip = new getClass() as MovieClip;								
								sceneSprite.addRes(mc);
								sceneSprite.startFrame = 0;
								if(vo is MapSceneResItemEffVO)
								{
									sceneSprite.startFrame = (vo as MapSceneResItemEffVO).startFrame;
								}
								if(sceneSprite.startFrame > 0)
								{
									mc.stop();
									UIComponentUtil.stopAllInMovieClip(mc);									
								}
							}
							
							layer.addSprite(sceneSprite);
														
						}						
					}
					
				}
			}
			
		}
		
		/**向左移动按钮 Down**/
		private function moveLMouseDownHandle(e:MouseEvent):void
		{
			sceneContainer.moveStatus = 1;
		}
		/**向左移动按钮 Up**/
		private function moveLMouseUpHandle(e:MouseEvent):void
		{
			sceneContainer.moveStatus = 0;
		}
		/**向右移动按钮 Down**/
		private function moveRMouseDownHandle(e:MouseEvent):void
		{
			sceneContainer.moveStatus = 2;
		}
		/**向右移动按钮 Up**/
		private function moveRMouseUpHandle(e:MouseEvent):void
		{
			sceneContainer.moveStatus = 0;
		}
		
		
		/**关闭窗口**/
		override public function callDelPopWin():void
		{
			sceneContainer.stop();
			sceneContainer.clear();			
		}
		
		
	}
}