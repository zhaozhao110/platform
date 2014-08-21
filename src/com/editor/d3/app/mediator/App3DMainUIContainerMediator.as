package com.editor.d3.app.mediator
{
	import away3d.debug.AwayStats;
	import away3d.loaders.parsers.Parsers;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.manager.View3DManager;
	import com.editor.d3.app.view.App3DMainUIContainer;
	import com.editor.d3.app.view.ui.bottom.App3DBottomContainer;
	import com.editor.d3.app.view.ui.bottom.App3DBottomContainerMediator;
	import com.editor.d3.app.view.ui.left.App3DLeftContainer;
	import com.editor.d3.app.view.ui.left.App3DLeftContainerMediator;
	import com.editor.d3.app.view.ui.middle.App3DSceneContainer;
	import com.editor.d3.app.view.ui.middle.App3DSceneContainerMediator;
	import com.editor.d3.app.view.ui.right.App3DRightContainer;
	import com.editor.d3.app.view.ui.right.App3DRightContainerMediator;
	import com.editor.d3.app.view.ui.top.App3DTopBarContainer;
	import com.editor.d3.app.view.ui.top.App3DTopBarContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3KeybroadManager;
	import com.editor.d3.pop.curveEditor.CurveEditor;
	import com.editor.d3.pop.eidtLua.EditLuaEditor;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.event.App3DEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.core.ASLoaderBase;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import theme.main;

	public class App3DMainUIContainerMediator extends AppMediator
	{
		public static const NAME:String = 'App3DMainUIContainerMediator'
		public function App3DMainUIContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get container():App3DMainUIContainer
		{
			return viewComponent as App3DMainUIContainer;
		}
		public function get topBarContainer():App3DTopBarContainer
		{
			return container.topBarContainer;
		}
		public function get viewStack():App3DSceneContainer
		{
			return container.viewStack;
		}
		public function get bottomContainer():App3DBottomContainer
		{
			return container.bottomContainer;
		}
		public function get leftContainer():App3DLeftContainer
		{
			return container.leftContainer;
		}
		public function get rightContainer():App3DRightContainer
		{
			return container.rightContainer;
		}
		public function get to3DBtn():UIButton
		{
			return container.to3DBtn;
		}
		public function get upCavans():UICanvas
		{
			return container.upCavans;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new App3DTopBarContainerMediator(topBarContainer));
			registerMediator(new App3DSceneContainerMediator(viewStack));
			registerMediator(new App3DBottomContainerMediator(bottomContainer));
			registerMediator(new App3DLeftContainerMediator(leftContainer));
			registerMediator(new App3DRightContainerMediator(rightContainer));
			
			iKeybroad.addKeyDownProxyFun(this);
			
			hideLoading()
			
			Parsers.enableAllBundled();
			//setTimeout(showCurveEditor,2000);
			
			container.mouseEnabled = true;
			container.addEventListener(MouseEvent.MOUSE_UP , onDownHandle);
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			D3ProjectCache.disabledDataChange = false;
		}
				
		public function respondToShowHideViewCellEvent(noti:Notification):void
		{
			bottomContainer.visible = !bottomContainer.visible
			leftContainer.visible = false
			rightContainer.visible = bottomContainer.visible
		}
		
		override public function keyDown_f(e:KeyboardEvent):void
		{
			if(e.ctrlKey){
				if(e.keyCode == KeyStringCodeConst.S){
					D3ProjectCache.getInstance().createXML();
					return ;
				}
			}
			if(e.keyCode == KeyStringCodeConst.W){
				if(D3SceneManager.getInstance().displayList.selectedComp!=null){
					if(D3SceneManager.getInstance().displayList.selectedComp.proccess is D3ProccessObject){
						D3ProccessObject(D3SceneManager.getInstance().displayList.selectedComp.proccess).translate();
					}
				}
			}
			if(e.keyCode == KeyStringCodeConst.E){
				if(D3SceneManager.getInstance().displayList.selectedComp!=null){
					if(D3SceneManager.getInstance().displayList.selectedComp.proccess is D3ProccessObject){
						D3ProccessObject(D3SceneManager.getInstance().displayList.selectedComp.proccess).scale();
					}
				}
			}
			if(e.keyCode == KeyStringCodeConst.R){
				if(D3SceneManager.getInstance().displayList.selectedComp!=null){
					if(D3SceneManager.getInstance().displayList.selectedComp.proccess is D3ProccessObject){
						D3ProccessObject(D3SceneManager.getInstance().displayList.selectedComp.proccess).rotation()
					}
				}
			}
			if(e.keyCode == KeyStringCodeConst.TAB){
				sendAppNotification(D3Event.showHideViewCell_event);
			}
		}
		
		public function respondToD3SceneInitEvent(noti:Notification):void
		{
			View3DManager.getInstance().open3DViews();
			
			get_App3DLeftContainerMediator().tabBar.selectedIndex = 0;
			get_App3DRightContainerMediator().tabBar.selectedIndex = 0;
			get_App3DBottomContainerMediator().tabBar.selectedIndex = 0;
			
			add3DStatus()
			
			D3KeybroadManager.getInstance().init();
		}
		
		public static var status:AwayStats;
		private function add3DStatus():void
		{
			if(status == null){
				status = new AwayStats();
				container.addChild(status);
			}
			//statusSp.right = 400;
			status.x = container.stage.stageWidth-400
			status.y = 10
		}
				
		public function addView(d:DisplayObjectContainer):void
		{
			container.upCavans2.addChild(d);
		}
		
		public function reactToTo3DBtnClick(e:MouseEvent):void
		{
			sendAppNotification(App3DEvent.changeTo2DScene_event);
		}
		
		public function respondToChange3DProjectEvent(noti:Notification):void
		{
			//hideLoading();
		}
		
		
		
		//////////////////////////////////////////////////////////////////////
		
		public function showLoading():void
		{
			container.loadCanvas.visible = true
			container.mainVBox.mouseChildren = false
		}
		
		public function hideLoading():void
		{
			container.loadCanvas.visible = false
			container.mainVBox.mouseChildren = true
		}
		
		
		
		//////////////////////////////////////////////////////////////////////
		
		public var editor:CurveEditor;
		public function showCurveEditor(obj:Object,f:Function):void
		{
			if(editor == null){
				editor = new CurveEditor();
				upCavans.addChild(editor);
			}
			editor.changeAnim(obj);
			editor.save_f = f;
			editor.x = upCavans.width/2-editor.width/2;
			editor.y = upCavans.height/2-editor.height/2
			editor.visible = true;
			upCavans.visible = true;
		}
		
		public function hideCurveEditor():void
		{
			if(editor!=null){
				editor.visible = false;
			}
			upCavans.visible = false;
		}
		
		
		//////////////////////////////////////////////////////////////////////
		
		public var luaEditor:EditLuaEditor;
		public function showLuaEditor(obj:Object,f:Function):void
		{
			if(luaEditor == null){
				luaEditor = new EditLuaEditor();
				upCavans.addChild(luaEditor);
			}
			luaEditor.changeAnim(obj);
			luaEditor.save_f = f;
			luaEditor.x = upCavans.width/2-luaEditor.width/2;
			luaEditor.y = upCavans.height/2-luaEditor.height/2
			luaEditor.visible = true;
			upCavans.visible = true;
		}
		
		public function hideLuaEditor():void
		{
			if(luaEditor!=null){
				luaEditor.visible = false;
			}
			upCavans.visible = false;
		}
		
		public function respondToDisplayStateChangeEvent(noti:Notification):void
		{
			
		}
		
		
		public function respondToChangeStackMode3DEvent(noti:Notification):void
		{
			/*if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_particle2){
				container.particle2Cont.load();
			}*/
		}
		
		private function get_App3DRightContainerMediator():App3DRightContainerMediator
		{
			return retrieveMediator(App3DRightContainerMediator.NAME) as App3DRightContainerMediator;
		}
		
		private function get_App3DLeftContainerMediator():App3DLeftContainerMediator
		{
			return retrieveMediator(App3DLeftContainerMediator.NAME) as App3DLeftContainerMediator;
		}
		
		private function get_App3DBottomContainerMediator():App3DBottomContainerMediator
		{
			return retrieveMediator(App3DBottomContainerMediator.NAME) as App3DBottomContainerMediator;
		}
		
	}
}