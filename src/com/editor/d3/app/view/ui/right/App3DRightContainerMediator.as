package com.editor.d3.app.view.ui.right
{
	import com.air.io.SelectFile;
	import com.air.utils.FileFilterUtils;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class App3DRightContainerMediator extends AppMediator
	{
		public static const NAME:String = "App3DRightContainerMediator"
		public function App3DRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get rightContainer():App3DRightContainer
		{
			return viewComponent as App3DRightContainer;
		}
		
		public function get tabBar():UITabBarNav
		{
			return rightContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			rightContainer.saveTxtBtn.addEventListener(MouseEvent.CLICK , onSave);	
			rightContainer.preBtn.addEventListener(MouseEvent.CLICK , onPre);
			rightContainer.playBtn.addEventListener(MouseEvent.CLICK , onPlay);
			rightContainer.pauseBtn.addEventListener(MouseEvent.CLICK , onPause);
			rightContainer.openBtn.addEventListener(MouseEvent.CLICK , onOpen);
		}
		
		public function respondToOpenView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop3d_attri){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}else{
					tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_attri,true);
				}
				tabBar.setSelectByLabel(DataManager.tabLabel3d_attri,true);
			}else if(type == DataManager.pop3d_source){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}else{
					tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_source,true);
				}
				tabBar.setSelectByLabel(DataManager.tabLabel3d_attri,true);
			}else if(type == DataManager.pop3d_particle){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}else{
					tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_particle,true);
				}
				tabBar.setSelectByLabel(DataManager.tabLabel3d_particle,true);
			}
			
		}
		
		public function respondToCloseView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(type == DataManager.pop3d_attri){
				tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_attri,false)
			}else if(type == DataManager.pop3d_source){
				tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_source,false)
			}else if(type == DataManager.pop3d_particle){
				tabBar.setTabVisibleByLabel(DataManager.tabLabel3d_particle,false)
			}
		}
		
		public function reflashSaveInfo():void
		{
			/*rightContainer.saveTxt.htmlText = "上次保存:" + D3ProjectCache.saveTime2;
			if(D3ProjectCache.particleDataChange){
				rightContainer.saveTxt.htmlText += ColorUtils.addColorTool("/有数据发生改变.",ColorUtils.red);
				//topContainer.saveTxtBtn.visible = true
			}else{
				//topContainer.saveTxtBtn.visible = false;
			}*/
		}
		    
		public function respondToChangeStackMode3DEvent(noti:Notification):void
		{
			if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_particle){
				rightContainer.saveTxt.visible = true;
				rightContainer.saveTxtBtn.visible = true
				rightContainer.preBtn.visible = true;
				rightContainer.playBtn.visible = true;
				rightContainer.pauseBtn.visible = true;
				rightContainer.openBtn.visible = true;
			}else if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_scene){
				rightContainer.saveTxt.visible = false
				rightContainer.saveTxtBtn.visible = false
				rightContainer.preBtn.visible = false;
				rightContainer.playBtn.visible = false;
				rightContainer.pauseBtn.visible = false;
				rightContainer.openBtn.visible = false;
			}
		}
		
		private function onSave(e:MouseEvent):void
		{
			D3ProjectCache.getInstance().saveParticle();
		}
		
		private function onPre(e:MouseEvent):void
		{
			D3SceneManager.getInstance().currScene.particleContainer.playParticle(D3ProjectCache.getInstance().preParticle());
		}
		
		private function onPlay(e:MouseEvent):void
		{
			D3SceneManager.getInstance().currScene.particleContainer.playAgain()
		}
		
		private function onPause(e:MouseEvent):void
		{
			D3SceneManager.getInstance().currScene.particleContainer.stopParticle()
		}
		
		private function onOpen(e:MouseEvent):void
		{
			SelectFile.select("particle",FileFilterUtils.parser(["awp","particle"]),openResult);
		}
		
		private function openResult(e:Event):void
		{
			var f:File = e.target as File;
			if(f.exists)sendAppNotification(D3Event.select3DComp_event,D3SceneManager.getInstance().displayList.convertObject(f));
		}
		
	}
}