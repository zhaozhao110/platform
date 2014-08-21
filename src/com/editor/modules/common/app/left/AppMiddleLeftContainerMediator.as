package com.editor.modules.common.app.left
{
	import com.editor.component.controls.UITabBarNav;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class AppMiddleLeftContainerMediator extends AppMediator
	{	
		public static const NAME:String = "AppMiddleLeftContainerMediator";
		public function AppMiddleLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get leftContainer():AppMiddleLeftContainer
		{
			return viewComponent as AppMiddleLeftContainer;
		}
		public function get tabBar():UITabBarNav
		{
			return leftContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function respondToOpenViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop_projectDirectory ){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}else if(type == DataManager.pop_comList){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}else if(type == DataManager.pop_outline){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}else if(type == DataManager.pop_invertedGroup){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}else if(type == DataManager.pop_codeOutline){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}else if(type == DataManager.pop_search){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}
		}
		
		public function respondToCloseViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop_projectDirectory ){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}else if(type == DataManager.pop_comList ){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}else if(type == DataManager.pop_outline){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}else if(type == DataManager.pop_invertedGroup){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}else if(type == DataManager.pop_codeOutline){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var a:Array = [];
			if(type == DataManager.stack_code){
				a = DataManager.codeStack_tab;
			}else if(type == DataManager.stack_ui){
				a = DataManager.uiStack_tab;
			}else if(type == DataManager.stack_css){
				a = DataManager.cssStack_tab;
			}
			if(a.length == 0) return ;
			var n:int = tabBar.getTabLength();
			for(var i:int=0;i<n;i++){
				tabBar.setTabVisible(i,false);
			}
			for(i=0;i<a.length;i++){
				tabBar.setTabVisibleByLabel(a[i],true);
			}
			if(type == DataManager.stack_code){
				tabBar.setSelectByLabel(DataManager.tabLabel_projectDirt,true);
			}else if(type == DataManager.stack_ui){
				tabBar.setSelectByLabel(DataManager.tabLabel_comList,true);
			}else if(type == DataManager.stack_css){
				tabBar.setSelectByLabel(DataManager.tabLabel_projectDirt,true);
			}
		}
		
		
	}
}