package com.editor.module_actionMix.component
{
	import com.editor.module_actionMix.vo.ActionMixData;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.SandyMapItem;

	public class ActionMixHidePreviewImage extends SandyMapItem
	{
		public function ActionMixHidePreviewImage()
		{
			super();
			visible = false;
		}
		
		public var curr_action:AppMotionActionVO;
		public var timeline:String;
		public var totalForward:int;
		public var column:int;
		public var animation_type:int;
		public var forward_str:String = "";
		
		
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