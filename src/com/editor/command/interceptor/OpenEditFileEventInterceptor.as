package com.editor.command.interceptor
{
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.OpenFileData;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.filesystem.File;

	public class OpenEditFileEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			var dd:OpenFileData = notification.getBody() as OpenFileData 
			var fl:File = dd.file;
			if(fl == null) return ;
			if(!fl.exists) skip();
			
			if(fl.extension == "as" || fl.extension == "xml" || fl.extension == "txt" || includeFile(fl)){
				StackManager.getInstance().changeStack(DataManager.stack_code)
			}else if(fl.extension == "png" || fl.extension == "jpg"){
				var open:OpenPopwinData = new OpenPopwinData();
				open.data = ProjectCache.getInstance().getProjectOppositePath(fl.nativePath);
				open.popupwinSign = PopupwinSign.PreImagePopWin_sign;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				SandyManagerBase.getInstance().openPopupwin(open);
				skip();
				return ;
			}else{
				var d:OpenMessageData = new OpenMessageData();
				d.info = "该文件类型将用系统默认软件打开？";
				d.okFunction = openFile;
				d.okFunArgs = fl;
				showConfirm(d);
				
				skip();
				return ;
			}
			
			proceed();
		}
		
		private function includeFile(fl:File):Boolean
		{
			if(fl.extension == "project") return true;
			if(fl.extension == "actionScriptProperties") return true;
			return false;
		}
		
		private function openFile(fl:File):Boolean
		{
			fl.openWithDefaultApplication();
			return true;
		}
		
	}
}