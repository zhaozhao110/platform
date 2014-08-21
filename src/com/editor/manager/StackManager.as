package com.editor.manager
{
	import com.editor.component.LogContainer;
	import com.editor.event.AppEvent;
	import com.editor.module_code.CodeEditorManager;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.modules.app.view.main.AppMainUIViewStackMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.manager.SandyManagerBase;
	
	import flash.filesystem.File;

	//透视图管理
	public class StackManager extends SandyManagerBase
	{
		private static var instance:StackManager ;
		public static function getInstance():StackManager{
			if(instance == null){
				instance =  new StackManager();
			}
			return instance;
		}
		
		public static var viewStackMediator:AppMainUIViewStackMediator;
		public static var currStack:int;
		
		public static function checkIsEditCSS():Boolean
		{
			return currStack == DataManager.stack_css	
		}
		
		public static function checkIsEditUI():Boolean
		{
			return currStack == DataManager.stack_ui;
		}
		
		public function changeStack(type:int):Boolean
		{
			if(currStack == type) return false;
			currStack = type;
			
			if(type == DataManager.stack_code){
				changeToCodeStack();
			}else if(type == DataManager.stack_ui){
				changeToUIStack();
			}else if(type == DataManager.stack_css){
				changeToCSSStack();
			}
			
			sendAppNotification(AppEvent.change_stackMode_event,null,type.toString());
			return true;
		}
		
		public static function checkIsCodeStack():Boolean
		{
			if(StackManager.currStack == DataManager.stack_code||
				StackManager.currStack == DataManager.stack_css ||
				StackManager.currStack == DataManager.stack_ui){
				return true
			}
			return false;
		}
		
		//代码编辑
		private function changeToCodeStack():void
		{
			sendAppNotification(AppEvent.setVisible_right_event,false);
			ViewManager.getInstance().openView(DataManager.pop_console);
			ViewManager.getInstance().openView(DataManager.pop_codeEditor);
			ViewManager.getInstance().openView(DataManager.pop_projectDirectory);
			ViewManager.getInstance().openView(DataManager.pop_codeOutline);
			ViewManager.getInstance().openView(DataManager.pop_search);
		}
		
		//界面编辑
		private function changeToUIStack():void
		{			
			sendAppNotification(AppEvent.setVisible_right_event,true);
			ViewManager.getInstance().openView(DataManager.pop_uiEditor);
			ViewManager.getInstance().openView(DataManager.pop_comList);	
			ViewManager.getInstance().openView(DataManager.pop_uiAttriList);
			ViewManager.getInstance().openView(DataManager.pop_outline);
			ViewManager.getInstance().openView(DataManager.pop_invertedGroup);
		}
		
		//css edit
		private function changeToCSSStack():void
		{
			sendAppNotification(AppEvent.setVisible_right_event,true);
			ViewManager.getInstance().openView(DataManager.pop_comList);	
			ViewManager.getInstance().openView(DataManager.pop_cssAttriList);
			ViewManager.getInstance().openView(DataManager.pop_cssEdit);
		}
		
		public function addCurrLogCont(s:String):void
		{
			if(StackManager.currStack == DataManager.stack_ui){
				UIEditManager.uiEditor.logCont.addLog(s);
			}else if(StackManager.currStack == DataManager.stack_css){
				UIEditManager.cssEditor.logCont.addLog(s);
			}else if(StackManager.currStack == DataManager.stack_code){
				LogManager.getInstance().addLog(s);
			}
		}
		
		public function openCurrLogCont():void
		{
			if(StackManager.currStack == DataManager.stack_ui){
				UIEditManager.uiEditor.logCont.forceOpen()
			}else if(StackManager.currStack == DataManager.stack_css){
				UIEditManager.cssEditor.logCont.forceOpen()
			}
			sendAppNotification(AppEvent.openLog_event);
		}
		
		public function getCurrEditFile():File
		{
			if(StackManager.currStack == DataManager.stack_code){
				return CodeEditorManager.currEditFile;
			}else if(StackManager.currStack == DataManager.stack_ui){
				if(UIEditManager.currEditShowContainer!=null){
					return UIEditManager.currEditShowContainer.uiData.file;
				}
			}else if(StackManager.currStack == DataManager.stack_css){
				if(CSSShowContainerMediator.currEditFile!=null){
					return CSSShowContainerMediator.currEditFile.file;
				}
			}
			return null;
		}
		
		
	}
}