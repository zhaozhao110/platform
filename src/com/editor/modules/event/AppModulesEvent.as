package com.editor.modules.event
{
	public class AppModulesEvent
	{
		//create file,在projectDirectory中用到
		public static const createFile_inProjectDirectory_event:String = "createFileInProjectDirectoryEvent";
		
		//全部折叠
		public static const allContract_event:String = "allContractEvent";
		
		//close project
		public static const closeProject_event:String = "closeProjectEvent"
			
		//创建项目后，根据模版创建的项目完成，所有文件拷贝完成
		public static const createProject_complete_event:String = "createProjectCompleteEvent"
		
		//edit file
		public static const openEditFile_event:String = "openEditFileEvent";
		
		//刷新项目目录文件
		public static const reflashProjectDirect_event:String = "reflashProjectDirectEvent";
		
		//css edit
		public static const openFile_inCSSEditor_event:String = "openFileInCSSEditorEvent";
		
		public static const openFile_inUIEditor_event:String = "openFileInUIEditorEvent";
		
		//delete 
		public static const deleteFile_inProject_event:String = "deleteFileInProjectEvent";
		
		public static const closeFile_inProject_event:String = "closeFileInProjectEvent";
		
	}
}