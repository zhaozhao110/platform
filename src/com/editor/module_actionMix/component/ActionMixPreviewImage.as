package com.editor.module_actionMix.component
{
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.SandyMapItem;
	import com.sandy.render2D.mapBase.animation.AnimationMixTimeline;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	
	import flash.display.BitmapData;
	import flash.events.Event;

	public class ActionMixPreviewImage extends SandyMapItem
	{
		public function ActionMixPreviewImage()
		{
			super();
		}
		
		
		
		override public function get forward():int
		{
			return _forward;
		}
		override public function set forward(value:int):void
		{
			_forward = value;
			forward_str = SandyMapConst.getForwardStr(_forward);
		}
		
		
		override public function getMapIndex():String
		{
			return getId();
		}
		
		/**
		 * 是4方向还是8方向
		 */ 
		override public function getTotalForward(action:String):int
		{
			return totalForward
		}
		
		override public function getTimeline(_action2:String):String
		{
			return timeline;
		}
		
		override public function getPngInfo(forward:int,ind:int,action:String):SandyRectangle
		{
			return curr_action.getForward(forward).getRectangle(ind);
		}
		
		override public function getColumn(action:String):int
		{
			return column;
		}
		
		override public function getOriginal_width():int
		{
			return this.width;
		}
		
		override public function getOriginal_height():int
		{
			return this.height;
		}
		
		override public function get isInScreen():Boolean
		{
			return true;
		}
		
		
		
		
		override protected function __init__():void
		{
			super.__init__();
			
			backgroundColor = 0xcccccc;
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0x000000;
		}
		
		
		
		private var curr_action:AppMotionActionVO;
		private var timeline:String;
		private var totalForward:int;
		private var column:int;
		private var animation_type:int;
		public var forward_str:String = "";
		
		
		
		
		public function reflash(bit:BitmapData,sign:String,_timeline:String,_totalForward:int,action:AppMotionActionVO,col:int,_animation_type:int):void
		{
			if(bitmap.bitmapData!=null){
				bitmap.bitmapData.dispose();
			}
			
			column 			= col;
			curr_action 	= action;
			timeline 		= _timeline;
			totalForward 	= _totalForward;
			animation_type	= _animation_type;
			
			if(animation_type== SandyMapConst.animation_shadow){
				
			}else{
				var dt:SandyMapSourceData = new SandyMapSourceData();
				dt.sceneType = 1;
				dt.url = sign;
				dt.action = curr_action.type;
				animation.parserSwfChild(dt)
			}
			
			stop();
			this.addEventListener(Event.ENTER_FRAME , play);
			
			visible = true;
		}
		
		public function play_animationMix(timeline:AnimationMixTimeline):void
		{
			stop();
			
			animation.play_animationMix(timeline);
			
			this.addEventListener(Event.ENTER_FRAME , playMix);
		}
		
		public function play(e:*=null):void
		{
			if(this.visible){
				if(animation_type==SandyMapConst.animation_shadow){
					//animation.play(tp,forward);
				}else{
					animation.play(actionType,forward);
				}
			}
		}
		
		public function playMix(e:*=null):void
		{
			if(this.visible){
				if(animation_type==SandyMapConst.animation_shadow){
					//animation.play(tp,forward);
				}else{
					animation.play_animationMix();
				}
			}
		}
		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME , play);
			if(animation!=null){
				animation.stop();
			}
			this.removeEventListener(Event.ENTER_FRAME , playMix);
			if(animation!=null){
				animation.stop_mix()
			}
		}
		
		override protected function synchScreen(delta:*=null):void{};
		override public function dispatchMouseClick():Boolean{
			return false;
		}
		override public function dispatchMouseOver():Boolean{
			return false;
		}
		override protected function checkInScreen():Boolean{
			return true;
		}
		
		
	}
}