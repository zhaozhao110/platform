package com.editor.module_skill.view.left.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;

	public class SkillSeqEffectCell extends UIVBox
	{
		public function SkillSeqEffectCell()
		{
			super();
			create_init();
		}
		
		public var selectBtn:UIButton;
		public var resBox:UIVBox;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			padding = 5;
			verticalGap = 5;
			
			selectBtn = new UIButton();
			selectBtn.label = "加载资源"
			addChild(selectBtn);
			
			resBox = new UIVBox();
			resBox.styleName = "uicanvas"
			resBox.percentWidth = 100;
			resBox.height = 400;
			resBox.itemRenderer = SkillSeqEffectItemRenderer;
			addChild(resBox);
		}
		
	}
}