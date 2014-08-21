package com.editor.module_skill.view.left.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.asComponent.controls.ASHSlider;
	import com.sandy.asComponent.controls.ASRadioButtonGroup;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.component.expand.SandyHSliderWithLabelWithTextInput;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.sandy.utils.ColorUtils;

	public class SkillSeqActionCell extends UIVBox
	{
		public function SkillSeqActionCell()
		{
			super();
			create_init();
		}
		
		public var lb:UILabel;
		public var selectBtn1:UIButton;
		public var selectBtn2:UIButton;
		public var combox1:UICombobox;
		public var combox2:UICombobox;
		public var xTi1:SandyTextInputWidthLabel;
		
		public var okBtn:UIButton;
		public var delBtn:UIButton;
		public var radioButtonGroup:ASRadioButtonGroup;
				
		private function create_init():void
		{
			enabledPercentSize = true;
			padding = 5;
			verticalGap = 5;
			
			lb = new UILabel();
			lb.text = label;
			lb.height = 25;
			addChild(lb);
			
			selectBtn1 = new UIButton();
			selectBtn1.label = "选择套装";
			addChild(selectBtn1);
			
			selectBtn2 = new UIButton();
			selectBtn2.label = "选择武器";
			addChild(selectBtn2);
			
			xTi1 = new SandyTextInputWidthLabel();
			xTi1.label = "初始的x坐标: "
			xTi1.percentWidth = 100;
			xTi1.restrict = "0-9.\\-";
			xTi1.text = EditSkillManager.attack_battleX.toString();
			addChild(xTi1);
			
			var lb1:UILabel = new UILabel();
			lb1.text = "(按回车确认，每次编辑一个技能，只需要设置一次)"
			lb1.multiline = true;
			lb1.width = 150
			lb1.color = ColorUtils.red;
			addChild(lb1);
			
			var vb:UIVBox = new UIVBox();
			vb.styleName = "uicanvas"
			vb.percentWidth = 100;
			vb.height = 300;
			vb.padding = 5;
			vb.verticalGap = 5;
			addChild(vb);
			
			radioButtonGroup = new ASRadioButtonGroup();
			
			var lb3:UIRadioButton = new UIRadioButton();
			lb3.label = "选择动作:";
			lb3.height = 22
			lb3.value = "1"
			lb3.group = radioButtonGroup;
			vb.addChild(lb3);
			
			combox1 = new UICombobox();
			combox1.width = 150;
			combox1.height = 25;
			vb.addChild(combox1);
			
			var lb4:UIRadioButton = new UIRadioButton();
			lb4.label = "选择混合动作:";
			lb4.height = 22
			lb4.value = "2"
			lb4.group = radioButtonGroup;
			vb.addChild(lb4);
						
			combox2 = new UICombobox();
			combox2.width = 150;
			combox2.height = 25;
			vb.addChild(combox2);
			
			okBtn = new UIButton();
			okBtn.label = "提交"
			vb.addChild(okBtn);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			vb.addChild(delBtn);
		}
	}
}