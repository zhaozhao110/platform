package com.editor.d3.manager
{
	import away3d.core.pick.IPickingCollider;
	import away3d.core.pick.PickingColliderType;
	
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.pop.preMaterial.App3DPreMaterialWin;
	import com.editor.d3.pop.preMesh.App3DPreMeshWin;
	import com.editor.d3.pop.preTexture.App3DPreTextureWin;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.attri.preview.MeshInfoPreview;
	import com.editor.d3.view.attri.preview.MeshPreview;
	import com.editor.d3.view.attri.preview.TexturePreview;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	
	import flash.filesystem.File;

	public class D3ViewManager
	{
		private static var instance:D3ViewManager ;
		public static function getInstance():D3ViewManager{
			if(instance == null){
				instance =  new D3ViewManager();
			}
			return instance;
		}
		
		public static function get pickingCollider():IPickingCollider
		{
			return PickingColliderType.PB_BEST_HIT;
		}
		
		
		
		
		////////////////////////////////// com.editor.d3.pop ///////////////////////////
		
		public var preMaterialView:App3DPreMaterialWin;
		public function openView_material(f:Function):void
		{
			if(preMaterialView == null){
				preMaterialView = new App3DPreMaterialWin();
				get_App3DMainUIContainerMediator().addView(preMaterialView);
			}
			preMaterialView.setValue(f);
			preMaterialView.visible = true;
		}
		
		public var preMeshView:App3DPreMeshWin;
		public function openView_mesh(f:Function):void
		{
			if(preMeshView == null){
				preMeshView = new App3DPreMeshWin();
				get_App3DMainUIContainerMediator().addView(preMeshView);
			}
			preMeshView.setValue(f);
			preMeshView.visible = true;
		}
		
		public var preListWin:App3DPreListWin;
		public function openView_preList(d:D3ComFile,comp:D3ObjectBase,f:Function):void
		{
			if(preListWin==null){
				preListWin = new App3DPreListWin();
				get_App3DMainUIContainerMediator().addView(preListWin);
			}
			preListWin.visible = true;
			preListWin.comFile = d;
			preListWin.setValue(comp,f);
		}
		
		public var preTexture:App3DPreTextureWin;
		public function openView_texture(f:Function):void
		{
			if(preTexture == null){
				preTexture = new App3DPreTextureWin();
				get_App3DMainUIContainerMediator().addView(preTexture);
			}
			preTexture.visible = true;
			preTexture.setValue(f);
		}
		
		
		
		
		////////////////////////////////// com.editor.d3.view.attri.preview ///////////////////////////
		
		public var meshInfoPreview:MeshInfoPreview;
		public function openView_meshInfo(comp:D3ObjectBase):void
		{
			if(meshInfoPreview == null){
				meshInfoPreview = new MeshInfoPreview();
				get_App3DMainUIContainerMediator().addView(meshInfoPreview);
			}else{
				if(meshInfoPreview.visible){
					meshInfoPreview.visible = false;
					return ;
				}
			}
			meshInfoPreview.setValue(comp);
			meshInfoPreview.visible = true;
		}
		
		public var pre_mesh:MeshPreview;
		public function openPreview_mesh(comp:D3ObjectBase):void
		{
			if(pre_mesh == null){
				pre_mesh = new MeshPreview();
				get_App3DMainUIContainerMediator().addView(pre_mesh);
			}
			pre_mesh.visible = true;
			pre_mesh.setValue(comp);
		}
		
		public var preTexture2:TexturePreview;
		public function openView_texture2(comp:*):void
		{
			if(preTexture2 == null){
				preTexture2 = new TexturePreview();
				get_App3DMainUIContainerMediator().addView(preTexture2);
			}
			preTexture2.visible = true;
			if(comp is D3ObjectBase){
				preTexture2.setValue(comp);
			}else if(comp is File){
				preTexture2.setFile(comp);
			}
		}
		
		
		
		
		
		
		
		
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		protected static function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}