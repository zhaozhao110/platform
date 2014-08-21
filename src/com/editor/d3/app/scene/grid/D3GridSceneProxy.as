package com.editor.d3.app.scene.grid
{
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.object.D3Object;

	public class D3GridSceneProxy
	{
		public function D3GridSceneProxy(s:D3GridScene)
		{
			target = s;
		}
		
		private var target:D3GridScene;
		
		public function get displayList():D3DisplayListCache
		{
			return target.displayList;
		}
		
	}
}