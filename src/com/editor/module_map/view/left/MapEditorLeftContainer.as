package com.editor.module_map.view.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_res;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_scene;
	import com.editor.module_map.view.render.SceneListRenderer;

	public class MapEditorLeftContainer extends UICanvas
	{
		public function MapEditorLeftContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBar;
		public var tabContainer1:UICanvas;
		public var tabContainer2:UICanvas;
		
		public var addSceneButton:UIButton;
		public var addEmptySceneButton:UIButton;
		public var sceneListContainer:UIVBox;
		public var sceneToUpButton:UIButton;
		public var sceneToDownButton:UIButton;
		
		public var viewStack:UIViewStack;
		public var attriScenePanel:MapEditorAttributeEditor_scene;
		public var attriResPanel:MapEditorAttributeEditor_res;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			percentHeight = 100;
			
			/**tabBar**/
			tabBar = new UITabBar();
			tabBar.dataProvider = ["场景层次","元件属性"];
			addChild(tabBar);
			
			/**tabBar mask**/
			var tabbarMasker:UICanvas = new UICanvas();
			tabbarMasker.x = 60; tabbarMasker.y = 0;
			tabbarMasker.width = 140; tabbarMasker.height = 26;
			tabbarMasker.mouseEnabled = true;
			addChild(tabbarMasker);
			
			var container1:UICanvas = new UICanvas();
			container1.x = 0; container1.y = 25;
			container1.width = 200; container1.percentHeight = 100;
			container1.styleName = "uicanvas";
			addChild(container1);
			
			/** <<场景层次**/
			tabContainer1 = new UICanvas();
			tabContainer1.x = 0; tabContainer1.y = 0;
			tabContainer1.width = 200;
			container1.addChild(tabContainer1);
			tabContainer1.visible = false;
			
			
			/**添加场景按钮**/
			addSceneButton = new UIButton();
			addSceneButton.x = 3; addSceneButton.y = 10;
			addSceneButton.label = "添加场景层次";
			tabContainer1.addChild(addSceneButton);
			
			/**添加空白场景按钮**/
			addEmptySceneButton = new UIButton();
			addEmptySceneButton.x = 100; addEmptySceneButton.y = 10;
			addEmptySceneButton.label = "添加空白层次";
			tabContainer1.addChild(addEmptySceneButton);
			
			/**容器V1**/
			var vbox1:UIVBox = new UIVBox();			
			vbox1.x = 3; vbox1.y = 42;
			vbox1.verticalGap = 10;
			tabContainer1.addChild(vbox1);						
			
			/**场景列表**/
			sceneListContainer = new UIVBox();
			sceneListContainer.width = 190; sceneListContainer.height = 100;
			sceneListContainer.padding = 2;
			sceneListContainer.verticalGap = 3;
			sceneListContainer.backgroundColor = 0xE5E5E5;
			sceneListContainer.verticalScrollPolicy = "auto";
			sceneListContainer.itemRenderer = SceneListRenderer;
			sceneListContainer.enabeldSelect = true;
			vbox1.addChild(sceneListContainer);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.horizontalGap = 10;
			vbox1.addChild(hbox1);
			/**场景层次调整按钮**/
			sceneToUpButton = new UIButton();
			sceneToUpButton.label = "上移";			
			hbox1.addChild(sceneToUpButton);
			
			sceneToDownButton = new UIButton();
			sceneToDownButton.label = "下移";
			hbox1.addChild(sceneToDownButton);
			
			
			/** <<元件属性**/
			tabContainer2 = new UICanvas();
			tabContainer2.x = 0; tabContainer2.y = 0;
			tabContainer2.width = 200;
			tabContainer2.backgroundColor = 0x666666;
			container1.addChild(tabContainer2);
			tabContainer2.visible = false;
			
			viewStack = new UIViewStack();
			tabContainer2.addChild(viewStack);
			
			attriScenePanel = new MapEditorAttributeEditor_scene();
			viewStack.addChild(attriScenePanel);
			
			attriResPanel = new MapEditorAttributeEditor_res();
			viewStack.addChild(attriResPanel);
			
			viewStack.selectedIndex = 1;
			
		}
		
		
		
	}
}