package com.editor.d3.app.scene.grid.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.events.Object3DEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframeCylinder;
	import away3d.primitives.WireframeSphere;
	import away3d.utils.Cast;
	
	import com.d3.component.core.DisplayObject3D;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.interfac.ISceneRepresentation;
	import com.editor.d3.editor.group.D3MapItemLight;
	import com.editor.d3.manager.D3ViewManager;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.event.SandyEventPriority;
	
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	public class LightGizmo3D extends DisplayObject3D implements ISceneRepresentation
	{
		
		public static const DIRECTIONAL_LIGHT:String = "directionalLight";
		public static const POINT_LIGHT:String = "pointLight";

		private var _representation:Mesh;
		public function get representation():Mesh { return _representation; }
		
		private var _sceneObject:ObjectContainer3D;
		public function get sceneObject():ObjectContainer3D { return _sceneObject; }
		
		public var type:String;
		
		private var lightTexture:TextureMaterial;
		private var directGeo:WireframeCylinder;
		private var pointGeo:WireframeSphere;
		public var directTargetMesh:Mesh;
		public var target:D3MapItemLight;
		
		
		public function LightGizmo3D(light:LightBase)
		{
			if(sceneObject!=null) return ;
			
			addChild(light);
			_sceneObject = light as ObjectContainer3D;
			
			type = (light is DirectionalLight) ? DIRECTIONAL_LIGHT : POINT_LIGHT;
				
			createTexture();
			
			if(type == DIRECTIONAL_LIGHT){
				createDirectLight();
			}else{
				createPointLight();
			}
			
			representation.castsShadows = false;
			representation.mouseEnabled = true;
			representation.pickingCollider = D3ViewManager.pickingCollider;
			representation.addEventListener(MouseEvent3D.MOUSE_DOWN , onRepDown);
			this.addChild(representation);
		}
		
		private function createTexture():void
		{
			if(type == DIRECTIONAL_LIGHT){
				lightTexture = new TextureMaterial(Cast.bitmapTexture(iManager.iResource.getBitmapData("light2_a")),true,false,false);
			}else{
				lightTexture = new TextureMaterial(Cast.bitmapTexture(iManager.iResource.getBitmapData("light3_a")),true,false,false);
			}
			lightTexture.alphaBlending = true;
			lightTexture.bothSides = true;
		}
		
		private var onRepDown_time:Number;
		private function onRepDown(e:MouseEvent3D):void
		{
			if(isNaN(onRepDown_time)){
				onRepDown_time = getTimer();
			}else{
				if((getTimer()-onRepDown_time)<10) return ;
			}
			onRepDown_time = getTimer();
			dispatchEvent(new ASEvent("repMouseDown"))
		}
		
		
		
		
		////////////////////////////////////// direct //////////////////////////////////
		
		private function createDirectLight():void
		{
			_representation = new Mesh(new PlaneGeometry(64, 64), lightTexture);
			
			//内部
			directGeo = new WireframeCylinder(50, 50, 220, 8, 1, 0xffff00, 0.25);
			addChild(directGeo); 
			directGeo.position = new Vector3D(0, -40, 0);
			
			_representation.material.depthCompareMode = directGeo.material.depthCompareMode = Context3DCompareMode.ALWAYS;
			
			createDirectTarget();
		}
		
		private function createDirectTarget():void
		{
			var tu:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(iManager.iResource.getBitmapData("light4_a")),true,false,false);
			tu.alphaBlending = true;
			tu.bothSides = true;
			//全局的
			directTargetMesh = new Mesh(new PlaneGeometry(32, 32), tu);
			directTargetMesh.data = this;
			D3SceneManager.getInstance().currScene.sceneContianer.addChild(directTargetMesh);
			 
			directTargetMesh.addEventListener(Object3DEvent.POSITION_CHANGED , onPositionChange);
			
			directTargetMesh.position = DirectionalLight(_sceneObject).direction;
		}
		
		private function onPositionChange(e:Object3DEvent):void
		{
			if(target == null) return ;
			if(target.comp == null) return ;
			if(target.comp.configData == null) return ;
			target.comp.configData.putAttri("direction",directTargetMesh.position);
			D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(target.comp)
			direct_updateRepresentation()
			if(directTargetMesh)directTargetMesh.visible=true
			if(directGeo)directGeo.visible = true
		}
		
		private var onDirectTargetMeshDown_time:Number;
		public function onDirectTargetMeshDown(e:MouseEvent3D=null):void
		{
			if(isNaN(onDirectTargetMeshDown_time)){
				onDirectTargetMeshDown_time = getTimer();
			}else{
				if((getTimer()-onDirectTargetMeshDown_time)<10) return ;
			}
			onDirectTargetMeshDown_time = getTimer();
			
			if(e!=null){
				e.stopImmediatePropagation();
				e.preventDefault();
			}
			
			D3SceneManager.getInstance().currScene.selectObject(directTargetMesh);
		}
		
		private function direct_updateRepresentation():void
		{
			DirectionalLight(_sceneObject).direction = directTargetMesh.position;
			
			directTargetMesh.eulers = D3SceneManager.getInstance().currCamera.eulers.clone();
			directTargetMesh.rotationX -= 90;
			directTargetMesh.rotationY -= 1;
			
			directGeo.eulers = DirectionalLight(_sceneObject).eulers.clone();
		}
		
		
		
		
		
		
		
		
		//////////////////////////////////////// point /////////////////////////////////////////
		
		private function createPointLight():void
		{
			_representation = new Mesh(new PlaneGeometry(64, 64), lightTexture);
			
			//内部
			/*pointGeo = new WireframeSphere(50,8,6);
			addChild(pointGeo); */
			
			//_representation.material.depthCompareMode = pointGeo.material.depthCompareMode = Context3DCompareMode.ALWAYS;
		}
		
		private function point_updateRepresentation():void
		{
			//pointGeo.radius = PointLight(sceneObject).radius;
		}
		 
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var selected:Boolean;
		public function noSelect():void
		{
			selected = false;
			if(directTargetMesh)directTargetMesh.visible=false;
			if(directGeo)directGeo.visible = false;
		}
		
		public function select():void
		{
			selected = true
			if(type == DIRECTIONAL_LIGHT){
				if(directTargetMesh)directTargetMesh.visible=true
				if(directGeo)directGeo.visible = true
			}
		}
		
		public function updateRepresentation():void 
		{
			if(visible){
				//始终面对相机
				_representation.eulers = D3SceneManager.getInstance().currCamera.eulers.clone();
				_representation.rotationX -= 90;
				_representation.rotationY -= 1;
			}
			
			if(!selected) return ;
			
			if(type == DIRECTIONAL_LIGHT){
				direct_updateRepresentation();
			}else{
				point_updateRepresentation();
			}
			
			/*var dist:Vector3D = D3SceneManager.getInstance().currCamera.scenePosition.subtract(_representation.scenePosition);
			_representation.scaleX = _representation.scaleZ = dist.length/1500;*/
		}
		
		
	}
}