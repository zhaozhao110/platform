package com.editor.d3.editor.group
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.containers.ObjectContainer3D;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.controls.CameraGizmo3D;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.process.D3ProccessCamera;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.sandy.asComponent.event.ASEvent;

	public class D3MapItemCamera extends D3MapItemObject
	{
		public function D3MapItemCamera()
		{
			super();
		}
		
		override public function getObject():ObjectContainer3D
		{
			return mesh;
		}
				
		private var mesh:CameraGizmo3D;
		private var camera:Camera3D;
		
		public function getCamera():Camera3D
		{
			return camera;
		}
		
		override public function dispose():void
		{
			D3SceneManager.getInstance().currScene.removeCamera(camera);
			super.dispose();
		}
		
		override public function createCamera():void
		{
			removeLight();
			
			camera = new Camera3D();
			mesh = D3SceneManager.getInstance().currScene.addCamera(camera);
			objectParent.addChild(mesh);
			mesh.target = this;
			mesh.addEventListener("repMouseDown",repMouseDown);
			reflashMeshInfo();
			addListener();
		}

		override public function removeCamera():void
		{
			if(camera)camera.dispose();
			camera = null;
			if(mesh)mesh.dispose();
			mesh = null;
			removeListener();
		}
		
		override public function setAttri(k:String, v:*):void
		{
			if(getObject() == null) return ;
			if(getObject().hasOwnProperty(k)){
				getObject()[k] = v;
			}else if(camera.hasOwnProperty(k) || (v is D3ObjectMethod)){
				if(v is D3MethodItemVO) return ;
				if(k == "lens" && (v is D3ObjectMethod)){
					camera.lens = (v as D3ObjectMethod).medthodProccess.getMethod();
				}else{
					if(camera.hasOwnProperty(k))camera[k] = v;
				}
				if(D3ObjectCamera(comp).isGlobalCamera){
					if(camera.hasOwnProperty(k)){
						D3SceneManager.getInstance().currCamera[k] = camera[k];
					}
				}
			}else{
				setNoOwnProp(mesh,k,v);
			}
		}
		
		private function repMouseDown(e:ASEvent):void
		{
			onMeshDown();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}