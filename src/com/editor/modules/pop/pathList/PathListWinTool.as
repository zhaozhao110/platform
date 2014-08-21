package com.editor.modules.pop.pathList
{
	import com.asparser.ClsUtils;
	import com.air.io.FileUtils;
	import com.air.thread.ThreadManager;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class PathListWinTool
	{
		public function PathListWinTool()
		{
		}
		
		public function getAllFile(fl:File):Array
		{
			if(!fl.exists){
				fl.createDirectory();
			}
			var a:Array = fl.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var _fl:File = a[i] as File;
				if(!FileUtils.isSVNFile(_fl.name)){
					fold_ls.push({path:_fl.nativePath,name:ClsUtils.getClassPackage(_fl)+"."+_fl.name.split(".")[0]});
				}
			}
			return fold_ls;
		}
		
		private var fold_ls:Array = [];
		
		public function getDirectory(fl:File):Array
		{
			var dp:ASTreeDataProvider = ProjectCache.getInstance().cache;
			return dp.getAllChildDirectory(fl.nativePath);
		}
		
		
		
		
	}
}