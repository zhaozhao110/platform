package com.editor.module_sql.component
{
	import com.editor.component.controls.UIButton;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class IndicesViewItemRenderer extends SandyBoxItemRenderer
	{
		public function IndicesViewItemRenderer()
		{
			super();
			
			var button44:UIButton = new UIButton();
			button44.label="X"
			button44.addEventListener('click',function(e:*):void{removeIndex(data);});
			addChild(button44);
		}
		
		private function removeIndex(d:*=null):void
		{
			
		}
	}
}