package com.editor.module_map.view.top
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class MapEditorToolBar extends UIHBox
	{
		public function MapEditorToolBar()
		{
			super();
			create_init();
		}
		
		public var selectSceneButton:UIButton;
		public var addSceneResButton:UIButton;
		public var addSceneResButton2:UIButton;
		public var previewButton:UIButton;
		public var saveButton:UIButton;
		public var visiLogButton:UIButton;
		public var infoTxt:UILabel;
		public var infoTxt2:UILabel;
		private function create_init():void
		{
			styleName = "uicanvas";
			verticalAlign = ASComponentConst.verticalAlign_middle;
			this.percentWidth=100
			this.paddingLeft=20
			height = 30;
			horizontalGap = 10;
				
			selectSceneButton = new UIButton();
			selectSceneButton.label = "选择要编辑的场景";
			addChild(selectSceneButton);
			
			addSceneResButton = new UIButton();
			addSceneResButton.label = "添加配置资源";
			addChild(addSceneResButton);
			
			addSceneResButton2 = new UIButton();
			addSceneResButton2.label = "添加普通资源";
			addChild(addSceneResButton2);
			
			previewButton = new UIButton();
			previewButton.label = "预览";
			addChild(previewButton);
			
			saveButton = new UIButton();
			saveButton.label = "保存";
			addChild(saveButton);
			
			visiLogButton = new UIButton();
			visiLogButton.label = "隐藏LOG";
			addChild(visiLogButton);
			
			
			infoTxt = new UILabel();
			addChild(infoTxt);
			
			infoTxt2 = new UILabel();
			addChild(infoTxt2);
			
			
			
		}
		
		
		
	}
}