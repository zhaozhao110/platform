package com.editor.module_roleEdit.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_roleEdit.component.PeopleImageTimelineItemRenderer;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class PeopleImageDataGrid extends UIVBox
	{
		public function PeopleImageDataGrid()
		{
			super()
			create_init()
		}
			

		public var selectFileBtn:SandyTextInputWithLabelWithSelectFile;
		public var openFoldBtn:UIButton;
		public var grid:UIVBox;
		
		public var logTxt:UITextArea;
		public var spContainer:ASComponent;

		//程序生成
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 10;
			verticalGap = 10
			enabledPercentSize = true
					
				
			//toolBar
			var gdpshbox25:UIHBox = new UIHBox();
			//gdpshbox25.background_red = true;
			gdpshbox25.percentWidth = 100;
			gdpshbox25.height = 30;
			gdpshbox25.horizontalGap = 10
			this.addChild(gdpshbox25);
			
			selectFileBtn = new SandyTextInputWithLabelWithSelectFile();
			selectFileBtn.openDirectory=true
			selectFileBtn.label="指定此动画资源本地序列图主目录（用于合成动作PNG/预览）"
			selectFileBtn.id="selectFileBtn"
			selectFileBtn.width=800
			gdpshbox25.addChild(selectFileBtn);
			
			openFoldBtn = new UIButton();
			openFoldBtn.label="打开编辑的图片的目录"
			openFoldBtn.id="openFoldBtn"
			gdpshbox25.addChild(openFoldBtn);
			
			
			
			
			
			grid = new UIVBox();
			grid.enabledPercentSize = true;
			grid.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			grid.itemRenderer = PeopleImageTimelineItemRenderer
			addChild(grid);
			
			
			
			
			
			var hbox29:UIHBox = new UIHBox();
			//hbox29.background_red = true;
			hbox29.height=30
			hbox29.paddingLeft=20
			addChild(hbox29);
			
			
			
			
			var lb:UILabel = new UILabel();
			lb.text = "记录log";
			lb.height = 20
			addChild(lb);
			
			logTxt = new UITextArea();
			logTxt.id="logTxt"
			logTxt.editable = true;
			logTxt.percentWidth=100
			logTxt.height=100
			addChild(logTxt);
			
			spContainer = new ASComponent();
			spContainer.id="sp"
			spContainer.visible=false
			spContainer.includeInLayout = false
			spContainer.mouseChildren=false
			spContainer.mouseEnabled=false
			$addChild(spContainer);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		//原始文件里的script
	}
}