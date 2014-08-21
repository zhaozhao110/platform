package com.editor.moudule_drama.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILoader;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_map.vo.map.AppMapDefineListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.SkillSeqModule;
	import com.editor.module_skill.vo.skill.EditSkillListVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqListVO;
	import com.editor.moudule_drama.DramaModule;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.mediator.right.DramaRightContainerMediator;
	import com.editor.moudule_drama.mediator.top.DramaToolBarMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.view.left.DramaLeftContainer;
	import com.editor.moudule_drama.view.right.DramaRightContainer;
	import com.editor.moudule_drama.view.top.DramaToolBar;
	import com.editor.moudule_drama.vo.DramaConfigVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListVO;
	import com.editor.moudule_drama.vo.project.DramaProjectItemVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	public class DramaModuleMediator extends UIModule2Mediator
	{
		public static const NAME:String = "DramaModuleMediator"
		public function DramaModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		override protected function getStackType():int
		{
			return DataManager.stack_drama;
		}
		public function get mainUI():DramaModule
		{
			return viewComponent as DramaModule;
		}
		public function get topToolBar():DramaToolBar
		{
			return mainUI.topToolBar;
		}
		public function get leftContainer():DramaLeftContainer
		{
			return mainUI.leftContainer;
		}
		public function get rightContainer():DramaRightContainer
		{
			return mainUI.rightContainer;
		}		
		
		private var motion_ld:UILoader = new UILoader();
		private var skillSequence_ld:UILoader = new UILoader();
		
		override public function onRegister():void
		{
			super.onRegister();
						
			registerProxy(new DramaProxy());
			registerMediator(new DramaToolBarMediator(topToolBar));
			registerMediator(new DramaLeftContainerMediator(leftContainer));
			registerMediator(new DramaRightContainerMediator(rightContainer));
			
			openSelectProject();
		}
		
		public function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = DramaConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:DramaProjectItemVO):void
		{
			if(!item)
			{
				showMessage("未选择项目！");
				return;
			}
			
			DramaConfig.currProject = item;
			if(item.data == DataManager.project_God)
			{
				DramaConfig.sceneBackgroundSourceType = DramaConst.backSource_inXMLByDefinition;
				
			}else if(item.data == DataManager.project_king2)
			{
				DramaConfig.sceneBackgroundSourceType = DramaConst.backSource_pictrue;
			}
			
			
			
			
			(retrieveMediator(DramaToolBarMediator.NAME) as DramaToolBarMediator).infoTxt.htmlText = "当前选中项目： <font color='#00CC00'><b>" + DramaConfig.currProject.name + "</b></font>";
			loadXML();
		}
		
		private function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:DramaProjectItemVO = DramaConfig.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var skill_xml_url:String = item.xml_ls.getItemByKey(Services.skill_xml_url).info;
			var action_xml_url:String;
			if(item.xml_ls.getItemByKey(Services.action_xml_url)!=null){
				action_xml_url = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			}
			var actionMix_xml_url:String
			if(item.xml_ls.getItemByKey(Services.actionMix_xml_url)!=null){
				actionMix_xml_url = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			}
			var plot_xml_url:String = item.xml_ls.getItemByKey(Services.plot_xml_url).info;
			
			addLog2("load xml: " + resource_xml_url);
			addLog2("load xml: " + dict_xml_url);
			addLog2("load xml: " + mapDefine_xml_url);
			addLog2("load xml: " + plot_xml_url);
			
			mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(mapDefine_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			mutltLoadData.addXMLData(iResource.getLoadSourceData(plot_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			
			if(get_DramaProxy().skill_ls == null){
				addLog2("load xml: " + skill_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(skill_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}			
			if(get_DramaProxy().action_ls == null && action_xml_url != null){
				addLog2("load xml: " + action_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(action_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_DramaProxy().mix_ls == null && actionMix_xml_url != null){
				addLog2("load xml: " + actionMix_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(actionMix_xml_url,false,false,true,LoadQueueConst.sourceCache_mode1));
			}
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadXMLComplete;
			iResource.loadMultResource(dt);
		}
		
		private function loadXMLComplete(e:*=null):void
		{
			var item:DramaProjectItemVO = DramaConfig.currProject;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var mapDefine_xml_url:String = item.xml_ls.getItemByKey(Services.mapDefine_xml_url).info;
			var skill_xml_url:String = item.xml_ls.getItemByKey(Services.skill_xml_url).info;
			var action_xml_url:String;
			if(item.xml_ls.getItemByKey(Services.action_xml_url)!=null){
				action_xml_url = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			}
			var actionMix_xml_url:String
			if(item.xml_ls.getItemByKey(Services.actionMix_xml_url)!=null){
				actionMix_xml_url = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			}
			var plot_xml_url:String = item.xml_ls.getItemByKey(Services.plot_xml_url).info;
			
			get_DramaProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			get_DramaProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			get_DramaProxy().mapDefine = new AppMapDefineListVO(XML(iCacheManager.getCompleteLoadSource(mapDefine_xml_url)));
			get_DramaProxy().plot_ls = new DramaPlotListVO(XML(iCacheManager.getCompleteLoadSource(plot_xml_url)));
			
			if(get_DramaProxy().skill_ls == null){
				get_DramaProxy().skill_ls = new EditSkillListVO(XML(iCacheManager.getCompleteLoadSource(skill_xml_url)));
			}
			if(get_DramaProxy().action_ls == null && action_xml_url !=null){
				get_DramaProxy().action_ls = new ActionMixActionXMLListVO(XML(iCacheManager.getCompleteLoadSource(action_xml_url)));
			}			
			if(get_DramaProxy().mix_ls == null && actionMix_xml_url!=null){
				get_DramaProxy().mix_ls = new ActionMixListVO(XML(iCacheManager.getCompleteLoadSource(actionMix_xml_url)),getNameById);
			}			
			if(get_DramaProxy().motion_ls == null){
				addLog2("load xml: " + item.xml_ls.getItemByKey(Services.motion_xml_url).info);
				motion_ld.ioError_fun = loadXMLComplete2;
				motion_ld.complete_fun = loadXMLComplete2;
				motion_ld.load(item.xml_ls.getItemByKey(Services.motion_xml_url).info)
			}
			
			if(get_DramaProxy().skillSeq_ls == null && item.xml_ls.getItemByKey(Services.skillSequence_xml_url) != null){
				skillSequence_ld.ioError_fun = loadXMLComplete2;
				skillSequence_ld.complete_fun = loadXMLComplete3;
				skillSequence_ld.load(item.xml_ls.getItemByKey(Services.skillSequence_xml_url).info);
			}
		}
		private function getNameById(id:int):String
		{
			return get_DramaProxy().action_ls.getItemById(id).name;
		}
		
		private function loadXMLComplete2(e:*=null):void
		{
			var x:XML = XML(motion_ld.content);
			get_DramaProxy().motion_ls = new AppMotionListVO(x);
		}
		
		private function loadXMLComplete3(e:*=null):void
		{
			var x:XML = XML(skillSequence_ld.content);
			get_DramaProxy().skillSeq_ls = new SkillSeqListVO(x);
		}
		
		private function get_DramaProxy():DramaProxy
		{
			return retrieveProxy(DramaProxy.NAME) as DramaProxy;
		}
		
	}
}