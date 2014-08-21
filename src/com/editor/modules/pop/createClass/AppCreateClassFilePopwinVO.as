package com.editor.modules.pop.createClass
{
	import com.editor.module_ui.vo.component.ComItemVO;
	
	import flash.filesystem.File;

	public class AppCreateClassFilePopwinVO
	{
		public function AppCreateClassFilePopwinVO()
		{
		}
		
		//as
		public static const file_type1:int = 1;
		//css
		public static const file_type2:int = 2;
		//ui - xml
		public static const file_type3:int = 3;
		//package
		public static const file_type4:int = 4;
		//popupwin
		public static const file_type5:int = 5;
		
		public var type:int;
		//创建的文件的父级目录
		public var package_file:File;
		public var selectStyleCom:ComItemVO;
		public var file:File;
		
		public function getFileSuffix():String
		{
			if(type == file_type1){
				return ".as"
			}else if(type == file_type2){
				return ".as"
			}else if(type == file_type3){
				return ".as"
			}
			return "";
		}
	}
}