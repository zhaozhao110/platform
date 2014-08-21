package com.editor.d3.view.attri.preview
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class D3CompPreviewBase extends UICanvas
	{
		public function D3CompPreviewBase()
		{
			super();
			addView(this);
			create_init();
			
			createSphere()
			initLights();
			initObject();
			initListeners();		
		}
				
		public var comp:D3ObjectBase;
		protected var titileLB:UILabel;
		
		protected function create_init():void
		{
			width = 250
			height = 200;
			//backgroundColor = DataManager.def_col;
			styleName = "uicanvas";
			mouseEnabled = true;
			
			creatTitle()
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{uiShow();});
		}
				
		protected function get compType():String
		{
			return ""
		}
		
		protected function setTitle2(value:String):void
		{
			if(titileLB!=null)titileLB.text = value;
		}
		
		protected function creatTitle():void
		{
			if(titileLB!=null) return ;
			titileLB = new UILabel();
			titileLB.color = ColorUtils.white;
			titileLB.text = compType
			titileLB.width = 180
			titileLB.bold = true;
			addChild(titileLB);
			titileLB.x = 3;
			titileLB.y = 3;
			titileLB.enabledFliter = true
		}
						
		public function setValue(d:D3ObjectBase):void
		{
			comp = d;	
		}
				
		public static var view_ls:Array = [];
		public static function addView(v:D3CompPreviewBase):void
		{
			if(view_ls.indexOf(v)==-1){
				view_ls.push(v);
			}
		}
		
		public static function hideAll():void
		{
			for(var i:int=0;i<view_ls.length;i++){
				(view_ls[i] as D3CompPreviewBase).visible = false;
			}
		}
		
		
		
		///////////////////////////////// scene ///////////////////////////////
		
		protected var view:View3D;
		protected var cameraController:HoverController;
		protected var scale_n:Number=1;
		protected var bodyMaterial:TextureMaterial;
		protected var pan:Point = new Point();		
		protected var ispanning:Boolean = false;
		protected var moveBool:Boolean = false;
		protected var lastPanAngle:Number;
		protected var lastTiltAngle:Number;
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		protected var scene:Scene3D;
		protected var camera:Camera3D;
		protected var sunLight:DirectionalLight;
		protected var skyLight:PointLight;
		protected var lightPicker:StaticLightPicker;
		
		public function getMaterial():TextureMaterial
		{
			return bodyMaterial;
		}
		
		public function removeMaterial():void
		{
			if(bodyMaterial!=null){
				bodyMaterial.dispose();
			}
			bodyMaterial = null;
		}
		
		
		
		protected function createSphere():void
		{
			view = new View3D();
			view.backgroundColor = 0x333333;
			view.antiAlias = 4;
			view.forceMouseMove = true;
			scene = view.scene;
			camera = view.camera;
			addChild(view);
			
			cameraController = new HoverController(camera, null, 45, 30, distance);
			cameraController.yFactor = 1;
		}
		
		protected function get distance():int
		{
			return 300;
		}
		
		protected function initLights():void
		{
			if(view ==null) return ;
			sunLight = new DirectionalLight(-1, -0.4, 1);
			sunLight.color = 0xFFFFFF;
			sunLight.ambient = 1;
			sunLight.diffuse = 1;
			sunLight.specular = 0
			scene.addChild(sunLight);
			
			lightPicker = new StaticLightPicker([sunLight]);
		}

		protected function initObject():void
		{
			
		}
		
		private var listenered:Boolean;
		private var listenerFrame:Boolean;
		protected function initListeners():void
		{
			if(listenered) return ;
			listenered = true;
			if(view ==null) return ;
			
			if(!listenerFrame){
				view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				listenerFrame = true;
			}
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if(stage == null){
				this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			}else{
				addToStage();
			}
			onResize();
		}
		
		protected function addToStage(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			view.addEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandle);
			
			view.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMouseMiddleDown,false,100000);
			view.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMouseMiddleUp,false,100000);
			
			onResize();
		}
				
		protected function removeListener():void
		{
			listenered = false;
			
			if(view!=null){
				view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				listenerFrame = false;
				view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				view.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				view.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMouseMiddleDown);
				view.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMouseMiddleUp);
				view.removeEventListener(MouseEvent.MOUSE_OUT , onMouseOutHandle);
				
				view.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			if(stage!=null){
				stage.removeEventListener(Event.RESIZE, onResize);
			}
		}
				
		protected function onMouseOutHandle(e:MouseEvent):void
		{
			ispanning = false;
		}
				
		protected function onMouseWheel(e:MouseEvent):void
		{
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			event.preventDefault();
			moveBool = true;
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			var pt:Point = getLocalPoint();
			lastMouseX = pt.x
			lastMouseY = pt.y;
			
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
			view.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			moveBool = false;
			
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseMiddleDown(e:MouseEvent):void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			pan = getLocalPoint()			
			ispanning = true;
		}
		
		protected function onMouseMiddleUp(e:MouseEvent):void
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			ispanning = false;
		}		
		
		protected function onResize(event:Event = null):void
		{
			
		}
				
		protected function getLocalPoint():Point
		{
			var pt:Point = new Point(this.mouseX,this.mouseY);
			return this.parent.globalToLocal(pt);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if (moveBool) {
				var pt:Point = getLocalPoint();
				cameraController.panAngle = 0.3*(pt.x - lastMouseX)+lastPanAngle;
				cameraController.tiltAngle = 0.3*(pt.y - lastMouseY)+lastTiltAngle;
			}
			
			if(view!=null)view.render();
		}
		
		override protected function uiShow():void
		{
			initListeners();
			onResize();
			if(view!=null){
				if(!listenerFrame){
					view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
					listenerFrame = true;
				}
				view.visible = true
			}
		}
		
		override protected function uiHide():void
		{
			removeListener();
			if(view!=null){
				view.visible =false;
				if(listenerFrame){
					view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					listenerFrame = false;
				}
			}
		}
		
		private function onStageMouseLeave(event:Event):void
		{
			moveBool = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		
		
		
		protected function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
	}
}