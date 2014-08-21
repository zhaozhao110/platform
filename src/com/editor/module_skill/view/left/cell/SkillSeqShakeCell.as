package com.editor.module_skill.view.left.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.sandy.component.expand.SandyTextInputWidthLabel;

	public class SkillSeqShakeCell extends UIVBox
	{
		public function SkillSeqShakeCell()
		{
			super();
			create_init();
		}
		
		public var shakeBtn:UICheckBox;
		public var rangeTI:SandyTextInputWidthLabel
		public var timeTI:SandyTextInputWidthLabel;
		public var okBtn:UIButton;
		public var delBtn:UIButton;
		public var shootBtn:UICheckBox;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			padding = 5;
			verticalGap = 5;
			
			shakeBtn =  new UICheckBox();
			shakeBtn.label = "是否抖动";
			addChild(shakeBtn);
			
			rangeTI = new SandyTextInputWidthLabel();
			rangeTI.label = "抖动幅度: "
			rangeTI.percentWidth = 100;
			rangeTI.restrict = "0-9";
			rangeTI.text = "20"
			addChild(rangeTI);
			
			timeTI = new SandyTextInputWidthLabel();
			timeTI.label = "时间(毫秒): "
			timeTI.percentWidth = 100;
			timeTI.restrict = "0-9";
			timeTI.text = "100"
			addChild(timeTI);
			
			shootBtn =  new UICheckBox();
			shootBtn.label = "是否是打击点";
			addChild(shootBtn);
			
			okBtn = new UIButton();
			okBtn.label = "提交"
			addChild(okBtn);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			addChild(delBtn);
		}
	}
}