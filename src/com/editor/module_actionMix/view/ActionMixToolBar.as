package com.editor.module_actionMix.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ActionMixToolBar extends UIHBox
	{
		public function ActionMixToolBar()
		{
			super()
			create_init()
		}
		
		public var infoTxt:UILabel;
		public var loadMotionBtn:UIButton;
		public var saveBtn:UIButton;
		public var uploadSWFBtn:UIButton;
		public var uploadMapBtn:UIButton;
		public var exportXMLBtn:UIButton;
		
		//程序生成
		private function create_init():void
		{
			styleName = "uicanvas"
			verticalAlign = ASComponentConst.verticalAlign_middle;
			percentWidth=100
			paddingLeft=20
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
			
			infoTxt = new UILabel();
			this.addChild(infoTxt);
			
			
			//dispatchEvent creationComplete
			initComplete();
		}

	}
}