package com.editor.command.action
{
	import com.air.io.ReadFile;
	import com.asparser.swcparser.SWCParser;
	import com.editor.command.AppSimpleCommand;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectViewMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.tool.ParserActionScriptProperties;
	import com.sandy.puremvc.interfaces.INotification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ImportProjectEventCommand extends AppSimpleCommand
	{
		public static var cache_project:String ; 
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var file:File = notification.getBody() as File;
			if(file == null) return ;
			if(cache_project == file.nativePath) return ;
			
			cache_project = file.nativePath;
			//cache
			ProjectCache.getInstance().cacheProject(file);
			//
			AppMainModel.getInstance().applicationStorageFile.putKey_project(file.nativePath)
			//
			ProjectCache.getInstance().reflash();
			//
			var tool1:ParserActionScriptProperties = new ParserActionScriptProperties();
			tool1.parser();
			ProjectCache.getInstance().projectProperties = tool1.data;
			var sdk_ls:Array = AppMainModel.getInstance().applicationStorageFile.sdkFold_ls;
			for(var i:int=0;i<sdk_ls.length;i++){
				var fl:File = new File(sdk_ls[i]);
				if(fl.name == tool1.data.sdk){
					ProjectCache.getInstance().projectProperties.sdk_path = fl.nativePath;
					break;
				}
			}
			if(!StringTWLUtil.isWhitespace(ProjectCache.getInstance().projectProperties.sdk_path)){
				var read:ReadFile = new ReadFile();
				ProjectCache.getInstance().projectProperties.sdk_swc_db = SWCParser.parse(read.read(ProjectCache.getInstance().projectProperties.sdk_path,ReadFile.READTYPE_BYTEARRAY))
			}
			//
			//界面刷新
			if(get_ProjectDirectViewMediator()!=null){
				get_ProjectDirectViewMediator().importCacheProject();
			}
		}
		
		private function get_ProjectDirectViewMediator():ProjectDirectViewMediator
		{
			return retrieveMediator(ProjectDirectViewMediator.NAME) as ProjectDirectViewMediator;
		}
	}
}