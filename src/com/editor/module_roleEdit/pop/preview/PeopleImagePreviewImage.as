package com.editor.module_roleEdit.pop.preview
{
	
	import com.editor.component.containers.UICanvas;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.text.SandyTextField;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.SandyMapItem;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	import com.sandy.utils.Random;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;

	public class PeopleImagePreviewImage extends SandyMapItem
	{
		public function PeopleImagePreviewImage()
		{
			super();
		}
		
		
		
		private var txt:SandyTextField;
		
		
		override public function get forward():int
		{
			return _forward;
		}
		override public function set forward(value:int):void
		{
			_forward = value;
			forward_str = SandyMapConst.getForwardStr(_forward);
			if(txt!=null) txt.text = forward_str;
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
			if(curr_action.getForward(forward) == null) {
				return null;
			}
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
			
			txt = new SandyTextField();
			txt.color = 0xcc0000;
			up_addChild(txt);
			
			backgroundColor = 0xcccccc;
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0x000000;
		}
		
		/**加载背景图 */ 
		public function loadImage(cls:String):void
		{
			/*var bit:Bitmap = new cls as Bitmap;
			up_addChildAt(bit,0);*/
		}
		
		
		
		private var curr_action:AppMotionActionVO;
		private var timeline:String;
		private var totalForward:int;
		private var column:int;
		private var animation_type:int;
		public var forward_str:String = "";
		
		
		
		
		public function reflash(bit:BitmapData,
								sign:String,
								_timeline:String,
								_totalForward:int,
								action:AppMotionActionVO,
								col:int,
								_animation_type:int):void
		{
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
			
			visible = true;
		}
		
		public function play(tp:String):void
		{
			if(this.visible){
				if(animation_type==SandyMapConst.animation_shadow){
					//animation.play(tp,forward);
				}else{
					animation.play(tp,forward);
				}
			}
		}
		
		override protected function synchScreen(delta:*=null):void{};
		override public function dispatchMouseClick():Boolean{return false;}
		override public function dispatchMouseOver():Boolean{return false;}
		override protected function checkInScreen():Boolean{return true;}
		override public function gotoActionForward(_action:String="", _forward:int=0):void{};
		override protected function playMotion():void{};
		
	}
}