package com.editor.moudule_drama
{
	import com.editor.component.UIModule2;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.view.left.DramaLeftContainer;
	import com.editor.moudule_drama.view.right.DramaRightContainer;
	import com.editor.moudule_drama.view.top.DramaToolBar;

	public class DramaModule extends UIModule2
	{
		public function DramaModule()
		{
			super();
		}
		
		public static const MODULENAME:String = "drama"

		public var topToolBar:DramaToolBar;
		public var leftContainer:DramaLeftContainer;
		public var rightContainer:DramaRightContainer;
		
		override public function create_init():void
		{
			super.create_init();
			
			DramaDataManager.init();
			
			topToolBar = new DramaToolBar();
			layout2Container.getToolBar().addChild(topToolBar);
			
			leftContainer = new DramaLeftContainer();
			layout2Container.getLeftContainer().addChild(leftContainer);
			layout2Container.getLeftContainer().width = 200;
			
			rightContainer = new DramaRightContainer();
			layout2Container.getRightContainer().addChild(rightContainer);
			
		}
	}
}