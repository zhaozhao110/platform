package com.editor.modules.cache
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.asparser.ClsDB;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.controls.UICombobox;
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.module_ui.vo.expandComp.ExpandCompListVO;
	import com.editor.vo.LocaleData;
	import com.editor.vo.global.AppStorageConfFile;
	import com.editor.vo.project.ActionScriptPropertiesData;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.math.HashMap;
	import com.sandy.math.SandyArray;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.XMLToJson;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ProjectCache
	{
		private static var instance:ProjectCache ;
		public static function getInstance():ProjectCache{
			if(instance == null){
				instance =  new ProjectCache();
			}
			return instance;
		}
		
		public static function getUserLocalAppData():String
		{
			return FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor"
		}
		
		//需要缓存的文件类型
		public static const suffix_ls:Array = ["txt","as","mxml","xml","properties","actionScriptProperties","project"];
		
		
		private var _currEditProjectFile:File;
		//当前要编辑的项目
		public function get currEditProjectFile():File
		{
			return _currEditProjectFile;
		}
		public function set currEditProjectFile(value:File):void
		{
			if(currEditProjectFile!=null && value != null){
				if(currEditProjectFile.nativePath == value.nativePath){
					return ;
				}
			}
			_currEditProjectFile = value;
			if(value != null) reflash();
		}
		
		//用户css的目录
		public var userCSSFold:File;
		
		//locale
		public var locale:String = "zh_CN"
			
		//actionScriptProperties
		public var projectProperties:ActionScriptPropertiesData;
		
		public function getProjectSrcURL():String
		{
			if(currEditProjectFile == null) return "" ;
			return currEditProjectFile.nativePath+File.separator+"src";
		}
		
		public function getProjectCodeURL():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg";
		}
		
		public function checkIsCompressXML(fl:File):Boolean
		{
			if(fl.nativePath.indexOf(getProjectCodeURL())!=-1) return true;
			if(fl.nativePath.indexOf(getThemePath())!=-1) return true;
			return false;
		}
		
		/**
		 * 角色绑定,每个角色都不一样的
		 * expandsComp.xml
		 * 
		 */ 
		
		public function getUserPopSign():String
		{
			return getModelPath()+File.separator+AppMainModel.getInstance().user.shortName+File.separator+StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_popwinSign.as";
		}
		
		public function getUserPopClass():String
		{
			return getModelPath()+File.separator+AppMainModel.getInstance().user.shortName+File.separator+StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_popwinClass.as";
		}
		
		public function get_userServerInterface():String
		{
			return getModelPath()+File.separator+AppMainModel.getInstance().user.shortName+File.separator+StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_serverInterface.as";
		}
		
		//theme/assets
		public function getThemeAssetsPath():String
		{
			return getProjectSrcURL()+File.separator+"theme"+File.separator+"assets";	
		}
		
		public function getAssetsPath():String
		{
			return getProjectSrcURL()+File.separator+"assets";	
		}
		
		public function getThemePath():String
		{
			return getProjectSrcURL()+File.separator+"theme";
		}
		
		public function getUserThemePath():String
		{
			return getThemePath()+File.separator+"css"+File.separator+AppMainModel.getInstance().user.shortName
		}
		
		public function getLocalePath(sign:String="zh_CN"):String
		{
			if(currEditProjectFile == null) return "";
			return getLocaleDir()+File.separator+sign;
		}
		
		public function getLocaleDir():String
		{
			if(currEditProjectFile == null) return "";
			return currEditProjectFile.nativePath+File.separator+"local"
		}
		
		public function getBin():String
		{
			if(currEditProjectFile == null) return "";
			return currEditProjectFile.nativePath+File.separator+"bin-debug"
		}
		
		public function getActionScriptProperties():String
		{
			return currEditProjectFile.nativePath+File.separator+".actionScriptProperties"
		}
		
		public function getRelease():String
		{
			if(currEditProjectFile == null) return "";
			return currEditProjectFile.nativePath+File.separator+"bin-release"
		}
		
		public function getLocaleEnum():String
		{
			return getModelPath()+File.separator+"LocaleEnum.as"
		}
		
		public function getUserLocale():String
		{
			return getLocalePath()+File.separator+AppMainModel.getInstance().user.shortName+".properties";
		}
		
		public function getPopwinEnum():String
		{
			return getModelPath()+File.separator+"PopwinEnum.as";
		}
		
		public function getServerInterfaceEnum():String
		{
			return getModelPath()+File.separator+"ServerInterfaceEnum.as";
		}
		
		public function getThemeMain():String
		{
			return getThemePath()+File.separator+"ThemeMain.as"
		}
		
		public function getUserCSSPath():String
		{
			return getThemePath()+File.separator+StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_CSS.as"
		}
		
		public function getProxyPath():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"proxy";
		}
		
		public function getEventPath():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"event";
		}
		
		public function getUserEventPath():String
		{
			return getEventPath() + File.separator + StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_event.as";
		}
		
		public function getVOPath():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"vo";
		}
		
		public function getPopupwinPath():String
		{
			if(currEditProjectFile == null) return "";
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"modules";
		}
		
		public function getServerCodePath():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"serverCode";
		}
		
		public function getServerCodeEnum():String
		{
			return getServerCodePath()+File.separator+"ServerCodeEnum.as"
		}
		
		public function getCommandPath():String
		{
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"command";
		}
		
		public function get_AppStartUpCommand():String
		{
			return getCommandPath()+File.separator+"app"+File.separator+"AppStartUpCommand.as";
		}
		
		public function get_serverCommand():String
		{
			return getCommandPath() + File.separator+"serverCommand"
		}
		
		public function get_Interceptor():String
		{
			return getCommandPath() + File.separator+"interceptor"
		}
		
		public function getModelPath():String
		{
			if(currEditProjectFile == null) return "";
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"model";
		}
		
		public function getModulesPath():String
		{
			if(currEditProjectFile == null) return "";
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"modules";
		}
		
		public function getCachePath():String
		{
			if(currEditProjectFile == null) return "";
			return getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"cache";
		}
		
		public function getUserSocketCodePath():String
		{
			if(currEditProjectFile == null) return "";
			return getServerCodePath()+File.separator+AppMainModel.getInstance().user.shortName.toLocaleLowerCase();
		}
		
		public function getUserSocketCodeEnumPath():String
		{
			if(currEditProjectFile == null) return "";
			return getServerCodePath()+File.separator+"ServerCodeEnum.as";
		}
		
		public function getExpandComps():Array
		{
			var file:File = getExpandCompFold();
			var a:Array = file.getDirectoryListing();
			return a;
		}
		
		public function getExpandCompFold():File
		{
			return new File(getProjectSrcURL()+File.separator+"com"+File.separator+"rpg"+File.separator+"component"+File.separator+"expands");	
		}
		
		public function getExpandCompXML():File
		{
			return new File(getExpandCompFold().nativePath+File.separator+"xml"+File.separator+AppMainModel.getInstance().user.shortName+"_expandsComp.xml")
		}
		
		public function getGlobalCSS():String
		{
			return getThemePath()+File.separator+"CSS_global.as";
		}
		
		/**相对于项目的路径**/
		public function getOppositePath(url:String):String
		{
			var _url:String = url;
			if(url.indexOf(getProjectSrcURL())!=-1){
				_url = url.substr(getProjectSrcURL().length);
			}
			if(_url.substring(0,1) == File.separator){
				_url = _url.substring(1,_url.length);
			}
			return _url;
		}
		
		/**加上项目的路径，组成一个完整的路径**/
		public function getProjectOppositePath(url:String):String
		{
			var path:String = url;
			if(path.indexOf(currEditProjectFile.nativePath)==-1){
				if(url.substring(0,1) == File.separator){
					if(path.substring(0,10).indexOf("src"+File.separator)==-1){
						path = getProjectSrcURL() + url;	
					}else{
						path = currEditProjectFile.nativePath + url;
					}
				}else{
					if(path.substring(0,10).indexOf("src"+File.separator)==-1){
						path = getProjectSrcURL() + File.separator + url;
					}else{
						path = currEditProjectFile.nativePath + File.separator + url;
					}
				}
			}
			var fl:File = new File(path);
			if(fl.exists) return fl.nativePath;
			return getProjectOppositePath_src(url);
		}
				
		private function getProjectOppositePath_src(url:String):String
		{
			if(url.substring(0,1) == File.separator){
				return getProjectSrcURL()+ url;
			}
			return getProjectSrcURL()+ File.separator + url;
		}
				
		public function reflash():void
		{
			if(currEditProjectFile!=null){
				var s:String = SharedObjectManager.getInstance().find("",currEditProjectFile.nativePath);
				SandyEngineGlobal.config.skinSourceURL = s;
			}
			
			if(!AppMainModel.getInstance().user.checkInPower([1,2])) return ;
			
			if(AppMainModel.getInstance().user == null) return ;
									
			//css
			try{
				userCSSFold = new File(getUserCSSFold());
			}catch(e:Error){
				return ;
			}
			ProjectAllUserCache.getInstance().getAllCSSXML();
			CreateCSSMainFile.getInstance().parser();
		}
		
		public function changeUser():void
		{
			try{
				userCSSFold = new File(getUserCSSFold());
			}catch(e:Error){
				return ;
			}
			jumpList2 = null;
			jumpList = null;
		}
		
		//获取用户的css的目录
		private function getUserCSSFold():String
		{
			if(AppMainModel.getInstance().user == null) return "";
			if(StringTWLUtil.isWhitespace(AppMainModel.getInstance().user.shortName)){
				return "";
			}
			var url:String = getThemePath()+File.separator+"css";
			try{
				var fl:File = new File(url);
			}catch(e:Error){
				return "";
			}
			if(!fl.exists) return ""
			var a:Array = fl.getDirectoryListing();
			var fl_a:Array = [];
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var _fl:File = a[i] as File;
				if(_fl.isDirectory){
					fl_a.push(_fl);
				}
			}
			for(i=0;i<fl_a.length;i++){
				_fl = fl_a[i] as File;
				out.push({label:_fl.name,data:_fl.nativePath});
			}
			var _selectedIndex2:int;
			for(i=0;i<out.length;i++){
				var obj:Object = out[i];
				if(String(obj.label).toLowerCase().indexOf(AppMainModel.getInstance().user.shortName)!=-1){
					return obj.data;
				}
			}
			return "";
		}
		
		private var jumpList:Array;
		private function _getJumpList():Array
		{
			if(AppMainModel.getInstance().user == null) return []
			if(StringTWLUtil.isWhitespace(AppMainModel.getInstance().user.shortName)){
				return [];
			}
			if(jumpList == null){
				var out:Array = [];
				out.push("");
				out.push("assets");
				out.push("assets"+File.separator+"img"+File.separator+AppMainModel.getInstance().user.shortName);
				out.push("theme");
				out.push("theme"+File.separator+"css"+File.separator+AppMainModel.getInstance().user.shortName);
				out.push("com"+File.separator+"rpg"+File.separator+"component");
				out.push("com"+File.separator+"rpg"+File.separator+"modules");
				out.push("com"+File.separator+"rpg"+File.separator+"modules"+File.separator+AppMainModel.getInstance().user.shortName);
				out.push("com"+File.separator+"rpg"+File.separator+"view");
				out.push("com"+File.separator+"rpg"+File.separator+"model");
				out.push("com"+File.separator+"rpg"+File.separator+"model"+File.separator+AppMainModel.getInstance().user.shortName);
				out.push("com"+File.separator+"rpg"+File.separator+"vo");
				jumpList = out;
			}
			return jumpList;
		}
		
		public var module_cb:UICombobox
		private var jumpList2:Array;
		public function getJumpList():Array
		{
			if(AppMainModel.getInstance().user == null) return []
			if(jumpList2 == null){
				if(tempActionFold_ls == null){
					tempActionFold_ls = AppMainModel.getInstance().applicationStorageFile.tempActionFold_ls;
				}
				var a:Array = _getJumpList();
				jumpList2 = a.concat(tempActionFold_ls);
				if(module_cb!=null){
					module_cb.dataProvider = jumpList2;
				}
				AppMainModel.getInstance().applicationStorageFile.putKey_tempActionFold(tempActionFold_ls.join("|"));
			}
			return jumpList2;
		}
		
		private var tempActionFold_ls:Array;
		public function addTempFold(url:String):void
		{
			if(StringTWLUtil.isWhitespace(url)) return ;
			if(tempActionFold_ls == null) return ;
			url = getOppositePath(url);
			_getJumpList();
			var ind:int = tempActionFold_ls.indexOf(url);
			if(ind == -1){
				ind = jumpList.indexOf(url);
				if(ind == -1){
					if(url.substring(0,1) == File.separator){
						url = url.substring(1,url.length);
					}
					tempActionFold_ls.push(url);
					jumpList2 = null;
					getJumpList();
				}
			}
		}
		
		
		////////////////////  cache project //////////////////
		
		//项目的文件结构
		public var cache:ASTreeDataProvider;
		public var locale_map:SandyArray = new SandyArray();
				
		public function cacheProject(file:File):void
		{
			currEditProjectFile = file;
			AppMainModel.getInstance().applicationStorageFile.putKey_recentProject(file.nativePath);
			//获取项目目录结构,第一个线程
			BackgroundThreadCommand.instance.cacheProject();
			//解析项目每个类的类结构,第二个线程
			BackgroundThreadCommand.instance.parserProject();
		}
		
		public function cacheTypeDB(db:Object):void
		{
			TypeDBCache.hash = db;	
			LogManager.getInstance().addLog("--解析项目文件类结构完成--");
		}
		
		public function getTypeDB(key:String):TypeDB
		{
			return TypeDBCache.getDB(key)
		}
		
		public function addTypeDB(db:TypeDB):void
		{
			TypeDBCache.addDB(db);
		}
		
		//value : LocaleData
		public function addLocales(m:SandyArray):void
		{
			locale_map.concat(m);
		}
		
		public function addLocale(d:LocaleData):void
		{
			if(d == null) return ;
			if(StringTWLUtil.isWhitespace(d.key)) return ;
			//if(locale_map.containerKey(d.getId1(),1)) return ;
			if(locale_map.containerKey(d.getId2(),2)) return ;
			locale_map.addItem(d);
		}
		
		public function getLocale(key:String):LocaleData
		{
			return locale_map.find(key) as LocaleData;
		}
		
		
		
		
		public function putFileContent(file:File,cont:String):void
		{
			var write:WriteFile = new WriteFile();
			write.write(file,cont);
		}
		
		
	}
}