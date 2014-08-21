package com.editor.module_ui.app.ui
{
	import com.air.io.ReadFile;
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UITabBar;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.CheckIsUIEditorFile;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowContainer;
	import com.editor.module_ui.view.uiAttri.ComSystemAttriCell;
	import com.editor.module_ui.view.uiAttri.com.ComInput;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.module_ui.vo.UIComponentData;
	import com.editor.module_ui.vo.expandComp.ExpandCompListVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	import com.sandy.manager.StageManager;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.LoadQueueEvent;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	public class UIEditorMediator extends AppMediator
	{
		public static const NAME:String = 'UIEditorMediator'
		public function UIEditorMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get thisView():UIEditor
		{
			return viewComponent as UIEditor;
		}
		public function get content():UIViewStack
		{
			return thisView.content;
		}
		public function get toolBar():UIEditorTopBar
		{
			return thisView.toolBar;
		}
		public function get tabBar():UITabBar
		{
			return thisView.tabbar;
		}
		public function get logCont():LogContainer
		{
			return thisView.logCont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			tabBar.addEventListener(ASEvent.CHANGE,tabBarChange);
			tabBar.addEventListener(ASEvent.TAB_REMOVED,tabBarRemove)
			
			registerMediator(new UIEditorTopBarMediator(toolBar));
			loadCSSLibs();
			loadExpndComp();
			
			thisView.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			thisView.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		private function loadExpndComp():void
		{
			ProjectAllUserCache.getInstance().loadExpndComp();
		}
				
		
		private var isMove:Boolean;
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.getSelect() == null) return ;
			if(StageManager.getMouseInNativeWinStage().focus is TextField) return 
			if(e.keyCode == Keyboard.RIGHT){
				UIEditManager.currEditShowContainer.getSelect().x += 1;
				isMove = true
			}else if(e.keyCode == Keyboard.LEFT){
				UIEditManager.currEditShowContainer.getSelect().x -= 1;
				isMove = true
			}else if(e.keyCode == Keyboard.UP){
				UIEditManager.currEditShowContainer.getSelect().y -= 1;
				isMove = true
			}else if(e.keyCode == Keyboard.DOWN){
				UIEditManager.currEditShowContainer.getSelect().y += 1;
				isMove = true
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(!isMove) return ;
			isMove = false
			if(StageManager.getMouseInNativeWinStage().focus is TextField) return				
			if(UIEditManager.currEditShowContainer.selectedUI == null){
				ComSystemAttriCell.instance.reflashBackImgLoc();
				return ;
			}
			
			if(UIEditManager.currShowUIAttri == null) return ;
			UIEditManager.currEditShowContainer.selectedUI.setAttri("x",UIEditManager.currEditShowContainer.selectedUI.target.x);
			UIEditManager.currEditShowContainer.selectedUI.setAttri("y",UIEditManager.currEditShowContainer.selectedUI.target.y);
			UIEditManager.currEditShowContainer.selectedUI.selectedThis();
		}
		
		private var loadLibs_complete:Boolean;
		private var later_file:File;
		//加载css的资源库
		private function loadCSSLibs():void
		{
			ProjectAllUserCache.getInstance().loadCSSLibs(_loadCompletehandle);
		}
		
		private function _loadCompletehandle(e:LoadQueueEvent=null):void
		{
			//iLogger.info("333");
			loadLibs_complete = true;
			if(later_file!=null){
				openFile(later_file);
			}
		}
				
		private function tabBarRemove(e:ASEvent):void
		{
			content.removeStack(int(e.data));
		}
		
		private function tabBarChange(e:ASEvent=null):void
		{
			content.setSelectIndex(tabBar.selectedIndex);
			UIEditManager.currEditShowContainer = content.getSelectedContianer() as UIShowContainer;
			sendAppNotification(UIEvent.currEditUIFile_change_event);
		}
		
		private function checkHaveOpen(file:UIComponentData):Boolean
		{
			var a:Array = tabBar.dataProvider as Array;
			if(a!=null){
				for(var i:int=0;i<a.length;i++){
					if(UIComponentData(a[i]).path == file.path){
						tabBar.setSelectIndex(i,false);
						return true
					}
				}
			}
			return false;
		}
		
		public function respondToCloseProjectEvent(noti:Notification):void
		{
			tabBar.dataProvider = null;
		}
		
		//新建
		public function respondToOpenFileInUIEditorEvent(noti:Notification):void
		{
			var d:OpenFileInUIEditorEventVO = noti.getBody() as OpenFileInUIEditorEventVO;
			if(d.file.name.indexOf("CSS_")!=-1){
				showError("该文件好像是css文件，应该在css中编辑");
				return ;
			}
			
			openFile(d.file);
		}
		
		private function openFile(fl:File):void
		{
			if(!loadLibs_complete){
				//SandyError.error("load libs not complete");
				later_file = fl;
				return ;
			}
			if(UIEditManager.currEditShowContainer!=null){
				if(UIEditManager.currEditShowContainer.uiData.file.nativePath == fl.nativePath) return ;
			}
			
			var d:UIComponentData = new UIComponentData();
			d.parserFile(fl);
			
			if(checkHaveOpen(d)){
				tabBarChange();
				return ;
			}
		
			addFile(d);
			if(UIEditManager.currEditShowContainer!=null){
				UIEditManager.currEditShowContainer.setValue(d);
			}
			later_file = null;
		}
		
		//在项目中打开
		public function respondToOpenEditFileEvent(noti:Notification):void
		{
			if(StackManager.currStack != DataManager.stack_ui) return ;
			var dd:OpenFileData = noti.getBody() as OpenFileData;
			var file:File = dd.file;
			var c:CheckIsUIEditorFile = new CheckIsUIEditorFile();
			c.complete_f = checkIsUIEditorFileComplete;
			c.complete_args = file;
			c.check(file);
		}
		
		private function checkIsUIEditorFileComplete(b:Boolean,file:File):void
		{
			if(b){
				openFile(file);
			}else{
				showError("不符合界面编辑文件格式")
			}
		}
		
		private function addFile(file:UIComponentData):void
		{
			if(checkHaveOpen(file)) return ;
			
			var ui:UIShowContainer = new UIShowContainer();
			content.addChild(ui);
			
			var ds:ASComponent = tabBar.addTab(file) as ASComponent;
			ds.toolTip = file.file.nativePath;
			
			UIEditManager.currEditShowContainer = ui;
		}
		
		
	}
}