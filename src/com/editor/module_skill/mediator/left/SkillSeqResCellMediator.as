package com.editor.module_skill.mediator.left
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.EffectItem;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.timeline.vo.TimelineResData;
	import com.editor.module_skill.view.left.cell.SkillSeqResCell;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class SkillSeqResCellMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqResCellMediator"
		public function SkillSeqResCellMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resCell():SkillSeqResCell
		{
			return viewComponent as SkillSeqResCell;
		}
		public function get selectBtn():UIButton
		{
			return resCell.selectBtn;
		}
		public function get resBox():UIVBox
		{
			return resCell.resBox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		override public function show():void
		{
			var rect:TimelineResData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineResData;
			if(rect!=null){	
				resBox.dataProvider = rect.list;
				rect.preview();
			}else{
				resBox.dataProvider = null;
			}
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			if(EditSkillManager.currSkill == null){
				showError("先选择技能");
				return ;
			}
			
			var out:Array = [];
			var a:Array = get_EditSkillProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = selectedMotion;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		
		private function selectedMotion(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			item = item.clone();
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var effect:EffectItem = BattleContainer.instace.battleItemContainer.addEffect(item,false)
			if(effect == null) return ;
			item.edit_mapItemIndex = effect.getMapIndex();
			
			var rect:TimelineResData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineResData;
			if(rect == null){
				var dat:TimelineResData = new TimelineResData();
				dat.addItem(item);
				dat.row = row;
				dat.frame = frame;
				EditSkillManager.timeDataList.put(dat);
				rect = dat;
			}else{
				rect.addItem(item);
			}
			
			resBox.dataProvider = rect.list;
		}
		
		public function delEffect(item:AppResInfoItemVO):void
		{
			var mess:OpenMessageData = new OpenMessageData();
			mess.info = "您确定要删除该特效?"
			mess.okFunArgs = item;
			mess.okFunction = confirm_delEffect;
			showConfirm(mess);
		}
		
		private function confirm_delEffect(item:AppResInfoItemVO):Boolean
		{
			var effect:EffectItem = BattleContainer.instace.battleItemContainer.getRoleByMapItemIndex(item.edit_mapItemIndex) as EffectItem;
			if(effect!=null){
				effect.dispose();
			}
			var rect:TimelineResData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineResData;
			if(rect != null){
				rect.removeItem(item);
				resBox.dataProvider = rect.list;
			}
			return true;
		}
		
		private function get_EditSkillProxy():EditSkillProxy
		{
			return retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
	}
}