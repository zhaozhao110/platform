package com.editor.module_sea.popview.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.mediator.SeaMapModuleTopContainerMediator;
	import com.editor.module_sea.popview.SeaMapLevelPopview;
	import com.editor.module_sea.vo.SeaMapLevelVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class SeaMapLevelItemRenderer extends ASHListItemRenderer
	{
		public function SeaMapLevelItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var lb:UITextInput;
		private var upBtn:UIAssetsSymbol;
		private var downBtn:UIAssetsSymbol;
		private var cb:UIRadioButton;
		private var vcb:UICheckBox;
		private var closeBtn:UIAssetsSymbol;
		
		public static var cb_group:UIRadioButtonGroup = new UIRadioButtonGroup();
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = false;
			
			horizontalGap = 5;
			
			cb = new UIRadioButton();
			cb.label = " "
			cb.group = cb_group;
			addChild(cb);
			cb.addEventListener(ASEvent.CHANGE,onSelectChange);
			
			lb = new UITextInput();
			lb.width = 70;
			lb.height = 22;
			lb.enterKeyDown_proxy = onKeyDown2
			addChild(lb);
			
			vcb = new UICheckBox();
			vcb.label = "显示"
			vcb.width = 50;
			vcb.selected = true;
			vcb.addEventListener(ASEvent.CHANGE,onVisibleChange);
			addChild(vcb);
			
			upBtn = new UIAssetsSymbol();
			upBtn.source = "up_arr_a"
			upBtn.width = 20;
			upBtn.height = 20;
			upBtn.toolTip = "上升一层"
			upBtn.buttonMode = true;
			upBtn.addEventListener(MouseEvent.CLICK , onUpHandle);
			addChild(upBtn);
			
			downBtn = new UIAssetsSymbol();
			downBtn.source = "down_arr_a"
			downBtn.width =20;
			downBtn.height = 20;
			downBtn.toolTip = "下降一层"
			downBtn.buttonMode = true;
			downBtn.addEventListener(MouseEvent.CLICK , onDownHandle)
			addChild(downBtn);
			
			closeBtn = new UIAssetsSymbol();
			closeBtn.source = "close2_a"
			closeBtn.width = 16;
			closeBtn.height = 16;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN , onCloseBtnClick);
			addChild(closeBtn);
		}
		
		private var levelItem:SeaMapLevelVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			levelItem = value as SeaMapLevelVO;
			lb.text = levelItem.name;
			
			cb.selected = false;
			if(SeaMapModuleManager.selectlevel!=null){
				if(SeaMapModuleManager.selectlevel.index == levelItem.index){
					cb.selected = true;
				}
			}
			
			vcb.selected = levelItem.container.visible
		}
		
		private function onSelectChange(e:ASEvent=null):void
		{
			if(cb.selected){
				SeaMapModuleManager.selectlevel = levelItem;
				get_SeaMapModuleTopContainerMediator().mainUI.infoTxt2.htmlText = "选中:" + ColorUtils.addColorTool(levelItem.name,ColorUtils.blue) + "层"
			}
		}
		
		private function get_SeaMapModuleTopContainerMediator():SeaMapModuleTopContainerMediator
		{
			return iManager.retrieveMediator(SeaMapModuleTopContainerMediator.NAME) as SeaMapModuleTopContainerMediator
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator
		}
		
		private function onVisibleChange(e:ASEvent):void
		{
			levelItem.container.visible = vcb.selected;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			get_SeaMapContentMediator().removeLevel(levelItem);
		}
		
		private function onKeyDown2():void
		{
			if(!StringTWLUtil.isWhitespace(lb.text)){
				levelItem.name = lb.text;
				if(SeaMapModuleManager.selectlevel!=null){
					if(SeaMapModuleManager.selectlevel.index == levelItem.index){
						cb.setSelect(true,true);
					}
				}
			}
		}
		
		private function onUpHandle(e:MouseEvent):void
		{
			levelItem.container.swapToUpLevel()
			SeaMapLevelPopview.instance.reflashMapInfo();
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			levelItem.container.swapToDownLevel();
			SeaMapLevelPopview.instance.reflashMapInfo();
		}
		
	}
}