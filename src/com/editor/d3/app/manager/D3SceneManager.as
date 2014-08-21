package com.editor.d3.app.manager
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.d3.app.scene.grid.D3GridScene;
	import com.editor.d3.app.scene.grid.manager.CameraManager;
	import com.editor.d3.app.view.ui.middle.App3DSceneContainerMediator;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.manager.D3KeybroadManager;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.manager.StageManager;
	import com.sandy.math.HashMap;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	//D3GridScene 的容器
	public class D3SceneManager extends SandyManagerBase
	{
		private static var instance:D3SceneManager ;
		public static function getInstance():D3SceneManager{
			if(instance == null){
				instance =  new D3SceneManager();
			}
			return instance;
		}
		
		
		
		public function getFreeStage3DProxy():Stage3DProxy
		{
			var stage3DProxy:Stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy();
			stage3DProxy.antiAlias = 4;
			stage3DProxy.color = 0x474747;
			return stage3DProxy;			
		}
		
		public function get stage():Stage
		{
			return StageManager.applicationStage.stage;
		}
		
		public var selectedObject:ObjectContainer3D;
		public var currScene:D3GridScene;
		
		
		public function get currCamera():Camera3D
		{
			return currScene.camera;
		}
		public function get stage3DProxy():Stage3DProxy
		{
			return currScene.stage3DProxy;
		}
		public function get cameraMM():CameraManager
		{
			return currScene.cameraMM;
		}
		public function get displayList():D3DisplayListCache
		{
			return currScene.displayList;
		}
		
				
		public function createScene(type:int):D3GridScene
		{
			if(currScene == null){
				var sp:UICanvas = new UICanvas();
				sp.enabledPercentSize = true;
				get_App3DSceneContainerMediator().sceneContainer.addChild(sp);
				
				var m:D3GridScene = new D3GridScene(sp,type);
				currScene = m;
			}
			return currScene;
		}
		
		public function edit():void
		{
			currScene.setView3DVisible(true);
			D3KeybroadManager.getInstance().init();
		}
		
		private function get_App3DSceneContainerMediator():App3DSceneContainerMediator
		{
			return iManager.retrieveMediator(App3DSceneContainerMediator.NAME) as App3DSceneContainerMediator;
		}
	}
}