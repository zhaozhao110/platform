package com.editor.d3.view.attri.preview.itemRenderer
{
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.utils.FilterTool;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class MeshInfoListItemRenderer extends ASListItemRenderer
	{
		public function MeshInfoListItemRenderer()
		{
			super();
		}
		
		
		override protected function item_downHandle(e:MouseEvent):void
		{
			if(e.ctrlKey) return;
			super.item_downHandle(e);
		}
		
		override public function checkDrag():Boolean
		{
			return true;
		}
		
		override protected function createDragProxy():Bitmap
		{
			var b:Bitmap = screenshot();
			FilterTool.setGlow(b);
			return b;
		}
		
		override protected function createDragSource():SandyDragSource
		{
			var ds:SandyDragSource = new SandyDragSource();
			ds.data = data
			ds.type = DataManager.dragAndDrop_3d_meshInfo;
			return ds;
		}
		
		
	}
}