package com.editor.d3.app.scene.grid.controls
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.math.Quaternion;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.D3GridScene;
	import com.editor.d3.app.scene.grid.manager.CameraManager;
	import com.sandy.asComponent.effect.tween.ASTween;
	import com.sandy.utils.MathUtils;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	public class OrientationTool extends Sprite
	{
		[Embed(source="/assets/img/orientationtool/cube_back.jpg")]
		private var CubeTextureBack:Class;
		
		[Embed(source="/assets/img/orientationtool/cube_front.jpg")]
		private var CubeTextureFront:Class;
		
		[Embed(source="/assets/img/orientationtool/cube_left.jpg")]
		private var CubeTextureLeft:Class;
		
		[Embed(source="/assets/img/orientationtool/cube_right.jpg")]
		private var CubeTextureRight:Class;
		
		[Embed(source="/assets/img/orientationtool/cube_top.jpg")]
		private var CubeTextureTop:Class;
		
		[Embed(source="/assets/img/orientationtool/cube_bottom.jpg")]
		private var CubeTextureBottom:Class;
		
		public var cube:Mesh;
		public var currentOrientation:String = "front";
		private var view : View3D;
		private var _orientationClicked : Boolean;
		
		
		public function OrientationTool()
		{
			this.mouseChildren = true;
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);		
		}
		
		protected function handleAddedToStage(event:Event):void
		{
			//Create OrientationView
			view = new View3D();		
			view.mousePicker = PickingType.RAYCAST_BEST_HIT;			
			view.stage3DProxy = sceneMM.stage3DProxy;
			view.shareContext = true;
			view.layeredView = true;
			view.antiAlias = 4;
			view.camera.position = new Vector3D(0, 0, -200);
			view.camera.lens.near = 50;
			view.camera.lens.far = 500;			
			view.width = 120;
			view.height = 120;			
					
			
			//Create light
			var ambientLight:PointLight = new PointLight();
			ambientLight.name = "AmbientLight";
			ambientLight.color = 0xFFFFFF;
			ambientLight.ambient = 0.5;
			ambientLight.diffuse = 1;
			ambientLight.specular = 0.1;
			
			var picker:StaticLightPicker = new StaticLightPicker([ambientLight]);
			
			view.camera.addChild(ambientLight);
			
			var planeGeometry:PlaneGeometry = new PlaneGeometry(100, 100);			
			
			var frontMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureFront));
			frontMaterial.lightPicker = picker;			
			var frontPlane:Mesh = new Mesh(planeGeometry);
			frontPlane.name = "front";
			frontPlane.mouseEnabled = true;
			frontPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);
			frontPlane.material = frontMaterial;
			frontPlane.rotationX = -90;
			frontPlane.z = -planeGeometry.width/2;
			view.scene.addChild(frontPlane);
			
			var backMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureBack));
			backMaterial.lightPicker = picker;
			var backPlane:Mesh = new Mesh(planeGeometry);
			backPlane.name = "back";
			backPlane.mouseEnabled = true;
			backPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);			
			backPlane.material = backMaterial;
			backPlane.rotationX = 90;
			backPlane.rotationZ = 180;
			backPlane.z = 50;
			view.scene.addChild(backPlane);
			
			var leftMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureLeft));			
			leftMaterial.lightPicker = picker;
			var leftPlane:Mesh = new Mesh(planeGeometry);
			leftPlane.name = "left";
			leftPlane.mouseEnabled = true;
			leftPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);			
			leftPlane.material = leftMaterial;
			leftPlane.rotationY = 90;
			leftPlane.rotationZ = 90;
			leftPlane.x = -50;			
			view.scene.addChild(leftPlane);			
				
			var rightMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureRight));
			rightMaterial.lightPicker = picker;
			var rightPlane:Mesh = new Mesh(planeGeometry);
			rightPlane.name = "right";
			rightPlane.mouseEnabled = true;
			rightPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);			
			rightPlane.material = rightMaterial;
			rightPlane.rotationY = -90;
			rightPlane.rotationZ = -90;
			rightPlane.x = 50;			
			view.scene.addChild(rightPlane);			
			
			var topMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureTop));
			topMaterial.lightPicker = picker;
			var topPlane:Mesh = new Mesh(planeGeometry);
			topPlane.name = "top";
			topPlane.mouseEnabled = true;
			topPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);			
			topPlane.material = topMaterial;
			topPlane.y = 50;			
			view.scene.addChild(topPlane);
			
			var bottomMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(CubeTextureBottom));
			bottomMaterial.lightPicker = picker;
			var bottomPlane:Mesh = new Mesh(planeGeometry);
			bottomPlane.name = "bottom";
			bottomPlane.mouseEnabled = true;
			bottomPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, handleSelectOrientation);			
			bottomPlane.material = bottomMaterial;
			bottomPlane.rotationX = 180;
			bottomPlane.y = -50;			
			view.scene.addChild(bottomPlane);				
			
			this.addChild(view);
		}
		
		protected function handleSelectOrientation(e:Event):void
		{
			currentOrientation = e.target.name;
			_orientationClicked = true;
			setTimeout(checkIsDrag,100,e);			
		}
		
		private function checkIsDrag(e:Event):void
		{
			if(cameraMM.dragging) return ;
			switch(e.target.name)
			{
				case "top": ASTween.to(cameraMM, 0.5, {_yDeg:90, _xDeg:0});				 
					break;
				case "bottom": ASTween.to(cameraMM, 0.5, {_yDeg:-90, _xDeg:0});
					break;
				case "left": ASTween.to(cameraMM, 0.5, {_yDeg:0, _xDeg:90});
					break;
				case "right": ASTween.to(cameraMM, 0.5, {_yDeg:0, _xDeg:-90});
					break;
				case "front": ASTween.to(cameraMM, 0.5, {_yDeg:0, _xDeg:0});
					break;	
				case "back": ASTween.to(cameraMM, 0.5, {_yDeg:0, _xDeg:180});
					break;					
			}
		}
		
		public function update():void
		{
			view.camera.eulers = camera.eulers;
			
			var camPos:Vector3D = getCameraPosition(cameraMM._xDeg, -cameraMM._yDeg);
			view.camera.x = -camPos.x;
			view.camera.y = -camPos.y;
			view.camera.z = -camPos.z;
			
			view.render();			
		}
		
		private function getCameraPosition(xDegree:Number, yDegree:Number):Vector3D
		{
			var cy:Number = Math.cos(MathUtils.toRadians(yDegree)) * 200;			
			
			var v:Vector3D = new Vector3D();
			
			v.x = Math.sin(MathUtils.toRadians(xDegree)) * cy;
			v.y = Math.sin(MathUtils.toRadians(yDegree)) * 200;
			v.z = Math.cos(MathUtils.toRadians(xDegree)) * cy;
			
			return v;
		}				
		
		/**
		 * Indicates if the orientation cube was clicked, to allow other views to process 
		 * mouseevent3d events accordingly
		 */
		public function get orientationClicked() : Boolean {
			return _orientationClicked;
		}

		public function set orientationClicked(orientationClicked : Boolean) : void {
			_orientationClicked = orientationClicked;
		}	
		
		protected function get camera():Camera3D
		{
			return sceneMM.currCamera;
		}
		protected function get currScene():D3GridScene
		{
			return sceneMM.currScene;
		}
		protected function get cameraMM():CameraManager
		{
			return sceneMM.cameraMM
		}
		private function get sceneMM():D3SceneManager
		{
			return D3SceneManager.getInstance();
		}
		
	}
}