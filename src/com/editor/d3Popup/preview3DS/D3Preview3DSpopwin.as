package com.editor.d3Popup.preview3DS
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.Stage3DEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD5MeshParser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.primitives.SkyBox;
	import away3d.primitives.WireframePlane;
	import away3d.tools.utils.Bounds;
	
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.FileFilterUtils;
	import com.d3.controlls.D3HoverController;
	import com.d3.loader.Sandy3DParsers;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	public class D3Preview3DSpopwin extends AppPopupWithEmptyWin
	{
		public function D3Preview3DSpopwin()
		{
			super()
			create_init()
		}
		
		override public function set backgroundColor(value:*):void
		{
			
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			/*opts.systemChrome = "none"
			opts.transparent = true;*/
			opts.width = 1000;
			opts.height = 700;
			opts.gpu = true
			opts.minimizable = true;
			opts.title = "预览模型"	
			return opts;
		}
		
		private function create_init():void
		{
			//backgroundAlpha = 0;
			
			var hb:UIVBox = new UIVBox();
			hb.width = 990;
			hb.height = 680
			hb.paddingLeft = 10;
			hb.verticalGap = 10;
			//hb.styleName = "uicanvas"
			addChild(hb);
			
			var h:UIHBox = new UIHBox();
			h.percentWidth =100;
			h.height = 30;
			h.verticalAlignMiddle = true;
			h.backgroundColor = 0x333333
			h.horizontalGap = 10;
			hb.addChild(h);
			
			var btn:UIButton = new UIButton();
			btn.label = "打开模型"
			btn.addEventListener(MouseEvent.CLICK , onOpen);
			h.addChild(btn);
			
			var lb:UILabel = new UILabel();
			lb.text = "模型大小:"
			lb.color = ColorUtils.white;
			h.addChild(lb);
			
			scale_ns = new UINumericStepper();
			scale_ns.minimum = 1;
			scale_ns.maximum = 100;
			scale_ns.stepSize = 1;
			scale_ns.width = 100;
			h.addChild(scale_ns);
			scale_ns.value = 1;
			scale_ns.addEventListener(ASEvent.CHANGE,onScaleChange);
			
			sp = new UICanvas();
			//sp.background_red = true
			sp.width = 973;
			sp.height = 626
			hb.addChild(sp);
			
			createSphere()
			
		}
		
		private var scale_ns:UINumericStepper;
		private var sp:UICanvas;
		
		///////////////////////////////// scene ///////////////////////////////
		
		private var view:View3D;
		private var bodyMaterial:TextureMaterial;
		private var scene:Scene3D;
		
		private var trident:Trident;
		private var gizmoView:View3D;
		private var grid:WireframePlane;
		private var backgroundGrid:WireframePlane;
		private var backgroundView:View3D;
				
		public function get camera():Camera3D
		{
			return view.camera;
		}
		override public function get stage():Stage
		{
			return super.stage;
		}
		
		private var cameraController:D3HoverController
		
		protected function createSphere():void
		{
			
			backgroundView = new View3D();
			backgroundView.layeredView = true;
			backgroundView.width = sp.width;
			backgroundView.height = sp.height;
			backgroundView.camera.lens.near = 1;
			backgroundView.camera.lens.far = 110000;			
			sp.addChild(backgroundView);
			
			view = new View3D();
			view.layeredView = true;
			view.width = sp.width;
			view.height = sp.height;
			view.camera.lens.near = 1;
			view.camera.lens.far = 100000;			
			//view.camera.position = new Vector3D(0, 200, -1000);
			sp.addChild(view);
			scene = view.scene;
			
			trident = new Trident(400,true);
			view.scene.addChild(trident);
			
			grid = new WireframePlane(10000, 10000, 100, 100, 0x5e5e5e, 0.5, "xz");
			grid.mouseEnabled = false;
			view.scene.addChild(grid);
			
			backgroundGrid = new WireframePlane(10000, 10000, 100, 100, 0x5e5e5e, 0.375, "xz");
			backgroundGrid.mouseEnabled = false;
			backgroundView.scene.addChild(backgroundGrid);
			
			cameraController = new D3HoverController(camera,null,45,30,300,-90,90,NaN,NaN,8,1,false);
			cameraController.init(view,this);
			
			if(stage != null){
				addToStage();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,addToStage);
			}
			
			
			
		}
		
		public function getMaterial():TextureMaterial
		{
			return bodyMaterial;
		}
		
		protected function addToStage(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function removeListener():void
		{
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			view.dispose();
			view = null;
			backgroundView.dispose();
			backgroundView = null;
			cameraController.dispose();
			cameraController = null;
			unload()
		}
		
		protected function onEnterFrame(event:Event):void
		{
			cameraController.update();
			if(view!=null)view.render();
			updateBackgroundGrid();
		}
		
		private function updateBackgroundGrid():void 
		{
			backgroundView.camera.lens.near = view.camera.lens.far;
			backgroundView.camera.lens.far = view.camera.lens.far + 10000;
			backgroundView.camera.transform = view.camera.transform.clone();
			backgroundGrid.transform = grid.transform.clone();
			backgroundView.render();
		}
		
		private function onOpen(e:MouseEvent):void
		{
			var a:Array = FileFilterUtils.parser(["ac","awd","3ds","md2","md5mesh","obj","dae"]);
			SelectFile.select("3d model",a,resultFile);
		}
		
		private var _loader:Loader3D;
		
		private function resultFile(e:Event):void
		{
			var f:File = e.target as File;
			
			var read:ReadFile = new ReadFile();
			var b:ByteArray = read.read(f.nativePath,ReadFile.READTYPE_BYTEARRAY)
			
			unload()
			scale_ns.value = 1;
			
			//var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			//assetLoaderContext.mapUrlToData("texture.jpg", new AntTexture());
			
			_loader = new Loader3D();
			_loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			_loader.loadData(b,null,null,Sandy3DParsers.getParser(f.extension));
			view.scene.addChild(_loader);
		}
		
		private var mesh:Mesh;
		
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH) {
				mesh = event.asset as Mesh;
				//onScaleChange();
				//mesh.castsShadows = true;
			} else if (event.asset.assetType == AssetType.MATERIAL) {
				var material:TextureMaterial = event.asset as TextureMaterial;
				//material.shadowMethod = new FilteredShadowMapMethod(_light);
				//material.lightPicker = _lightPicker;
				/*material.gloss = 30;
				material.specular = 1;
				material.ambientColor = 0x303040;
				material.ambient = 1;*/
			}
		}
		
		private function onScaleChange(e:ASEvent=null):void
		{
			if(mesh!=null){
				mesh.scaleX = scale_ns.value;
				mesh.scaleY = scale_ns.value;
				mesh.scaleZ = scale_ns.value;
			}
		}
		
		private function unload():void
		{
			if(_loader!=null){
				_loader.stopLoad();
				_loader.dispose();
			}
			if(mesh!=null){
				mesh.dispose();
			}
			mesh = null;
			_loader = null;
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.D3Preview3DSpopwin_sign
			isModel    		= false;
			
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new D3Preview3DSpopwinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeListener();
			removeMediator(D3Preview3DSpopwinMediator.NAME);
		}
		
		
	}
}