package com.editor.module_ui.vo
{
	import com.air.io.FileUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	/**
	 * 编辑的ui文件
	 */ 
	public class UIComponentData
	{
		public function UIComponentData()
		{
		}
		
		public var name:String;
		public var smallName:String;
		//E:\hg_res\sandy_engine\test\uiTest\src\com\rpg\modules\sh\userInfo\view\UserInfoPopupwin.as
		public var file:File;
		public var toolTip:String;
		public var path:String;
		
		public function parserFile(fl:File):void
		{
			file = fl;
			name = file.name;
			smallName = name.split(".")[0];
			path = file.nativePath;
			toolTip = path;
			
		}
		
		public function getXMLFile():File
		{
			var url:String;
			if(file.extension == "xml"){
				return file;
			}else{
				url = file.parent.nativePath+File.separator+"xml"+File.separator+smallName+".xml";
			}
			var f:File = new File(url);
			return f;
		}
		
		
		
		public function getASFile():File
		{
			var url:String;
			if(file.extension == "as"){
				return file;
			}else{
				url = file.parent.parent.nativePath+File.separator+file.name.split(".")[0]+".as";
			}
			var f:File = new File(url);
			return f;
		}
		
		public function getBackgroundImage():File
		{
			var url:String;
			if(file.extension == "xml"){
				url = file.parent.nativePath+File.separator+"img";
			}else{
				url = file.parent.nativePath+File.separator+"xml"+File.separator+"img";
			}
			var f:File = new File(url);
			var ff:File = FileUtils.checkHaveFile(f,smallName);
			if(ff!=null){
				return ff;
			}
			return null;
		}
		
		
		
	}
}