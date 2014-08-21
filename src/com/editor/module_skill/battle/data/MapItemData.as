package com.editor.module_skill.battle.data
{
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.render2D.map2.data.SandyMapItemData2;
	
	public class MapItemData extends SandyMapItemData2
	{
		public function MapItemData()
		{
			super();
			moveSpeed = 20;
		}
		
		public var isAttack:Boolean = false;
		
		/**
		 * motion data == 动画信息
		 */ 
		public var motionData:AppMotionItemVO;
		
		/**
		 * 公用的资源定义
		 */ 
		public var resInfoItem:AppResInfoItemVO;
		
		
		
	}
}