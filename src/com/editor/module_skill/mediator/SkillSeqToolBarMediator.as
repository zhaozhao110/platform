package com.editor.module_skill.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.XMLCacheManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.event.ModuleSkillEvent;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.mediator.left.SkillSeqActionCellMediator;
	import com.editor.module_skill.pop.preview.PreviewContainerMediator;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.view.SkillSeqToolBar;
	import com.editor.module_skill.view.right.SkillSeqRightContainer;
	import com.editor.module_skill.vo.EditSkillConfigVO;
	import com.editor.module_skill.vo.skill.EditSkillItemVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqGroupVO;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.editor.services.Services;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;

	public class SkillSeqToolBarMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqToolBarMediator" 
		public function SkillSeqToolBarMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get toolBar():SkillSeqToolBar
		{
			return viewComponent as SkillSeqToolBar;
		}
		public function get loadBtn():UIButton
		{
			return toolBar.loadBtn;
		}
		public function get infoTxt():UILabel
		{
			return toolBar.infoTxt;
		}
		public function get showTimelineBtn():UIButton
		{
			return toolBar.showTimelineBtn;
		}
		public function get timelineTxt():UILabel
		{
			return toolBar.timelineTxt;
		}
		public function get infoTxt1():UILabel
		{
			return toolBar.infoTxt1;
		}
		public function get showLogBtn():UIButton
		{
			return toolBar.showLogBtn;
		}
		public function get preBtn():UIButton
		{
			return toolBar.preBtn;
		}
		public function get saveBtn():UIButton
		{
			return toolBar.saveBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToPreBtnClick(e:MouseEvent):void
		{
			if(BattleContainer.instace.battleItemContainer.attackPlayer == null){
				showError("没有攻击方")
				return ;
			}
			/*if(BattleContainer.instace.battleItemContainer.attackPlayer.arm == null){
				showError("没有攻击方武器");
				return ;
			}*/
			if(BattleContainer.instace.battleItemContainer.defendPlayer == null) {
				showError("没有防御方");
				return ;
			}
			/*if(BattleContainer.instace.battleItemContainer.defendPlayer.arm == null) {
				showError("没有防御方武器");
				return ;
			}*/
			get_PreviewContainerMediator().start();
		}
		
		private function get_PreviewContainerMediator():PreviewContainerMediator
		{
			return retrieveMediator(PreviewContainerMediator.NAME) as PreviewContainerMediator;
		}
		
		public function reactToShowLogBtnClick(e:MouseEvent):void
		{
			get_SkillSeqModuleMediator().logContainer.visible = !get_SkillSeqModuleMediator().logContainer.visible;
			if(get_SkillSeqModuleMediator().logContainer.visible){
				showLogBtn.label = "隐藏log";
			}else{
				showLogBtn.label = "显示log";
			}
		}
				
		public function reactToShowTimelineBtnClick(e:MouseEvent):void
		{
			TimelineContainer.instance.visible = !TimelineContainer.instance.visible;
			if(TimelineContainer.instance.visible){
				showTimelineBtn.label = "隐藏时间轴"
			}else{
				showTimelineBtn.label = "显示时间轴"
			}
		}
		
		public function reactToLoadBtnClick(e:MouseEvent):void
		{
			if(get_EditSkillProxy().motion_ls == null){
				showError("请等待加载完成");
				return ;
			}
			
			if(TimelineContainer.instance.getTimeRect(EditSkillManager.row8,EditSkillManager.total_frames)==null){
				showError("请等待时间轴渲染完成");
				return ;
			}
			
			if(EditSkillManager.currSkill == null){
				confirm();
			}else{
				var mess:OpenMessageData = new OpenMessageData();
				mess.info = "在编辑新的技能前请确定保存,您确定要选择新的技能编辑?"
				//mess.okFunArgs = item;
				mess.okFunction = confirm;
				showConfirm(mess);
			}
		}
		
		private function confirm():Boolean
		{
			var out:Array = [];
			var a:Array = get_EditSkillProxy().skill_ls.list;
			for(var i:int=0;i<a.length;i++){
				var item:EditSkillItemVO = a[i] as EditSkillItemVO;
				item = item.cloneObject();
				var g:SkillSeqGroupVO = get_EditSkillProxy().skillSeq_ls.getGroupBySkillId(item.id);
				if(g!=null){
					item.attackId = g.attackId;
					item.isEdited = true;
				}
				out.push(item);
				var b:Array = get_EditSkillProxy().skillSeq_ls.getMonsterSkill(item.id);
				if(b!=null){
					for(var j:int=0;j<b.length;j++){
						g = b[j] as SkillSeqGroupVO;
						item = item.cloneObject();
						item.name1 = item.id + "/" + item.name + "/(" + get_EditSkillProxy().resInfo_ls.getResInfoItemByID(g.attackId).name;
						item.attackId = g.attackId;
						item.isEdited = true
						out.push(item);
					}
				}
			}
			
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = out;
			vo.labelField = "name1";
			vo.label = "选择技能编辑: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSkill;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
			return true;
		}
		
		private function selectedSkill(item:EditSkillItemVO,item1:SelectEditPopWin2VO):void
		{
			resetAll();
			
			EditSkillManager.currSkill = item;
			
			if(item.isEdited){
				EditSkillManager.timeDataList.parser();
			}
			
			infoTxt.text = "选择编辑技能: " + item.id + " / " + item.name + "/总帧数:"+EditSkillManager.timeDataList.currSkillSeqG.endFrame;
		}
		
		public function resetAll():void
		{
			EditSkillManager.currSkill = null;
			EditSkillManager.timeDataList.reset();
			EditSkillManager.selectRect = null;
			EditSkillManager.timelineBottomTxt.text = "";
			TimelineContainer.instance.reset();
			BattleContainer.instace.reset();
			get_SkillSeqLeftContainerMediator().vs.selectedIndex = -1;
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = "输入结束帧"
			d.okButtonFun = after_on_new;
			if(EditSkillManager.timeDataList.currSkillSeqG != null){
				d.text = EditSkillManager.timeDataList.currSkillSeqG.endFrame.toString();
			}
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function after_on_new(nm:String):void
		{
			var x:XML = EditSkillManager.timeDataList.save(nm);
			if(x == null) return ;
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.action = x;
			httpObj.sid = EditSkillManager.currSkill.getSaveId();
			httpObj.srt = "2";
			httpObj.project = EditSkillManager.currProject.data;
			httpObj.savePath = EditSkillManager.currProject.saveFold
			httpObj.fileName = EditSkillManager.currProject.saveFileName;
			
			var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
			http.args = httpObj;
			http.sucResult_f = confirmSuc;
			http.conn(EditSkillConfigVO.instance.serverDomain, SandyEngineConst.HTTP_POST);
		}
		
		private function confirmSuc(dat:*=null):void
		{
			showError("保存成功,请等待几秒，将重新加载缓存");
			
			XMLCacheManager.getXML(Services.skillSequence_xml_url).change();
			get_SkillSeqModuleMediator().loadXML();
		}
		
		private function get_EditSkillProxy():EditSkillProxy
		{
			return retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
		
		private function get_SkillSeqModuleMediator():SkillSeqModuleMediator
		{
			return retrieveMediator(SkillSeqModuleMediator.NAME) as SkillSeqModuleMediator
		}
		
		private function get_SkillSeqActionCellMediator():SkillSeqActionCellMediator
		{
			return retrieveMediator(SkillSeqActionCellMediator.NAME) as SkillSeqActionCellMediator;
		}
		
		private function get_SkillSeqLeftContainerMediator():SkillSeqLeftContainerMediator
		{
			return retrieveMediator(SkillSeqLeftContainerMediator.NAME) as SkillSeqLeftContainerMediator;
		}
	}
}