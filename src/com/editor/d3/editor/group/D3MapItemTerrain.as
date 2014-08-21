package com.editor.d3.editor.group
{
	import away3d.containers.ObjectContainer3D;
	import away3d.extrusions.Elevation;
	import away3d.materials.MaterialBase;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.process.D3ProccessTerrain;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.display.BitmapData;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class D3MapItemTerrain extends D3EditorMapItem
	{
		public function D3MapItemTerrain()
		{
			super();
		}
		
		override public function getObject():ObjectContainer3D
		{
			return terrain;
		}
		
		private var terrain:Elevation;
		private var time_u:uint;
		
		public function createTerrain():void
		{
			clearTimeout(time_u);
			time_u = setTimeout(_createTerrain,1000);
		}
		
		private function _createTerrain():void
		{
			if(terrain !=null){
				removeListener()
				terrain.dispose();
				terrain = null;
			}
			
			var material:MaterialBase = D3ProccessTerrain(comp.proccess).createTerrainMaterial();
			if(material==null)return ;
			var heightMap:BitmapData = D3ProccessTerrain(comp.proccess).createHeightMap();
			if(heightMap == null)return ;
			terrain = new Elevation(material,heightMap,
										getTerrain_width(),
										getTerrain_height(),
										getTerrain_depth(),
										getTerrain_segmentsW(),
										getTerrain_segmentsH(),
										getTerrain_maxElevation(),
										getTerrain_minElevation(),
										getTerrain_smoothMap());
			objectParent.addChild(terrain);
			//terrain.pickingCollider = D3ViewManager.pickingCollider;
			terrain.mouseEnabled = true;
			_setMaterialInited(material);
			reflashMeshInfo();
			addListener();
			
			if(mesh_create_complete_f!=null) mesh_create_complete_f(this);
			mesh_create_complete_f = null;
			dispatchEvent(new ASEvent(MESH_CREATE_COMPLETE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(terrain!=null)terrain.dispose();
			terrain = null;
		}
		
		private function getTerrain_width():int
		{
			var w:int = int(comp.configData.getAttri("width"));
			if(w == 0) return 1000;
			return w;
		}
		
		private function getTerrain_height():int
		{
			var w:int = int(comp.configData.getAttri("height"));
			if(w == 0) return 100;
			return w;
		}
		
		private function getTerrain_depth():int
		{
			var w:int = int(comp.configData.getAttri("depth"));
			if(w == 0) return 1000;
			return w;
		}
		
		private function getTerrain_segmentsW():int
		{
			var w:int = int(comp.configData.getAttri("segmentsW"));
			if(w == 0) return 30;
			return w;
		}
		
		private function getTerrain_segmentsH():int
		{
			var w:int = int(comp.configData.getAttri("segmentsH"));
			if(w == 0) return 30;
			return w;
		}
		
		private function getTerrain_maxElevation():int
		{
			var w:int = int(comp.configData.getAttri("maxElevation"));
			if(w == 0) return 255;
			return w;
		}
		
		private function getTerrain_minElevation():int
		{
			var w:int = int(comp.configData.getAttri("minElevation"));
			if(w == 0) return 0;
			return w;
		}
		
		private function getTerrain_smoothMap():Boolean
		{
			if(comp.configData.checkAttri("smoothMap")){
				return comp.configData.getAttri("smoothMap");
			}
			return false;
		}
		
		
		
		
	}
}