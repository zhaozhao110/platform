package com.editor.d3.app.scene.grid.scene
{
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	
	import com.d3.component.core.DisplayObject3D;
	import com.editor.d3.app.scene.grid.ParticleAssetLoaderContext;
	
	import flash.utils.ByteArray;

	public class D3ParticleScene extends DisplayObject3D
	{
		public function D3ParticleScene()
		{
			super();
		}
		
		public function play():void
		{
			if(particleGroup!=null){
				particleGroup.animator.start();
			}
		}
		
		public function stop():void
		{
			if(particleGroup!=null){
				particleGroup.animator.stop();
			}
		}
		
		/////////////////////////////// particle ////////////////////////////
		
		public var particleGroup:ParticleGroup;
		private var pLoader:AssetLoader;
		private var particleContext:ParticleAssetLoaderContext = new ParticleAssetLoaderContext();
		
		public function playParticle(b:ByteArray):void
		{
			if(b == null) return ;
			removeParticle()
			
			pLoader = new AssetLoader();
			pLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onAnimation);
			pLoader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onComplete);
			pLoader.addEventListener(LoaderEvent.LOAD_ERROR, onError);
			
			pLoader.loadData(b,"particle",particleContext);
			//pLoader.load(new URLRequest("G:\\project\\test3\\particle\\45646.awp"));
		}
		
		public function playAgain():void
		{
			if(particleGroup!=null)particleGroup.animator.start();
		}
		
		public function stopParticle():void
		{
			if(particleGroup!=null)particleGroup.animator.stop();	
		}
		
		private function onAnimation(e:AssetEvent):void
		{
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup)
			{
				particleGroup = e.asset as ParticleGroup;
				addChild(particleGroup);
				particleGroup.animator.start();
			}
		}
		
		private function onComplete(e:LoaderEvent):void
		{
			trace("Loader Complete");
		}
		
		private function onError(e:LoaderEvent):void
		{
			throw(new Error("Loader error: " + e.message));
		}
		
		private function removeParticle():void
		{
			if(particleGroup!=null){
				particleGroup.dispose();
			}
			particleGroup = null;
			if(pLoader!=null){
				pLoader.stop();
			}
			pLoader = null;
		}
		
	}
}