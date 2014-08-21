package com.editor.tool.project.del
{
	import com.air.io.DeleteFile;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import com.editor.tool.project.create.CreatePopupwinTool;

	public class ProjectFileDelTool
	{
		public function ProjectFileDelTool()
		{
		}
		
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		
		
		public function del(fl:File):void
		{
			var dir_fl:File = fl.clone();
			var path:String = fl.nativePath;
			var name1:String = fl.name.split(".")[0];
			//popupwin
			var isPopwin:Boolean;
			if(fl.isDirectory){
				if(fl.parent.nativePath == (ProjectCache.getInstance().getModulesPath()+File.separator+AppMainModel.getInstance().user.shortName)){
					fl = CreatePopupwinTool.getPopMainWinAS(fl);
					if(fl == null){
						SandyManagerBase.getInstance().showError("删除成功,但没有找到窗口类");
						fl = dir_fl;
					}else{
						path = fl.nativePath;
						name1 = fl.name.split(".")[0];
						isPopwin = true;
					}
				}
			}else{
				/*var cont:String = read.readFromFile(fl);
				if(cont.indexOf("function delPopwin():void")!=-1){
					isPopwin = true;
				}*/
			} 
			if(isPopwin){
				var clsFile:File = new File(ProjectCache.getInstance().getUserPopClass());
				DeleteFile.deleteLine(clsFile,name1)
				
				clsFile = new File(ProjectCache.getInstance().getUserPopSign());
				DeleteFile.deleteLine(clsFile,name1)
			}
			//css
			if(fl.nativePath.indexOf(ProjectCache.getInstance().getUserThemePath())!=-1){
				clsFile = new File(ProjectCache.getInstance().getUserCSSPath());
				DeleteFile.deleteLine(clsFile,name1.split("_")[1])
			}
			//command
			if(fl.nativePath.indexOf(ProjectCache.getInstance().getCommandPath())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				DeleteFile.deleteLine(clsFile,name1)
			}
			//proxy
			if(fl.nativePath.indexOf(ProjectCache.getInstance().getProxyPath())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				DeleteFile.deleteLine(clsFile,name1)
			}
			//serverCode
			if(fl.nativePath.indexOf(ProjectCache.getInstance().getServerCodePath())!=-1){
				clsFile = new File(ProjectCache.getInstance().getServerCodeEnum());
				DeleteFile.deleteLine(clsFile,name1)
			}
			//interceptor
			if(fl.nativePath.indexOf(ProjectCache.getInstance().get_Interceptor())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				DeleteFile.deleteLine(clsFile,name1)
			}
			
			if(isPopwin){
				DeleteFile.deleteFile(dir_fl);
			}else{
				DeleteFile.deleteFile(fl);
			}
			var xml_file:File = new File(fl.parent.nativePath+File.separator+"xml"+File.separator+fl.name.split(".")[0]+".xml");
			if(xml_file.exists){
				DeleteFile.deleteFile(xml_file);
			}
			//css
			if(fl.nativePath.indexOf(ProjectCache.getInstance().getThemePath())!=-1){
				CreateCSSMainFile.getInstance().del(fl);
			}
			//刷新目录列表
			sendAppNotification(AppModulesEvent.reflashProjectDirect_event);
			sendAppNotification(AppModulesEvent.deleteFile_inProject_event,fl);
		}
		
		private function get sendAppNotification():Function
		{
			return SandyManagerBase.getInstance().ifabrication.sendNotification
		}
	}
	
	
}