package com.editor.module_skill.mediator
{
	import com.editor.component.controls.UILoader;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.LogManager;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.vo.ActionMixActionXMLListVO;
	import com.editor.module_actionMix.vo.mix.ActionMixListVO;
	import com.editor.module_roleEdit.vo.dict.RoleEditDictListVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionListVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoListVO;
	import com.editor.module_skill.SkillSeqModule;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.pop.preview.PreviewContainer;
	import com.editor.module_skill.pop.preview.PreviewContainerMediator;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.view.SkillSeqToolBar;
	import com.editor.module_skill.view.left.SkillSeqLeftContainer;
	import com.editor.module_skill.view.right.SkillSeqRightContainer;
	import com.editor.module_skill.vo.EditSkillConfigVO;
	import com.editor.module_skill.vo.motion.MotionLvlListVO;
	import com.editor.module_skill.vo.project.EditSkillProjectItemVO;
	import com.editor.module_skill.vo.skill.EditSkillListVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqListVO;
	import com.editor.modules.common.layout2.AppLayout2Container;
	import com.editor.project_pop.selectProject.SelectProjectPopwinVO;
	import com.editor.services.Services;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;

	public class SkillSeqModuleMediator extends UIModule2Mediator
	{
		public static const NAME:String = "SkillSeqModuleMediator";
		public function SkillSeqModuleMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get skillModule():SkillSeqModule
		{
			return viewComponent as SkillSeqModule 
		}
		public function get toolBar():SkillSeqToolBar
		{
			return skillModule.toolBar;
		}
		public function get leftContainer():SkillSeqLeftContainer
		{
			return skillModule.leftContainer;
		}
		public function get rightContainer():SkillSeqRightContainer
		{
			return skillModule.rightContainer;
		}
		public function get previewContainer():PreviewContainer
		{
			return skillModule.previewContainer;
		}
		
		override protected function getStackType():int
		{
			return DataManager.stack_skill
		}
		
		private var motion_ld:UILoader = new UILoader();
		private var skillSequence_ld:UILoader = new UILoader();
		
		override public function onRegister():void
		{
			super.onRegister();
						
			registerProxy(new EditSkillProxy());
			
			registerMediator(new SkillSeqToolBarMediator(toolBar));
			registerMediator(new SkillSeqLeftContainerMediator(leftContainer));
			registerMediator(new SkillSeqRightContainerMediator(rightContainer));
			registerMediator(new PreviewContainerMediator(previewContainer))
			
			openSelectProject();
			
			XMLCacheManager.add(Services.actionMix_xml_url,SkillSeqModule.MODULENAME);
			XMLCacheManager.add(Services.motion_xml_url,SkillSeqModule.MODULENAME);
			XMLCacheManager.add(Services.skillSequence_xml_url,SkillSeqModule.MODULENAME);
		}
		
		private function openSelectProject():void
		{
			var obj:SelectProjectPopwinVO = new SelectProjectPopwinVO;
			obj.data = EditSkillConfigVO.instance.project_ls.list
			obj.labelField = "name";
			obj.callFun = selectProjectCallBackFun
			sendAppNotification(AppEvent.selectProject_event,obj);
		}
		
		private function selectProjectCallBackFun(item:EditSkillProjectItemVO):void
		{
			EditSkillManager.currProject = item;
			get_SkillSeqToolBarMediator().infoTxt1.text = "选中项目： " + EditSkillManager.currProject.name;
			loadXML();
		}
		
		override public function show():void
		{
			loadXML();
		}
		
		/**
		 * 
		 * 加载
		 */
		public function loadXML():void
		{
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var item:EditSkillProjectItemVO = EditSkillManager.currProject;
			if(item == null) return ;
			
			var skill_xml_url:String = item.xml_ls.getItemByKey(Services.skill_xml_url).info;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var action_xml_url:String = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			var motionLvl_xml_url:String = item.xml_ls.getItemByKey(Services.motionLvl_xml_url).info;
			var actionMix_xml_url:String = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			
			if(get_EditSkillProxy().skill_ls == null){
				addLog2("load xml: " + skill_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(skill_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_EditSkillProxy().resInfo_ls == null){
				addLog2("load xml: " + resource_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(resource_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_EditSkillProxy().dictList == null){
				addLog2("load xml: " + dict_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(dict_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_EditSkillProxy().action_ls == null){
				addLog2("load xml: " + action_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(action_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_EditSkillProxy().motionLvl_ls == null){
				addLog2("load xml: " + motionLvl_xml_url);
				mutltLoadData.addXMLData(iResource.getLoadSourceData(motionLvl_xml_url,false,false,false,LoadQueueConst.sourceCache_mode1));
			}
			if(get_EditSkillProxy().mix_ls == null || XMLCacheManager.getXML(Services.actionMix_xml_url).checkChange(SkillSeqModule.MODULENAME)){
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
			var item:EditSkillProjectItemVO = EditSkillManager.currProject
				
			var skill_xml_url:String = item.xml_ls.getItemByKey(Services.skill_xml_url).info;
			var resource_xml_url:String = item.xml_ls.getItemByKey(Services.resource_xml_url).info;
			var dict_xml_url:String = item.xml_ls.getItemByKey(Services.dict_xml_url).info;
			var action_xml_url:String = item.xml_ls.getItemByKey(Services.action_xml_url).info;
			var motionLvl_xml_url:String = item.xml_ls.getItemByKey(Services.motionLvl_xml_url).info;
			var actionMix_xml_url:String = item.xml_ls.getItemByKey(Services.actionMix_xml_url).info;
			
			if(get_EditSkillProxy().dictList == null){
				get_EditSkillProxy().dictList = new RoleEditDictListVO(XML(iCacheManager.getCompleteLoadSource(dict_xml_url)));
			}
			if(get_EditSkillProxy().resInfo_ls == null){
				get_EditSkillProxy().resInfo_ls = new AppResInfoListVO(XML(iCacheManager.getCompleteLoadSource(resource_xml_url)));
			}
			if(get_EditSkillProxy().action_ls == null){
				get_EditSkillProxy().action_ls = new ActionMixActionXMLListVO(XML(iCacheManager.getCompleteLoadSource(action_xml_url)));
			}
			if(get_EditSkillProxy().skill_ls == null){
				get_EditSkillProxy().skill_ls = new EditSkillListVO(XML(iCacheManager.getCompleteLoadSource(skill_xml_url)));
			}
			if(get_EditSkillProxy().motionLvl_ls == null){
				get_EditSkillProxy().motionLvl_ls = new MotionLvlListVO(XML(iCacheManager.getCompleteLoadSource(motionLvl_xml_url)));
			}
			if(get_EditSkillProxy().mix_ls == null || XMLCacheManager.getXML(Services.actionMix_xml_url).checkChange(SkillSeqModule.MODULENAME)){
				get_EditSkillProxy().mix_ls = new ActionMixListVO(XML(iCacheManager.getCompleteLoadSource(actionMix_xml_url)),getNameById);
				XMLCacheManager.getXML(Services.actionMix_xml_url).noChange(SkillSeqModule.MODULENAME)
			}
						
			if(get_EditSkillProxy().motion_ls == null || XMLCacheManager.getXML(Services.motion_xml_url).checkChange(SkillSeqModule.MODULENAME)){
				addLog2("load xml: " + item.xml_ls.getItemByKey(Services.motion_xml_url).info);
				motion_ld.ioError_fun = loadXMLComplete2;
				motion_ld.complete_fun = loadXMLComplete2;
				motion_ld.load(item.xml_ls.getItemByKey(Services.motion_xml_url).info)
			}
			
			if(get_EditSkillProxy().skillSeq_ls == null || XMLCacheManager.getXML(Services.skillSequence_xml_url).checkChange(SkillSeqModule.MODULENAME)){
				skillSequence_ld.ioError_fun = loadXMLComplete2;
				skillSequence_ld.complete_fun = loadXMLComplete3;
				skillSequence_ld.load(item.xml_ls.getItemByKey(Services.skillSequence_xml_url).info)
			}
		}
		
		private function getNameById(id:int):String
		{
			return get_EditSkillProxy().action_ls.getItemById(id).name;
		}
		
		private function loadXMLComplete2(e:*=null):void
		{
			var x:XML = XML(motion_ld.content);
			get_EditSkillProxy().motion_ls = new AppMotionListVO(x);
			XMLCacheManager.getXML(Services.motion_xml_url).noChange(SkillSeqModule.MODULENAME)
		}
		
		private function loadXMLComplete3(e:*=null):void
		{
			var x:XML = XML(skillSequence_ld.content);
			get_EditSkillProxy().skillSeq_ls = new SkillSeqListVO(x);
			XMLCacheManager.getXML(Services.skillSequence_xml_url).noChange(SkillSeqModule.MODULENAME)
		}
		
		private function get_SkillSeqToolBarMediator():SkillSeqToolBarMediator
		{
			return retrieveMediator(SkillSeqToolBarMediator.NAME) as SkillSeqToolBarMediator;
		}
		
		private function get_SkillSeqRightContainerMediator():SkillSeqRightContainerMediator
		{
			return retrieveMediator(SkillSeqRightContainerMediator.NAME) as SkillSeqRightContainerMediator;
		}
		
		private function get_EditSkillProxy():EditSkillProxy
		{
			return retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
		
		
	}
}