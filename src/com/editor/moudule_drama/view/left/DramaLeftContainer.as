package com.editor.moudule_drama.view.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameDialog;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameMovie;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameResRecord;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameScene;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_LayoutView;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_Row;
	import com.editor.moudule_drama.view.render.FrameClipListRenderer;

	public class DramaLeftContainer extends UICanvas
	{
		public function DramaLeftContainer()
		{
			super();
			create_init();
		}
		
		
		public var tabBar:UITabBar;
		public var tabContainer1:UICanvas;
		public var tabContainer2:UICanvas;
		
		/**片断添加按钮**/
		public var addFrameClipButton:UIButton;
		/**片断列表**/
		public var frameClipListVbox:UIVBox;
		/**片断上移按钮**/
		public var frameClipUpButton:UIButton;
		/**片断下移按钮**/
		public var frameClipDownButton:UIButton;
		
		/**属性切换**/
		public var viewStack:UIViewStack;
		
		/**0	场景帧属性**/
		public var attSceneFrame:DramaAttributeEditor_FrameScene;
		/**1	人物帧属性**/
		public var attResRecord:DramaAttributeEditor_FrameResRecord;
		/**2	影片帧属性**/
		public var attMovieFrame:DramaAttributeEditor_FrameMovie;
		/**3	对话帧属性**/
		public var attDialogFrame:DramaAttributeEditor_FrameDialog;
		
		/**4	显示对象属性**/
		public var attLayoutView:DramaAttributeEditor_LayoutView;
		
		/**5	层属性**/
		public var attRow:DramaAttributeEditor_Row;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			percentHeight = 100;
			
			/**tabBar**/
			tabBar = new UITabBar();
			tabBar.dataProvider = ["片段列表","属性"];
			addChild(tabBar);
			
			/**tabBar mask**/
			var tabbarMasker:UICanvas = new UICanvas();
			tabbarMasker.x = 60; tabbarMasker.y = 0;
			tabbarMasker.width = 140; tabbarMasker.height = 26;
			tabbarMasker.backgroundColor = 0xffffff;
			tabbarMasker.backgroundAlpha = 0;
			tabbarMasker.mouseEnabled = true;
			addChild(tabbarMasker);
			
			/**container1**/
			var container1:UICanvas = new UICanvas();
			container1.x = 0; container1.y = 25;
			container1.width = 200; container1.percentHeight = 100;
			container1.styleName = "uicanvas";
			addChild(container1);
			
			/** <<片断列表容器**/
			tabContainer1 = new UICanvas();
			tabContainer1.x = 0; tabContainer1.y = 0;
			tabContainer1.width = 200;
			container1.addChild(tabContainer1);
			tabContainer1.visible = false;
			/**片段添加按钮**/
			addFrameClipButton = new UIButton();
			addFrameClipButton.x = 5; addFrameClipButton.y = 5;
			addFrameClipButton.label = "添加片段";
			tabContainer1.addChild(addFrameClipButton);
			/**片断上移按钮**/
			frameClipUpButton = new UIButton();
			frameClipUpButton.x = 100; frameClipUpButton.y = 5;
			frameClipUpButton.label = "上移";
			tabContainer1.addChild(frameClipUpButton);
			/**片断下移按钮**/
			frameClipDownButton = new UIButton();
			frameClipDownButton.x = 146; frameClipDownButton.y = 5;
			frameClipDownButton.label = "下移";
			tabContainer1.addChild(frameClipDownButton);
			/**片段列表**/
			frameClipListVbox = new UIVBox();
			frameClipListVbox.x = 6; frameClipListVbox.y = 32;
			frameClipListVbox.width = 180; frameClipListVbox.height = 300;
			frameClipListVbox.padding = 2;
			frameClipListVbox.verticalGap = 3;
			frameClipListVbox.backgroundColor = 0xE5E5E5;
			frameClipListVbox.verticalScrollPolicy = "auto";
			frameClipListVbox.itemRenderer = FrameClipListRenderer;
			frameClipListVbox.enabeldSelect = true;
			tabContainer1.addChild(frameClipListVbox);
			
			/** <<帧属性面板容器**/
			tabContainer2 = new UICanvas();
			tabContainer2.x = 0; tabContainer2.y = 0;
			tabContainer2.width = 200;
			tabContainer2.backgroundColor = 0xCCCCCC;
			container1.addChild(tabContainer2);
			tabContainer2.visible = false;
			
			/** << 帧属性面板切换 **/
			viewStack = new UIViewStack();
			tabContainer2.addChild(viewStack);
			
			/**0	场景帧属性**/
			attSceneFrame = new DramaAttributeEditor_FrameScene();
			viewStack.addChild(attSceneFrame);
			attSceneFrame.visible = false;
			/**1	人物帧属性**/
			attResRecord = new DramaAttributeEditor_FrameResRecord();
			viewStack.addChild(attResRecord);
			attResRecord.visible = false;
			/**2	影片帧属性**/
			attMovieFrame = new DramaAttributeEditor_FrameMovie();
			viewStack.addChild(attMovieFrame);
			attMovieFrame.visible = false;
			/**3	对话帧属性**/
			attDialogFrame = new DramaAttributeEditor_FrameDialog();
			viewStack.addChild(attDialogFrame);
			attDialogFrame.visible = false;
			
			/**4	显示对象属性**/
			attLayoutView = new DramaAttributeEditor_LayoutView();
			viewStack.addChild(attLayoutView);
			attLayoutView.visible = false;
			
			/**5	层属性**/
			attRow = new DramaAttributeEditor_Row();
			viewStack.addChild(attRow);
			attRow.visible = false;
			
		}
		
	}
}