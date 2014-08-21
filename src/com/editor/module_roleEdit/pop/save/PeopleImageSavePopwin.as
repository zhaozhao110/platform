package com.editor.module_roleEdit.pop.save
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 保存图片的原始偏移点
	 */ 
	public class PeopleImageSavePopwin extends AppPopupWithEmptyWin
	{
		public function PeopleImageSavePopwin()
		{
			super()
			create_init()
		}
		
		
		public var originalTI:SandyTextInputWidthLabel;
		public var saveBtn:UIButton;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 300;
			opts.height = 150;
			opts.title = "保存配置"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			
			//contentArea
			var gdpsvbox19:UIVBox = new UIVBox();
			gdpsvbox19.enabledPercentSize=true
			gdpsvbox19.paddingTop = 10;
			gdpsvbox19.paddingLeft = 10;
			gdpsvbox19.horizontalAlign = ASComponentConst.horizontalAlign_center;
			addChild(gdpsvbox19);
			
			originalTI = new SandyTextInputWidthLabel();
			originalTI.id="originalTI"
			originalTI.label="原始图片原点: "
			originalTI.width=200
			originalTI.text="200,237"
			gdpsvbox19.addChild(originalTI);
			
			saveBtn = new UIButton();
			saveBtn.id="saveBtn"
			saveBtn.label="保存"
			gdpsvbox19.addChild(saveBtn);
			
			//dispatchEvent creationComplete
			initComplete();
		}
				
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.PeopleImageSavePopwin_sign;
			isModel    		= true;
			
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new PeopleImageSavePopwinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(PeopleImageSavePopwinMediator.NAME)
		}
		
		
	}
}