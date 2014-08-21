package com.editor.module_gdps.pop.dataManageCompare
{
	import com.editor.component.controls.UILabel;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class GdpsDataManageCompareRenderer extends SandyBoxItemRenderer
	{
		public function GdpsDataManageCompareRenderer()
		{
			super();
			
			create_init();
		}
		private var txt:UILabel;
		
		private function create_init():void
		{
			verticalAlign = "middle";
			horizontalAlign = "center";
			mouseChildren = true;
			height = 25;
			
			txt = new UILabel();
			//txt.enabledPercentSize = true;
			txt.textAlign = "center";
			txt.y = 4;
			addChild(txt);
			
			initComplete();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if(txt!=null) txt.width = value;
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			txt.text = value[this.dataField];
			
			if (Number(value.comType) === 2) //修改的行
			{
				setStyle("backgroundColor", 0x0080FF);
			}
			else if (Number(value.comType) === 1) //增加行
			{
				setStyle("backgroundColor", 0x00BB00);
			}
			else
			{
				if(listIndex % 2 == 1){
					setStyle("backgroundColor", 0xF8F8F8);
				}else{
					setStyle("backgroundColor", 0xFFFFFF);
				}
			}
		}
	}
}