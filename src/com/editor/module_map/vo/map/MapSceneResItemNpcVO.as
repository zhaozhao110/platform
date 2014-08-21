package com.editor.module_map.vo.map
{
	public class MapSceneResItemNpcVO extends MapSceneResItemVO
	{
		public function MapSceneResItemNpcVO()
		{
		}
		
		override public function clone():MapSceneResItemVO
		{
			var n:MapSceneResItemNpcVO = new MapSceneResItemNpcVO();
			
			n.type = this.type;
			n.sourceId = this.sourceId;
			n.sourceName = this.sourceName;
			n.sourceType = this.sourceType;
			n.sceneId = this.sceneId;
			n.x = this.x;
			n.y = this.y;
			n.scaleX = this.scaleX;
			n.scaleY = this.scaleY;
			n.rotation = this.rotation;
			n.data = this.data;
			
			return n;	
		}
		
	}
}