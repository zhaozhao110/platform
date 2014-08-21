package com.editor.d3.view.source
{
	import com.air.component.SandyAIRImage;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.d3.tool.D3AIRImage;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;

	public class D3SourcePopView extends UIVBox
	{
		public function D3SourcePopView()
		{
			super();
			create_init();
		}
		
		public var imgContainer:UIVBox;
		public var txtContainer:UIVBox;
		public var img:D3AIRImage;
		public var txt:UITextArea;
		public var infoTxt:UIText;
		public var copyBtn:UIButton;
				
		private function create_init():void
		{
			padding = 2;
			enabledPercentSize = true
			styleName = "uicanvas";
			visible = false;
			
			var h:UIHBox = new UIHBox();
			h.height = 50;
			addChild(h);
			
			infoTxt = new UIText();
			infoTxt.height = 50;
			infoTxt.width = 300;
			infoTxt.bold = true;
			infoTxt.color = ColorUtils.blue;
			h.addChild(infoTxt);
			
			var c:UICanvas = new UICanvas();
			c.enabledPercentSize = true;
			addChild(c);
			
			imgContainer = new UIVBox();
			imgContainer.enabledPercentSize = true;
			imgContainer.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			imgContainer.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			c.addChild(imgContainer);
				
			img = new D3AIRImage();
			imgContainer.addChild(img);
			
			txtContainer = new UIVBox();
			txtContainer.enabledPercentSize = true
			c.addChild(txtContainer);
			
			h = new UIHBox();
			h.height = 25;
			txtContainer.addChild(h);
			
			copyBtn = new UIButton();
			copyBtn.label = "复制"
			h.addChild(copyBtn);
			
			txt = new UITextArea();
			txt.enabledPercentSize = true;
			txt.editable = false;
			txt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			txt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			txtContainer.addChild(txt);
		}
	}
}