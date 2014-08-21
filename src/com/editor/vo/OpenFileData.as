package com.editor.vo
{
	import flash.filesystem.File;

	public class OpenFileData
	{
		public function OpenFileData()
		{
		}
		
		public var file:File;
		//跳转到行
		public var rowIndex:int;
		//标识
		public var rowSign_ls:Array;
	}
}