package com.editor.d3.app.scene.grid
{
	import away3d.loaders.misc.AssetLoaderContext;
	
	public class ParticleAssetLoaderContext extends AssetLoaderContext
	{
		public function ParticleAssetLoaderContext(includeDependencies:Boolean=true, dependencyBaseUrl:String=null)
		{
			super(includeDependencies, dependencyBaseUrl);
		}
		
		override public function mapUrl(originalUrl:String, newUrl:String):void
		{
			super.mapUrl(originalUrl,newUrl);
		}
		
		override public function mapUrlToData(originalUrl:String, data:*):void
		{
			super.mapUrlToData(originalUrl,data);
		}
	}
}