package com.editor.module_avg.popview.timeline.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.popview.timeline.AVGTimelineViewMediator;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASVListItemRenderer;
	
	import flash.events.MouseEvent;

	public class AVGTimelineViewItemRenderer extends ASListItemRenderer
	{
		public function AVGTimelineViewItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var txt1:UILabel;
		private var txt2:UILabel;
		private var cb:UICheckBox;
				
		private function create_init():void
		{			
			height = 50;
						
			cb = new UICheckBox();
			cb.label = " "
			cb.y = 20;
			cb.x = 2;
			addChild(cb);
						
			txt1 = new UILabel();
			txt1.width = 200;
			txt1.x = 55;
			txt1.y = 5;
			addChild(txt1);
			
			txt2 = new UILabel();
			txt2.x = 55;
			txt2.y = 26;
			txt2.width = 200;
			addChild(txt2);
			
			//addEventListener(MouseEvent.RIGHT_CLICK , onRightClick);
		}
		
		public var frame:AVGFrameItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			frame = value as AVGFrameItemVO;
			txt1.text = "index:" + frame.index + " / " + frame.peoName + " / 选项:" + frame.opts_ls.length;
			txt2.text = frame.content;
			
			if(AVGManager.currFrame!=null){
				if(AVGManager.currFrame == frame){
					dispatchSelect(true);
				}
			}
		}
		
		override public function select():void
		{
			super.select();
			cb.selected = true
		}
		
		override public function noSelect():void
		{
			super.noSelect()
			cb.selected = false;
		}
		
		private function onRightClick(e:MouseEvent):void
		{
			get_AVGTimelineViewMediator().delFrame(frame);
		}
		
		private function get_AVGTimelineViewMediator():AVGTimelineViewMediator
		{
			return iManager.retrieveMediator(AVGTimelineViewMediator.NAME) as AVGTimelineViewMediator;
		}
	}
}