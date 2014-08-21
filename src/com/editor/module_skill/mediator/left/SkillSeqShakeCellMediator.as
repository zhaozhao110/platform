package com.editor.module_skill.mediator.left
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.timeline.vo.ITimelineDataBase;
	import com.editor.module_skill.timeline.vo.TimelineShakeData;
	import com.editor.module_skill.view.left.cell.SkillSeqShakeCell;
	import com.sandy.asComponent.effect.ASShakeEffect;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	
	import flash.events.MouseEvent;

	public class SkillSeqShakeCellMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqShakeCellMediator"
		public function SkillSeqShakeCellMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get shakeCell():SkillSeqShakeCell
		{
			return viewComponent as SkillSeqShakeCell;
		}
		public function get shakeBtn():UICheckBox
		{
			return shakeCell.shakeBtn;
		}
		public function get shootBtn():UICheckBox
		{
			return shakeCell.shootBtn;
		}
		public function get rangeTI():SandyTextInputWidthLabel
		{
			return shakeCell.rangeTI;
		}
		public function get timeTI():SandyTextInputWidthLabel
		{
			return shakeCell.timeTI;
		}
		public function get okBtn():UIButton
		{
			return shakeCell.okBtn;
		}
		public function get delBtn():UIButton
		{
			return shakeCell.delBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function reactToOkBtnClick(e:MouseEvent):void
		{
			save();
		}
		
		public function reactToDelBtnClick(e:MouseEvent):void
		{
			shakeBtn.selected = false;
			shootBtn.selected = false;
			save()
		}
		
		override public function show():void
		{
			var rect:TimelineShakeData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineShakeData;
			if(rect!=null){	
				shootBtn.selected = rect.isShoot;
				shakeBtn.selected = rect.shake;
				if(rect.shake){
					rangeTI.text = rect.range.toString();
					timeTI.text = rect.time.toString();
					BattleContainer.instace.shake(rect.range,rect.time);
				}else{
					rangeTI.text = "20"
					timeTI.text = "100"
				}
			}else{
				shakeBtn.selected = false;
				shootBtn.selected = false;
				rangeTI.text = "20"
				timeTI.text = "100"
			}
		}
		
		private function save():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			if(shakeBtn.selected || shootBtn.selected)
			{
				var dat:TimelineShakeData = new TimelineShakeData();
				dat.shake = shakeBtn.selected;
				dat.isShoot = shootBtn.selected;
				dat.row = row;
				dat.range = int(rangeTI.text);
				dat.time = int(timeTI.text);
				dat.frame = frame;
				EditSkillManager.timeDataList.put(dat);
				if(shakeBtn.selected){
					BattleContainer.instace.shake(dat.range,dat.time);
				}
			}
			else
			{
				var d:ITimelineDataBase = EditSkillManager.timeDataList.getDataBase(row,frame);
				if(d!=null){
					EditSkillManager.timeDataList.remove(d);
				}
			}
		}
		
	}
}