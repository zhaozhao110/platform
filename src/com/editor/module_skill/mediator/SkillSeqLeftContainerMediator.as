package com.editor.module_skill.mediator
{
	import com.editor.component.containers.UIViewStack;
	import com.editor.mediator.AppMediator;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.mediator.left.SkillSeqActionCellMediator;
	import com.editor.module_skill.mediator.left.SkillSeqEffectCellMediator;
	import com.editor.module_skill.mediator.left.SkillSeqMoveCellMediator;
	import com.editor.module_skill.mediator.left.SkillSeqResCellMediator;
	import com.editor.module_skill.mediator.left.SkillSeqShakeCellMediator;
	import com.editor.module_skill.view.left.SkillSeqLeftContainer;
	import com.editor.module_skill.view.left.cell.SkillSeqActionCell;
	import com.editor.module_skill.view.left.cell.SkillSeqEffectCell;
	import com.editor.module_skill.view.left.cell.SkillSeqMoveCell;
	import com.editor.module_skill.view.left.cell.SkillSeqResCell;
	import com.editor.module_skill.view.left.cell.SkillSeqShakeCell;
	import com.sandy.manager.data.SandyData;
	
	public class SkillSeqLeftContainerMediator extends AppMediator
	{
		public static const NAME:String = "SkillSeqLeftContainerMediator";
		public function SkillSeqLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get leftContainer():SkillSeqLeftContainer
		{
			return viewComponent as SkillSeqLeftContainer;
		}
		public function get vs():UIViewStack
		{
			return leftContainer.vs;
		}
		public function get moveCell():SkillSeqMoveCell
		{
			return leftContainer.moveCell;
		}
		public function get actionCell():SkillSeqActionCell
		{
			return leftContainer.actionCell;
		}
		public function get effectCell():SkillSeqEffectCell
		{
			return leftContainer.effectCell;
		}
		//抖动
		public function get shakeCell():SkillSeqShakeCell
		{
			return leftContainer.shakeCell;
		}
		//场景效果
		public function get resCell():SkillSeqResCell
		{
			return leftContainer.resCell;
		}
		
		public var moveMediator:SkillSeqMoveCellMediator;
		public var actionMediator:SkillSeqActionCellMediator;
		public var effectMediator:SkillSeqEffectCellMediator;
		public var shakeCellMediator:SkillSeqShakeCellMediator
		public var resCellMediator:SkillSeqResCellMediator
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(actionMediator = new SkillSeqActionCellMediator(actionCell));
			registerMediator(moveMediator = new SkillSeqMoveCellMediator(moveCell));
			registerMediator(effectMediator = new SkillSeqEffectCellMediator(effectCell));
			registerMediator(shakeCellMediator = new SkillSeqShakeCellMediator(shakeCell))
			registerMediator(resCellMediator = new SkillSeqResCellMediator(resCell));
			
			vs.selectedIndex = -1;
			vs.visible = false;
		}
		
		public function edit(d:SandyData):void
		{
			if(int(d.data) == EditSkillManager.editType1){
				if(vs.selectedIndex == 0){
					actionMediator.show();	
				}else{
					vs.selectedIndex = 0;
					vs.visible = true;
				}
			}else if(int(d.data) == EditSkillManager.editType2){
				if(vs.selectedIndex == 1){
					moveMediator.show();	
				}else{
					vs.selectedIndex = 1;
					vs.visible = true;
				}
			}else if(int(d.data) == EditSkillManager.editType3){
				if(vs.selectedIndex == 2){
					effectMediator.show();
				}else{
					vs.selectedIndex = 2;
					vs.visible = true;
				}
			}else if(int(d.data) == EditSkillManager.editType4){
				if(vs.selectedIndex == 3){
					resCellMediator.show();
				}else{
					vs.selectedIndex = 3;
					vs.visible = true;
				}
			}else if(int(d.data) == EditSkillManager.editType5){
				if(vs.selectedIndex == 4){
					shakeCellMediator.show();
				}else{
					vs.selectedIndex = 4;
					vs.visible = true;
				}
			}
			
		}
		
		
		
	}
}