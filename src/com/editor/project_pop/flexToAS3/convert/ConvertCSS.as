package com.editor.project_pop.flexToAS3.convert
{
	import com.air.component.SandyFile;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.popup.flexToAS3.convert.vo.ConvertData;
	import com.flashartofwar.fcss.stylesheets.FStyleSheet;
	import com.flashartofwar.fcss.vo.FStyleData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ConvertCSS
	{
		public function ConvertCSS(_data:ConvertData)
		{
			data = _data;
		}
		
		private var data:ConvertData;
		public var selectFile:SandyFile;
		private var styleSheet:FStyleSheet;
		private var css_content:String;
		
		public function parser(file:SandyFile):void
		{
			selectFile = file;
			var read:ReadFile = new ReadFile();
			css_content = read.read(selectFile.nativePath);
						
			styleSheet = new FStyleSheet();
			
			createClassString();
		}
		
		public function createClassString():String
		{
			var clsStr:String = "package"+createSpace2()+createClassPath()+"{" + NEWLINE_SIGN;
			clsStr += createSpace()+"import"+createSpace2()+"theme.css.*;"+NEWLINE_SIGN;
			
			clsStr += createSpace()+"public"+createSpace()+"class"+createSpace()+selectFile.fileName+NEWLINE_SIGN;
			clsStr += createSpace()+"{" + NEWLINE_SIGN;
						
			//[Embed(source="assets/component/btn2_1.png",scaleGridTop="5", scaleGridBottom="19",scaleGridLeft="10", scaleGridRight="82")]
			//private var default2Button_btn2:Class;
			var a:Array = styleSheet.parseCSSReturnArray(css_content);
			for(var i:int=0;i<a.length;i++)
			{
				var _data:FStyleData = a[i] as FStyleData;
				var fileName:String = _data.createMetadataString();
				clsStr += createSpace(2)+"public"+createSpace2()+"var"+createSpace2()+fileName+":CSS_"+fileName+"=new"+createSpace2()+"CSS_"+fileName+"();"+NEWLINE_SIGN;
			}
			
			clsStr += createSpace()+"}" + NEWLINE_SIGN;
			clsStr += "}";
			
			var path:String = selectFile.nativePath;
			var path_a:Array = path.split(selectFile.fileName);
			path = path_a[0] + selectFile.fileName+".as";
			
			var target:File = new File(path);
			var write:WriteFile = new WriteFile();
			write.writeAsync(target,clsStr);
			
			return clsStr;
		}
		
		/**
		 * 产生类的路径
		 * 
		 */ 
		private function createClassPath():String
		{
			var path:String = selectFile.nativePath;
			path = path.split(data.originalDirectory.nativePath)[1];
			path = path.split("\\").join(".");
			path = path.split(selectFile.name)[0];
			if(path.substring(0,1) == "."){
				path = path.substring(1,path.length);
			}
			if(path.substring(path.length-1,path.length)=="."){
				path = path.substring(0,path.length-1);
			}
			return path
		}
		
		private function createSpace(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				out += "	";
				//out += " "
			}
			return out;
		}
		
		private function createSpace2(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				//out += "	";
				out += " "
			}
			return out;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
	}
}