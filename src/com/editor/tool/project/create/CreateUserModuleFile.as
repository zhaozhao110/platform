	package com.editor.tool.project.create
{
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.tool.ParserLocaleTool;
	import com.editor.tool.PopwinEnumTool;
	import com.editor.tool.ServerInterfaceEnumTool;
	import com.editor.tool.ThemeMainTool;
	import com.editor.tool.project.jsfl.CompileFla;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CreateUserModuleFile
	{
		public function CreateUserModuleFile()
		{
		}
		
		public static function create():void
		{
			var name:String = AppMainModel.getInstance().user.shortName;
			var name2:String = StringTWLUtil.setFristUpperChar(name);
			//event
			createClass(ProjectCache.getInstance().getEventPath()+File.separator+name2+"_event.as");
			//model
			var model_path:String = ProjectCache.getInstance().getModelPath()+File.separator+name;
			createClass(model_path+File.separator+name2+"_popwinClass.as");
			createClass(model_path+File.separator+name2+"_popwinSign.as");
			createClass(model_path+File.separator+name2+"_serverInterface.as");
			//modules;
			createDir(ProjectCache.getInstance().getPopupwinPath()+File.separator+name);
			//serverCode
			createDir(ProjectCache.getInstance().getServerCodePath()+File.separator+name);
			//vo
			createDir(ProjectCache.getInstance().getVOPath()+File.separator+name);
			//thme
			createClass(ProjectCache.getInstance().getThemePath()+File.separator+name2+"_CSS.as");
			createDir(ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+name);
			createDir(ProjectCache.getInstance().getThemePath()+File.separator+"assets"+File.separator+name);
			//locale
			createlocaleFile(ProjectCache.getInstance().getUserLocale());
			//PopwinEnum.as
			var tool1:PopwinEnumTool = new PopwinEnumTool();
			tool1.create();
			//ServerInterfaceEnum.as
			var tool2:ServerInterfaceEnumTool = new ServerInterfaceEnumTool();
			tool2.create();
			//ThemeMain.as
			var tool3:ThemeMainTool = new ThemeMainTool();
			tool3.create();
			//create fla
			var pile:CompileFla = new CompileFla();
			pile.createUserModuleFla();
		}
		
		private static function createDir(path:String):void
		{
			var fl:File = new File(path);
			if(!fl.exists){
				try{
					fl.createDirectory();
				}catch(e:Error){};
				LogManager.getInstance().addLog("create dir:"+fl.nativePath);
			}
		}
		
		private static function createClass(path:String):void
		{
			var fl:File = new File(path);
			if(!fl.exists){
				var cont:String = ClsUtils.createEmptyClass(fl);
				var write:WriteFile = new WriteFile();
				write.write(fl,cont);
				LogManager.getInstance().addLog("create file:"+fl.nativePath);
			}
		}
		
		private static function createlocaleFile(path:String):void
		{
			var fl:File = new File(ProjectCache.getInstance().getUserLocale());
			if(fl.exists) return ;
			var tool:ParserLocaleTool = new ParserLocaleTool();
			tool.createLocaleEnum();
		}
		
	}
}