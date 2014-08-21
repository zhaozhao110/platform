package com.editor.tool.project.create
{
	import com.air.io.WriteFile;
	import com.editor.event.AppEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	//cache
	public class CreateCacheTool
	{
		public function CreateCacheTool()
		{
		}
		
		private var write:WriteFile = new WriteFile();
		
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		}
		
		public function create(fold_sign:String):void
		{
			var url:String = ProjectCache.getInstance().getCachePath()
			var clsName:String = StringTWLUtil.setFristUpperChar(fold_sign)
			var path:String = url + File.separator + clsName+".as"
			var file:File = new File(path);
			if(file.exists){
				SandyManagerBase.getInstance().showError("已经有该文件了");
				return ;
			}
			var cont:String = getTemple(10);
			cont = StringTWLUtil.replace(cont,"PackCache",clsName);
			
			write.write(file,cont);
			
			var new_fl:File = new File(url);
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.openFold_event,new_fl);
		}
		
	}
}