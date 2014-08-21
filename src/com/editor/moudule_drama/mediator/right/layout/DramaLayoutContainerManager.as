package com.editor.moudule_drama.mediator.right.layout
{
	import com.editor.moudule_drama.view.right.layout.component.DLayoutContainer;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;

	public class DramaLayoutContainerManager
	{
		public function DramaLayoutContainerManager()
		{
		}
		
		/**场景帧层	背景图片列表**/
		private static var frameSceneBgList:Array = [];
		
		/**场景帧层	添加背景图片到列表**/
		public static function addToFrameSceneBgList(s:DLayoutSprite):void
		{
			frameSceneBgList.push(s);
		}
		
		/**场景帧层	清除场景数组**/
		public static function clearFrameSceneBgList():void
		{
			var a:Array = frameSceneBgList;
			var len:int = a.length-1;
			for(var i:int=len;i>=0;i--)
			{
				var s:DLayoutSprite = a[i] as DLayoutSprite;
				if(s)
				{
					if(s.parentContainer)
					{
						s.parentContainer.removeSprite(s);
						a.splice(i,1);
					}
					s.dispose();
					s = null;
				}				
			}
			
			frameSceneBgList = [];
		}
		
		/**场景帧层	显示背景图片 > 返回是否已存在并成功显示**/
		public static function visiFrameSceneBg(container:DLayoutContainer, vo:Drama_FrameSceneVO):Boolean
		{
			var bool:Boolean = false;
			var a:Array = frameSceneBgList;
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var s:DLayoutSprite = a[i] as DLayoutSprite;
				if(s)
				{
					var sceneDefLayerSourceId:String = vo? String(vo.sceneBackgroundSourceId) : "";
					if(s.ident == sceneDefLayerSourceId)
					{
						container.addSprite(s);
						s.x = -vo.sceneOffset;
						container.width = s.width;
						bool = true;
					}else
					{
						if(s.parentContainer)
						{
							s.parentContainer.removeSprite(s);
						}
					}
										
				}
										
			}
			
			return bool;
			
		}
		
		
		
	}
}