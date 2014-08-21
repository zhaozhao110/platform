package com.editor.module_skill
{
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.pop.preview.PreviewContainer;
	import com.editor.module_skill.view.SkillSeqToolBar;
	import com.editor.module_skill.view.left.SkillSeqLeftContainer;
	import com.editor.module_skill.view.right.SkillSeqRightContainer;
	import com.editor.modules.common.layout2.AppLayout2Container;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.manager.ASLayoutManager;

	public class SkillSeqModule extends UIModule2
	{
		public function SkillSeqModule()
		{
			super();
			//create_init();
		}
		
		public static const MODULENAME:String = "editSkill";
		
		public var toolBar:SkillSeqToolBar;
		public var leftContainer:SkillSeqLeftContainer;
		public var rightContainer:SkillSeqRightContainer;
		public var previewContainer:PreviewContainer;
		
		
		override public function create_init():void
		{
			ASComponent.percentSizeToPixel_n = 0;
			ASComponent.validateChildSize_n = 0;
			
			super.create_init();
			EditSkillManager.init();
									
			toolBar = new SkillSeqToolBar();
			layout2Container.getToolBar().addChild(toolBar);
			
			leftContainer = new SkillSeqLeftContainer();
			layout2Container.getLeftContainer().addChild(leftContainer);
			layout2Container.getLeftContainer().width = 200
			
			rightContainer = new SkillSeqRightContainer();
			layout2Container.getRightContainer().addChild(rightContainer);
			
			previewContainer = new PreviewContainer();
			addChild(previewContainer);
		}
	}
}