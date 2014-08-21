package com.editor.module_ui.view.comList
{
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.resource.ResourceManager;
	
	import flash.display.Bitmap;

	public class UIEditorComListItemRenderer extends ASHListItemRenderer
	{
		public function UIEditorComListItemRenderer()
		{
			super();
			
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			toolTip = Object(value).toolTip;	
		}
				
		override public function checkDrag():Boolean
		{
			return true;
		}
		
		override protected function createDragProxy():Bitmap
		{
			if(icon!=null){
				var bit:Bitmap = new Bitmap(Bitmap(icon.content).bitmapData)
				return bit;
			}
			return null;
		}
		
		override protected function createDragSource():SandyDragSource
		{
			var ds:SandyDragSource = new SandyDragSource();
			ds.data = data;
			ds.type = DataManager.dragAndDrop_comList;
			return ds;
		}
		
	}
}