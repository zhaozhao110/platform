package com.editor.module_skill.view.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UICheckBox;
	import com.editor.module_skill.view.left.cell.SkillSeqActionCell;
	import com.editor.module_skill.view.left.cell.SkillSeqEffectCell;
	import com.editor.module_skill.view.left.cell.SkillSeqMoveCell;
	import com.editor.module_skill.view.left.cell.SkillSeqResCell;
	import com.editor.module_skill.view.left.cell.SkillSeqShakeCell;
	
	public class SkillSeqLeftContainer extends UICanvas
	{
		public function SkillSeqLeftContainer()
		{
			super();
			create_init();
		}
		
		public var vs:UIViewStack;
		//位置
		public var moveCell:SkillSeqMoveCell;
		//动作
		public var actionCell:SkillSeqActionCell;
		//动作特效
		public var effectCell:SkillSeqEffectCell;
		//抖动
		public var shakeCell:SkillSeqShakeCell;
		//场景效果
		public var resCell:SkillSeqResCell;
		
		private function create_init():void
		{
			styleName = "uicanvas";
			width = 200;
			percentHeight = 100;
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
			actionCell = new SkillSeqActionCell();
			vs.addChild(actionCell);
			
			moveCell = new SkillSeqMoveCell();
			vs.addChild(moveCell);
						
			effectCell = new SkillSeqEffectCell();
			vs.addChild(effectCell);
						
			resCell = new SkillSeqResCell();
			vs.addChild(resCell);
			
			shakeCell = new SkillSeqShakeCell();
			vs.addChild(shakeCell);
		}
	}
}