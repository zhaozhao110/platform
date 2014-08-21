package com.editor.module_ui.view.projectDirectory
{
	import com.air.io.DeleteFile;
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.component.controls.UITreeVList;
	import com.editor.component.controls.UIVlist;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.LogManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.css.CSSShowContainer;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.module_ui.ui.UIShowContainer;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.app.view.ui.topBar.AppTopBarContainerMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.editor.tool.project.create.ProjectCreateFileTool;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.controls.interfac.IASTreeItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	public class ProjectDirectViewMediator extends AppMediator
	{
		public static const NAME:String = "ProjectDirectViewMediator"
		public function ProjectDirectViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get projectWin():ProjectDirectView
		{
			return viewComponent as ProjectDirectView
		}
		//list列表模式
		public function get listModeBox():ProjectDirectList
		{
			return projectWin.listModeBox;
		}
		
		
		private var listModeBoxMediator:ProjectDirectListMediator;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			listModeBoxMediator = registerMediator(new ProjectDirectListMediator(listModeBox)) as ProjectDirectListMediator;
			
			importCacheProject();
		}
		
		private function getCurrShowMode():ProjectDirectListMediator
		{
			return listModeBoxMediator;
		}
		
		public function importCacheProject():void
		{
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			if(!StringTWLUtil.isWhitespace(url)){
				later_setProject()
			}
		}
		
		//刚打开的时候，初始化
		private function later_setProject():void
		{
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			var file:File = new File(url);
			if(!file.exists){
				return ;
			}
			getCurrShowMode().setProject();
			get_AppTopBarContainerMediator().setProject("正在编辑项目："+ file.nativePath);
			
			if(!StringTWLUtil.isWhitespace(AppMainModel.getInstance().applicationStorageFile.curr_projectFold)){
				var edit_url:String = AppMainModel.getInstance().applicationStorageFile.curr_projectFold;
				setPath(edit_url);
			}else{
				setPath(file.nativePath);
			}
		}
		
		public function getSelectedFile():File
		{
			return getCurrShowMode().getSelectedFile();
		}
		
		private function setPath(url:String):void
		{
			getCurrShowMode().setPath(url);
		}
		
		public function respondToOpenFoldEvent(noti:Notification):void
		{
			var fl:File = noti.getBody() as File;
			if(fl!=null&&fl.exists){
				setPath(fl.nativePath);
			}
		}
		
		public function respondToCreateProjectCompleteEvent(noti:Notification):void
		{
			
		}
		
		public function respondToReflashProjectDirectEvent(noti:Notification):void
		{
			reflashFileTree();
		}
		
		private function reflashFileTree():void
		{
			getCurrShowMode().reflashPath()
			/*var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			if(!StringTWLUtil.isWhitespace(url)){
				fileTree.dataProvider = new File(url);
			}*/
		}
		
		public function respondToCreateFileInProjectDirectoryEvent(noti:Notification):void
		{
			var item:AppCreateClassFilePopwinVO = noti.getBody() as AppCreateClassFilePopwinVO;
			var type:int = item.type;
			if(type == AppCreateClassFilePopwinVO.file_type1){
				//as
				ProjectCache.getInstance().putFileContent(item.file,ProjectCreateFileTool.createAS(item))
				var dd:OpenFileData = new OpenFileData();
				dd.file = item.file;
				sendAppNotification(AppModulesEvent.openEditFile_event,dd);
			}else if(type == AppCreateClassFilePopwinVO.file_type2){
				//css
				StackManager.getInstance().changeStack(DataManager.stack_css)
				ProjectCache.getInstance().putFileContent(item.file,ProjectCreateFileTool.createCSS(item))
				sendAppNotification(AppModulesEvent.openFile_inCSSEditor_event,item.file);
				CreateCSSMainFile.getInstance().create(item.file);
			}
			else if(type == AppCreateClassFilePopwinVO.file_type3){
				//popupwin
				
				var write:WriteFile = new WriteFile();
				write.write(item.file,ClsUtils.createEmptyClass(item.file));
				
				var d1:OpenFileInUIEditorEventVO = new OpenFileInUIEditorEventVO();
				d1.file = item.file;
				d1.type = type;
				sendAppNotification(AppModulesEvent.openFile_inUIEditor_event,d1);
			}else if(type == AppCreateClassFilePopwinVO.file_type4){
				WriteFile.createDirectory(item.file.nativePath);
			}
			LogManager.getInstance().addLog("create:"+item.file.nativePath);
			getCurrShowMode().insertPath(item.file.nativePath);
		}
		
		public function delFile():void
		{
			getCurrShowMode().delFile();
		}
		
		private function get_AppTopBarContainerMediator():AppTopBarContainerMediator
		{
			return retrieveMediator(AppTopBarContainerMediator.NAME) as AppTopBarContainerMediator;
		}
		
	}
}