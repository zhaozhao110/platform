package com.editor.modules.app.view.main
{
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_actionMix.ActionMixModule;
	import com.editor.module_actionMix.mediator.ActionMixModuleMediator;
	import com.editor.module_api.ApiModule;
	import com.editor.module_api.ApiModuleMediator;
	import com.editor.module_avg.AVGModule;
	import com.editor.module_avg.mediator.AVGModuleMediator;
	import com.editor.module_changeLog.ChangeLogModule;
	import com.editor.module_changeLog.ChangeLogModuleMediator;
	import com.editor.module_html.HtmlModule;
	import com.editor.module_html.HtmlModuleMediator;
	import com.editor.module_map.MapEditorModule;
	import com.editor.module_map.mediator.MapEditorModuleMediator;
	import com.editor.module_map2.MapEditor2Module;
	import com.editor.module_map2.mediator.MapEditor2ModuleMediator;
	import com.editor.module_mapIso.MapEditorIsoModule;
	import com.editor.module_mapIso.mediator.MapEditorIsoModuleMediator;
	import com.editor.module_roleEdit.PeopleImageModule;
	import com.editor.module_roleEdit.mediator.PeopleImageModuleMediator;
	import com.editor.module_sea.SeaMapModule;
	import com.editor.module_sea.mediator.SeaMapModuleMediator;
	import com.editor.module_server.ServerModule;
	import com.editor.module_server.ServerModuleMediator;
	import com.editor.module_skill.SkillSeqModule;
	import com.editor.module_skill.mediator.SkillSeqModuleMediator;
	import com.editor.module_sql.SqlMamModule;
	import com.editor.module_sql.SqlMamModuleMediator;
	import com.editor.modules.common.app.AppMiddleContainer;
	import com.editor.modules.common.app.AppMiddleContainerMediator;
	import com.editor.moudule_drama.DramaModule;
	import com.editor.moudule_drama.mediator.DramaModuleMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.UIComponentUtil;
	
	public class AppMainUIViewStackMediator extends AppMediator
	{
		public static const NAME:String = "AppMainUIViewStackMediator"
		public function AppMainUIViewStackMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainViewStack():AppMainUIViewStack
		{
			return viewComponent as AppMainUIViewStack;
		}
		public function get contianer():AppMiddleContainer
		{
			return mainViewStack.contianer;
		}
				
		override public function onRegister():void
		{
			super.onRegister();
			
			StackManager.viewStackMediator = this;
			
			registerMediator(new AppMiddleContainerMediator(contianer));
		}
		
		public function respondToOpenWebsiteEvent(noti:Notification):void
		{
			var _create:Boolean;
			if(htmlContainer != null){
				_create = true;
			}
			StackManager.getInstance().changeStack(DataManager.stack_html);
			if(!_create){
				sendAppNotification(AppEvent.openWebsite_event,noti.getBody(),noti.getType());
			}
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			if(type == DataManager.stack_code || type == DataManager.stack_css || type == DataManager.stack_ui){
				mainViewStack.selectedIndex = 0;
			}else if(type == DataManager.stack_roleEdit){
				addRoleEdit();
				mainViewStack.setSelectByLabel(DataManager.stack_roleEdit.toString())
			}else if(type == DataManager.stack_actionMix){
				addActionMix()
				mainViewStack.setSelectByLabel(DataManager.stack_actionMix.toString())
			}else if(type == DataManager.stack_skill){
				addSkillSeq()
				mainViewStack.setSelectByLabel(DataManager.stack_skill.toString())
			}else if(type == DataManager.stack_map){
				addMapEditor()
				mainViewStack.setSelectByLabel(DataManager.stack_map.toString())
			}else if(type == DataManager.stack_html){
				addHtmlContainer();
				mainViewStack.setSelectByLabel(DataManager.stack_html.toString())
			}else if(type == DataManager.stack_drama){
				addDrama()
				mainViewStack.setSelectByLabel(DataManager.stack_drama.toString())
			}else if(type == DataManager.stack_database){
				addSqlContainer();
				mainViewStack.setSelectByLabel(DataManager.stack_database.toString())
			}else if(type == DataManager.stack_mapIso){
				addMapIsoEditor();
				mainViewStack.setSelectByLabel(DataManager.stack_mapIso.toString())
			}else if(type == DataManager.stack_backManager){
				addServerModule();
				mainViewStack.setSelectByLabel(DataManager.stack_backManager.toString())
			}else if(type == DataManager.stack_changeLog){
				addChangeLog();
				mainViewStack.setSelectByLabel(DataManager.stack_changeLog.toString())
			}else if(type == DataManager.stack_mapTile){
				addMap2Module();
				mainViewStack.setSelectByLabel(DataManager.stack_mapTile.toString())
			}else if(type == DataManager.stack_avg){
				addavgModule()
				mainViewStack.setSelectByLabel(DataManager.stack_avg.toString())
			}else if(type == DataManager.stack_api){
				addApiModule()
				mainViewStack.setSelectByLabel(DataManager.stack_api.toString())
			}else if(type == DataManager.stack_sea){
				addSeaModule()
				mainViewStack.setSelectByLabel(DataManager.stack_sea.toString())
			}
		}
		
		//api
		private var apiModule:ApiModule;
		private var apiModuleMediator:ApiModuleMediator;
		public function addApiModule():Boolean
		{
			if(apiModule != null) return false;
			apiModule = new ApiModule();
			apiModule.label = DataManager.stack_api.toString();
			mainViewStack.addChild(apiModule);
			registerMediator(apiModuleMediator = new ApiModuleMediator(apiModule));
			return true;
		}
		public function removeApiModule():void
		{
			if(apiModuleMediator!=null){
				removeMediator(ApiModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,apiModule);
			apiModule = null;
		}
		
		//avg
		private var avgModule:AVGModule;
		private var avgModuleMediator:AVGModuleMediator;
		public function addavgModule():Boolean
		{
			if(avgModule != null) return false;
			avgModule = new AVGModule();
			avgModule.label = DataManager.stack_avg.toString();
			mainViewStack.addChild(avgModule);
			registerMediator(avgModuleMediator = new AVGModuleMediator(avgModule));
			return true;
		}
		public function removeavgModule():void
		{
			if(avgModuleMediator!=null){
				removeMediator(AVGModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,avgModule);
			avgModule = null;
		}
		
		//map2
		private var map2Module:MapEditor2Module;
		private var map2ModuleMediator:MapEditor2ModuleMediator;
		public function addMap2Module():Boolean
		{
			if(map2Module != null) return false;
			map2Module = new MapEditor2Module();
			map2Module.label = DataManager.stack_mapTile.toString();
			mainViewStack.addChild(map2Module);
			registerMediator(map2ModuleMediator = new MapEditor2ModuleMediator(map2Module));
			return true;
		}
		public function removeMap2Module():void
		{
			if(map2ModuleMediator!=null){
				removeMediator(MapEditor2ModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,map2Module);
			map2Module = null;
		}
		
		//changeLog
		private var changeLog:ChangeLogModule;
		private var changeLogMediator:ChangeLogModuleMediator;
		public function addChangeLog():Boolean
		{
			if(changeLog != null) return false;
			changeLog = new ChangeLogModule();
			changeLog.label = DataManager.stack_changeLog.toString();
			mainViewStack.addChild(changeLog);
			registerMediator(changeLogMediator = new ChangeLogModuleMediator(changeLog));
			return true;
		}
		public function removeChangeLog():void
		{
			if(changeLogMediator!=null){
				removeMediator(ChangeLogModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,changeLog);
			changeLog = null;
		}
		
		//横版地图编辑
		private var mapContainer:MapEditorModule;
		private var mapContainerMediator:MapEditorModuleMediator;
		public function addMapEditor():Boolean
		{
			if(mapContainer != null) return false;
			mapContainer = new MapEditorModule();
			mapContainer.label = DataManager.stack_map.toString();
			mainViewStack.addChild(mapContainer);
			registerMediator(mapContainerMediator = new MapEditorModuleMediator(mapContainer));
			return true;
		}
		public function removeMapEditor():void
		{
			if(mapContainerMediator!=null){
				removeMediator(MapEditorModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,mapContainer);
			mapContainer = null;
		}
		
		
		//角色编辑
		private var roleEditContainer:PeopleImageModule;
		private var roleEditContainerMediator:PeopleImageModuleMediator;
		public function addRoleEdit():Boolean
		{
			if(roleEditContainer != null) return false;
			roleEditContainer = new PeopleImageModule();
			roleEditContainer.label = DataManager.stack_roleEdit.toString();
			mainViewStack.addChild(roleEditContainer);
			registerMediator(roleEditContainerMediator = new PeopleImageModuleMediator(roleEditContainer));
			return true;
		}
		public function removeRoleEdit():void
		{
			if(roleEditContainerMediator!=null){
				removeMediator(PeopleImageModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,roleEditContainer);
			roleEditContainer = null;
		}
		
		
		//角色动作混合
		public var actionMixContainer:ActionMixModule;
		private var actionMixContainerMediator:ActionMixModuleMediator;
		public function addActionMix():Boolean
		{
			if(actionMixContainer != null) return false;
			actionMixContainer = new ActionMixModule();
			actionMixContainer.label = DataManager.stack_actionMix.toString();
			mainViewStack.addChild(actionMixContainer);
			registerMediator(actionMixContainerMediator = new ActionMixModuleMediator(actionMixContainer));
			return true;
		}
		public function removeActionMix():void
		{
			if(actionMixContainerMediator!=null){
				removeMediator(ActionMixModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,actionMixContainer);
			actionMixContainer = null;
		}
		
		//技能编辑
		public var skillSeqContainer:SkillSeqModule;
		private var skillSeqContainerMediator:SkillSeqModuleMediator;		
		public function addSkillSeq():Boolean
		{
			if(skillSeqContainer != null) return false;
			skillSeqContainer = new SkillSeqModule();
			skillSeqContainer.label = DataManager.stack_skill.toString();
			mainViewStack.addChild(skillSeqContainer);
			registerMediator(skillSeqContainerMediator = new SkillSeqModuleMediator(skillSeqContainer));
			return true;
		}
		public function removeSkillSeq():void
		{
			if(skillSeqContainerMediator!=null){
				removeMediator(SkillSeqModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,skillSeqContainer);
			skillSeqContainer = null;
		}
		
		
		//剧情编辑
		public var dramaContainer:DramaModule;
		private var dramaContainerMediator:DramaModuleMediator;
		public function addDrama():Boolean
		{
			if(dramaContainer != null) return false;
			dramaContainer = new DramaModule();
			dramaContainer.label = DataManager.stack_drama.toString();
			mainViewStack.addChild(dramaContainer);
			registerMediator(dramaContainerMediator = new DramaModuleMediator(dramaContainer));
			return true;
		}
		public function removeDrama():void
		{
			if(dramaContainerMediator!=null){
				removeMediator(DramaModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,dramaContainer);
			dramaContainer = null;
		}
		
		//html browse
		public var htmlContainer:HtmlModule;
		public var htmlContainerMediator:HtmlModuleMediator;
		private function addHtmlContainer():Boolean
		{
			if(htmlContainer != null) return false;
			htmlContainer = new HtmlModule();
			htmlContainer.label = DataManager.stack_html.toString();
			mainViewStack.addChild(htmlContainer);
			registerMediator(htmlContainerMediator = new HtmlModuleMediator(htmlContainer));
			return true;
		}
		public function removeHtmlContainer():void
		{
			if(htmlContainerMediator!=null){
				removeMediator(HtmlModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,htmlContainer);
			htmlContainer = null;
		}
		
		//sql database
		public var sqlContainer:SqlMamModule;
		public var sqlContainerMediator:SqlMamModuleMediator;
		private function addSqlContainer():Boolean
		{
			if(sqlContainer != null) return false;
			sqlContainer = new SqlMamModule();
			sqlContainer.label = DataManager.stack_database.toString();
			mainViewStack.addChild(sqlContainer);
			registerMediator(sqlContainerMediator = new SqlMamModuleMediator(sqlContainer));
			return true;
		}
		public function removeSqlContainer():void
		{
			if(sqlContainer!=null){
				removeMediator(SqlMamModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,sqlContainer);
			sqlContainer = null;
		}
		
		//45度地图编辑
		private var mapIsoContainer:MapEditorIsoModule;
		private var mapIsoContainerMediator:MapEditorIsoModuleMediator;
		public function addMapIsoEditor():Boolean
		{
			if(mapIsoContainer != null) return false;
			mapIsoContainer = new MapEditorIsoModule();
			mapIsoContainer.label = DataManager.stack_mapIso.toString();
			mainViewStack.addChild(mapIsoContainer);
			registerMediator(mapIsoContainerMediator = new MapEditorIsoModuleMediator(mapIsoContainer));
			return true;
		}
		public function removeMapIsoEditor():void
		{
			if(mapIsoContainerMediator!=null){
				removeMediator(MapEditorIsoModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,mapIsoContainer);
			mapIsoContainer = null;
		}
		
		//后台管理
		private var serverModule:ServerModule;
		private var serverModuleMediator:ServerModuleMediator;
		public function addServerModule():Boolean
		{
			if(serverModule != null) return false;
			serverModule = new ServerModule();
			serverModule.label = DataManager.stack_backManager.toString();
			mainViewStack.addChild(serverModule);
			registerMediator(serverModuleMediator = new ServerModuleMediator(serverModule));
			return true;
		}
		public function removeServerModule():void
		{
			if(mapIsoContainerMediator!=null){
				removeMediator(ServerModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,serverModule);
			serverModule = null;
		}
		
		
		//海岛地图编辑
		private var seaMapContainer:SeaMapModule;
		private var seaMapContainerMediator:SeaMapModuleMediator;
		public function addSeaModule():Boolean
		{
			if(seaMapContainer != null) return false;
			seaMapContainer = new SeaMapModule();
			seaMapContainer.label = DataManager.stack_sea.toString();
			mainViewStack.addChild(seaMapContainer);
			registerMediator(seaMapContainerMediator = new SeaMapModuleMediator(seaMapContainer));
			return true;
		}
		public function removeSeaEditor():void
		{
			if(seaMapContainerMediator!=null){
				removeMediator(SeaMapModuleMediator.NAME);
			}
			UIComponentUtil.removeMovieClipChild(mainViewStack,seaMapContainer);
			seaMapContainer = null;
		}
		
	}
}