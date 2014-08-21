package com.editor.module_roleEdit.component{
	
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_roleEdit.mediator.PeopleImageDataGridMediator;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.sandy.component.expand.SandyReflashButton;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class PeopleImageTimelineItemRenderer extends SandyHBoxItemRenderer
	{
		public function PeopleImageTimelineItemRenderer()
		{
			super()
			create_init()
		}
		
		
		public var ti1:UITextInput;
		
		public var btn2:SandyReflashButton;
		public var typeLB:UILabel;
		
		//程序生成
		private function create_init():void
		{
			horizontalGap = 5;
			
			typeLB = new UILabel();
			typeLB.width = 100;
			addChild(typeLB);
			
			ti1 = new UITextInput();
			ti1.id="ti"
			ti1.addEventListener('change',function(e:*):void{change1();});
			ti1.restrict="0-9,/,\,"
			ti1.toolTip="格式1/9,2/9,3/9,4/9"
			ti1.width = 300
			addChild(ti1);
						
			btn2 = new SandyReflashButton();
			btn2.label="PNG合成并预览"
			//btn2.visible = false;
			btn2.id="btn2"
			btn2.addEventListener('click',function(e:*):void{clickHandle();});
			addChild(btn2);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		
		private var item:ActionData;
		private var lastValue:String = "";
		private var last_isupdate:String = "";
		
		
		override public function poolChange(dat:*):void
		{
			super.poolChange(dat);
			item = dat as ActionData;
			
			typeLB.text = item.type_str;
			ti1.text = item.timeline;
			
			lastValue = ti1.text;
			last_isupdate = item.isupdate;
			
			if(last_isupdate == "true"){
				setTextInputColor(0xcc0000);
				btn2.visible = true;
			}else{
				ti1.backgroundColor = null;
				btn2.visible = false;
			}
		}
		
		private function setTextInputColor(col:*):void
		{
			ti1.backgroundColor = col
		}
		
		private function clickHandle():void
		{
			get_PeopleImageDataGridMediator().compose(item)	
		}
		
		private function change1():void
		{
			item.timeline = ti1.text
			
			if(lastValue != ti1.text)
			{
				item.isupdate = "true";
				ti1.backgroundColor = 0xcc0000;
				btn2.visible = true;
			}
			else
			{
				item.isupdate = "false";
				ti1.backgroundColor = null;
				btn2.visible = false;
			}
			lastValue = ti1.text;
		}
		
		private function get_PeopleImageDataGridMediator():PeopleImageDataGridMediator
		{
			return iManager.retrieveMediator(PeopleImageDataGridMediator.NAME) as PeopleImageDataGridMediator
		}
	}
}