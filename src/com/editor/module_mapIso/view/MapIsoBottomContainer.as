package com.editor.module_mapIso.view
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class MapIsoBottomContainer extends UICanvas
	{
		public function MapIsoBottomContainer()
		{
			super();
			create_init();
		}
		
		public var mapEditOutCanvas:UICanvas;
		public var mapEditCanvas:UICanvas;
		
		private function create_init():void
		{
			styleName = "uicanvas";
			enabledPercentSize = true;
			mouseEnabled = true;
			
			mapEditOutCanvas = new UICanvas();
			mapEditOutCanvas.x = 10;
			mapEditOutCanvas.mouseEnabled = false;
			mapEditOutCanvas.mouseEnabled = true
			mapEditOutCanvas.verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			mapEditOutCanvas.horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			mapEditOutCanvas.enabledPercentSize = true;
			addChild(mapEditOutCanvas);
			
			mapEditCanvas = new UICanvas();
			mapEditCanvas.mouseEnabled = true;
			mapEditOutCanvas.addChild(mapEditCanvas);
		}
		
	}
}