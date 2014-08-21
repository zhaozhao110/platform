package com.editor.module_avg.pop
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.mediator.AVGModuleMediator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AVGPopViewBase extends UICanvas
	{
		public function AVGPopViewBase()
		{
			super();
			create_init();
		}
		
		protected function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			/*verticalCenter = 0;
			horizontalCenter = 0;*/
			width = 450;
			height = 300;
			backgroundColor = DataManager.def_col;
			styleName = "uicanvas"
			
			var h:UIHBox = new UIHBox();
			h.styleName = "uicanvas"
			h.height = 30;
			h.verticalAlignMiddle = true;
			h.percentWidth = 100;
			h.paddingLeft = 10;
			h.horizontalGap = 10;
			addChild(h);
			h.mouseEnabled = true
			h.addEventListener(MouseEvent.MOUSE_DOWN,onDownHandle);
			
			var lb:UILabel = new UILabel();
			lb.text = poptitle
			//lb.enabledFliter = true;
			//lb.bold = true;
			lb.fontSize = 16;
			h.addChild(lb);
			
			var btn:UIButton = new UIButton();
			btn.label = "关闭"
			btn.addEventListener(MouseEvent.CLICK , onCloseHandle);
			h.addChild(btn);
			
			contentBox = new UIVBox();
			contentBox.width = 444;
			contentBox.height = 262;
			contentBox.styleName = "uicanvas"
			contentBox.y = 33;
			contentBox.x = 2;
			contentBox.paddingTop = 10;
			contentBox.paddingLeft = 10;
			contentBox.verticalGap = 5;
			addChild(contentBox);
			
			addEventListener(Event.ADDED_TO_STAGE , onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			this.x = parent.width/2-this.width/2;
			this.y = parent.height/2-this.height/2;
		}
		
		protected var contentBox:UIVBox;
		
		protected function addContentChild(d:DisplayObject):void
		{
			contentBox.addChild(d);
		}
		
		protected function createHBox():UIHBox
		{
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.verticalAlignMiddle = true;
			h.percentWidth = 100;
			h.horizontalGap = 10;
			addContentChild(h);
			return h
		}
		
		protected function get poptitle():String
		{
			return "";
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP , onUpHandle);
			this.startDrag();
		}
		
		private function onUpHandle(e:MouseEvent=null):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP , onUpHandle);
			this.stopDrag();
		}
		
		protected function onCloseHandle(e:MouseEvent):void
		{
			onUpHandle();
			visible = false;
		}
		
		protected function get_AVGModuleMediator():AVGModuleMediator
		{
			return iManager.retrieveMediator(AVGModuleMediator.NAME) as AVGModuleMediator;
		}
	}
}