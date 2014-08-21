package com.editor.modules.pop.recentOpenProject
{
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectViewMediator;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.filesystem.File;

	public class AppRecentOpenProjectPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppRecentOpenProjectPopwinMediator"
		public function AppRecentOpenProjectPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get recentWin():AppRecentOpenProjectPopwin
		{
			return viewComponent as AppRecentOpenProjectPopwin;
		}
		public function get uiList():UIVlist
		{
			return recentWin.uiList;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			uiList.addEventListener(ASEvent.CHANGE,onComListChange);
			
			var b:Array = [];
			var a:Array = [];
			if(AppMainModel.getInstance().isIn3DScene){
				a = AppMainModel.getInstance().applicationStorageFile.recent3DProject_ls;
			}else{
				a = AppMainModel.getInstance().applicationStorageFile.recentProject_ls;
			}
			for(var i:int=0;i<a.length;i++){
				var fl:File = new File(a[i]);
				b.push(fl);
			}
			uiList.labelField = "name";
			uiList.dataProvider = b;
		}
		
		private function onComListChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var f:File = e.addData as File;
				if(AppMainModel.getInstance().isIn3DScene){
					sendAppNotification(D3Event.change3DProject_event,f);
				}else{
					sendAppNotification(AppEvent.changeProject_event,f);
				}
				closeWin();
			}
		}
		
		
		
		
	}
}