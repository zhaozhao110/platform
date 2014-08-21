package com.editor.d3.app.view.ui.top
{
	import com.air.io.FileUtils;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UIMenuBar;
	import com.editor.component.controls.UIToggleButtonBar;
	import com.editor.d3.app.manager.App3DMenuManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.vo.global.AppMenuConfig;
	import com.editor.vo.stacks.StackDataVO;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	
	public class App3DTopBarContainerMediator extends AppMediator
	{
		public static const NAME:String = "App3DTopBarContainerMediator"
		public function App3DTopBarContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topContainer():App3DTopBarContainer
		{
			return viewComponent as App3DTopBarContainer;
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
		private function get txt():UILinkButton
		{
			return topContainer.txt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			menuBar.addEventListener(ASEvent.CHANGE,menuBarChangeHandle)
			stackBar.labelField = "name"
			stackBar.addEventListener(ASEvent.CHANGE,_stackBarChange);	
			txt.addEventListener(MouseEvent.CLICK , onLinkClick);
			
			topContainer.saveTxtBtn.addEventListener(MouseEvent.CLICK , onSave);
			topContainer.preBtn.addEventListener(MouseEvent.CLICK , onPre);
			topContainer.preBtn.disabledTime = 2000
		}
				
		public function respondToD3SceneInitEvent(noti:Notification):void
		{
			stackBar.dataProvider = D3ComponentConst.d3Stack_ls;
			stackBar.selectedIndex = 0;
			
			menuBar.dataProvider = AppMenuConfig.instance.top3DMenu_xml;
			
			txt.text = AppMainModel.getInstance().applicationStorageFile.curr_3dproject;
		}
		
		public function respondToChangeTo3DSceneEvent(noti:Notification):void
		{
			if(StringTWLUtil.isWhitespace(txt.text)) return ;
			if(AppMainModel.getInstance().d3SceneCreated) return ;
			get_App3DMainUIContainerMediator().showLoading();
			to3DSceneLater();
		}
		
		private function to3DSceneLater():void
		{
			var f:File = new File(txt.text);
			if(f.exists){
				sendAppNotification(D3Event.change3DProject_event,f);
			}else{
				get_App3DMainUIContainerMediator().hideLoading();
			}
		}
		
		private function onLinkClick(e:MouseEvent):void
		{
			var f:File = new File(txt.text);
			if(f.exists){
				FileUtils.openFold(f.nativePath);
			}
		}
		
		public function reflashSaveInfo():void
		{
			topContainer.saveTXT.htmlText = "上次保存:" + D3ProjectCache.saveTime;
			if(D3ProjectCache.dataChange){
				topContainer.saveTXT.htmlText += ColorUtils.addColorTool("/有数据发生改变.",ColorUtils.red);
				//topContainer.saveTxtBtn.visible = true
			}else{
				//topContainer.saveTxtBtn.visible = false;
			}
		}
		
		private function onSave(e:MouseEvent):void
		{
			D3ProjectCache.dataChange = true;
			D3ProjectCache.getInstance().createXML();
		}
		
		public function respondToChange3DProjectEvent(noti:Notification):void
		{
			txt.text = AppMainModel.getInstance().applicationStorageFile.curr_3dproject;
		}
		
		private function menuBarChangeHandle(e:ASEvent):void
		{
			var dat:IASMenuButton = e.data as IASMenuButton;
			var xml:XML = dat.getMenuXML();
			App3DMenuManager.getInstance().topMenuBarClick(xml);
		}
		
		public function respondToChangeStackMode3DEvent(noti:Notification):void
		{
			if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_scene){
				topContainer.saveTXT.visible = true;
				topContainer.saveTxtBtn.visible = true
				stackBar.selectedIndex = 0
			}else if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_particle){
				topContainer.saveTXT.visible = false
				topContainer.saveTxtBtn.visible = false
				stackBar.selectedIndex = 1;
			}
		}
		
		private function _stackBarChange(e:ASEvent):void
		{
			Stack3DManager.getInstance().changeStack((stackBar.selectedItem as StackDataVO).id);
		}
		
		private function onPre(e:MouseEvent):void
		{
			
		}
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
	}
}