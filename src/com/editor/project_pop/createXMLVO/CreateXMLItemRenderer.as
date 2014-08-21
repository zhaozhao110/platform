package com.editor.project_pop.createXMLVO
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UITextInput;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.containers.ASDataGridRow;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class CreateXMLItemRenderer extends SandyBoxItemRenderer
	{
		public function CreateXMLItemRenderer()
		{
			super();
			
		}
		
		
		
		private var ti:UITextInput;
		private var isNum_cb:UICheckBox;
		
		override protected function __init__():void
		{
			super.__init__();
			
			mouseChildren = true;
			
			ti = new UITextInput();
			ti.height = 23;
			ti.addEventListener(ASEvent.CHANGE,onKeyDown);
			ti.enterKeyDown_proxy = onKeyDown;
			addChild(ti);
			
			isNum_cb = new UICheckBox();
			isNum_cb.label = "是数字"
			isNum_cb.y = 4;
			isNum_cb.addEventListener(ASEvent.CHANGE,onChange);
			isNum_cb.selected = false;
			addChild(isNum_cb);
		}
				
		private function onKeyDown(e:ASEvent=null):void
		{
			item[dataField] = ti.text;
			if(item.isGroup){
				if(dataField == "vo"){
					ParserXMLVOTool.instance.putGroup_vo(item.xml,ti.text);
				}
				if(dataField == "info"){
					ParserXMLVOTool.instance.putGroup_info(item.xml,ti.text);
				}
			}else{
				if(dataField == "vo"){
					ParserXMLVOTool.instance.putItem_vo(item.xml,ti.text);
				}
				if(dataField == "info"){
					ParserXMLVOTool.instance.putItem_info(item.xml,ti.text);
				}
			}
		}
		
		private var item:PaserXMLVO;
		
		private function onChange(e:ASEvent):void
		{
			if(item == null) return ;
			item.isNumber = isNum_cb.selected;
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			item = value as PaserXMLVO;
			if(item == null){
				ti.text = "";
				isNum_cb.selected = false
				return 
			}
			ti.text = item[dataField]
			if(dataField == "vo"){
				ti.width = 140;
				isNum_cb.visible = false;
			}else if(dataField == "info"){
				isNum_cb.visible = true
				ti.width = 190
				isNum_cb.x = 200;				
			}
			isNum_cb.selected = item.isNumber;
		}
		
		override public function poolDispose():void
		{
			super.poolDispose()
			if(ti == null) return ;
			item = null
			ti.text = "";
			isNum_cb.selected = false;
		}
		
		
	}
}