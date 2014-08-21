package com.editor.moudule_drama.vo.drama.frame
{
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	/**
	 * 场景	关键帧
	 * 
	 */	
	public class Drama_FrameSceneVO extends Drama_FrameBaseVO
	{
		public var sceneId:int;
		public var sceneOffset:int;
		/**是否振动**/
		public var shakeNow:int;
		/**场景背景	资源ID**/
		public var sceneBackgroundSourceId:int;
		public function Drama_FrameSceneVO()
		{
			
		}
		
		override public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:Drama_FrameSceneVO = new Drama_FrameSceneVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			/**base**/
			cloneObj.frameClipId = frameClipId;
			
			/**self**/
			cloneObj.sceneId = sceneId;
			cloneObj.sceneOffset = sceneOffset;
			cloneObj.shakeNow = shakeNow;
			cloneObj.sceneBackgroundSourceId = sceneBackgroundSourceId;
			
			return cloneObj;
		}
				
		override public function parseExtendXML(x:XML):void
		{
			this.sceneId = x.@s;
			this.sceneOffset = x.@O;
			this.shakeNow = x.@k;
			
			
			/**加载场景背景图**/
			
			var item:AppMapDefineItemVO = DramaManager.getInstance().get_DramaProxy().mapDefine.getMapDefineItemVoById(this.sceneId);
			if(item)
			{
				if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_pictrue)
				{
					sceneBackgroundSourceId = item.id;
					loaderBackgroundSource(item.id, DramaConst.loading_background, DramaConst.file_jpg, DramaConfig.currProject.mapResUrl+ "map/" + item.id + ".jpg");
					
				}else if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_inXMLByDefinition)
				{
					loadingXMLUrl = DramaConfig.currProject.mapConfigUrl + "map/" + item.id + ".xml";
					var mutltLoadData:ILoadMultSourceData = DramaManager.getInstance().get_DramaModuleMediator().iResource.getMultLoadSourceData();
					mutltLoadData.addXMLData(DramaManager.getInstance().get_DramaModuleMediator().iResource.getLoadSourceData(loadingXMLUrl,false,false,false,LoadQueueConst.sourceCache_mode1));
					var dt:ILoadQueueDataProxy = DramaManager.getInstance().get_DramaModuleMediator().iResource.getLoadQueueDataProxy();
					dt.multSourceData = mutltLoadData;
					dt.allLoadComplete_f = loadSceneXMLComplete;
					DramaManager.getInstance().get_DramaModuleMediator().iResource.loadMultResource(dt);
				}
			}
			
			
		}
		
		/**加载场景背景图**/
		private var loadingXMLUrl:String;
		private function loadSceneXMLComplete(e:*=null):void
		{
			var x:XML = XML(DramaManager.getInstance().get_DramaModuleMediator().iCacheManager.getCompleteLoadSource(loadingXMLUrl));
			
			/**场景层**/
			for each(var sXML:XML in x.s.i)
			{
				var isd:int = sXML.@df ? sXML.@df : 0;
				if(isd > 0)
				{
					var resId:String = sXML.@id ? sXML.@id : "";
					if(resId != "")
					{
						this.sceneBackgroundSourceId = int(resId);
						loaderBackgroundSource(int(resId), DramaConst.loading_background, DramaConst.file_swfDefinition);
					}
				}
			}
		}
		
		
		
		private function loaderBackgroundSource(id:int, loadingType:int, fileType:int, fileUrl:String=""):void
		{
			var item:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(id);
			var data:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
			data.loading_keyframeVO = this;
			data.loading_resInfoItemVO = item;
			data.fileType = fileType;
			data.fileUrl = fileUrl;
			data.loadingType = loadingType;
			DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);
			
		}
		
		
		
	}
}