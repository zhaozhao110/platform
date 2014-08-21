package com.editor.module_ui.event
{
	public class UIEvent
	{
		public static const selectUI_inUI_event:String = "selectUIInUIEvent";
		
		//右边属性改变，而改变xml,生成as,改变缓存
		public static const reflash_cssInfo_event:String = "reflashCSSInfoEvent";
		
		//生成as后，改变界面上的代码，刷新缓存,刷新右边属性列表
		public static const cssFile_change_event:String = "cssFileChangeEvent";
		
		//open component attri list
		public static const open_comAttri_inCSS_event:String = "openComAttriInCSSEvent";
		
		//ui编辑的时候，修改属性，刷新组件
		public static const reflash_uiAttri_event:String = "reflashUiAttriEvent"
		
		public static const reflash_compOutline_event:String = "reflashCompOutlineEvent";
		
		public static const save_uiEdit_event:String = "saveUiEditEvent"
			
		public static const currEditUIFile_change_event:String = "currEditUIFileChangeEvent";
		
		public static const reflash_invertedGroupList_event:String = "reflashInvertedGroupListEvent"
	}
}