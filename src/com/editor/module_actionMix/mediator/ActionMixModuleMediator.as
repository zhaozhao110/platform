package com.editor.module_actionMix.mediator
{
	import com.editor.component.controls.UILoader;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.ActionMixModule;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.editor.module_actionMix.proxy.ActionMixProxy;
	import com.editor.module_actionMix.view.ActionMixContent;
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.ActionMixConfigVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_actionMix.vo.project.ActionMixProjectItemVO;
	import com.editor.module_roleEdit.event.RoleEditEvent;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.vo.motion.MotionLvlListVO;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.manager.data.SandyXMLListVO;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.LoadQueueEvent;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	
	public class ActionMixModuleMediator extends AppMediator
	{
		public static const NAME:String = "ActionMixModuleMediator"
		public function ActionMixModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get actionModule():ActionMixModule
		{
			return viewComponent as ActionMixModule;
		}
		public function get content():ActionMixContent
		{
			return actionModule.content;
		}
		
		private var motion_ld:UILoader = new UILoader();
		
		override public function onRegister():void
		{
			super.onRegister();
			
			ActionMixManager.init();
			
			registerProxy(new ActionMixProxy());
			
			registerMediator(new ActionMixContentMediator(content));
			
			openSelectProject();
			
			XMLCacheManager.add(Services.actionMix_xml_url,ActionMixModule.MODULENAME);
			XMLCacheManager.add(Services.motion_xml_url,ActionMixModule.MODULENAME);
			//XMLCacheManager.add(Services.skillSequence_xml_url,SkillSeqModule.MODULENAME);
		}
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = ActionMixConfigVO.instance.project_ls.list;
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
			
		private function selectProjectCallBackFun(item:ActionMixProjectItemVO):void
		{
			ActionMixManager.currProject = item;
			get_ActionMixToolBarMediator().infoTxt.text = "选中项目： " + ActionMixManager.currProject.name;
			loadXML();
		}
		
		private function get_ActionMixToolBarMediator():ActionMixToolBarMediator
		{
			return retrieveMediator(ActionMixToolBarMediator.NAME) as ActionMixToolBarMediator;
		}
		
		override public function show():void
		{
			loadXML();
		}
		
		public function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:ActionMixProjectItemVO = ActionMixManager.currProject as ActionMixProjectItemVO;
			if(item == null) return ;
			
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var action_xml_url:String = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			var actionMix_xml_url:String = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			var motionLvl_xml_url:String = item.xml_ls.getItemByKey(Services.motionLvl_xml_url).info;
			
			if(get_ActionMixProxy().resInfo_ls == null){
				get_ActionMixContentMediator().addLog2("load xml: " + resource_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_ActionMixProxy().dictList == null){
				get_ActionMixContentMediator().addLog2("load xml: " + dict_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_ActionMixProxy().action_ls == null){
				get_ActionMixContentMediator().addLog2("load xml: " + action_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(action_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_ActionMixProxy().mix_ls == null || XMLCacheManager.getXML(Services.actionMix_xml_url).checkChange(ActionMixModule.MODULENAME)){
				get_ActionMixContentMediator().addLog2("load xml: " + actionMix_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(actionMix_xml_url,false,false,true,LoadQueueConst.sourceCache_mode1));
			}
			if(get_ActionMixProxy().motionLvl_ls == null){
				get_ActionMixContentMediator().addLog2("load xml: " + motionLvl_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(motionLvl_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadAllComplete;
			iResource.loadMultResource(dt);
		}
		
		private function loadAllComplete(e:LoadQueueEvent):void
		{
			var item:ActionMixProjectItemVO = ActionMixManager.currProject as ActionMixProjectItemVO;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var action_xml_url:String = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			var actionMix_xml_url:String = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			var motionLvl_xml_url:String = item.xml_ls.getItemByKey(Services.motionLvl_xml_url).info;
			
			if(get_ActionMixProxy().dictList == null){
				get_ActionMixProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			}
			if(get_ActionMixProxy().resInfo_ls == null){
				get_ActionMixProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			}
			if(get_ActionMixProxy().action_ls == null){
				get_ActionMixProxy().action_ls = new ActionMixActionXMLListVO(XML(iCacheManager.getCompleteLoadSource(action_xml_url)));
			}
			if(get_ActionMixProxy().mix_ls == null || XMLCacheManager.getXML(Services.actionMix_xml_url).checkChange(ActionMixModule.MODULENAME)){
				get_ActionMixProxy().mix_ls = new ActionMixListVO(XML(iCacheManager.getCompleteLoadSource(actionMix_xml_url)),getNameById);
				XMLCacheManager.getXML(Services.actionMix_xml_url).noChange(ActionMixModule.MODULENAME)
			}
			if(get_ActionMixProxy().motionLvl_ls == null){
				get_ActionMixProxy().motionLvl_ls = new MotionLvlListVO(XML(iCacheManager.getCompleteLoadSource(motionLvl_xml_url)));
			}	
			if(get_ActionMixProxy().motion_ls == null || XMLCacheManager.getXML(Services.motion_xml_url).checkChange(ActionMixModule.MODULENAME)){
				get_ActionMixContentMediator().addLog2("load xml: " + item.xml_ls.getItemByKey(Services.motion_xml_url).info);
				motion_ld.ioError_fun = loadXMLComplete;
				motion_ld.complete_fun = loadXMLComplete;
				motion_ld.load(item.xml_ls.getItemByKey(Services.motion_xml_url).info)
			}
		}
		
		private function getNameById(id:int):String
		{
			return get_ActionMixProxy().action_ls.getItemById(id).name;
		}
		
		private function loadXMLComplete(e:*=null):void
		{
			var x:XML = XML(motion_ld.content);
			get_ActionMixProxy().motion_ls = new AppMotionListVO(x);
			XMLCacheManager.getXML(Services.motion_xml_url).noChange(ActionMixModule.MODULENAME)
		}
		
		private function get_ActionMixProxy():ActionMixProxy
		{
			return retrieveProxy(ActionMixProxy.NAME) as ActionMixProxy;
		}
		
		private function get_ActionMixContentMediator():ActionMixContentMediator
		{
			return retrieveMediator(ActionMixContentMediator.NAME) as ActionMixContentMediator;
		}
	}
}