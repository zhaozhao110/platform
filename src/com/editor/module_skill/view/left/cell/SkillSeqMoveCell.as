package com.editor.module_skill.view.left.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.sandy.component.expand.SandyHSliderWithLabelWithTextInput;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.utils.ColorUtils;

	public class SkillSeqMoveCell extends UIVBox
	{
		public function SkillSeqMoveCell()
		{
			super();
			create_init();
		}
		
		public var lb:UILabel;
		public var xTi:SandyTextInputWidthLabel;
		public var yTi:SandyTextInputWidthLabel;
		public var okBtn:UIButton;
		public var delBtn:UIButton;
		public var scaleXSlider:SandyHSliderWithLabelWithTextInput;
		public var scaleYSlider:SandyHSliderWithLabelWithTextInput;
		public var rotationSlider:SandyHSliderWithLabelWithTextInput;
		public var visibleCB:UICheckBox;
		public var scaleXCB:UICheckBox;
		public var scaleYCB:UICheckBox;
		public var alphaSlider:SandyHSliderWithLabelWithTextInput;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			padding = 5;
			verticalGap = 15;
			
			lb = new UILabel();
			lb.text = " -- 位移 -- "
			addChild(lb);
			
			var lb2:UILabel = new UILabel();
			lb2.color = ColorUtils.red;
			addChild(lb2);
			lb2.text = "是相对玩家的坐标，不是绝对坐标"
			
			xTi = new SandyTextInputWidthLabel();
			xTi.label = "x轴: "
			xTi.percentWidth = 100;
			xTi.restrict = "0-9.\\-";
			addChild(xTi);
			
			yTi = new SandyTextInputWidthLabel();
			yTi.label = "y轴: "
			yTi.percentWidth = 100;
			addChild(yTi);
			yTi.restrict = "0-9.\\-";
			
			scaleXSlider = new SandyHSliderWithLabelWithTextInput();
			scaleXSlider.label = "左右缩放:"
			scaleXSlider.minimum = -1;
			scaleXSlider.maximum = 1;
			addChild(scaleXSlider);
			//scaleXSlider.visible = false;
			scaleXSlider.value = 1;
			
			scaleYSlider = new SandyHSliderWithLabelWithTextInput();
			scaleYSlider.label = "上下缩放:"
			scaleYSlider.minimum = -1;
			scaleYSlider.maximum = 1;
			addChild(scaleYSlider);
			//scaleYSlider.visible = false;
			scaleYSlider.value = 1;
			
			rotationSlider = new SandyHSliderWithLabelWithTextInput();
			rotationSlider.label = "角度旋转:"
			rotationSlider.minimum = 0;
			rotationSlider.maximum = 360;
			addChild(rotationSlider);
			rotationSlider.value = 0;
			
			alphaSlider = new SandyHSliderWithLabelWithTextInput();
			alphaSlider.label = "透明度:"
			alphaSlider.minimum = 0;
			alphaSlider.maximum = 1;
			addChild(alphaSlider);
			alphaSlider.value = 1;
			
			visibleCB = new UICheckBox();
			visibleCB.label = "显示"
			visibleCB.height = 25;
			visibleCB.selected = true;
			addChild(visibleCB);
			
			okBtn = new UIButton();
			okBtn.label = "提交"
			addChild(okBtn);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			addChild(delBtn);
		}
	}
}