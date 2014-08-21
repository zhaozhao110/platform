package com.editor.d3.editor.group
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class D3MapItemParticle extends D3EditorMapItem
	{
		public function D3MapItemParticle()
		{
		}
		
		override public function getObject():ObjectContainer3D
		{
			return particleGroup;
		}
		
		private var pLoader:AssetLoader;
		private var particleGroup:ParticleGroup;
		
		//////////////////////////// particle //////////////////////////////////
		
		
		public function getParticleFile():File
		{
			return pLoader.data as File;
		}
		
		override public function loadParticle(b:File):void
		{
			if(b == null) return ;
			if(!b.exists) return ;
			removeParticle();
			
			if(D3ResChangeProxy.getInstance().checkFile(b)){
				var d:D3ResData = D3ResChangeProxy.getInstance().getFile(b.nativePath);
				if(d.content is ParticleGroup){
					getParticleFromCache(b);
					return;
				}
			}	
			
			pLoader = new AssetLoader();
			pLoader.data = b;
			pLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			pLoader.addEventListener(LoaderEvent.LOAD_ERROR, onError);
			pLoader.load(new URLRequest(b.nativePath));
		}
		
		protected function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.CONTAINER && event.asset is ParticleGroup)
			{
				particleGroup = event.asset as ParticleGroup;
				if(!D3ResChangeProxy.getInstance().checkFile(getParticleFile())){
					D3ResChangeProxy.getInstance().addFile(getParticleFile(),particleGroup.clone());
				}
				objectParent.addChild(particleGroup);
				particleGroup.animator.start();
				reflashMeshInfo()
				dispatchEvent(new ASEvent(ANIMATIONSET_CREATE_COMPLETE));
			}	
		}
		
		private function onError(e:LoaderEvent):void
		{
			
		}
		
		public function reflashParticleCache():void
		{
			loadParticle(getParticleFile());
		}
		
		public function setParticleAttri(k:String,v:*):void
		{
			if(particleGroup.hasOwnProperty(k)){
				particleGroup[k] = v;
			}
		}
		
		override public function removeParticle():void
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
		
		public function playParticle():void
		{
			if(particleGroup!=null)particleGroup.animator.start();
		}
		
		public function stopParticle():void
		{
			if(particleGroup!=null)particleGroup.animator.stop();	
		}
		
		private function getParticleFromCache(f:File):void
		{
			var d:D3ResData = D3ResChangeProxy.getInstance().getFile(f.nativePath);
			particleGroup = (d.content as ParticleGroup).clone() as ParticleGroup;
			objectParent.addChild(particleGroup);
		}
		
		
	}
}