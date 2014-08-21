package com.editor.module_actionMix.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_actionMix.mediator.ActionMixContentMediator;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.render2D.mapBase.animation.AnimActionRect;
	
	import flash.events.MouseEvent;

	public class ActionMixQueueItemRenderer extends ASHListItemRenderer
	{
		public function ActionMixQueueItemRenderer()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			mouseChildren = true;
			width = 190;
			height = 22;
						
			closeImg = new UIAssetsSymbol();
			closeImg.source = "closeBtn_a";
			closeImg.width = 16;
			closeImg.height = 16;
			closeImg.buttonMode = true;
			closeImg.addEventListener(MouseEvent.CLICK , onCloseHandle)
			addChild(closeImg);
			
			txt = new UILabel();
			addChild(txt);
		}
		
		public var closeImg:UIAssetsSymbol;
		public var txt:UILabel;
		
		public var action:String;
		public var resId:Number;
		public var frameIndex:int;
		public var rect:AnimActionRect;
		
		public function reflash():void
		{
			txt.text = sign;
		}
		
		public function get sign():String
		{
			if(rect==null){
				return "空白帧"
			}
			return resId + " - " + action + " - " + frameIndex;
		}
		
		private function onCloseHandle(e:MouseEvent):void
		{
			get_ActionMixContentMediator().delAction(this);
		}
		
		private function get_ActionMixContentMediator():ActionMixContentMediator
		{
			return iManager.retrieveMediator(ActionMixContentMediator.NAME) as ActionMixContentMediator;
		}
	}
}