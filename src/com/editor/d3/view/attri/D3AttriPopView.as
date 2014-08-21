package com.editor.d3.view.attri
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.sandy.asComponent.controls.ASPopupImage;

	public class D3AttriPopView extends UICanvas
	{
		public function D3AttriPopView()
		{
			super();
			padding = 2;
			enabledPercentSize = true
			create_init();				
		}
		public var cont:UICanvas;
		
		public function create_init():void
		{
			cont = new UICanvas();
			cont.enabledPercentSize = true;
			addChild(cont);
		}
		
	}
}