package com.editor.module_ui.ui
{
	import flash.filesystem.File;

	public class CheckIsUIEditorFile
	{
		public function CheckIsUIEditorFile()
		{
		}
		
		public var complete_f:Function;
		public var complete_args:*;
		
		private var file:File;
		
		
		public function check(fl:File):void
		{
			file = fl;
			var sp:File = fl.parent;
			checkXML(sp);
		}
				
		private function checkXML(p:File):void
		{
			var a:Array = p.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var f:File = a[i] as File;
				if(!f.isDirectory && f.name.split(".")[0] == file.name.split(".")[0]){
					complete_f(true,complete_args);
					return ;
				}
			}
			complete_f(false,complete_args);
		}
		
		
	}
}