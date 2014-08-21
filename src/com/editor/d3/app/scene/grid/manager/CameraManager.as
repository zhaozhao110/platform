package com.editor.d3.app.scene.grid.manager
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Quaternion;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.D3GridScene;
	import com.editor.d3.app.scene.grid.interfac.ID3GridScene;
	import com.editor.d3.app.scene.grid.vo.CameraMode;
	import com.sandy.asComponent.effect.tween.ASTween;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.manager.StageManager;
	import com.sandy.utils.MathUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	
	public class CameraManager
	{
		
		public static const ZOOM_DELTA_VALUE:Number = .05;
		public static const ZOOM_MULTIPLIER:Number = 2;
				
		public function CameraManager() {}			
		
		// common variables	
		public var dragging:Boolean = false;
		public var hasMoved:Boolean = false;
		public var panning:Boolean = false;
		public var running:Boolean = false;
		public var runMultiplier:Number = 3;
		
		private var _active:Boolean = false;			
		
		public var _xDeg:Number = 0;
		public var _yDeg:Number = 0;				
		
		private var offset:Vector3D = new Vector3D();
		private var click:Point = new Point();						
		private var pan:Point = new Point();		
		
		// target mode variables
		public var wheelSpeed:Number = 10;
		public var mouseSpeed:Number = 1;		
		
		private var _radius:Number = 0;
		private var _minRadius:Number = 10;								
		
		private var target:Sprite;
		
		// free mode variables
		private var _mode:String;
        private var _speed:Number = 5;				
		private var _xSpeed:Number = 0;
        private var _zSpeed:Number = 0;
		private var _runMultiplier:Number = 3;
		private var _pause:Boolean = false;
		private var ispanning:Boolean = false;
		private var _mouseOutDetected:Boolean = false;
		
		private var poi:ObjectContainer3D;
		private var quat:Quaternion;

		public function get radius():Number{
			return _radius; 
		}
		public function set radius(radius:Number):void{ 
			if(_radius == radius) return;
			_radius = radius;
			currScene.updateDefaultCameraFarPlane();
		}
		   
		
		
		
		public function init(target:Sprite, view:View3D, mode:String="CameraFreeMode", speed:Number=10):void
		{			   
			target = target;
			  
			speed = speed;
			_mode = mode;
			
			poi = new ObjectContainer3D();
			view.scene.addChild(poi);
			
			quat = new Quaternion();
			quat.fromMatrix(camera.transform);						
			
			switch(_mode)
			{
				case CameraMode.FREE:{
					initFreeMode(5, 1000, 0, 15);
				}
				case CameraMode.TARGET:{
					
				}
			}			
						
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);			
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMouseMiddleDown);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMouseMiddleUp);
			
			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);	
			target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);	
			
			focusTarget();
			
			target.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function kill():void
		{
			target.removeEventListener(Event.ENTER_FRAME, loop);
			target.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);	
			target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);	
			
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);			
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);	
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);	
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMouseMiddleDown);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMouseMiddleUp);
		}			
		
		public function get active():Boolean { return _active; }		
		public function set active(value:Boolean):void { 
			_active = value;
			if(!_active){
				dragging = false;
			}
		}			
		
		public function get speed():Number { return _speed; }		
		public function set speed(value:Number):void { _speed = value; }				
		
		public function get minRadius():Number { return _minRadius; }		
		public function set minRadius(value:Number):void 
		{ 
			_minRadius = value; 
		}				
		
		public function get mode():String { return _mode; }		
		public function set mode(value:String):void 
		{
			if(mode == value) return ;
			_mode = value;
			
			switch(value)
			{
				case CameraMode.FREE:{
					radius = Vector3D.distance(camera.position, poi.scenePosition);
					currScene.updateDefaultCameraFarPlane();
					currScene.zoomToDistance(radius);
				}
				case CameraMode.TARGET:{ 
				}
			}			
		}
				
		private function loop(e:Event):void
		{
			if(!_pause){
				if(_mouseOutDetected) {
					cameraMM.active = false;
					currScene.active = false;
				}
				_mouseOutDetected = false;
				
				switch(mode)
				{
					case CameraMode.FREE:{
						processFreeMode();
					}
					case CameraMode.TARGET:{
					}
				}
			}				
		}					
		
		public function quit():void
		{
			var obj:Object = {};
			obj._xDeg 		= _xDeg;
			obj._yDeg 		= _yDeg;
			obj.radius 		= radius;
			obj._zoom 		= _zoom;
			
			obj.camEulers 	= camera.eulers;
			obj.camPos		= camera.position;
			obj.poiEulers 	= poi.eulers;
			obj.poiPos 		= poi.position;
			
			SharedObjectManager.getInstance().put("","camera.position",obj);
		}
		
		public function enter():void
		{
			var obj:Object = SharedObjectManager.getInstance().find("","camera.position");
			if(obj){
				_xDeg = obj._xDeg
				_yDeg = obj._yDeg
				_zoom = obj._zoom;
				
				poi.position = new Vector3D(obj.poiPos.x,obj.poiPos.y,obj.poiPos.z);
				poi.eulers = new Vector3D(obj.poiEulers.x,obj.poiEulers.y,obj.poiEulers.z);
				
				camera.position = new Vector3D(obj.camPos.x,obj.camPos.y,obj.camPos.z);
				camera.eulers = new Vector3D(obj.camEulers.x,obj.camEulers.y,obj.camEulers.z);
				
				radius = obj.radius;
			}
		}
		
		
		// FreeMode ***************************************************************
		
		private function initFreeMode(minRadius:Number=5, radius:Number=NaN, xDegree:Number=NaN, yDegree:Number=NaN):void
		{				
			cameraMM.minRadius = minRadius;
			
			if(!isNaN(xDegree)) _xDeg = xDegree;
			if(!isNaN(yDegree)) _yDeg = yDegree;								
			
			if(!isNaN(radius)){
				cameraMM.radius = radius;
			}else{
				radius = Vector3D.distance(camera.position, poi.scenePosition);
			}							
			
			camera.position = getCameraPosition(_xDeg, -_yDeg);							
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));		
			
			active = true;
		}			
		
		private function processFreeMode():void
		{			
			if(ispanning) updatePOIPosition();
			if(dragging) updateMouseRotation();
			
			camera.position = getCameraPosition(_xDeg, -_yDeg);							
			camera.eulers = quat.rotatePoint(new Vector3D(_yDeg, _xDeg, camera.rotationZ));
			currScene.updateGizmo();

			if(hasMoved){
				radius = Vector3D.distance(camera.position, poi.scenePosition);
 			}
		}			
		
		
		////////////////////// focus //////////////////////////////////
		
		public function focusTarget(t:ObjectContainer3D = null):void
		{	
			if(currScene.view == null) return ;
			var tr:Number;
			var bmin:Vector3D;
			var bmax:Vector3D;
			
			var bounds:Vector.<Number> = (t ? currScene.containerBounds(t) : currScene.getSceneBounds());
				
			if(bounds[0]==Infinity || bounds[1]==Infinity || bounds[2]==Infinity || bounds[3]==-Infinity || bounds[4]==-Infinity || bounds[5]==-Infinity) { 
				bmin = new Vector3D(-500, 0, 0);
				bmax = new Vector3D(500, 0, 0);
			} else {
				bmin = new Vector3D(bounds[0], bounds[1], bounds[2]);
				bmax = new Vector3D(bounds[3], bounds[4], bounds[5]);
			}
			
			var center:Vector3D = bmax.subtract(bmin);
			tr = center.length;	
			center.x /= 2;
			center.y /= 2;
			center.z /= 2;
			center = center.add(bmin);

			ASTween.to(CameraManager, 0.5, {radius:tr, onComplete:calculateWheelSpeed, onCompleteParams:[tr, center]});
			ASTween.to(poi, 0.5, {x:center.x, y:center.y, z:center.z});
		}
		
		private function calculateWheelSpeed(a:Array):void
		{
			var radius:Number = a[0];
			var pos:Vector3D = a[1]
			//adjust mouseWheel speed according size and scale of the mesh;
			var dist:Vector3D = camera.scenePosition.subtract(pos);
			wheelSpeed = dist.length/60; 
			currScene.zoomToDistance(radius);
			currScene.updateDefaultCameraFarPlane();
		}
				
		private function updatePOIPosition():void
		{
			poi.rotationX = camera.rotationX;
			poi.rotationY = camera.rotationY;
			poi.rotationZ = camera.rotationZ;			
			
			var dx:Number = (stage.mouseX - pan.x) * (radius/500);
			var dy:Number = (stage.mouseY - pan.y) * (radius/500);
			
			if(dx != 0 || dy != 0) hasMoved = true;
			
			pan.x = stage.mouseX;
			pan.y = stage.mouseY;			
			
			poi.moveUp(dy);
			poi.moveLeft(dx);
		}		
		
		private function updateMouseRotation():void
		{			
			var dx:Number = stage.mouseX - click.x;
			var dy:Number = stage.mouseY - click.y;
			
			if(dx != 0 || dy != 0) hasMoved = true;
			
			click.x = stage.mouseX;
			click.y = stage.mouseY;
			
			_yDeg += (dy * mouseSpeed);
			_xDeg += (dx * mouseSpeed);
		}		
		
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.toRadians(yDegree)) * radius;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = (poi.scenePosition.x + offset.x) - Math.sin(MathUtils.toRadians(xDegree)) * cy;
			v.y = (poi.scenePosition.y + offset.y) - Math.sin(MathUtils.toRadians(yDegree)) * radius;
			v.z = (poi.scenePosition.z + offset.z) - Math.cos(MathUtils.toRadians(xDegree)) * cy;
			return v;
		}				
		
		private function onMouseMiddleDown(e:MouseEvent):void
		{
			pan.x = stage.mouseX;
			pan.y = stage.mouseY;			
			ispanning = true;
		}
		
		private function onMouseMiddleUp(e:MouseEvent):void
		{
			ispanning = false;
		}		
		
		private function onRightMouseDown(event:MouseEvent):void
		{			
			if(active){
				click.x = stage.mouseX;
				click.y = stage.mouseY;				
				
				if(panning){
					pan.x = stage.mouseX;
					pan.y = stage.mouseY;
					ispanning = true;
				}else{
					dragging = true;				
				}
				hasMoved = false;
			}
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			active = true;
			currScene.active = true;
			_mouseOutDetected = false;
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_mouseOutDetected = true;
		}

		private function onRightMouseUp(event:MouseEvent):void
		{
			dragging = false;
			ispanning = false;
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			if(active){
				switch(mode){
					case CameraMode.TARGET:{
						
					}
					case CameraMode.FREE:{
						if(event.ctrlKey){
							currScene.zoomDistanceDelta(event.delta / 250);
						}else{
							currScene.zoomDistanceDelta(event.delta / 500);
						}
					}
				}
			}	
		}						
		
		private function onMouseLeave(event:Event):void
		{
			dragging = false;
			ispanning = false;			
		}					

		public function zoomFunction(x:Number):Number
		{
			return Math.pow(2, 8-x);
		}
		
		private var _zoom:Number = 0;
		
		public function zoom(n:Number):void
		{
			_zoom += n*CameraManager.ZOOM_MULTIPLIER;
			radius = zoomFunction(_zoom);
		}
		
		public function distanceFunction(x:Number):Number
		{
			return 8 - Math.log(x) / Math.log(2);
		}
		
		protected function get stage():Stage
		{
			return currScene.stage;
		}
		protected function get camera():Camera3D
		{
			return currScene.camera;
		}
		protected function get cameraMM():CameraManager
		{
			return currScene.cameraMM;
		}
		
		public var currScene:D3GridScene
		
	}
}