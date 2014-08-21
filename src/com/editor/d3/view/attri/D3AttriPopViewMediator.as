package com.editor.d3.view.attri
{
	import com.editor.component.containers.UICanvas;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.group.D3AttriGroup1View;
	import com.editor.d3.view.attri.group.D3AttriGroup2View;
	import com.editor.d3.view.attri.group.D3AttriGroupViewBase;
	import com.editor.d3.view.attri.preview.D3CompPreviewBase;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.HashMap;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.filesystem.File;

	public class D3AttriPopViewMediator extends AppMediator
	{
		public static const NAME:String = "D3AttriPopViewMediator"
		public function D3AttriPopViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get view():D3AttriPopView
		{
			return viewComponent as D3AttriPopView;
		}
		public function get cont():UICanvas
		{
			return view.cont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		private var group_ls:HashMap = new HashMap();
		private var systemAttri:D3AttriGroup2View;
		
		public function respondToSelect3DCompEvent(noti:Notification):void
		{
			cont.setAllChildVisible(false);
			D3CompPreviewBase.hideAll();
			D3SceneManager.getInstance().displayList.selectedAttriView = null;
			
			var c:D3ObjectBase = noti.getBody() as D3ObjectBase;
			if(noti.getBody() == null){
				createSystemAttri()
				D3SceneManager.getInstance().displayList.selectedComp = null;
				return ;
			}
			if(c == null){
				D3SceneManager.getInstance().displayList.selectedComp = null;
				return ;
			}
			
			D3SceneManager.getInstance().displayList.selectedComp = c;
			
			var a:D3AttriGroupViewBase = group_ls.find(c.group.toString());
			if(a == null){
				a = new D3AttriGroup1View();
				if(a!=null) cont.addChild(a);
				group_ls.put(c.group.toString(),a);
			}
			
			D3SceneManager.getInstance().displayList.selectedAttriView = a;
			a.changeComp(c);
			
			if(c is D3ObjectMethod){
				if(c.parentObject.proccess){
					if(c.parentObject.proccess.mapItem){
						D3SceneManager.getInstance().currScene.selectObject(c.parentObject.proccess.mapItem.getObject());
					}
				}
			}
		}
		
		public function respondToDeleteD3CompEvent(noti:Notification):void
		{
			
		}
		
		private function createSystemAttri():void
		{
			if(systemAttri == null){
				systemAttri = new D3AttriGroup2View();
				cont.addChild(systemAttri);
			}
			D3SceneManager.getInstance().displayList.selectedAttriView = systemAttri;
			systemAttri.changeComp();
		}

		public function respondToChange3DProjectEvent(noti:Notification):void
		{
			if(noti.getBody() == null)respondToSelect3DCompEvent(new Notification(""));
		}
		
	}
}