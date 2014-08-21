package com.editor.module_code.view.search
{
	import com.asparser.Field;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;

	public class CodeSearchViewItemRenderer extends ASHListItemRenderer
	{
		public function CodeSearchViewItemRenderer()
		{
			super();
		}
		
		override protected function renderTextField():void{};
		
		private var lb:UILabel;
		
		override protected function __init__():void
		{
			super.__init__();
			
			mouseEnabled = true;
			
			lb = new UILabel();
			addChild(lb);
		}
		
		private var f:Field;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			f = value as Field;
			if(f == null){
				lb.text = "";
				return ;
			}
			
			lb.text = f.filenam + "/有"+f.search_ls.length+"处";
			this.toolTip = f.getSearchToolTip();
		}
		
		
	}
}