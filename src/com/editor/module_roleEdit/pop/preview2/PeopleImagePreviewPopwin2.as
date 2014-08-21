package com.editor.module_roleEdit.pop.preview2
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHScrollBar;
	import com.editor.component.controls.UILabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 预览效果
	 */ 
	public class PeopleImagePreviewPopwin2 extends AppPopupWithEmptyWin
	{
		public function PeopleImagePreviewPopwin2()
		{
			super()
			create_init()
		}
		
		
		public var topTxt:UILabel;
		public var img1:PeopleImagePreviewImageContainer2;
		public var imgHBox:UIHBox;
		public var actCB:UICombobox;
		public var forCB:UICombobox;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
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
						
			imgHBox = new UIHBox();
			imgHBox.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			imgHBox.width = 900;
			imgHBox.height = 550
			gdpsvbox16.addChild(imgHBox);
			
			var lb:UILabel = new UILabel();
			lb.text = "动作:"
			imgHBox.addChild(lb);
			
			actCB = new UICombobox();
			actCB.width = 200;
			actCB.height = 23;
			imgHBox.addChild(actCB);
			
			lb = new UILabel();
			lb.text = "方向:"
			imgHBox.addChild(lb);
			
			forCB = new UICombobox();
			forCB.width = 200;
			forCB.height = 23;
			imgHBox.addChild(forCB);
			
			topTxt = new UILabel();
			topTxt.id="topTxt";
			topTxt.fontSize = 20;
			gdpsvbox16.addChild(topTxt);
			
			img1 = new PeopleImagePreviewImageContainer2();
			img1.id="img1"
			addChild(img1);
			
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
			popupSign  		= PopupwinSign.PeopleImagePreviewPopwin2_sign;
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new PeopleImagePreviewPopwinMediator2(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(PeopleImagePreviewPopwinMediator2.NAME)
		}
		         
		
	}
}