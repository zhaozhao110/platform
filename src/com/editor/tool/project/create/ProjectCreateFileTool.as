package com.editor.tool.project.create
{
	import com.asparser.ClsUtils;
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ProjectCreateFileTool
	{
		public function ProjectCreateFileTool()
		{
		}
		
		public static function createAS(item:AppCreateClassFilePopwinVO):String
		{
			var s:String = "/** author by ["+AppMainModel.getInstance().user.shortName+"[ , please not delete **/"+StringTWLUtil.NEWLINE_SIGN;
			s += ClsUtils.createEmptyClass(item.file);
			return s;
		}
		
		public static function createCSS(item:AppCreateClassFilePopwinVO):String
		{
			var s:String = "/** from templete <" + item.selectStyleCom.name + "> , please not delete **/"+StringTWLUtil.NEWLINE_SIGN;
			s += ClsUtils.createEmptyClass(item.file);
			return s;
		}
		
		public static function createXML(item:AppCreateClassFilePopwinVO):void
		{
			/*var write:WriteFile = new WriteFile();
			write.write(new File(item.url),"");*/
		}
		
		
		
	}
}	