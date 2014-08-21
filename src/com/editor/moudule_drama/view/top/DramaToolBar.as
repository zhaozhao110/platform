package com.editor.moudule_drama.view.top
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class DramaToolBar extends UIHBox
	{
		public function DramaToolBar()
		{
			super();
			create_init();
		}
		
		/**选择剧情按钮**/
		public var selectDramaButton:UIButton;
		/**更新剧情配置按钮**/
		public var updataDramaConfigButton:UIButton;
		/**预览按钮**/
		public var previewButton:UIButton;
		/**保存按钮**/
		public var saveButton:UIButton;
		/**隐藏时间轴**/
		public var visiTimelineButton:UIButton;
		/**隐藏LOG**/
		public var visiLogButton:UIButton;
		/**项目文本**/
		public var infoTxt:UILabel;
		/**当前剧情文本**/
		public var infoTxt2:UILabel;
		/**当前片断文本**/
		public var infoTxt3:UILabel;
		private function create_init():void
		{
			styleName = "uicanvas";
			verticalAlign = ASComponentConst.verticalAlign_middle;
			this.percentWidth=100;
			this.paddingLeft=20;
			height = 30;
			horizontalGap = 10;
			
			/**选择剧情按钮**/
			selectDramaButton = new UIButton();
			selectDramaButton.label = "选择要编辑的剧情";
			addChild(selectDramaButton);
			
			updataDramaConfigButton = new UIButton();
			updataDramaConfigButton.label = "更新剧情配置";
			addChild(updataDramaConfigButton);
			
			previewButton = new UIButton();
			previewButton.label = "预览";
			addChild(previewButton);
			
			saveButton = new UIButton();
			saveButton.label = "保存";
			addChild(saveButton);
			
			visiTimelineButton = new UIButton();
			visiTimelineButton.label = "隐藏时间轴";
			addChild(visiTimelineButton);
			
			visiLogButton = new UIButton();
			visiLogButton.label = "隐藏LOG";
			addChild(visiLogButton);
			
			/**项目文本**/
			infoTxt = new UILabel();
			addChild(infoTxt);
			/**当前剧情文本**/
			infoTxt2 = new UILabel();
			addChild(infoTxt2);
			/**当前片断文本**/
			infoTxt3 = new UILabel();
			addChild(infoTxt3);
			
		}
		
	}
}