package com.editor.module_roleEdit.pop.saveNameLoc
{
	
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.expand.SandyTextInputWidthLabel;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 保存物体顶上的名字的位置
	 */ 
	public class PeopleImageSaveNameLocPopwin extends AppPopupWithEmptyWin
	{
		public function PeopleImageSaveNameLocPopwin()
		{
			super()
			create_init()
		}
		
		
		public var name_x:SandyTextInputWidthLabel;
		public var saveBtn:UIButton;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 300;
			opts.height = 150;
			opts.title = "保存动作配置"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			var gdpsvbox20:UIVBox = new UIVBox();
			gdpsvbox20.enabledPercentSize=true
			addChild(gdpsvbox20);
			
			name_x = new SandyTextInputWidthLabel();
			name_x.id="name_x"
			name_x.label="名称显示坐标: "
			name_x.width=200
			name_x.text=""
			gdpsvbox20.addChild(name_x);
			
			saveBtn = new UIButton();
			saveBtn.id="saveBtn"
			saveBtn.label="保存"
			gdpsvbox20.addChild(saveBtn);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.PeopleImageSaveNameLocPopwin_sign
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new PeopleImageSaveNameLocPopwinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(PeopleImageSaveNameLocPopwinMediator.NAME)
		}
		
		
	}
}