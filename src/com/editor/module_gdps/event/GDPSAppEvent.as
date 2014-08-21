package com.editor.module_gdps.event
{
	public class GDPSAppEvent
	{
		/**
		 * 显示选择项目界面
		 */ 
		public static const showGDPSProjects_event:String = "showGDPSProjectsEvent";
		
		/**
		 * 登录后
		 */ 
		public static const enterGDPSMainUI_event:String = "enterGDPSMainUIEvent";
		
		/**
		 * 初始化完成
		 */ 
		public static const initCompleteGDPS_event:String = "initCompleteGDPSEvent";
		
		/**
		 * 显示遮罩
		 */
		public static const showLoadingProgressBarGdps_event:String = "showLoadingProgressBarGdpsEvent";
		
		/**
		 * 隐藏遮罩
		 */
		public static const hideLoadingProgressBarGdps_event:String = "hideLoadingProgressBarGdpsEvent";
		
		/**
		 * 显示进度
		 */
		public static const showMsgProgressBarGdps_event:String = "showMsgProgressBarGdpsEvent";
		
		/**
		 * 隐藏进度
		 */
		public static const hideMsgProgressBarGdps_event:String = "hideMsgProgressBarGdpsEvent";
	}
}