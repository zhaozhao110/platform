package com.editor.modules.app.view.ui.topBar
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.component.controls.UIToggleButtonBar;
	import com.editor.event.App3DEvent;
	import com.editor.event.AppEvent;
	import com.editor.manager.AppTimerManager;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
	import com.editor.modules.manager.AppMenuManager;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.tool.project.jsfl.CompileFla;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.plus.PlusItemVO;
	import com.editor.vo.stacks.StackDataVO;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.data.SandyData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class AppTopBarContainerMediator extends AppMediator
	{
		public static const NAME:String = "AppTopBarContainerMediator"
		public function AppTopBarContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topContainer():AppTopBarContainer
		{
			return viewComponent as AppTopBarContainer;
		}
		public function get menuBar():UIMenuBar
		{
			return topContainer.menuBar;
		}
		//打开透视图
		public function get stackBar():UIToggleButtonBar
		{
			return topContainer.stackBar;
		}
		public function get projectHB():UIHBox
		{
			return topContainer.projectHB;
		}
		private function get txt():UILabel
		{
			return topContainer.txt;
		}
		public function get setBtn():UIButton
		{
			return topContainer.setBtn;
		}
		public function get to3DBtn():UIButton
		{
			return topContainer.to3DBtn;
		}
		public function get toGDPSBtn():UIButton
		{
			return topContainer.toGDPSBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			menuBar.addEventListener(ASEvent.CHANGE,menuBarChangeHandle)
							
			stackBar.labelField = "name";
			stackBar.addEventListener(ASEvent.CHANGE,_stackBarChange);
			stackBar.addEventListener(ASEvent.TAB_REMOVED,_stackBarRemove);			
		}
				
		public function respondToLoginEvent(noti:Notification):void
		{
			var x:XML = get_AppModuleProxy().menuBar_ls.xml;
			var a:Array = get_AppPlusProxy().list.list;
			var add_x:XML = <menuitem label="插件"/>
			x.appendChild(add_x);	
			for(var i:int=0;i<a.length;i++){
				var plus_d:PlusItemVO = a[i] as PlusItemVO;
				var child_x:XML = <menuitem />
				child_x.@label = plus_d.name;
				child_x.@tip = plus_d.toolTip;
				add_x.appendChild(child_x)
			}
			menuBar.dataProvider = x;
			
			var haveCodeStack:Boolean;
			
			if(AppMainModel.getInstance().applicationStorageFile.stacks_ls.length > 0){
				var cahce_ls:Array = AppMainModel.getInstance().applicationStorageFile.stacks_ls;
				var out:Array = [];
				for(i=0;i<cahce_ls.length;i++){
					var stackId:int = cahce_ls[i];
					var item:StackDataVO = AppGlobalConfig.instance.stack_list.getData(stackId);
					if(item!=null&&AppMainModel.getInstance().user.checkInPower(item.power)){
						if(item.id == DataManager.stack_code){
							haveCodeStack = true;
						}
						out.push(item);
					}
				}
				showStackBar_ls = out;
			}else{
				a = AppGlobalConfig.instance.stack_list.stack_ls.slice(0,3);
				out = [];
				for(i=0;i<a.length;i++){
					item = a[i] as StackDataVO;
					if(AppMainModel.getInstance().user.checkInPower(item.power)){
						if(item.id == DataManager.stack_code){
							haveCodeStack = true;
						}
						out.push(item);
					}
				}
				showStackBar_ls = out;
			}
			
			if(AppMainModel.getInstance().user.checkInPower([1,2])){
				if(!haveCodeStack){
					showStackBar_ls.push(AppGlobalConfig.instance.stack_list.getData(DataManager.stack_code))
				}
			}
			
			showStackBar_ls = showStackBar_ls.sortOn("id",Array.NUMERIC);
			
			stackBar.dataProvider = showStackBar_ls;
			
			setTimeout(laterChangeStack,1000);
		}
		
		private function cacheStacks():void
		{
			var out:Array = [];
			for(var i:int=0;i<showStackBar_ls.length;i++){
				var d:StackDataVO = showStackBar_ls[i] as StackDataVO;
				out.push(d.id);
			}
			if(out.length > 0){
				AppMainModel.getInstance().applicationStorageFile.putKey_stacks(out.join(","));
			}
		}
		
		private var showStackBar_ls:Array = [];
				
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var a:Array = stackBar.dataProvider as Array;
			var haveTab:Boolean;
			for(var i:int=0;i<a.length;i++){
				if((a[i] as StackDataVO).id == StackManager.currStack){
					haveTab = true;
					break;
				}
			}
			if(haveTab){
				for(i=0;i<a.length;i++){
					if((a[i] as StackDataVO).id == StackManager.currStack){
						stackBar.selectedIndex = i;
						break;
					}
				}
			}else{
				var d:StackDataVO = AppGlobalConfig.instance.stack_list.getData(type);
				if(d!=null){
					showStackBar_ls.push(d);
					cacheStacks();
					stackBar.dataProvider = showStackBar_ls;
					stackBar.selectedIndex = showStackBar_ls.length-1;
				}
			}
		}
		
		//切换到代码透视图
		private function laterChangeStack():void
		{
			if(AppMainModel.getInstance().user.checkInPower([1,2])){
				showStack(DataManager.stack_code);
			}else{
				stackBar.selectedIndex = 0;
			}
		}
		
		private function showStack(ind:int):void
		{
			var n:int = stackBar.numChildren;
			for(var i:int=0;i<n;i++){
				var it:StackDataVO = (stackBar.getChildAt(i) as ASComponent).data as StackDataVO;
				if(it.id == ind){
					stackBar.selectedIndex = i;
					break
				}
			}
		}
		
		private function menuBarChangeHandle(e:ASEvent):void
		{
			var dat:IASMenuButton = e.data as IASMenuButton;
			var xml:XML = dat.getMenuXML();
			AppMenuManager.getInstance().topMenuBarClick(xml);
		}
		
		private function _stackBarChange(e:ASEvent):void
		{
			StackManager.getInstance().changeStack((stackBar.selectedItem as StackDataVO).id);
		}
		
		private function _stackBarRemove(e:ASEvent):void
		{
			cacheStacks();
		}
		
		public function setProject(path:String):void
		{
			txt.text = path;
			if(!StringTWLUtil.isWhitespace(path)){
				setBtn.visible = true;
			}
		}
		
		public function respondToCloseProjectEvent(noti:Notification):void
		{
			txt.text = "";
			setBtn.visible = false;
		}
		
		public function reactToSetBtnClick(e:MouseEvent):void
		{
			/*var pile:CompileFla = new CompileFla();
			pile.createUserModuleFla();
			return ;*/
			var open:OpenPopwinData = new OpenPopwinData();
		//	open.data = input_vo;
			open.popupwinSign = PopupwinSign.ProjectSetPopwin_sign
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		public function reactToTo3DBtnClick(e:MouseEvent):void
		{
			sendAppNotification(App3DEvent.changeTo3DScene_event);
		}
		
		public function reactToToGDPSBtnClick(e:MouseEvent):void
		{
			sendAppNotification(AppEvent.sendGotoGDPS_event);
		}
		
		private function get_AppModuleProxy():AppModuleProxy
		{
			return retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy;
		}
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy;
		}
	}
}