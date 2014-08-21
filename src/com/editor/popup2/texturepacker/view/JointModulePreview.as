package com.editor.popup2.texturepacker.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.popup2.texturepacker.component.UIPanel;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.core.SandySprite;
	
	import flash.display.Sprite;
	
	public class JointModulePreview extends UIPanel
	{
		public var img:UIImage;
		public var bms:UICanvas;
		public var bms_cont:UICanvas
		
		public function JointModulePreview()
		{
			super();
			
			this.width = 800;
			this.percentHeight = 100;
			this.y      = 50;
						
			img = new UIImage;
			addChild(img);
			img.source = "texture_img_a"
			
			bms_cont = new UICanvas();
			bms_cont.enabledPercentSize = true
			bms_cont.verticalScrollPolicy  	= ASComponentConst.scrollPolicy_on;
			bms_cont.horizontalScrollPolicy	= ASComponentConst.scrollPolicy_on;
			addChild(bms_cont);
			
			bms = new UICanvas();
			bms.clipContent = true;
			bms_cont.addChild(bms);
		}
		
		
	}
} 