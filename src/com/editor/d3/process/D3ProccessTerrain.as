package com.editor.d3.process
{
	import away3d.materials.MaterialBase;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemTerrain;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectTerrain;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;

	public class D3ProccessTerrain extends D3ProccessObject
	{
		public function D3ProccessTerrain(d:D3ObjectTerrain)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group3;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_9;
		}
		
		override public function getPreList(c:D3ComFile):Array
		{
			if(c.item.expand == "image"){
				return D3ProjectFilesCache.getInstance().getAllTextureAssets();
			}
			return D3ProjectFilesCache.getInstance().getAllMaterial();
		}
		
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			D3MapItemTerrain(mapItem).createTerrain();
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemTerrain;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			D3MapItemTerrain(mapItem).createTerrain();
		}
		
		public function createTerrainMaterial():MaterialBase
		{
			var s:String = comp.configData.getAttri("material");
			if(StringTWLUtil.isWhitespace(s)) return null;
			s = D3ProjectFilesCache.getInstance().addProjectResPath(s);
			var f:File = new File(s);
			if(!f.exists)return null;
			var d:D3ObjectMaterial = D3SceneManager.getInstance().displayList.convertObject(f,false) as D3ObjectMaterial;
			comp.materialComp = d;
			return D3ProccessMaterial(d.proccess).getMaterial();
		}
		
		public function createHeightMap():BitmapData
		{
			var s:String = comp.configData.getAttri("heightMap");
			if(StringTWLUtil.isWhitespace(s)) return null;
			s = D3ProjectFilesCache.getInstance().addProjectResPath(s);
			return D3ResChangeProxy.getInstance().getFile(s).content.bitmapData;
		}
		
		
		
		
		
	}
}