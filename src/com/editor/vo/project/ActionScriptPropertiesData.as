package com.editor.vo.project
{
	import com.asparser.swcparser.parser.TypeDB_swc;

	public class ActionScriptPropertiesData
	{
		public function ActionScriptPropertiesData()
		{
		}
		
		public var sdk:String;
		public var sdk_path:String;
		public var additionalCompilerArguments:String;
		public var sdk_swc_db:TypeDB_swc;
	}
}