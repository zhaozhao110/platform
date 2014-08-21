package com.editor.module_roleEdit.vo.action
{
	
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.sandy.math.SandyPoint;

	public class ActionData
	{
		public function ActionData()
		{
		}
		/**
		 * 动作
		 * 待机，
		 * 攻击1，
		 * 采集
		 */ 
		public var type:String;
		/**
		 * 动作
		 */ 
		public var type_str:String;
		
		/**
		 * 时间轴
		 */ 
		public var timeline:String = "";
				
		
				
		//是否更改过
		public var isupdate:String = "false";
		
		public var actionVO:AppMotionActionVO;
		
		
		
	}
}