package com.editor.module_skill.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class SkillSeqToolBar extends UIHBox
	{
		public function SkillSeqToolBar()
		{
			super();
			create_init();
		}
		
		public var loadBtn:UIButton;
		public var infoTxt:UILabel;
		public var showTimelineBtn:UIButton;
		public var showLogBtn:UIButton;
		public var timelineTxt:UILabel;
		public var infoTxt1:UILabel;
		public var preBtn:UIButton;
		public var saveBtn:UIButton;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			verticalAlign = ASComponentConst.verticalAlign_middle;
			this.percentWidth=100
			this.paddingLeft=20
			height = 30;
			horizontalGap = 10;
			
			loadBtn = new UIButton();
			loadBtn.label = "选择技能"
			addChild(loadBtn);
			
			showTimelineBtn = new UIButton();
			showTimelineBtn.label = "隐藏时间轴";
			addChild(showTimelineBtn);
			
			showLogBtn = new UIButton();
			showLogBtn.label = "隐藏log"
			addChild(showLogBtn);
			
			preBtn = new UIButton();
			preBtn.label = "预览";
			addChild(preBtn);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存"
			addChild(saveBtn);
			
			infoTxt1 = new UILabel();
			infoTxt1.width = 320;
			addChild(infoTxt1);
			
			infoTxt = new UILabel();
			infoTxt.width = 320;
			addChild(infoTxt);
			
			timelineTxt = new UILabel();
			timelineTxt.width = 320;
			timelineTxt.color = 0xcc0000;
			addChild(timelineTxt);
		}
	}
}