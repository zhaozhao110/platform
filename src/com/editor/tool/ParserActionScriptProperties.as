package com.editor.tool
{
	import com.air.io.ReadFile;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.project.ActionScriptPropertiesData;
	
	import flash.filesystem.File;

	public class ParserActionScriptProperties
	{
		public function ParserActionScriptProperties()
		{
		}
		
		private var read:ReadFile = new ReadFile();
		public var data:ActionScriptPropertiesData = new ActionScriptPropertiesData();
		
		public function parser():void
		{
			var fl:File = new File(ProjectCache.getInstance().getActionScriptProperties());
			var cont:String = read.readFromFile(fl);
			var x:XML = XML(cont);
			var x1:XML = XML(x.child("compiler")[0]);
			data.sdk = x1.@flexSDK;
			data.additionalCompilerArguments = x1.@additionalCompilerArguments;
		}
	}
}