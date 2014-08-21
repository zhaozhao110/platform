package com.editor.module_roleEdit.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class PeopleImageToolBar extends UIHBox
	{
		public function PeopleImageToolBar()
		{
			super()
			create_init()
		}

		public var infoTxt:UILabel;
		public var loadMotionBtn:UIButton;
		public var saveBtn:UIButton;
		public var reflashBtn:UIButton;
		public var previewBtn:UIButton;
		
		//程序生成
		private function create_init():void
		{
			styleName = "uicanvas"
			verticalAlign = ASComponentConst.verticalAlign_middle;
			this.percentWidth=100
			this.paddingLeft=20
			height = 30;
			horizontalGap = 10;
			
			loadMotionBtn = new UIButton();
			loadMotionBtn.label="加载动画"
			loadMotionBtn.id="loadMotionBtn"
			this.addChild(loadMotionBtn);

			saveBtn = new UIButton();
			saveBtn.label="保存配置"
			saveBtn.id="saveBtn"
			this.addChild(saveBtn);
			
			reflashBtn = new UIButton();
			reflashBtn.label="刷新缓存"
			this.addChild(reflashBtn);
			
			previewBtn = new UIButton();
			previewBtn.label="预览动画"
			this.addChild(previewBtn);
			
			infoTxt = new UILabel();
			this.addChild(infoTxt);
			

			//dispatchEvent creationComplete
			initComplete();
		}

		//原始文件里的script
	}
}