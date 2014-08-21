package com.editor.d3.editor.group
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.Object3DEvent;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.utils.Cast;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.controls.LightGizmo3D;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.object.D3ObjectLight;
	import com.sandy.asComponent.event.ASEvent;

	public class D3MapItemLight extends D3MapItemObject
	{
		public function D3MapItemLight()
		{
			super();
		}
		
		override public function getObject():ObjectContainer3D
		{
			return mesh;
		}
		
		private var mesh:LightGizmo3D;
		private var light:LightBase;
		
		public function getLight():LightBase
		{
			return light;
		}
				
		override public function createLight():void
		{
			removeLight();
			
			if(comp.compItem.id == 3){
				light = new DirectionalLight();
			}else if(comp.compItem.id == 4){
				light = new PointLight();
			}
			mesh = D3SceneManager.getInstance().currScene.addLight(light);
			objectParent.addChild(mesh);
			mesh.target = this;
			mesh.addEventListener("repMouseDown",repMouseDown);
			reflashMeshInfo();
			addListener();
			
			D3SceneManager.getInstance().displayList.laterLightCreated(comp.node.path);
		}
		
		public function get_directTargetMesh():Mesh
		{
			return mesh.directTargetMesh;
		}
		
		override public function removeLight():void
		{
			D3SceneManager.getInstance().displayList.removeLight(comp as D3ObjectLight);
			if(light)light.dispose();
			light = null;
			if(mesh)mesh.dispose();
			mesh = null;
			removeListener();
		}
		
		override public function setAttri(k:String, v:*):void
		{
			if(getObject().hasOwnProperty(k)){
				getObject()[k] = v;
			}else if(light.hasOwnProperty(k)){
				if(k == "direction"){
					mesh.directTargetMesh.position = v;
				}
				light[k] = v;
			}else{
				setNoOwnProp(mesh,k,v);
			}
		}
		
		private function repMouseDown(e:ASEvent):void
		{
			onMeshDown();
		}
		
		override protected function onSceleChange(e:Object3DEvent):void{}
		override protected function onRotationChange(e:Object3DEvent):void{};
		
		public function onDirectTargetMeshDown():void
		{
			if(mesh)mesh.onDirectTargetMeshDown();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}