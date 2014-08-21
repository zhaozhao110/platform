package com.editor.project_pop.sharedobject
{
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.StringTWLUtil;

	public class SharedObjectItemRenderer extends SandyHBoxItemRenderer
	{
		public function SharedObjectItemRenderer()
		{
			super();
			create_init();
		}
		
		private var lb:UILabel;
		private var ti:UITextInput;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			
			lb = new UILabel();
			lb.width = 200;
			addChild(lb);
			
			ti = new UITextInput();
			ti.width = 230;
			ti.height = 23;
			addChild(ti);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			lb.text = Object(data).key;
			ti.text = StringTWLUtil.removeNewlineChar(Object(data).content);
		}
	}
}