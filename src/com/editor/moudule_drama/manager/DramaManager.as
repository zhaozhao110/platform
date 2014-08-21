package com.editor.moudule_drama.manager
{
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.mediator.DramaModuleMediator;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameDialogMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameMovieMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameResRecordMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameSceneMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_LayoutViewMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_RowMediator;
	import com.editor.moudule_drama.mediator.right.DramaRightContainerMediator;
	import com.editor.moudule_drama.mediator.right.layout.DramaLayoutContainerManager;
	import com.editor.moudule_drama.mediator.right.layout.DramaLayoutContainerMediator;
	import com.editor.moudule_drama.mediator.top.DramaToolBarMediator;
	import com.editor.moudule_drama.popup.preview.DramaPreviewPopupwinMediator;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewSequenceVO;
	import com.editor.moudule_drama.vo.drama.layout.IDrama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesNpcVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;
	import com.editor.moudule_drama.vo.project.DramaProjectItemVO;
	import com.sandy.manager.SandyManagerBase;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DramaManager extends SandyManagerBase
	{
		/**布局允许加载的资源类型表**/
		public static const layoutResTypeList:Array = [1,2,4,5,6,7,9,13,14];
		
		private static const actionType1:String = "d";
		private static const actionType2:String = "gd";
		
		
		private static var instance:DramaManager;
		public static function getInstance():DramaManager
		{
			if(!instance)
			{
				instance = new DramaManager();
			}
			return instance;
		}
		
		/**加载成功创建新的显示对象VO**/
		public static function createNewLayoutViewVO(loadingData:Drama_LoadingLayoutResData):IDrama_LayoutViewBaseVO
		{
			var vo:IDrama_LayoutViewBaseVO;
			
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			var resInfoType:int = loadingData.loading_resInfoItemVO.type;
			if(resInfoType == 4 || resInfoType == 6 || resInfoType == 13)
			{
				vo = new Drama_LayoutViewBaseVO();
				
			}else if(resInfoType == 1 || resInfoType == 2 || resInfoType == 5 || resInfoType == 14)
			{
				vo = new Drama_LayoutViewSequenceVO();
			}
			if(vo)
			{
				vo.id = DramaDataManager.getInstance().getLayoutViewNewId() + "";
				vo.rowId = DramaDataManager.getInstance().selectedRowId;
				vo.sourceId = loadingData.loading_resInfoItemVO.id;
				vo.sourceName = loadingData.loading_resInfoItemVO.name;
				vo.sourceType = loadingData.loading_resInfoItemVO.type;
			}
			
			
			return vo;
		}
		
		/**加载成功创建新的属性VO**/
		public static function createNewPropertiesVO(resInfoItem:AppResInfoItemVO):ITimelineViewProperties_BaseVO
		{
			var vo:ITimelineViewProperties_BaseVO;
			
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			var resInfoType:int = resInfoItem.type;
			if(resInfoType == 4 || resInfoType == 6 || resInfoType == 13)
			{
				vo = new Drama_PropertiesBaseVO();
				
			}else if(resInfoType == 1 || resInfoType == 5 || resInfoType == 14)
			{
				vo = new Drama_PropertiesRoleVO();
				
			}else if(resInfoType == 2)
			{
				vo = new Drama_PropertiesNpcVO();
			}
			
			/**proto**/
			vo.x = 100;
			vo.y = 100;
			
			/**base vo**/
			if(vo is Drama_PropertiesBaseVO)
			{
				(vo as Drama_PropertiesBaseVO).name = resInfoItem.name;
				(vo as Drama_PropertiesBaseVO).resType = resInfoItem.type;
			}
			
			return vo;
		}
		
		/**根据资源类型返回新的属性VO**/
		public function getNewPropertyVO_BySourceType(type:int):ITimelineViewProperties_BaseVO
		{
			var propVO:ITimelineViewProperties_BaseVO;
			
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			if(type == 4 || type == 6 || type == 13)
			{
				propVO = new Drama_PropertiesBaseVO();
			}else if(type == 2)
			{
				propVO = new Drama_PropertiesNpcVO();
			}else if(type == 1 || type == 5 || type == 14)
			{
				propVO = new Drama_PropertiesRoleVO();
			}else
			{
				propVO = new Drama_PropertiesBaseVO();
			}
			
			return propVO;			
		}
		/**根据资源类型返回新的显示VO**/
		public function getNewLayoutVO_BySourceType(type:int):IDrama_LayoutViewBaseVO
		{
			var layoutVO:IDrama_LayoutViewBaseVO;
			
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			if(type == 4 || type == 6 || type == 13)
			{
				layoutVO = new Drama_LayoutViewBaseVO();
				
			}else if(type == 1 || type == 2 || type == 5 || type == 14)
			{
				layoutVO = new Drama_LayoutViewSequenceVO();
			}else
			{
				layoutVO = new Drama_LayoutViewBaseVO();
			}
			
			return layoutVO;
		}
		
				
		/**获得资源所需类名**/
		public static function getResClassName(id:int, type:int):String
		{
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			var outStr:String = "";
			var actionType:String = "";
			var hasActionType:Boolean;
			
			var a:AppMotionItemVO = getInstance().get_DramaProxy().motion_ls.getMotionById(id);
			if(a)
			{
				var action:AppMotionActionVO = a.getActionByType(actionType2);
				if(action && action.getForward(7))
				{
					actionType = "_" + actionType2;
				}else
				{
					action = a.getActionByType(actionType1);
					if(action && action.getForward(7))
					{
						actionType = "_" + actionType1;
					}
				}
			}
			
			switch(type)
			{
				case 1:
					//outStr = "e" + id;
					outStr = "e1003"
					hasActionType = true;
					break;
				case 2:
					outStr = "e" + id;
					hasActionType = true;
					break;
				case 3:
					break;
				case 4:
					outStr = "e" + id;
					break;
				case 5:
					outStr = "e" + id;
					hasActionType = true;
					break;
				case 6:
					outStr = "sceneEffect" + id;
					break;
				case 7:
					outStr = "e" + id;
					hasActionType = true;
					break;
				case 9:
					outStr = "scene" + id;
					break;
				case 12:
					outStr = "e" + id;
					break;
				case 13:
					outStr = "pic" + id;
					break;
				case 14:
					outStr = "e" + id;
					hasActionType = true;
					break;
			}
			
			if(hasActionType)
			{
				if(getInstance().get_DramaModuleMediator().iResource.haveClass(outStr + "_" + actionType2))
				{
					outStr = outStr + "_" + actionType2;
				}else if(getInstance().get_DramaModuleMediator().iResource.haveClass(outStr + "_" + actionType1))
				{
					outStr = outStr + "_" + actionType1;
				}else
				{
					outStr = outStr + actionType;
				}
			}
			
			return outStr;
		}
		
		/**获得资源子路径**/
		public static function getResSubpath(type:int):String
		{
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			var subpath:String = "";			
			switch(type)
			{
				case 1:
					subpath = "monster/swf/";
					break;
				case 2:
					subpath = "npc/swf/";
					break;
				case 3:
					break;
				case 4:
					subpath = "effect/swf/";
					break;
				case 5:
					subpath = "user/swf/";
					break;
				case 6:
					subpath = "map/effect/";
					break;
				case 7:
					subpath = "user/arm/swf/";
					break;
				case 9:
					subpath = "map/scene/";
					break;
				case 12:
					subpath = "movie/swf/";
					break;
				case 13:
					subpath = "pic/";
					break;
				case 14:
					subpath = "npc/swf/";
					break;
			}
			
			return subpath;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**获得文件**/
		public static function getResFilePath(type:int=0):String
		{
			/** 1 怪物 2 NPC 4 战斗特效 5 玩家 6 场景动画 7 武器 8  12影片 13图片 14剧情NPC **/
			var filePath:String = "";			
			switch(type)
			{
				case 1:
					filePath = "assets/img/role.png";
					break;
				case 2:
					filePath = "assets/img/role.png";
					break;
				case 3:
					break;
				case 4:
					filePath = "assets/img/effect.png";
					break;
				case 5:
					filePath = "assets/img/role.png";
					break;
				case 6:
					filePath = "assets/img/effect.png";
					break;
				case 7:
					filePath = "assets/img/role.png";
					break;
				case 9:
					filePath = "assets/img/role.png";
					break;
				case 12:
					filePath = "assets/img/role.png";
					break;
				case 13:
					filePath = "assets/img/nopic.png";
					break;
				case 14:
					filePath = "assets/img/role.png";
					break;
				
				default:
					filePath = "assets/img/role.png";
					break;
			}
			
			return filePath;
		}
		
		
		/**获取人物静止图像**/
		public static function getRoleStaticBitmapData(roleBD:BitmapData, resItem:AppResInfoItemVO):BitmapData
		{
			var outBD:BitmapData = roleBD;
			
			var resId:int = resItem.id;
			if(resItem.type == 1){
				resId = 1003;
			}
			
			var a:AppMotionItemVO = getInstance().get_DramaProxy().motion_ls.getMotionById(resId);
			var action:AppMotionActionVO;
			if(a)
			{
				action = a.getActionByType(actionType2);
				if(!action || !action.getForward(7))
				{
					action = a.getActionByType(actionType1);
				}
				
				if(action && action.getForward(7))
				{
					var r:Rectangle = action.getForward(7).getRectangle(0) as Rectangle;
					if(r)
					{
						r.x = 0; 
						r.y = 0;
						outBD = new BitmapData(r.width, r.height, true, 0x000000);
						outBD.copyPixels(roleBD, r, new Point());
					}
					
				}				
			}
			
			return outBD;
		}
		
		/**
		 * 当前状态是否允许操作 ==
		 * 判断项目、剧情、加载、片断		是否已成功
		 * @param phase 1:选择片断阶段
		 * @return 
		 * 
		 */
		public function isEnabledToControl(phase:int=0):Boolean
		{
			if(!DramaConfig.currProject || !DramaConfig.currProject.data)
			{
				/**未选择项目**/
				getInstance().get_DramaModuleMediator().openSelectProject();
				return false;
			}			
			if(getInstance().get_DramaProxy().plot_ls == null)
			{
				/**项目未加载完成**/
				get_DramaModuleMediator().showMessage("请等待加载完成！");
				return false;
			}
			if(!DramaDataManager.getInstance().currentSelectedDramaItem)
			{
				/**未选择当前剧情**/
				getInstance().get_DramaToolBarMediator().selectedDrama();
				return false;
			}
			if(!DramaDataManager.getInstance().getCurrentFrameClip())
			{
				if(phase != 1)
				{
					/**未选择片断**/
					getInstance().get_DramaLeftContainerMediator().tabBar.selectedIndex = 0;
					get_DramaModuleMediator().showMessage("请选择片断！");
					return false;
				}
			}
			
			return true;
		}
		
		/**选择新剧情后清除上一个剧情数据**/
		public function selectNewDramaClear():void
		{
			DramaDataManager.getInstance().clearFrameClipList();
			DramaDataManager.getInstance().clearKeyframe();
			DramaDataManager.getInstance().clearLayoutView();
			
			DramaDataManager.getInstance().clearFrameClipNewId();
			DramaDataManager.getInstance().clearKeyframeNewId();
			DramaDataManager.getInstance().clearLayoutViewNewId();
			
			DramaLayoutContainerManager.clearFrameSceneBgList();
			getInstance().get_DramaLayoutContainerMediator().clearLayoutView();
			
			DramaManager.getInstance().get_DramaLeftContainerMediator().updataFrameClipList();
			sendAppNotification(DramaEvent.drama_updataTimeline_event);
		}
		
		
		/**获取布局显示对象**/
		public function getLayoutViewById(id:String):DLayoutSprite
		{
			return get_DramaLayoutContainerMediator().getLayoutViewById(id);
		}
		
		/** <<gets **/
		public function get_DramaModuleMediator():DramaModuleMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaModuleMediator.NAME) as DramaModuleMediator;
		}		
		public function get_DramaProxy():DramaProxy
		{
			return iManager.getAppFacade().retrieveProxy(DramaProxy.NAME) as DramaProxy;
		}
		public function get_DramaToolBarMediator():DramaToolBarMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaToolBarMediator.NAME) as DramaToolBarMediator;
		}
		public function get_DramaLeftContainerMediator():DramaLeftContainerMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaLeftContainerMediator.NAME) as DramaLeftContainerMediator;
		}
		public function get_DramaRightContainerMediator():DramaRightContainerMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaRightContainerMediator.NAME) as DramaRightContainerMediator;
		}		
		public function get_DramaLayoutContainerMediator():DramaLayoutContainerMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaLayoutContainerMediator.NAME) as DramaLayoutContainerMediator;
		}
		
		public function get_DramaAttributeEditor_sceneFrameMediator():DramaAttributeEditor_FrameSceneMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_FrameSceneMediator.NAME) as DramaAttributeEditor_FrameSceneMediator;
		}
		public function get_DramaAttributeEditor_resRecordMediator():DramaAttributeEditor_FrameResRecordMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_FrameResRecordMediator.NAME) as DramaAttributeEditor_FrameResRecordMediator;
		}
		public function get_DramaAttributeEditor_movieFrameMediator():DramaAttributeEditor_FrameMovieMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_FrameMovieMediator.NAME) as DramaAttributeEditor_FrameMovieMediator;
		}
		public function get_DramaAttributeEditor_dialogFrameMediator():DramaAttributeEditor_FrameDialogMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_FrameDialogMediator.NAME) as DramaAttributeEditor_FrameDialogMediator;
		}
		public function get_DramaAttributeEditor_LayoutViewMediator():DramaAttributeEditor_LayoutViewMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_LayoutViewMediator.NAME) as DramaAttributeEditor_LayoutViewMediator;
		}
		public function get_DramaAttributeEditor_RowMediator():DramaAttributeEditor_RowMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaAttributeEditor_RowMediator.NAME) as DramaAttributeEditor_RowMediator;
		}
		
		public function get_DramaPreviewPopupwinMediator():DramaPreviewPopupwinMediator
		{
			return iManager.getAppFacade().retrieveMediator(DramaPreviewPopupwinMediator.NAME) as DramaPreviewPopupwinMediator;
		}
		
		
	}
}