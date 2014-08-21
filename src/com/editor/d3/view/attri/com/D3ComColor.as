package com.editor.d3.view.attri.com
{
	import com.sandy.asComponent.controls.ASColorPickerBar;
	import com.sandy.asComponent.event.ASEvent;

	public class D3ComColor extends D3ComBase
	{
		public function D3ComColor()
		{
			super();
		}
		
		private var col:ASColorPickerBar;
		
		override protected function create_init():void
		{
			super.create_init();
			
			col = new ASColorPickerBar();
			col.width = 120;
			col.height = 22;
			col.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(col);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			callUIRender();
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = new D3ComBaseVO();
			d.data = col.selectedColor;
			return d;
		}
		
		override public function setValue():void
		{
			super.setValue();
			col.setColor(getCompValue(),false);
		}
		
		
	}
}