package com.editor.module_mapIso.popview
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.sandy.event.SandyEventPriority;
	import com.sandy.manager.StageManager;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MapIsoPopViewBase extends UIVBox
	{
		public function MapIsoPopViewBase()
		{
			super();
			create_init();
		}
		
		protected var titleHB:UIHBox;
		protected var titleLB:UILabel;
		protected var contentVB:UIVBox;
		private var closeBtn:UIAssetsSymbol;
		
		protected function create_init():void
		{
			styleName = "uicanvas";
			//verticalGap = 2;
			
			titleHB = new UIHBox();
			titleHB.percentWidth = 100;
			titleHB.backgroundColor = ColorUtils.gray;
			titleHB.height = 30;
			titleHB.verticalAlignMiddle = true;
			addChild(titleHB);
			titleHB.mouseEnabled = true;
			titleHB.addEventListener(MouseEvent.MOUSE_DOWN , onDown,false,SandyEventPriority.getPriority());
			titleHB.addEventListener(MouseEvent.MOUSE_UP , onUp,false,SandyEventPriority.getPriority());
			
			titleLB = new UILabel();
			titleLB.selectable = false;
			titleLB.width = 140
			titleLB.color = ColorUtils.lime;
			titleHB.addChild(titleLB);
			titleLB.text = titles;
			
			closeBtn = new UIAssetsSymbol();
			closeBtn.source = "close2_a"
			closeBtn.width = 16;
			closeBtn.height = 16;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.MOUSE_DOWN , onCloseBtnClick);
			titleHB.addChild(closeBtn);
			
			contentVB = new UIVBox();
			contentVB.styleName = "uicanvas"
			contentVB.backgroundColor = 0xcccccc;
			contentVB.enabledPercentSize = true;
			contentVB.padding = 5;
			addChild(contentVB);
			
			x = StageManager.getMouseInNativeWinStage().stageWidth-width-100;
			y = 100
			
			addEventListener(Event.ADDED_TO_STAGE , onAddStage);
			visible = false;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			visible = false;
		}
		
		private function onAddStage(e:Event):void
		{
			this.stage.addEventListener(Event.MOUSE_LEAVE , onUp);
			//swapToUpLevel();
		}
		
		protected function get titles():String
		{
			return "";	
		}
		
		protected function addContent(d:DisplayObject):void
		{
			contentVB.addChild(d);
		}
		
		private function onDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			this.startDrag();
			swapToTop();
		}
		
		private function onUp(e:Event):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			this.stopDrag();
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			/*this.x = parent.width - this.width - 100;
			this.y = 100;*/
			swapToTop();
		}
		
	}
}