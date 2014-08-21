package com.editor.module_ui.css
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.air.logging.CatchLog;
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.ClsUtils;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	//SH_css.as
	public class CreateCSSMainFile
	{
		private static var instance:CreateCSSMainFile ;
		public static function getInstance():CreateCSSMainFile{
			if(instance == null){
				instance =  new CreateCSSMainFile();
			}
			return instance;
		}
		
		private var write:WriteFile = new WriteFile();
		private var read:ReadFile = new ReadFile();
		private var db:ClsDB;
		//E:\hg_res\sandy_engine\test\uiTest\src\theme\Sh_css.as
		private var file:File;
		
		
		public function parser():void
		{
			if(AppMainModel.getInstance().user == null) return ;
			if(ProjectCache.getInstance().currEditProjectFile == null) return ;
			if(StringTWLUtil.isWhitespace(AppMainModel.getInstance().user.shortName)) return ;
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName)+"_CSS.as";
			file = new File(url);
			if(!file.exists){
				write.write(file,"");
				CatchLog.getInstance().info("CreateCSSMainFile create file:"+url);
			}
			
			var c:String = "";
			if(!file.exists){
				c = createEmptyFile();
			}else{
				c = read.read(file.nativePath);
			}
			Parser.addSourceFile(c,file.nativePath,_parserComplete);
		}
		
		private function _parserComplete():void
		{
			db = new ClsDB(TypeDBCache.getDB(file.nativePath));
		}
		
		private function getName():String
		{
			return AppMainModel.getInstance().user.shortName
		}
		
		public function rename(fl:File=null):void
		{
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+getName().toLocaleLowerCase();
			if(fl!=null){
				if(fl.nativePath.indexOf(url)==-1) return ;
			}
			var fold_file:File = new File(url);
			if(!fold_file.exists) return ;
			
			reflashCSS();
		}
		
		public function del(fl:File=null):void
		{
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+getName().toLocaleLowerCase();
			if(fl!=null){
				if(fl.nativePath.indexOf(url)==-1) return ;
			}
			var fold_file:File = new File(url);
			if(!fold_file.exists) return ;
			
			reflashCSS();
		}
		
		public function create(fl:File=null):void
		{
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+getName().toLocaleLowerCase();
			if(fl!=null){
				if(fl.nativePath.indexOf(url)==-1) return ;
			}
			var fold_file:File = new File(url);
			if(!fold_file.exists) return ;
			
			reflashCSS();	
		}
		
		private function reflashCSS():void
		{
			if(db == null) return ;
			var url:String = ProjectCache.getInstance().getThemePath()+File.separator+"css"+File.separator+getName().toLocaleLowerCase();
			var fold_file:File = new File(url);
			
			db.members = null;
			db.members = [];
			
			var file_a:Array = [];
			var a:Array = fold_file.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var _fl:File = a[i] as File;
				if(!_fl.isDirectory){
					file_a.push(_fl);
					var cls:ClsAttri = new ClsAttri();
					cls.className = _fl.name.split(".")[0];
					cls.name = cls.className.substring(4,cls.className.length);
					db.add_member(cls);
				}
			}
						
			url = ProjectCache.getInstance().getThemePath()+File.separator+StringTWLUtil.setFristUpperChar(getName())+"_CSS.as";
			if(StringTWLUtil.isWhitespace(db.package_url)){
				db.package_url = ClsUtils.getClassPackage(new File(url));
			}
			var s:String = "/** from ["+AppMainModel.getInstance().user.shortName +"] , please not delete **/"+NEWLINE_SIGN;
			s += "package"+" "+db.package_url+NEWLINE_SIGN;
			s += "{"+NEWLINE_SIGN;
			
			//import
			s += createSpace()+"import"+" "+db.package_url+".css."+AppMainModel.getInstance().user.shortName.toLocaleLowerCase()+".*"+";"+NEWLINE_SIGN;
			
			s += createSpace()+"public"+" "+"class"+" "+db.name+NEWLINE_SIGN;
			s += createSpace()+"{"+NEWLINE_SIGN;
			
			s += createSpace(2)+"public"+" "+"function"+" "+db.name+'():void'+NEWLINE_SIGN;
			s += createSpace(2)+"{"+NEWLINE_SIGN;
			s += createSpace(2)+"}"+NEWLINE_SIGN;
			
			//members
			for each(var attri:ClsAttri in db.members){
				s += attri.getCSSFile()+NEWLINE_SIGN;
			}
			
			s += createSpace()+"}"+NEWLINE_SIGN;
			s += "}"+NEWLINE_SIGN;
			
			write.write(file,s);
		}
		
		//\src\theme\sh_css.as
		public static function createEmptyFile():String
		{
			var url:String = ProjectCache.getInstance().getThemePath() + File.separator + StringTWLUtil.setFristUpperChar(AppMainModel.getInstance().user.shortName) + "_CSS.as";
			var s:String = "/** from ["+AppMainModel.getInstance().user.shortName +"] , please not delete **/"+StringTWLUtil.NEWLINE_SIGN;
			s += ClsUtils.createEmptyClass(new File(url));
			var w:WriteFile = new WriteFile()
			w.write(new File(url),s);
			return s;
		}
				
		//\src\theme\css\sh\
		//\src\theme\assets\sh\
		public static function createEmptyFold():void
		{
			var url:String = ProjectCache.getInstance().getThemePath() + File.separator + "css" + File.separator + AppMainModel.getInstance().user.shortName;
			WriteFile.createDirectory(url);
			
			url = ProjectCache.getInstance().getThemePath() + File.separator + "assets" + File.separator + AppMainModel.getInstance().user.shortName;
			WriteFile.createDirectory(url);
		}
				
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
	}
}