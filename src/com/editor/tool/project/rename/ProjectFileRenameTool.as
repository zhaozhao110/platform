package com.editor.tool.project.rename
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ProjectFileRenameTool
	{
		public function ProjectFileRenameTool()
		{
		}
		
		private var oldName:String;
		private var newName:String;
		private var file:File;
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		
		public function rename(_oldName:String,_newName:String,_file:File):void
		{
			oldName = _oldName;
			newName = _newName;
			file = _file;
			
			var oldName2:String = oldName;
			if(oldName.indexOf(".")!=-1){
				oldName2 = oldName.split(".")[0];
			}
			var url:String = file.nativePath;
			file = WriteFile.changeName(file,getNewName());
			//修改Sh_css.as
			if(file.nativePath.indexOf(ProjectCache.getInstance().getThemePath())!=-1){
				CreateCSSMainFile.getInstance().rename(file);
				//修改了css，需要更新缓存
				ProjectAllUserCache.getInstance().getAllCSSXML();
			}
			//修改类里的名
			ClsUtils.rename(file,oldName);
			//刷新目录列表
			sendAppNotification(AppModulesEvent.reflashProjectDirect_event);
			//关闭打开的tabs
			sendAppNotification(AppModulesEvent.closeFile_inProject_event,url);
			//修改xml
			url = file.parent.nativePath+File.separator+"xml"+File.separator+oldName.split(".")[0]+".xml";
			var xml_file:File = new File(url);
			WriteFile.changeName(xml_file,getNewName());
			//修改img
			url = file.parent.nativePath+File.separator+"xml"+File.separator+"img"+File.separator+oldName.split(".")[0]+".jpg";
			var img_file:File = new File(url);
			WriteFile.changeName(img_file,getNewName());
			//popupwin
			var cont:String = read.readFromFile(file);
			if(cont.indexOf("function delPopwin():void")!=-1){
				//是窗口
				var clsFile:File = new File(ProjectCache.getInstance().getUserPopClass());
				var cont2:String = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
				
				clsFile = new File(ProjectCache.getInstance().getUserPopSign());
				cont2 = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
				
				//change mediator
				url = file.parent.parent.nativePath+File.separator+"mediator"+File.separator+oldName2+"Mediator.as";
				var m_file:File = new File(url);
				if(m_file.exists){
					m_file = WriteFile.changeName(m_file,getNewName2()+"Mediator");
					cont2 = read.readFromFile(m_file);
					cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
					write.write(m_file,cont2);
				}
			}
			//proxy
			if(file.nativePath.indexOf(ProjectCache.getInstance().getProxyPath())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				cont2 = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
			}
			//command
			if(file.nativePath.indexOf(ProjectCache.getInstance().getCommandPath())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				cont2 = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
			}
			//serverCode
			if(file.nativePath.indexOf(ProjectCache.getInstance().getServerCodePath())!=-1){
				clsFile = new File(ProjectCache.getInstance().getServerCodeEnum());
				cont2 = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
			}
			//interceptor
			if(file.nativePath.indexOf(ProjectCache.getInstance().get_Interceptor())!=-1){
				clsFile = new File(ProjectCache.getInstance().get_AppStartUpCommand());
				cont2 = read.readFromFile(clsFile);
				cont2 = StringTWLUtil.replace(cont2,oldName2,getNewName2());
				write.write(clsFile,cont2);
			}
			
		}
		
		private function getNewName2():String
		{
			if(newName.indexOf(".")!=-1){
				return newName.split(".")[0];
			}
			return newName
		}
		
		private function getNewName():String
		{
			if(newName.indexOf(".")==-1){
				return newName + "."+ file.extension;
			}
			return newName;
		}
		
		private function get sendAppNotification():Function
		{
			return SandyEngineGlobal.iManager.sendAppNotification;
		}
	}
}