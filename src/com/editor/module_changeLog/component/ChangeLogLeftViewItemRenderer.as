package com.editor.module_changeLog.component
{
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ByteArrayUtil;

	public class ChangeLogLeftViewItemRenderer extends ASHListItemRenderer
	{
		public function ChangeLogLeftViewItemRenderer()
		{
			super()
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
		}
		
		override protected function setRendererLabel():void
		{
			label = Object(data).time;
		}
		
		//override protected function renderTextField():void{};
	}
}