package com.editor.d3.app.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.view.ui.bottom.App3DBottomContainer;
	import com.editor.d3.app.view.ui.left.App3DLeftContainer;
	import com.editor.d3.app.view.ui.middle.App3DSceneContainer;
	import com.editor.d3.app.view.ui.right.App3DRightContainer;
	import com.editor.d3.app.view.ui.top.App3DTopBarContainer;
	import com.editor.d3.view.particle2.Particle2StarlingCont;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.ModelMaskContainer;
	import com.sandy.utils.ColorUtils;

	public class App3DMainUIContainer extends UICanvas
	{
		public function App3DMainUIContainer()
		{
			super();
			//create_init()
		}
		
		public var topBarContainer:App3DTopBarContainer;
		public var viewStack:App3DSceneContainer;
		public var bottomContainer:App3DBottomContainer;
		public var leftContainer:App3DLeftContainer;
		public var rightContainer:App3DRightContainer;
		public var contCanvas:UICanvas;
		public var upCavans:UICanvas;
		public var upCavans2:UICanvas;
		public var to3DBtn:UIButton;
		public var loadCanvas:UICanvas;
		public var mainVBox:UIVBox;
		public var mainVS:UIViewStack;
		public var maskCont:ModelMaskContainer;
		public var particle2Cont:Particle2StarlingCont;
		
		
		public function create_init():void
		{
			if(topBarContainer!=null) return ;
			name = "AppMainUIContainer"
			enabledPercentSize=true;
			styleName = "uicanvas";
			
			mainVBox = new UIVBox();
			mainVBox.enabledPercentSize = true;
			mainVBox.mouseChildren = false;
			addChild(mainVBox);
			
			///////////////////////////////////////////////////////////////
			
			topBarContainer = new App3DTopBarContainer();
			mainVBox.addChild(topBarContainer);
			
			
			///////////////////////////////////////////////////////////////
			
			mainVS = new UIViewStack();
			mainVS.enabledPercentSize = true;
			mainVBox.addChild(mainVS);
			
			///////////////////////////////////////////////////////////////
			
			contCanvas = new UICanvas();
			contCanvas.enabledPercentSize = true;
			mainVS.addChild(contCanvas);
			
			viewStack = new App3DSceneContainer();
			contCanvas.addChild(viewStack);
						
			leftContainer = new App3DLeftContainer();
			leftContainer.y = 10;
			leftContainer.width = 250;
			leftContainer.height = 460;
			contCanvas.addChild(leftContainer);
			
			bottomContainer = new App3DBottomContainer();
			bottomContainer.height = 350;
			bottomContainer.width = 1030
			bottomContainer.bottom = 15;
			contCanvas.addChild(bottomContainer);
			
			rightContainer = new App3DRightContainer();
			rightContainer.y = 10;
			rightContainer.width = 300;
			rightContainer.percentHeight = 100;
			rightContainer.right = 0;
			contCanvas.addChild(rightContainer);
			
			upCavans2 = new UICanvas();
			upCavans2.enabledPercentSize = true;
			contCanvas.addChild(upCavans2);
			
			upCavans = new UICanvas();
			upCavans.enabledPercentSize = true;
			upCavans.mouseChildren = true;
			upCavans.mouseEnabled = true;
			contCanvas.addChild(upCavans);
			upCavans.visible = false;
						
			maskCont = new ModelMaskContainer();
			upCavans.addChild(maskCont);
			
			
			///////////////////////////////////////////////////////////////
			
			particle2Cont = new Particle2StarlingCont();
			mainVS.addChild(particle2Cont);
			
			
			///////////////////////////////////////////////////////////////
			
			loadCanvas = new UICanvas();
			loadCanvas.borderThickness = 5;
			loadCanvas.borderColor = ColorUtils.gray;
			loadCanvas.width = 300;
			loadCanvas.height = 80;
			loadCanvas.backgroundColor = ColorUtils.black;
			loadCanvas.backgroundAlpha = .3;
			loadCanvas.horizontalCenter = 0;
			loadCanvas.verticalCenter = 0;
			loadCanvas.borderStyle = ASComponentConst.borderStyle_solid;
			loadCanvas.cornerRadius = 5
			addChild(loadCanvas)
						
			var t:UILabel = new UILabel();
			t.text = "解析项目中，请等待..."
			t.color = ColorUtils.white;
			t.bold = true;
			t.fontSize = 20;
			t.verticalCenter = 0;
			t.horizontalCenter = 0;
			t.font = "幼圆"
			loadCanvas.addChild(t);
			
			to3DBtn = new UIButton();
			to3DBtn.label = "切换到2D场景";
			to3DBtn.right = 0;
			to3DBtn.top = 2;
			addChild(to3DBtn);
			
			initComplete();
		}
		
	}
}