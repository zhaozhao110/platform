package com.editor.d3.editor.group
{ 
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.WireframeCube;
	import away3d.primitives.WireframeCylinder;
	import away3d.primitives.WireframePlane;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.primitives.WireframeSphere;
	
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.manager.D3ViewManager;

	public class D3MapItemWireframe extends D3EditorMapItem
	{
		public function D3MapItemWireframe()
		{
			super();	
		}
		
		override public function getObject():ObjectContainer3D
		{
			return wireframe
		}
		
		/////////////////////////////////////////////  Geometry ///////////////////////////////////
		
		private var wireframe:WireframePrimitiveBase;
		
		override public function createWireframe():void
		{
			removeWireframe();
			
			wireframe = getWireframe();
			wireframe.pickingCollider = D3ViewManager.pickingCollider;;
			wireframe.mouseEnabled = true;
			objectParent.addChild(wireframe);
			reflashMeshInfo();
			addListener()
		}

		private function getWireframe():WireframePrimitiveBase
		{
			if(comp.compItem.id == 20){
				return new WireframeCylinder();
			}else if(comp.compItem.id == 21){
				return new WireframeSphere();
			}else if(comp.compItem.id == 22){
				return new WireframePlane(100,100);
			}else if(comp.compItem.id == 23){
				return new WireframeCube();
			}
			return null;
		}
		
		override public function removeWireframe():void
		{
			if(wireframe)wireframe.dispose();
			wireframe = null;
			removeListener();
		}
		
	}
}