package com.editor.d3.view.particle
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class ParticleAttriViewMediator extends AppMediator
	{
		public static const NAME:String = "ParticleAttriViewMediator"
		public function ParticleAttriViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get view():ParticleAttriView
		{
			return viewComponent as ParticleAttriView;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.tabBar.addEventListener(ASEvent.CHANGE , onTabBarChange);
			setPropMouse(false);
		}
		
		public function respondToEditParticleEvent(noti:Notification):void
		{
			var c:D3ObjectParticle = noti.getBody() as D3ObjectParticle;
			if(noti.getBody() == null){
				return ;
			}
			
			view.infoTxt2.htmlText = "选中文件:"+ D3ProjectFilesCache.getInstance().getProjectResPath(c.file)
			
			D3SceneManager.getInstance().displayList.selectedParticle = c;
			D3SceneManager.getInstance().displayList.selectedParticleAttri = view;
			
			setPropMouse(false);
			
			view.tabBar.selectedIndex = 0;
			view.anim.changeComp(c);
			view.prop.changeComp(c);
			view.beh.changeComp(c);
			
			view.anim.selectedFirst();
		}
		
		public function setPropMouse(v:Boolean):void
		{
			view.prop.mouseChildren = v;
			view.prop.mouseEnabled = v;
			view.beh.mouseChildren = v;
			view.beh.mouseEnabled = v;
		}
		
		private function onTabBarChange(e:ASEvent):void
		{
			
		}
		
		public function respondToDelFileIn3DEvent(noti:Notification):void
		{
			var f:File = noti.getBody() as File;
			if(D3SceneManager.getInstance().displayList.selectedParticle.file.nativePath == f.nativePath){
				view.infoTxt.text = "";
				setPropMouse(false);
				D3SceneManager.getInstance().displayList.selectedParticle = null;
				view.tabBar.selectedIndex = 0;
				view.anim.changeComp(null);
				view.prop.changeComp(null);
				view.beh.changeComp(null);
			}
		}
		
		public function respondToChangeStackMode3DEvent(noti:Notification):void
		{
			if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_particle){
				view.mouseChildren = true;
				view.mouseEnabled = true;
			}else if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_scene){
				view.mouseChildren = false;
				view.mouseEnabled = false
			}
		}
			
	}
}