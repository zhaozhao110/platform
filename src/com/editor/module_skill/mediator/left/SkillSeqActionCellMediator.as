package com.editor.module_skill.mediator.left
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.editor.module_actionMix.vo.ActionMixData;
	import com.editor.module_actionMix.vo.mix.ActionMixGroupVO;
	import com.editor.module_actionMix.vo.mix.ActionMixItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.timeline.TimelineRect;
	import com.editor.module_skill.timeline.vo.ITimelineDataBase;
	import com.editor.module_skill.timeline.vo.TimelineActionData;
	import com.editor.module_skill.timeline.vo.TimelineMoveData;
	import com.editor.module_skill.view.left.cell.SkillSeqActionCell;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.asComponent.controls.ASRadioButtonGroup;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.math.SandyPoint;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SkillSeqActionCellMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqActionCellMediator"
		public function SkillSeqActionCellMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get actionCell():SkillSeqActionCell
		{
			return viewComponent as SkillSeqActionCell;
		}
		public function get selectBtn1():UIButton
		{
			return actionCell.selectBtn1;
		}
		public function get selectBtn2():UIButton
		{
			return actionCell.selectBtn2;
		}
		public function get combox1():UICombobox
		{
			return actionCell.combox1;
		}
		public function get combox2():UICombobox
		{
			return actionCell.combox2;
		}
		public function get xTi1():SandyTextInputWidthLabel
		{
			return actionCell.xTi1;
		}
		public function get okBtn():UIButton
		{
			return actionCell.okBtn;
		}
		public function get delBtn():UIButton
		{
			return actionCell.delBtn;
		}
		public function get lb():UILabel
		{
			return actionCell.lb;
		}
		public function get radioButtonGroup():ASRadioButtonGroup
		{
			return actionCell.radioButtonGroup;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			ActionMixManager.init();
			
			combox1.labelField = "type_str";
			combox1.addEventListener(ASEvent.CHANGE , actionTypeChange1)
			combox1.dataProvider = ActionMixManager.god_action_ls;
			combox1.selectedIndex = 0;
			
			combox2.labelField = "name";
			combox2.addEventListener(ASEvent.CHANGE , actionTypeChange2)
			
			xTi1.enterKeyDown_proxy = xTi1EnterKeyDown;
			
			selectBtn1.addEventListener(MouseEvent.CLICK , selectBtn1Click);
			selectBtn2.addEventListener(MouseEvent.CLICK , selectBtn2Click);
						
			okBtn.addEventListener(MouseEvent.CLICK,onSaveHandle);
			delBtn.addEventListener(MouseEvent.CLICK,onDelHandle)
				
			radioButtonGroup.selectedValue = 1;
		}
		
		private function onSaveHandle(e:MouseEvent):void
		{
			var action_active:Boolean;
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var player:RoleBase;
			if(EditSkillManager.checkIsAttack(row)){
				player = BattleContainer.instace.battleItemContainer.attackPlayer;
			}else{
				player = BattleContainer.instace.battleItemContainer.defendPlayer;
			}
			
			if(radioButtonGroup.selectedValue == 1){
				var curr_action:ActionMixData = combox1.selectedItem as ActionMixData;
				if(curr_action == null) return ;
				if(curr_action.type == SandyMapConst.status_attackDaiji_type){
					action_active = false;
				}else{
					action_active = true;
				}
			}else if(radioButtonGroup.selectedValue == 2){
				var curr_action2:ActionMixItemVO = combox2.selectedItem as ActionMixItemVO;
				if(curr_action2 == null) return ;
				action_active = true;
			}
			
			if( !action_active){
				EditSkillManager.timeDataList.remove(EditSkillManager.timeDataList.getDataBase(row,frame))
				TimelineActionData.reset();
				return ;
			}
			
			var dat:TimelineActionData = new TimelineActionData();
			if(radioButtonGroup.selectedValue == 1){
				dat.action = curr_action.type;
			}else{
				curr_action2 = combox2.selectedItem as ActionMixItemVO;
				if(curr_action2 == null) return ;
				dat.action = curr_action2.id.toString();
			}
			dat.totalFrame = BattleContainer.instace.battleItemContainer.attackPlayer.getTotalFrame();
			dat.row = row;
			dat.frame = frame;
			EditSkillManager.timeDataList.put(dat);
			
			dat.preview();
		}
		
		private function onDelHandle(e:MouseEvent):void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			EditSkillManager.timeDataList.remove(EditSkillManager.timeDataList.getDataBase(row,frame))
			show();
		}
		
		public function xTi1EnterKeyDown():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			var player:RoleBase;
			var row2:int;
			if(EditSkillManager.checkIsAttack(row)){
				player = BattleContainer.instace.battleItemContainer.attackPlayer;
				EditSkillManager.attack_loc.x = int(xTi1.text);
				player.pixelLoc = EditSkillManager.attack_loc;
				row2 = EditSkillManager.row2
			}else{
				player = BattleContainer.instace.battleItemContainer.defendPlayer;
				EditSkillManager.defend_loc.x = int(xTi1.text);
				player.pixelLoc = EditSkillManager.defend_loc;
				row2 = EditSkillManager.row5
			}
			
			if(player!=null){
				frame = 1
				var dat:TimelineMoveData = new TimelineMoveData();
				dat.x = int(xTi1.text);
				dat.y = EditSkillManager.battleY;
				dat.row = row2;
				dat.rotation = 0;
				dat.frame = frame;
				dat.isKey = true;
				if(row2 == EditSkillManager.row5){
					dat.scaleX = -1;
				}
				EditSkillManager.timeDataList.put(dat);
			}
		}
		
		override public function show():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			if(EditSkillManager.checkIsAttack(row)){
				lb.text = " -- 攻击方 -- ";
				xTi1.text = EditSkillManager.attack_loc.x.toString();
			}else{
				lb.text = " -- 防御方 -- ";
				xTi1.text = EditSkillManager.defend_loc.x.toString();
			}
			
			var rect:TimelineActionData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineActionData;
			if(rect!=null){
				if(rect.checkIsMixAction()){
					var actionGroupId:int = BattleContainer.instace.battleItemContainer.attackPlayer.getResInfoItem().monsterType;
					var g:ActionMixGroupVO = get_EditSkillProxy().mix_ls.getGroupByActionGroup(actionGroupId);
					if(g!=null){
						radioButtonGroup.selectedValue = 2;
						combox2.selectedIndex = g.getIndexById(int(rect.action));
					}
				}else{
					radioButtonGroup.selectedValue = 1;
					combox1.selectedIndex = ActionMixManager.getIndexByAction(rect.action);
				}
			}else{
				radioButtonGroup.selectedValue = 1;
				combox1.setSelectIndex(0);
			}
			
			rect = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineActionData
			if(rect!=null){
				rect.preview();
			}
			
			if(BattleContainer.instace.battleItemContainer.attackPlayer != null){
				actionGroupId = BattleContainer.instace.battleItemContainer.attackPlayer.getResInfoItem().monsterType;
				g = get_EditSkillProxy().mix_ls.getGroupByActionGroup(actionGroupId);
				if(g!=null){
					combox2.dataProvider = g.all_ls;
				}
			}
		}
		
		/**
		 * 只是在动作类型中
		 */ 
		private function actionTypeChange1(e:ASEvent=null):void
		{
			if(EditSkillManager.selectRect == null) return ;
			var curr_action:ActionMixData = combox1.selectedItem as ActionMixData;
			
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var player:RoleBase;
			if(EditSkillManager.checkIsAttack(row)){
				player = BattleContainer.instace.battleItemContainer.attackPlayer;
			}else{
				player = BattleContainer.instace.battleItemContainer.defendPlayer;
			}
			
			if(player!=null){
				var d:ITimelineDataBase = EditSkillManager.timeDataList.getDataBase(row,frame);
				if(d!=null){
					if(d.getData() == player.actionType) return ;
				}
				player.actionType = curr_action.type;
			}
		}
		
		/**
		 * 只是在动作类型中
		 */ 
		private function actionTypeChange2(e:ASEvent=null):void
		{
			if(EditSkillManager.selectRect == null) return ;
			var curr_action:ActionMixItemVO = combox2.selectedItem as ActionMixItemVO;
			
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var player:RoleBase;
			if(EditSkillManager.checkIsAttack(row)){
				player = BattleContainer.instace.battleItemContainer.attackPlayer;
			}else{
				player = BattleContainer.instace.battleItemContainer.defendPlayer;
			}
			
			if(player!=null){
				var d:ITimelineDataBase = EditSkillManager.timeDataList.getDataBase(row,frame);
				if(d!=null){
					if(d.getData() == player.actionType) return ;
				}
				player.actionType = curr_action.id.toString();
			}
		}
		
		//选择套装
		public function selectBtn1Click(e:MouseEvent):void
		{
			selectMotion(1)
		}
		
		//选择武器
		public function selectBtn2Click(e:MouseEvent):void
		{
			selectMotion(2)
		}
		
		private function selectMotion(selectType:int):void
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
			vo.addData = selectType;
			vo.column2_dataField = "name1";
			vo.select_dataField = "item_ls";
				
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
			var isAttack:Boolean;
			isAttack = EditSkillManager.checkIsAttack(row);
			
			var type:int = int(item1.addData);
			if(type == 1){
				//怪物的职业标记就是5
				if(EditSkillManager.currSkill.checkVoc(item.monsterVoc)){
					//套装
					BattleContainer.instace.battleItemContainer.addPlayer(item,isAttack)
					xTi1EnterKeyDown();
				}else if(EditSkillManager.currSkill.voc == 5){
					BattleContainer.instace.battleItemContainer.addMonster(item,isAttack)
					xTi1EnterKeyDown();
				}else{
					showError("职业不符");
					return ;
				}
			}else if(type == 2){
				//武器
				if(EditSkillManager.currSkill.checkVoc(item.monsterVoc)){
					BattleContainer.instace.battleItemContainer.addArm(item,isAttack)
				}else{
					showError("武器不符");
					return ;
				}
			}
		}
		
		private function get_EditSkillProxy():EditSkillProxy
		{
			return retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
	}
}