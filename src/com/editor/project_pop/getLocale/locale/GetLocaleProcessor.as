package com.editor.project_pop.getLocale.locale
{
	
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class GetLocaleProcessor
	{
		public function GetLocaleProcessor()
		{
		}
		
		private var string_ls:Vector.<String> = new Vector.<String>;
		private var string_ls2:Array = [];
		
		public var log:Function;
		
		private var originalDirectory:File;
		
		/**
		 * 转换目录
		 */ 
		public function getLocale(fl:File):void
		{
			string_ls = null;
			string_ls = new Vector.<String>;
			
			string_ls2 = null;
			string_ls2 = [];
			
			originalDirectory = fl;
			
			//遍历文件
			var file_a:Array = originalDirectory.getDirectoryListing();
			_convertChildDirectory(file_a);
			
			
			//保存到properties中
			var targetURL:String = File.desktopDirectory.nativePath+File.separator+"main.properties"
			var target:File = new File(targetURL);
			var write:WriteFile = new WriteFile();
			write.writeAsync(target,string_ls.join(""));
		}
		
		private function _convertChildDirectory(file_a:Array):void
		{
			var n:int = file_a.length;
			for(var i:int=0;i<n;i++){
				var _file:File = file_a[i] as File;
				if(!_file.isHidden && !FileUtils.isSVNFile(_file.name)){
					if(_file.isDirectory){
						_convertChildDirectory(_file.getDirectoryListing());	
					}else{
						_convertOneFile(_file);						
					}
				}
			}
		}
		
		private function _convertOneFile(fl:File):void
		{
			var read:ReadFile = new ReadFile();
			var content:String = read.readFromFile(fl);
			
			var a:Array = getString(content);
			var str:String = replace(content,a)
			
			//覆盖原文件
			if(a.length > 0){
				str = importLocaleClass(str);
				var write:WriteFile = new WriteFile();
				write.writeAsync(fl,str);
			}
		}
		
		private function importLocaleClass(str:String):String
		{
			var n:int = str.indexOf("{");
			if(n>0){
				var s1:String = str.substring(0,n);
				s1 += "{"+StringTWLUtil.NEWLINE_SIGN +StringTWLUtil.space_sign_en2+ "import com.sandy.locale.LocaleManager;" + StringTWLUtil.NEWLINE_SIGN;
				s1 += str.substring(n+1,str.length);
				return s1
			}
			return str;
		}
		
		private function replace(s:String,a:Array):String
		{
			for(var i:int=0;i<a.length;i++){
				var str:String = a[i];
				var str2:String = str.substring(1,str.length-1);
				s = StringTWLUtil.replace(s,str,"LocaleManager.getInstance().getLocale('"+string_ls2[str2]+"')");
			}
			return s;
		}
		
		private function getString(s:String):Array
		{
			var out:Array = [];
			var a:Array = s.split(/\n|\r/);
			var n:int = a.length;
			for(var i:int=0;i<n;i++)
			{
				var str:String = a[i];
				str = StringTWLUtil.trim(str);
				if(!StringTWLUtil.isWhitespace(str)){
					var isCorrect:Boolean = true;
					// //注释
					if(str.substring(0,2) == "//"){
						isCorrect = false;
					}
					if(str.substring(0,2) == "/*"){
						isCorrect = false;
					}
					if(str.substring(0,1) == "*"){
						isCorrect = false
					}
					if(str.substring(0,2) == "*/"){
						isCorrect = false
					}
					if(str.substring(0,5) == "trace("){
						isCorrect = false
					}
					
					var dot:String;
					if(isCorrect){
						if(str.indexOf('"')!=-1){
							dot = '"'
							var b:Array = str.split('"');
							var n2:int = b.length;
							for(var j:int=0;j<n2;j++)
							{
								var str2:String = b[j];
								if(StringTWLUtil.hasChineseChar(str2) && !StringTWLUtil.isWhitespace(str2)){
									if(addList(str2)){
										out.push(dot+str2+dot);
									}
								}
							}
						}else if(str.indexOf("'")!=-1){
							dot = "'"
							b = str.split("'");
							n2 = b.length;
							for(j=0;j<n2;j++)
							{
								str2 = b[j];
								if(StringTWLUtil.hasChineseChar(str2) && !StringTWLUtil.isWhitespace(str2)){
									if(addList(str2)){
										out.push(dot+str2+dot);
									}
								}
							}
						}
					}
				}
			}
			return out;
		}
		
		private function addList(s:String):Boolean
		{
			if(filter_string_ls.indexOf(s) != -1) return false;
			if(string_ls2[s] == null){
				var ind:String = "s"+string_ls.length
				var log_s:String = ind+"="+s
				string_ls.push(log_s+StringTWLUtil.NEWLINE_SIGN);
				log(log_s);
				string_ls2[s] = ind
			}
			return true;
		}
		
		
		public static const filter_string_ls:Array = ["●","○","【","】","、","。","：",
													"β","α","κ","γ","δ","ε","ζ","η","θ",
													"ι","λ","ν","ξ","μ","ο","σ","τ","υ","φ","◆"]
		
	}
}