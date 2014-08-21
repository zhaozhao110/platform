package com.editor.d3.view.source
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.view.ui.right.App3DRightContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.event.App3DEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.System;

	public class D3SourcePopViewMediator extends AppMediator
	{
		public static const NAME:String = "D3SourcePopViewMediator"
		public function D3SourcePopViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get view():D3SourcePopView
		{
			return viewComponent as D3SourcePopView;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			view.visible = false
			view.addEventListener(ASEvent.VISIBLE_CHANGE,viewChange);
			view.copyBtn.addEventListener(MouseEvent.CLICK , onCopy);
			get_App3DRightContainerMediator().tabBar.addEventListener(ASEvent.CHANGE,onTabBarChange);
		}
		
		private function onCopy(e:MouseEvent):void
		{
			System.setClipboard(view.txt.text);
		}
		
		public function respondToSelect3DCompEvent(noti:Notification=null):void
		{
			var comp:D3ObjectBase = noti.getBody() as D3ObjectBase;
			
			if(comp!=null){
				if(comp.group == D3ComponentConst.comp_group10){
					view.visible = false;
				}
				if(comp.group == D3ComponentConst.comp_group6){
					view.visible = false;
				}
				return ;
			}
			
			if(comp == null){
				if(noti.getBody() is File){
					var f:File = noti.getBody() as File;
					if(f.exists){
						if(D3ResChangeProxy.getInstance().getFile(f.nativePath)!=null){
							openText(D3ResChangeProxy.getInstance().getFile(f.nativePath).content);
							if(get_App3DRightContainerMediator().tabBar.getSelectedTab().label == DataManager.tabLabel3d_source){
								view.visible = true;
							}
						}
					}else{
						view.visible = false;
					}
				}
				return ;
			}
			
			reflashTitle(comp);
			comp.proccess.openSource();
			if(get_App3DRightContainerMediator().tabBar.getSelectedTab().label == DataManager.tabLabel3d_source){
				view.visible = true;
			}
		}
		
		private function onTabBarChange(e:ASEvent):void
		{
			if(get_App3DRightContainerMediator().tabBar.selectedIndex==1){
				var noti:Notification = new Notification(D3Event.select3DComp_event);
				noti.setBody(D3SceneManager.getInstance().displayList.selectedComp);
				respondToSelect3DCompEvent(noti);
			}
		}
		
		private function get_App3DRightContainerMediator():App3DRightContainerMediator
		{
			return retrieveMediator(App3DRightContainerMediator.NAME) as App3DRightContainerMediator;
		}
		
		private function reflashTitle(comp:D3ObjectBase):void
		{
			view.infoTxt.htmlText = comp.proccess.getTitle();	
		}
			
		public function openImageFile(f:File):void
		{
			view.txtContainer.visible = false;
			
			view.imgContainer.visible = true;
			view.img.source = f;
		}
		
		public function openText(t:String):void
		{
			view.imgContainer.visible = false;
		
			view.txtContainer.visible = true;
			view.txt.text = t;
		}
		
		private function viewChange(e:ASEvent):void
		{
			if(!view.visible) return ;
			if(D3SceneManager.getInstance().displayList.selectedComp == null) return ;
			D3SceneManager.getInstance().displayList.selectedComp.proccess.openSource();
		}
		
	}
}