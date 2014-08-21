package com.editor.module_map.popup.preview.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.model.MapConst;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class PreviewSceneContainer extends PreviewDisplayObject
	{
		/**移动状态：0停止、1向左、2向右**/
		public var moveStatus:int;
		
		public function PreviewSceneContainer()
		{
			super();
			create_init();
		}
		
		private var layersContainer:UICanvas;
		private function create_init():void
		{
			layersContainer = new UICanvas();
			addChild(layersContainer);
		}
		
		public function addLayer(layer:PreviewSceneLayer):void
		{
			layersContainer.addChild(layer);
		}
		
		public function getLayerById(id:String):PreviewSceneLayer
		{
			var outPsl:PreviewSceneLayer;
			var len:int = layersContainer.numChildren;
			for(var i:int=0;i<len;i++)
			{
				if(layersContainer.getChildAt(i) is PreviewSceneLayer)
				{
					var psl:PreviewSceneLayer = layersContainer.getChildAt(i) as PreviewSceneLayer;
					if(psl)
					{
						if(psl.sceneId == id)
						{
							outPsl =  psl;
							break;
						}
					}
				}
				
			}
			return outPsl;
		}
		
		public function clear():void
		{
			stop();
			
			var len:int = layersContainer.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var disObj:DisplayObject = layersContainer.getChildAt(i) as DisplayObject;
				if(disObj)
				{
					if(disObj is PreviewSceneLayer)
					{
						(disObj as PreviewSceneLayer).dispose();
					}
					layersContainer.removeChild(disObj);
					disObj = null;
					
				}
				
			}
		}
		
		public function run():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
		}
		
		private function onEnterFrameHandle(e:Event):void
		{
			var len:int = layersContainer.numChildren;
			for(var i:int=0;i<len;i++)
			{
				if(layersContainer.getChildAt(i) is PreviewSceneLayer)
				{
					var layer:PreviewSceneLayer = layersContainer.getChildAt(i) as PreviewSceneLayer;
					if(layer)
					{
						layer.runStep();
						moveLayer(layer);
					}
				}
				
			}
		}
		
		private function checkMoveLayerEnable():Boolean
		{
			var bool:Boolean = true;			
			if(moveStatus <= 0) return bool;
			
			var len:int = layersContainer.numChildren;
			for(var i:int=0;i<len;i++)
			{
				if(layersContainer.getChildAt(i) is PreviewSceneLayer)
				{
					var layer:PreviewSceneLayer = layersContainer.getChildAt(i) as PreviewSceneLayer;
					if(layer.isDefault)
					{
						if(moveStatus == 1)
						{
							if(layer.x >= 0)
							{
								layer.x = 0;
								bool = false;
								moveStatus = 0;
								break;
							}
						}else if(moveStatus == 2)
						{
							var cW:int = layer.width - MapConst.layoutSceneContainerW;
							if(layer.x <= -cW)
							{
								layer.x = -cW;
								bool = false;
								moveStatus = 0;
								break;
							}
						}
						break;
												
					}
				}
			}
			
			return bool;
		}
		
		private function moveLayer(layer:PreviewSceneLayer):void
		{
			if(moveStatus <= 0) return;
			if(!layer) return;
			if(!checkMoveLayerEnable()) return;
						
			if(layer.horirontalMoveSpeed)
			{
				var nextStepX:Number;
				if(moveStatus == 1)
				{
					nextStepX = layer.x + layer.horirontalMoveSpeed;
					if(nextStepX >= 0 && layer.useHDefaultSpeed)
					{
						layer.x = 0;
					}else
					{
						layer.x += layer.horirontalMoveSpeed;						
					}
					
				}else if(moveStatus == 2)
				{
					nextStepX = layer.x - layer.horirontalMoveSpeed;
					var cW:int = layer.width - MapConst.layoutSceneContainerW;
					if(nextStepX <= -cW && layer.useHDefaultSpeed)
					{
						layer.x = -cW;
					}else
					{
						layer.x -= layer.horirontalMoveSpeed;						
					}
						
				}
			}
			
			
		}
		
	}
}