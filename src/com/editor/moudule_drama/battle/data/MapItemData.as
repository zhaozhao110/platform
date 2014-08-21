package com.editor.moudule_drama.battle.data
{
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.render2D.map2.data.SandyMapItemData2;
	
	public class MapItemData extends SandyMapItemData2
	{
		public function MapItemData()
		{
			super();
		}
				
		/**
		 * motion data == 动画信息
		 */ 
		public var motionData:AppMotionItemVO;
		
		/**
		 * 公用的资源定义
		 */ 
		public var resInfoItem:AppResInfoItemVO;
		
		
		private var _moveSpeed:Number = 20
		/**
		 * 移动速度(帧移动的距离)
		 * 移动速度 (每帧移动7像素,一秒30帧，也就是一秒移动210像素)
		 */
		public function get moveSpeed():Number
		{
			return _moveSpeed
		}
		public function set moveSpeed(value:Number):void
		{
			_moveSpeed = value;
		}
		
		
	}
}