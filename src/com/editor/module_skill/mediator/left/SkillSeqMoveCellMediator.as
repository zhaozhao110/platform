package com.editor.module_skill.mediator.left
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.timeline.vo.TimelineMoveData;
	import com.editor.module_skill.view.left.cell.SkillSeqMoveCell;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.expand.SandyHSliderWithLabelWithTextInput;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.math.SandyPoint;
	
	import flash.events.MouseEvent;
	
	public class SkillSeqMoveCellMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqMoveCellMediator"
		public function SkillSeqMoveCellMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get moveCell():SkillSeqMoveCell
		{
			return viewComponent as SkillSeqMoveCell;
		}
		public function get xTi():SandyTextInputWidthLabel
		{
			return moveCell.xTi;
		}
		public function get yTi():SandyTextInputWidthLabel
		{
			return moveCell.yTi;
		}
		public function get okBtn():UIButton
		{
			return moveCell.okBtn;
		}
		public function get delBtn():UIButton
		{
			return moveCell.delBtn;
		}
		public function get scaleXSlider():SandyHSliderWithLabelWithTextInput
		{
			return moveCell.scaleXSlider;
		}
		public function get scaleYSlider():SandyHSliderWithLabelWithTextInput
		{
			return moveCell.scaleYSlider;
		}
		public function get rotationSlider():SandyHSliderWithLabelWithTextInput
		{
			return moveCell.rotationSlider;
		}
		public function get visibleCB():UICheckBox
		{
			return moveCell.visibleCB;
		}
		public function get alphaSlider():SandyHSliderWithLabelWithTextInput
		{
			return moveCell.alphaSlider;
		}
		 
		override public function onRegister():void
		{
			super.onRegister();
			
			/*xTi.enterKeyDown_proxy = xTiEnterKeyDown;
			yTi.enterKeyDown_proxy = yTiEnterKeyDown;*/
			visibleCB.addEventListener(ASEvent.CHANGE,onVisibleCBChange);
		}
		
		private function onVisibleCBChange(e:ASEvent):void
		{
			
		}
		
		override public function show():void
		{
			var rect:TimelineMoveData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineMoveData;
			if(rect!=null){	
				xTi.text = rect.x.toString();
				yTi.text = rect.y.toString();
				scaleXSlider.value 	= rect.scaleX;
				scaleYSlider.value 	= rect.scaleY;
				alphaSlider.value 	= rect.alpha;
				rotationSlider.value = rect.rotation;
				visibleCB.selected 	= rect.visible;
				preview();
			}else{
				var lastFrame:int = EditSkillManager.timeDataList.getLastFrame(EditSkillManager.selectRect.getFrame(),EditSkillManager.selectRect.getRow());
				rect = EditSkillManager.timeDataList.getDataBase(EditSkillManager.selectRect.getRow(),lastFrame) as TimelineMoveData;
				if(rect!=null){
					xTi.text = rect.x.toString();
					yTi.text = rect.y.toString();
				}else{
					xTi.text = "";
					yTi.text = ""
				}
				if(EditSkillManager.selectRect.getRow() == EditSkillManager.row2){
					scaleXSlider.value = 1;
				}else{
					scaleXSlider.value = -1;
				}
				scaleYSlider.value = 1;
				alphaSlider.value = 1;
				rotationSlider.value = 0;
				visibleCB.selected = true;
				reset()
			}
		}
		
		private function reset():void
		{
			TimelineMoveData.reset();
		}
		
		private function preview():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var d:TimelineMoveData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineMoveData
			if(d!=null){
				//计算该选中帧前的所有帧的位移
				d.preview();
			}
		}
		
		public function reactToOkBtnClick(e:MouseEvent):void
		{
			save()
		}
		
		/*private function xTiEnterKeyDown():void
		{
			save();
		}
		
		private function yTiEnterKeyDown():void
		{
			save();
		}*/
		
		private function save():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var player:RoleBase;
			if(EditSkillManager.checkIsAttack(row)){
				player = BattleContainer.instace.battleItemContainer.attackPlayer;
			}else{
				player = BattleContainer.instace.battleItemContainer.defendPlayer;
			}
			
			var dat:TimelineMoveData = new TimelineMoveData();
			dat.row = row;
			dat.frame = frame;
			dat.x = int(xTi.text);
			dat.y = int(yTi.text);
			dat.alpha = alphaSlider.value;
			dat.visible = visibleCB.selected;
			dat.isKey = true;
			dat.scaleX = scaleXSlider.value;
			dat.scaleY = scaleYSlider.value;
			dat.rotation = rotationSlider.value;
			EditSkillManager.timeDataList.put(dat);
			dat.preview();	
		}
		
		public function reactToDelBtnClick(e:MouseEvent):void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			var d:TimelineMoveData = EditSkillManager.timeDataList.getSelectedDataBase() as TimelineMoveData
			if(d!=null){
				//只能删除关键帧
				if(!d.isKey){
					showError("只能删除关键帧");
					return ;
				}
			}
			
			var key_a:Array = EditSkillManager.timeDataList.getRow(row,true);
			
			//计算出该帧的前一帧和后一帧的之间的每一帧的位移
			var leftData:TimelineMoveData;
			var rightData:TimelineMoveData;
			for(var i:int=0;i<key_a.length;i++){
				d = key_a[i] as TimelineMoveData;
				if(d.frame < frame){
					leftData = d;
				}else if(d.frame > frame){
					if(rightData == null){
						rightData = d;
					}
				}
			}
			if(leftData == null){
				showError("第一个关键帧，不能删除");
				return ;
			}
			
			EditSkillManager.timeDataList.remove(EditSkillManager.timeDataList.getDataBase(row,frame))
				
			show();
			reset()
		}
		
	}
}