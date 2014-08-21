package com.editor.module_avg.preview
{
	import com.sandy.asComponent.core.ASComponentResponder;

	public class AVGPreviewItemResponder extends ASComponentResponder
	{
		public function AVGPreviewItemResponder(pItem:AVGPreviewItem)
		{
			previewItem = pItem;
			y_change = yChange;
			x_change = xChange;
		}
		
		private var previewItem:AVGPreviewItem;
		
		private function yChange():void
		{
			previewItem.resData.putAttri("y",previewItem.getDisplayObject().y);
			previewItem.reflashAttri();
		}
		
		private function xChange():void
		{
			previewItem.resData.putAttri("x",previewItem.getDisplayObject().x);
			previewItem.reflashAttri();	
		}
				
	}
}