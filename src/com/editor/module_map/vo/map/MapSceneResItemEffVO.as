package com.editor.module_map.vo.map
{
	public class MapSceneResItemEffVO extends MapSceneResItemVO
	{
		public var startFrame:int; //起始播放帧
		
		public function MapSceneResItemEffVO()
		{
		}
		
		override public function clone():MapSceneResItemVO
		{
			var n:MapSceneResItemEffVO = new MapSceneResItemEffVO();
			
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
			
			n.startFrame = this.startFrame;
			
			return n;	
		}
		
	}
}