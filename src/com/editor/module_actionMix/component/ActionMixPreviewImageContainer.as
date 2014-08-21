package com.editor.module_actionMix.component
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class ActionMixPreviewImageContainer extends UICanvas
	{
		public function ActionMixPreviewImageContainer()
		{
			super();
			
			this.width = 500;
			this.height = 500;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0x000000;
			
			img = new ActionMixPreviewImage();
			addChild(img);
		}
		
		public var img:ActionMixPreviewImage;
		
		
	}
}