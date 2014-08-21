package com.editor.d3.app.scene.grid
{
	import away3d.animators.AnimationSetBase;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.pick.PickingColliderType;
	import away3d.core.pick.PickingType;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.events.Stage3DEvent;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.misc.SingleFileLoader;
	import away3d.loaders.parsers.ParticleGroupParser;
	import away3d.primitives.SkyBox;
	import away3d.primitives.WireframePlane;
	import away3d.tools.utils.Bounds;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.manager.View3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.app.scene.grid.controls.CameraGizmo3D;
	import com.editor.d3.app.scene.grid.controls.ContainerGizmo3D;
	import com.editor.d3.app.scene.grid.controls.Gizmo3DBase;
	import com.editor.d3.app.scene.grid.controls.LightGizmo3D;
	import com.editor.d3.app.scene.grid.controls.ObjectContainerBounds;
	import com.editor.d3.app.scene.grid.controls.OrientationTool;
	import com.editor.d3.app.scene.grid.controls.RotateGizmo3D;
	import com.editor.d3.app.scene.grid.controls.ScaleGizmo3D;
	import com.editor.d3.app.scene.grid.controls.TextureProjectorGizmo3D;
	import com.editor.d3.app.scene.grid.controls.TranslateGizmo3D;
	import com.editor.d3.app.scene.grid.event.Gizmo3DEvent;
	import com.editor.d3.app.scene.grid.event.Grid3DEvent;
	import com.editor.d3.app.scene.grid.interfac.ID3GridScene;
	import com.editor.d3.app.scene.grid.interfac.ISceneRepresentation;
	import com.editor.d3.app.scene.grid.manager.CameraManager;
	import com.editor.d3.app.scene.grid.scene.D3MapScene;
	import com.editor.d3.app.scene.grid.scene.D3ParticleScene;
	import com.editor.d3.app.scene.grid.vo.D3LoopFunData;
	import com.editor.d3.app.scene.grid.vo.GizmoMode;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.editor.modules.app.AppMainPopupwinModule;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.utils.MathUtils;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class D3GridScene extends EventDispatcher implements ID3GridScene
	{
		public function D3GridScene(sp:Sprite,type:int)
		{
			proxy = new D3GridSceneProxy(this);
			sceneType = type;
			target = sp;
			__init__();
		}
		
		public var proxy:D3GridSceneProxy;
		private var _active:Boolean = true;
		public function get active():Boolean
		{
			return _active;
		}
		public function set active(value:Boolean):void
		{
			_active = value;
		}
		public var sceneType:int;
		public var target:Sprite;
		public var stage3DProxy:Stage3DProxy;
		public var displayList:D3DisplayListCache = new D3DisplayListCache();
		
		private var backgroundView:View3D;
		
		//scene
		public var view:View3D;
		public var sceneContianer:D3MapScene;
		//particle
		public var particleContainer:D3ParticleScene;
		  
		private var orientationTool:OrientationTool;
		private var _lastCameraPos:Vector3D;
		private var _lastCameraRot:Vector3D;
		private var gizmoView:View3D;
		private var grid:WireframePlane;
		private var backgroundGrid:WireframePlane;
		
		private var currentGizmo:Gizmo3DBase;
		private var translateGizmo:TranslateGizmo3D;
		private var rotateGizmo:RotateGizmo3D;
		private var scaleGizmo:ScaleGizmo3D;
		private var trident:Trident;
		
		private var _cameraMM:CameraManager;
		public function get cameraMM():CameraManager
		{
			return _cameraMM;
		}
		public function set cameraMM(value:CameraManager):void
		{
			_cameraMM = value;
		}
		
		public var textureProjectorGizmos:Vector.<TextureProjectorGizmo3D> = new Vector.<TextureProjectorGizmo3D>();
		public var containerGizmos:Vector.<ContainerGizmo3D> = new Vector.<ContainerGizmo3D>();
		
		public function get camera():Camera3D
		{
			return view.camera;
		}
		
		public function get stage():Stage
		{
			return target.stage;
		}
		
		private function __init__():void
		{
			stage3DProxy = D3SceneManager.getInstance().getFreeStage3DProxy();
			//stage3DProxy.independence = true;
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
		}
				
		private function onContextCreated(e:Stage3DEvent=null):void 
		{
			backgroundView = new View3D();
			backgroundView.name = "backgroundView"
			backgroundView.layeredView = true;
			backgroundView.shareContext = true;
			backgroundView.stage3DProxy = stage3DProxy;	
			backgroundView.camera.lens.near = 1;
			backgroundView.camera.lens.far = 110000;			
			target.addChild(backgroundView);
			
			view = new View3D();
			view.name = "view"
			view.shareContext = true;
			view.stage3DProxy = stage3DProxy;
			view.layeredView = true;
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;
			view.camera.lens.near = 1;
			view.camera.lens.far = 100000;			
			view.camera.position = new Vector3D(0, 200, -1000);
			view.camera.rotationX = 0;
			view.camera.rotationY = 0;	
			view.camera.rotationZ = 0;			
			target.addChild(view);
			
			trident = new Trident(400,true);
			view.scene.addChild(trident);
			trident.visible = false
			
			sceneContianer = new D3MapScene();
			view.scene.addChild(sceneContianer);
			
			particleContainer = new D3ParticleScene();
			view.scene.addChild(particleContainer);
			particleContainer.visible = false;
						
			_lastCameraPos = new Vector3D();
			_lastCameraRot = new Vector3D();
			
			orientationTool = new OrientationTool();
			target.addChild(orientationTool);
			
			gizmoView = new View3D();
			gizmoView.name = "gizmoView"
			gizmoView.shareContext = true;
			gizmoView.stage3DProxy = stage3DProxy;
			gizmoView.layeredView = true;
			gizmoView.mousePicker = PickingType.RAYCAST_BEST_HIT;
			gizmoView.camera.lens.near = 1;
			gizmoView.camera.lens.far = 100000;	
			target.addChild(gizmoView);
			
			translateGizmo = new TranslateGizmo3D();
			translateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			translateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(translateGizmo);
			rotateGizmo = new RotateGizmo3D();
			rotateGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			rotateGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(rotateGizmo);
			scaleGizmo = new ScaleGizmo3D();
			scaleGizmo.addEventListener(Gizmo3DEvent.MOVE, handleGizmoAction);
			scaleGizmo.addEventListener(Gizmo3DEvent.RELEASE, handleGizmoActionRelease);
			gizmoView.scene.addChild(scaleGizmo);
			
			currentGizmo = translateGizmo;
			
			grid = new WireframePlane(10000, 10000, 100, 100, 0x5e5e5e, 0.5, "xz");
			grid.mouseEnabled = false;
			view.scene.addChild(grid);
			
			backgroundGrid = new WireframePlane(10000, 10000, 100, 100, 0x5e5e5e, 0.375, "xz");
			backgroundGrid.mouseEnabled = false;
			backgroundView.scene.addChild(backgroundGrid);
			
			cameraMM = new CameraManager();
			cameraMM.currScene = this;
			cameraMM.init(target,view);
			
			target.stage.addEventListener(Event.RESIZE, handleScreenSize);
			listenerFrame();
			
			backgroundView.mouseEnabled = true;
			backgroundView.addEventListener(MouseEvent.MOUSE_DOWN,onBackMouseDownHandle);
						
			resize();
			registerView();
			
			SingleFileLoader.enableParser(ParticleGroupParser);
			
			cameraMM.enter();
		}
		
		public function setView3DVisible(b:Boolean):void
		{
			view.visible = b;
			gizmoView.visible = b;
			backgroundView.visible = b;
		}
		
		public function setTridentVisible(b:*=null):Boolean
		{
			if(b==null){
				trident.visible = !trident.visible;
			}else{
				trident.visible = b;
			}
			return trident.visible;
		}
		
		public function setGridVisible(b:*=null):Boolean
		{
			if(b==null){
				backgroundGrid.visible = !backgroundGrid.visible;
			}else{
				backgroundGrid.visible = b;
			}
			grid.visible = backgroundGrid.visible;
			return backgroundGrid.visible;
		}
		
		private function listenerFrame():void
		{
			if(!listenerFrameBool){
				stage3DProxy.addEventListener(Event.ENTER_FRAME, loop);	
			}
			listenerFrameBool = true;
		}
		
		private var listenerFrameBool:Boolean;
		private function noListenerFrame():void
		{
			if(listenerFrameBool){
				stage3DProxy.removeEventListener(Event.ENTER_FRAME, loop);	
			}
			listenerFrameBool = false;
		}
		
		private var onBackMouseDownHandle_time:Number;
		private function onBackMouseDownHandle(e:MouseEvent):void
		{
			if(isNaN(onBackMouseDownHandle_time)){
				onBackMouseDownHandle_time = getTimer();
			}else{
				if((getTimer()-onBackMouseDownHandle_time)<10) return ;
			}
			onBackMouseDownHandle_time = getTimer();
			e.stopImmediatePropagation();
			e.preventDefault();
			
			backgroundView.addEventListener(MouseEvent.MOUSE_UP,onBackMouseUpHandle);
		}
		
		private var onBackMouseUpHandle_time:Number;
		private function onBackMouseUpHandle(e:MouseEvent):void
		{
			if(isNaN(onBackMouseUpHandle_time)){
				onBackMouseUpHandle_time = getTimer();
			}else{
				if((getTimer()-onBackMouseUpHandle_time)<10) return ;
			}
			onBackMouseUpHandle_time = getTimer();
			e.stopImmediatePropagation();
			e.preventDefault();
			
			backgroundView.removeEventListener(MouseEvent.MOUSE_UP,onBackMouseUpHandle);
			iManager.sendAppNotification(D3Event.select3DComp_event,null);
			setTransformMode(null,null);
		}
		
		public function onViewToStage(e:*=null):void
		{
			zoomDistanceDelta(-1);
		}
		
		private function handleScreenSize(e:Event=null):void 
		{
			resize();
		}	
		
		private function resize():void 
		{
			if(isNaN(target.width) || isNaN(target.height)){
				laterResize();	
			}else{
				checkTargetSize(null);
			}
		}
				
		private function laterResize():void
		{
			target.stage.addEventListener(Event.ENTER_FRAME,checkTargetSize);
		}
		
		private function checkTargetSize(e:Event=null):void
		{
			if(isNaN(target.width) || isNaN(target.height)){
				return ;
			}
			
			target.stage.removeEventListener(Event.ENTER_FRAME,checkTargetSize);
			
			if(isNaN(target.width)){
				orientationTool.x = target.stage.stageWidth - 120 - 10;
			}else{
				orientationTool.x = target.width - 120 - 10;
			}
			if(get_App3DMainUIContainerMediator().rightContainer.visible){
				orientationTool.x -= get_App3DMainUIContainerMediator().rightContainer.width;
			}
			orientationTool.y = 5;
			
			var position:Point = target.localToGlobal(new Point(0, 0));
			stage3DProxy.x = position.x;
			stage3DProxy.y = position.y;
			stage3DProxy.width = target.width;
			stage3DProxy.height = target.height;
			
			backgroundView.width = view.width = gizmoView.width = target.width;
			backgroundView.height = view.height = gizmoView.height = target.height;
		}
		
		private var loopFun_a:Vector.<D3LoopFunData>=new Vector.<D3LoopFunData>;
		
		public function addLoopFun(f:D3LoopFunData):void
		{
			var n:int = loopFun_a.indexOf(f);
			if(n == -1) loopFun_a.push(f);
		}
		
		public function removeLoopFun(f:D3LoopFunData):void
		{
			var n:int = loopFun_a.indexOf(f);
			if(n>=0) loopFun_a.splice(n,1);
		}
		
		private function loop(e:Event):void 
		{	
			if(!AppMainModel.getInstance().isIn3DScene) return ;
			if(AppMainPopupwinModule.instance.getNativeWindow() == null) return ;
			if(!AppMainPopupwinModule.instance.getNativeWindow().active) return ;
			//trace(NativeApplication.nativeApplication.activeWindow.displayState,"--");
			var n:int=loopFun_a.length;
			for(var i:int=0;i<n;i++){
				loopFun_a[i].call();
			}
			updateBackgroundGrid();
			updateLights();
			updateCamera();
			if(currentGizmo!=null) currentGizmo.update();
			updateGizmo()
			view.render();			
			orientationTool.update();
			gizmoView.render();
		}
		
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.toRadians(yDegree)) * view.height/2;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = Math.sin(MathUtils.toRadians(xDegree)) * cy;
			v.y = Math.sin(MathUtils.toRadians(yDegree)) * view.height/2;
			v.z = Math.cos(MathUtils.toRadians(xDegree)) * cy;
			
			return v;
		}
		
		private function updateBackgroundGrid():void 
		{
			backgroundView.camera.lens.near = view.camera.lens.far;
			backgroundView.camera.lens.far = view.camera.lens.far + 10000;
			backgroundView.camera.transform = view.camera.transform.clone();
			backgroundGrid.transform = grid.transform.clone();
			backgroundView.render();
		}
		
		private function handleGizmoActionRelease(e:Gizmo3DEvent):void
		{
			dispatchEvent(new Grid3DEvent(Grid3DEvent.TRANSFORM_RELEASE, e.mode, e.object, e.currentValue, e.startValue, e.endValue));
		}
		
		private function handleGizmoAction(e:Gizmo3DEvent):void
		{
			dispatchEvent(new Grid3DEvent(Grid3DEvent.TRANSFORM, e.mode, e.object, e.currentValue, e.startValue, e.endValue));
		}
		
		public function zoomDistanceDelta(delta:Number):void 
		{
			var v:Vector3D = new Vector3D(delta, 0, 0)
			cameraMM.zoom(v.x);
			dispatchEvent(new Grid3DEvent(Grid3DEvent.ZOOM_DISTANCE_DELTA, "", null,v ));
		}
		
		public function zoomToDistance(distance:Number):void 
		{
			dispatchEvent(new Grid3DEvent(Grid3DEvent.ZOOM_TO_DISTANCE, "", null, new Vector3D(distance, 0, 0)));
		}
		
		
		////////////////////////////////////////// selected ////////////////////////////////
		
		public var selectedObject:ObjectContainer3D;
		
		public function selectObject(c:ObjectContainer3D,mode:String=GizmoMode.TRANSLATE):void
		{
			if(c == null || c.parent == null ){
				noSelected()
				return ;
			}
			if(c is LightGizmo3D){
				if(mode == GizmoMode.SCALE || mode == GizmoMode.ROTATE) return ;
			}
			noSelected()
			selectedObject = c;
			if(c is ISceneRepresentation){
				(c as ISceneRepresentation).select();
			}else if(c.parent is ISceneRepresentation){
				(c.parent as ISceneRepresentation).select();
			}
			createBound(c);
			setTransformMode(mode,c);
		}
		
		public function noSelected():void
		{
			if(objectBoundContainer!=null){
				objectBoundContainer.showBounds = false;
				objectBoundContainer.visible = false;
			}
			if(currentGizmo!=null){
				currentGizmo.active = false;
				currentGizmo.hide();
			}
			noSelectAllLights();
			noSelectAllCamera();
		}
		
		private function setTransformMode(mode:String,c:ObjectContainer3D):void
		{
			selectedObject = c;
			if(currentGizmo!=null){
				currentGizmo.active = false;
				currentGizmo.hide();
			}
			currentGizmo = null;
			switch(mode){													
				case GizmoMode.TRANSLATE : 
					currentGizmo = translateGizmo;
					break;				
				case GizmoMode.ROTATE: 
					currentGizmo = rotateGizmo;
					break;				
				case GizmoMode.SCALE: 
					currentGizmo = scaleGizmo;
					break;								
			}
			
			if(currentGizmo!=null){
				currentGizmo.active = false;
				currentGizmo.show(c);
			}
		}
		
		private var objectBoundContainer:ObjectContainerBounds;
		private function createBound(c:ObjectContainer3D):void
		{
			if(c is LightGizmo3D || c is CameraGizmo3D){
				if(objectBoundContainer!=null){
					objectBoundContainer.showBounds = false;
					objectBoundContainer.visible = false;
				}
				return ;
			}
			if(objectBoundContainer == null){
				objectBoundContainer = new ObjectContainerBounds();
			}
			objectBoundContainer.setParentContainer(c);
			objectBoundContainer.showBounds = true;
			objectBoundContainer.updateContainerBounds();
			objectBoundContainer.visible = true;
		}
		
		
		//////////////////////////////// light ////////////////////////////////

		public var lightGizmos:Vector.<LightGizmo3D> = new Vector.<LightGizmo3D>();
		
		public function addLight(light:LightBase):LightGizmo3D
		{
			var gizmo:LightGizmo3D = new LightGizmo3D(light); 
			lightGizmos.push(gizmo);
			gizmo.updateRepresentation();
			return gizmo;
		}
		
		public function removeLight(light:LightBase):void
		{
			for each (var lG:LightGizmo3D in lightGizmos) {
				if (lG.sceneObject == light && lG.parent) {
					lG.parent.removeChild(lG);
					lightGizmos.splice(lightGizmos.indexOf(lG), 1);
					break;
				}
			}
			
			if (light.parent)light.parent.removeChild(light);
		}	
		
		private function updateLights():void
		{
			for(var i:int=0;i<lightGizmos.length;i++){
				lightGizmos[i].updateRepresentation();
			}
		}
		
		private function noSelectAllLights():void
		{
			for(var i:int=0;i<lightGizmos.length;i++){
				lightGizmos[i].noSelect();
			}
		}
		
		////////////////////////// camera //////////////////////////
		
		public var cameraGizmos:Vector.<CameraGizmo3D> = new Vector.<CameraGizmo3D>();
		
		public function addCamera(cam:Camera3D):CameraGizmo3D
		{		
			var gizmo:CameraGizmo3D = new CameraGizmo3D(cam); 
			cameraGizmos.push(gizmo);
			gizmo.updateRepresentation();
			updateDefaultCameraFarPlane();
			return gizmo;
		}
		
		public function removeCamera(cam:Camera3D):void
		{
			for each (var lG:CameraGizmo3D in cameraGizmos) {
				if (lG.sceneObject == cam && lG.parent) {
					lG.parent.removeChild(lG);
					cameraGizmos.splice(cameraGizmos.indexOf(lG), 1);
					break;
				}
			}
			
			if(cam.parent)cam.parent.removeChild(cam);
		}	
		
		private function updateCamera():void
		{
			for(var i:int=0;i<cameraGizmos.length;i++){
				cameraGizmos[i].updateRepresentation();
			}
		}
		
		private function noSelectAllCamera():void
		{
			for(var i:int=0;i<cameraGizmos.length;i++){
				cameraGizmos[i].noSelect();
			}
		}
		
		
		//////////////////////////////// tool ////////////////////////////////
		
		public function updateGizmo():void 
		{
			gizmoView.camera.transform = camera.transform.clone();
		}
		
		public function updateDefaultCameraFarPlane():void 
		{
			var bounds:Vector.<Number> = getSceneBounds(false);
			if(bounds == null) return ;
			if (abs(bounds[0])==Infinity || abs(bounds[1])==Infinity || abs(bounds[2])==Infinity || abs(bounds[3])==Infinity || abs(bounds[4])==Infinity || abs(bounds[5])==Infinity)
				camera.lens.far = 100000;
			else {
				var vec:Vector3D = new Vector3D(bounds[3] - bounds[0], bounds[4] - bounds[1], bounds[5] - bounds[2]);
				var objRadius:Number = vec.length/2;
				vec.x = (vec.x * 0.5) + bounds[0];
				vec.y = (vec.y * 0.5) + bounds[1];
				vec.z = (vec.z * 0.5) + bounds[2];
				
				// Far plane is distance from camera position to scene bounds center + the radius of the scene bounds
				camera.lens.far = Vector3D.distance(camera.position, vec) + objRadius;
			}
		}
		
		public function getSceneBounds(excludeGizmos : Boolean = true):Vector.<Number> 
		{			
			if(view == null) return null;
			var min:Vector3D = new Vector3D(Infinity, Infinity, Infinity);
			var max:Vector3D = new Vector3D(-Infinity, -Infinity, -Infinity);
			
			var ctr:int = 0;
			var oCCount:int = view.scene.numChildren;
			var rep:ISceneRepresentation;
			
			// Hide representations to get clear bounds
			if (excludeGizmos) {
				for each (rep in textureProjectorGizmos) rep.visible = false;
				for each (rep in cameraGizmos) rep.visible = false;
				for each (rep in containerGizmos) rep.visible = false;
				for each (rep in lightGizmos) rep.visible = false;
			}
			
			// Get all scene child container bounds		
			while (ctr < oCCount) {
				var oC:ObjectContainer3D = view.scene.getChildAt(ctr++);
				if (!(oC is SkyBox || oC is PointLight || oC == grid)) {
					Bounds.getObjectContainerBounds(oC);
					if (Bounds.minX < min.x) min.x = Bounds.minX;
					if (Bounds.minY < min.y) min.y = Bounds.minY;
					if (Bounds.minZ < min.z) min.z = Bounds.minZ;
					if (Bounds.maxX > max.x) max.x = Bounds.maxX;
					if (Bounds.maxY > max.y) max.y = Bounds.maxY;
					if (Bounds.maxZ > max.z) max.z = Bounds.maxZ;
				}
			}
			
			// Re-show representations
			if (excludeGizmos) {
				for each (rep in textureProjectorGizmos) rep.visible = true;
				for each (rep in cameraGizmos) rep.visible = true;
				for each (rep in containerGizmos) rep.visible = true;
				for each (rep in lightGizmos) rep.visible = true;
			}
			
			return Vector.<Number>([min.x, min.y, min.z, max.x, max.y, max.z]);
		}
		
		public function abs( value:Number ):Number 
		{
			return value < 0 ? -value : value;
		}
		
		public function containerBounds(oC:ObjectContainer3D, sceneBased:Boolean = true):Vector.<Number> 
		{
			Bounds.getObjectContainerBounds(oC, sceneBased);
			return Vector.<Number>([Bounds.minX, Bounds.minY, Bounds.minZ, Bounds.maxX, Bounds.maxY, Bounds.maxZ]);
		}
		
		
		
		////////////////////////////////////////////////////
				
		public function hide():void
		{
			
		}
		
		public function resetData():void
		{
			registerView()
			if(view !=null){
				noSelected();
				if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_scene){
					sceneContianer.visible = true;
					particleContainer.visible = false;
					particleContainer.stop();
				}else if(Stack3DManager.getInstance().currStack == D3ComponentConst.stack3d_particle){
					sceneContianer.visible = false
					particleContainer.visible = true;
					particleContainer.play();
					trident.visible = true;
				}
			}
		}
		
		private function registerView():void
		{
			App3DMainUIContainerMediator.status.clearViews();
			App3DMainUIContainerMediator.status.registerView(view);
		}
		
		public function quit():void
		{
			if(cameraMM)cameraMM.quit();
		}
		
		////////////////////////////////////////////////////////////////////////////
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
		
	}
}