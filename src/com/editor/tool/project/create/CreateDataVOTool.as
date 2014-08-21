package com.editor.tool.project.create
{
	import com.asparser.ClsUtils;
	import com.air.io.WriteFile;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	//vo
	public class CreateDataVOTool
	{
		public function CreateDataVOTool()
		{
		}
		
		private var write:WriteFile = new WriteFile();
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		}
		
		public function create(fold_sign:String,url:String):void
		{
			var clsName:String = StringTWLUtil.setFristUpperChar(fold_sign)
			var path:String = url + File.separator + clsName+".as"
			var file:File = new File(path);
			if(file.exists){
				SandyManagerBase.getInstance().showError("已经有该文件了");
				return ;
			}
			var cont:String = getTemple(8);
			cont = StringTWLUtil.replace(cont,"com.rpg.vo.temp",ClsUtils.getClassPackage(file));
			cont = StringTWLUtil.replace(cont,"TempItemVO",clsName);
			
			write.write(file,cont);
		}
		
	}
}