package com.editor.moudule_drama.popup.preview.component.rowLayers
{
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_RowLayer;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Sprite;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;

	/**
	 * 场景层
	 * @author sun
	 * 
	 */	
	public class DramaPreview_RowLayerScene extends DramaPreview_RowLayer
	{
		public function DramaPreview_RowLayerScene()
		{
		}
		
		override public function processKeyFrameVO(vo:ITimelineKeyframe_BaseVO):void
		{
			if(vo is Drama_FrameSceneVO)
			{
				var sceneDefLayerSourceId:String = (vo as Drama_FrameSceneVO).sceneBackgroundSourceId.toString();
				if(sceneDefLayerSourceId && sceneDefLayerSourceId != "")
				{
					var a:Array = layoutList;
					var len:int = a.length;
					for(var i:int=0;i<len;i++)
					{
						var s:DramaPreview_Sprite = a[i] as DramaPreview_Sprite;
						if(s)
						{
							if(s.ident == sceneDefLayerSourceId)
							{
								addChild(s);
								s.x = -(vo as Drama_FrameSceneVO).sceneOffset;
							}else
							{
								if(contains(s)) removeChild(s);
							}
						}
					}
				}
			}
			
			
		}
		
		
	}
}