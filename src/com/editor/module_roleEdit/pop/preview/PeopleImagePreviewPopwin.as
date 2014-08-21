package com.editor.module_roleEdit.pop.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHScrollBar;
	import com.editor.component.controls.UILabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 预览效果
	 */ 
	public class PeopleImagePreviewPopwin extends AppPopupWithEmptyWin
	{
		public function PeopleImagePreviewPopwin()
		{
			super()
			create_init()
		}
		
		
		public var topTxt:UILabel;
		public var img1:PeopleImagePreviewImageContainer;
		public var img2:PeopleImagePreviewImageContainer;
		public var img3:PeopleImagePreviewImageContainer;
		public var img4:PeopleImagePreviewImageContainer;
		public var img5:PeopleImagePreviewImageContainer;
		public var img6:PeopleImagePreviewImageContainer;
		public var img7:PeopleImagePreviewImageContainer;
		public var img8:PeopleImagePreviewImageContainer;
		public var imgHBox:UIHBox;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 1000;
			opts.height = 600;
			opts.title = "预览动画"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			var gdpsvbox16:UIVBox = new UIVBox();
			gdpsvbox16.enabledPercentSize=true
			addChild(gdpsvbox16);
			
			topTxt = new UILabel();
			topTxt.id="topTxt";
			topTxt.fontSize = 20;
			gdpsvbox16.addChild(topTxt);
			
			imgHBox = new UIHBox();
			imgHBox.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			imgHBox.width = 900;
			imgHBox.height = 550
			gdpsvbox16.addChild(imgHBox);
			
			img1 = new PeopleImagePreviewImageContainer();
			img1.id="img1"
			img1.forward=SandyMapConst.right;
			imgHBox.addChild(img1);
			
			img2 = new PeopleImagePreviewImageContainer();
			img2.id="img2"
			img2.forward=SandyMapConst.right_top;
			imgHBox.addChild(img2);
			
			img3 = new PeopleImagePreviewImageContainer();
			img3.id="img3"
			img3.forward=SandyMapConst.top;
			imgHBox.addChild(img3);
			
			img4 = new PeopleImagePreviewImageContainer();
			img4.id="img4"
			img4.forward=SandyMapConst.right_bot;
			imgHBox.addChild(img4);
			
			img5 = new PeopleImagePreviewImageContainer();
			img5.id="img5"
			img5.forward=SandyMapConst.bottom;
			imgHBox.addChild(img5);
			
			img6 = new PeopleImagePreviewImageContainer();
			img6.id="img6"
			img6.forward=SandyMapConst.left_bot;
			imgHBox.addChild(img6);
			
			img7 = new PeopleImagePreviewImageContainer();
			img7.id="img7"
			img7.forward=SandyMapConst.left;
			imgHBox.addChild(img7);
			
			img8 = new PeopleImagePreviewImageContainer();
			img8.id="img8"
			img8.forward=SandyMapConst.left_top;
			imgHBox.addChild(img8);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		//原始文件里的script
		
		import com.sandy.effect.interfac.ISandyEffectDataProxy;
		import com.sandy.math.SandyPoint;
		import com.sandy.render2D.map.data.SandyMapConst;
		
		
		override protected function __init__() : void
		{
			enabledDestroy 	= true
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.PeopleImagePreviewPopwin_sign;
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new PeopleImagePreviewPopwinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(PeopleImagePreviewPopwinMediator.NAME)
		}
		         
		
	}
}