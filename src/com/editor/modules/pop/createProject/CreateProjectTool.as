package com.editor.modules.pop.createProject
{
	import com.air.io.DeleteFile;
	import com.air.io.ReadFile;
	import com.air.io.UnZipWriteFile;
	import com.air.io.WriteFile;
	import com.editor.event.AppEvent;
	import com.editor.manager.StackManager;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.services.Services;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class CreateProjectTool
	{
		public function create(fl:File):void
		{
			projectName = fl.name.split(".")[0];
			saveFile = fl;
			
			var url:String = Services.temp_local_url;
			
			addLog("load zip: " + url);
			unzip = new UnZipWriteFile();
			unzip.writeComplete_f = writeComplete;
			unzip.writeAllComplete_f = writeAllComplete;
			var fl:File = File.applicationDirectory;
			unzip.saveDirectory(url,saveFile)
		}
		
		private var saveFile:File;
		private var unzip:UnZipWriteFile;
		private var projectName:String;
		
		private function writeComplete(url:String):void
		{
			addLog(unzip.areadyWrite_n + "/" + unzip.total_write_n + ":" + url);
		}
		
		private function addLog(s:String):void
		{
			StackManager.getInstance().addCurrLogCont(s);
		}
		
		private function writeAllComplete():void
		{
			changeFile(unzip.save_dir.getDirectoryListing());
			setTimeout(copySwc,1000*2);
		}
		
		private function copySwc():void
		{
			/*var file1:File = new File(Services.assets_fold_url + File.separator + "sandyEngine_as.swc");
			var toURL:String = saveFile.nativePath + File.separator + projectName + File.separator + "libs" + File.separator + "sandyEngine_as.swc";
			var file2:File = new File(toURL)
			WriteFile.copy(file1,file2);*/
			var _file:File = new File(saveFile.nativePath + File.separator + projectName);
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.changeProject_event,_file);
			SandyManagerBase.getInstance().closePoupwin(PopupwinSign.AppCreateProjectPopupwin_sign);
		}
		
		private function changeFile(a:Array):void
		{
			for(var i:int=0;i<a.length;i++)
			{
				var fl:File = a[i] as File;
				if(fl.name == "projectTemple" && fl.isDirectory){
					changeDirecryName(fl);
					break;
				}else if(fl.name == ".actionScriptProperties"){
					changeFile1(fl);
				}else if(fl.name == ".project"){
					changeFile2(fl);
				}else if(fl.name == "projectTemple.as"){
					changeFileName1(fl);
				}else if(fl.name == "AppProjectConfig.as"){
					changeFile3(fl);
				}else if(fl.name == "AppProjectMediator.as"){
					changeFile4(fl);
				}else if(fl.name == "Loading.as"){
					changeFile5(fl);
				}
				
				if(fl.isDirectory){
					changeFile(fl.getDirectoryListing())
				}
			}
		}
		
		/**修改projectTemple目录名 */ 
		private function changeDirecryName(fl:File):void
		{
			WriteFile.changeName(fl,projectName);
			changeFile(unzip.save_dir.getDirectoryListing());
		}
		
		/**修改.actionScriptProperties*/ 
		private function changeFile1(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			write.writeAsync(new File(fl.nativePath),cont);
		}
		
		/**修改.project */ 
		private function changeFile2(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			write.writeAsync(new File(fl.nativePath),cont);
		}
		
		/**
		 * 改名projectTemple.as
		 */ 
		private function changeFileName1(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			var newFile:File = new File(fl.parent.nativePath + File.separator + projectName + ".as")
			write.writeAsync(newFile,cont);
			DeleteFile.deleteFile(fl);
		}
		
		/**AppProjectConfig */ 
		private function changeFile3(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			write.writeAsync(new File(fl.nativePath),cont);
		}
		
		/**AppProjectMediator*/ 
		private function changeFile4(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			write.writeAsync(new File(fl.nativePath),cont);
		}
		
		/**
		 * Loading.as
		 */ 
		private function changeFile5(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			cont = StringTWLUtil.replace(cont,"projectTemple",projectName);
			var write:WriteFile = new WriteFile();
			write.writeAsync(new File(fl.nativePath),cont);
		}
		
	}
}