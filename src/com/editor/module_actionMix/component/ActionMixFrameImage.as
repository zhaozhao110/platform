package com.editor.module_actionMix.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.module_actionMix.mediator.ActionMixContentMediator;
	import com.sandy.asComponent.containers.ASCanvas;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.core.SandySprite;
	import com.sandy.render2D.mapBase.animation.AnimActionRect;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	
	public class ActionMixFrameImage extends ASCanvas
	{
		public function ActionMixFrameImage()
		{
			super();
		}
		
		override protected function __init__():void
		{
			super.__init__();
			
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			width = 500;
			height = 500;
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0x000000;
			
			bit = new Bitmap();
			addChild(bit);
			
			btn = new UIButton();
			btn.label = "添加";
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK , addHandle)
			
		}
		
		private var btn:UIButton;
		private var rect:AnimActionRect;
		private var bit:Bitmap;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			rect = data as AnimActionRect;
			
			btn.label = "添加/图片索引"+rect.index;
						
			//bit.x = rect.info.x;
			//bit.y = rect.info.y;
			bit.bitmapData = rect.bitmapData.clone();	
		}
		
		private function addHandle(e:MouseEvent):void
		{
			get_ActionMixContentMediator().addAction(rect,get_ActionMixContentMediator().curr_action.type);
		}
		
		private function get_ActionMixContentMediator():ActionMixContentMediator
		{
			return iManager.retrieveMediator(ActionMixContentMediator.NAME) as ActionMixContentMediator;
		}
	}
}