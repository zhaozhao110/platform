package com.editor.module_roleEdit.pop.preview2
{
	
	import com.editor.component.containers.UICanvas;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.text.SandyTextField;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.SandyMapItem;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	import com.sandy.render2D.mapBase.animation.Animation;
	import com.sandy.utils.Random;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;

	public class PeopleImagePreviewImage2 extends SandyMapItem
	{
		public function PeopleImagePreviewImage2()
		{
			super();
		}
				
		override protected function getSceneType():int
		{
			return 1;
		}
		
		override public function getTotalForward(action:String):int
		{
			return AppResInfoItemVO(data.data).totalForward;
		}
		
		override public function get isInScreen():Boolean
		{
			return true;
		}
		
		override protected function getPlayMode(action:String):int
		{
			return Animation.CIRCULATION;
		}
		
		override protected function get defaultForward():int
		{
			return _forward
		}
		
		
		override protected function __init__():void
		{
			super.__init__();
			
			backgroundColor = 0xcccccc;
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0x000000;
		}
		
		override protected function synchScreen(delta:*=null):void{};
		override public function dispatchMouseClick():Boolean{return false;}
		override public function dispatchMouseOver():Boolean{return false;}
		override protected function checkInScreen():Boolean{return true;}
		
		
	}
}