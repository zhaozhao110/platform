package com.editor.d3.process
{
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.methods.SimpleWaterNormalMethod;
	import away3d.textures.CubeTextureBase;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.vo.D3LoopFunData;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemGeometry;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectGeometry;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.loopFun.D3WaterLoop;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.filesystem.File;

	public class D3ProccessGeometry extends D3ProccessObject
	{
		public function D3ProccessGeometry(d:D3ObjectGeometry)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group11;
		}
		
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			mapItem.createGeometry();
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemGeometry;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.attriId == 107 || d.attriId == 108){
				var scaleU:Number = Number(comp.configData.getAttri("scaleU"));
				var scaleV:Number = Number(comp.configData.getAttri("scaleV"));
				D3MapItemGeometry(mapItem).scaleUV(scaleU,scaleV);
			}
		}
		
		public function create_skyCubeTextureBase():CubeTextureBase
		{
			var s1:String = comp.configData.getAttri("cubeTexture");
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(s1));
			if(!f.exists) return null;
			var d:D3ObjectTexture = D3SceneManager.getInstance().displayList.convertObject(f,false) 
			return D3ProccessTexture(d.proccess).getTexture();
		}
		
		override public function getPreList(c:D3ComFile):Array
		{
			if(comp.compItem.isSkyBox){
				return D3ProjectFilesCache.getInstance().getAllTexture2();
			}
			return D3ProjectFilesCache.getInstance().getAllMaterial();
		}
		
		override public function reflashObjectAttri():void
		{
			super.reflashObjectAttri();
		}
		
		override protected function material_add_handle(e:ASEvent):void
		{
			createWaterLoop()
		}
		
		override protected function material_remove_handle(e:ASEvent):void
		{
			removeWaterLoop()
		}
		
		private var loopFun:D3WaterLoop;
		private function createWaterLoop():void
		{
			if(D3MapItemGeometry(mapItem).getMaterial() is SinglePassMaterialBase){
				if(SinglePassMaterialBase(D3MapItemGeometry(mapItem).getMaterial()).normalMethod is SimpleWaterNormalMethod){
					var m:SimpleWaterNormalMethod = SinglePassMaterialBase(D3MapItemGeometry(mapItem).getMaterial()).normalMethod as SimpleWaterNormalMethod;
					removeWaterLoop()
					if(loopFun == null){
						loopFun = new D3WaterLoop();
						loopFun.waterMethod = m;
						loopFun.proccess = this;
						D3SceneManager.getInstance().currScene.addLoopFun(loopFun);
					}
					return ;
				}
			}
			
		}
		
		private function removeWaterLoop():void
		{
			if(loopFun){
				D3SceneManager.getInstance().currScene.removeLoopFun(loopFun);
			}
			loopFun = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeWaterLoop()
		}
				
	}
}