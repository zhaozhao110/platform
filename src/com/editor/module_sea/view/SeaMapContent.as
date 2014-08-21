package com.editor.module_sea.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_sea.popview.SeaMapInfoPopview;
	import com.editor.module_sea.popview.SeaMapLevelPopview;
	import com.editor.module_sea.popview.SeaMapLibPopview;
	import com.editor.module_sea.popview.SeaMapMouseInfoPopView;
	import com.editor.module_sea.popview.SeaMapResListPopview;
	import com.editor.module_sea.popview.SeaMapSmallImgPopView;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class SeaMapContent extends UICanvas
	{
		public function SeaMapContent()
		{
			super();
			create_init();
		}
		
		public var popCont:UICanvas
		public var mapEditOutCanvas:UICanvas
		public var mapEditCanvas:UICanvas
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			
			mapEditOutCanvas = new UICanvas();
			mapEditOutCanvas.mouseChildren  =true;
			mapEditOutCanvas.mouseEnabled = true;
			mapEditOutCanvas.enabledPercentSize = true;
			mapEditOutCanvas.verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			mapEditOutCanvas.horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			addChild(mapEditOutCanvas);
			
			mapEditCanvas = new UICanvas();
			mapEditCanvas.mouseChildren = true;
			mapEditCanvas.mouseEnabled = true;
			mapEditOutCanvas.addChild(mapEditCanvas);
			
			popCont = new UICanvas();
			/*popCont.mouseChildren = true;
			popCont.mouseEnabled = true;*/
			popCont.enabledPercentSize = true
			addChild(popCont);
			
			addPopviews()
		}
		
		private function addPopviews():void
		{
			var info:SeaMapInfoPopview = new SeaMapInfoPopview();
			popCont.addChild(info);
			
			var level:SeaMapLevelPopview = new SeaMapLevelPopview();
			popCont.addChild(level);
			
			var lib:SeaMapLibPopview = new SeaMapLibPopview();
			popCont.addChild(lib);
			
			var small:SeaMapSmallImgPopView = new SeaMapSmallImgPopView();
			popCont.addChild(small);
			
			var mouse:SeaMapMouseInfoPopView = new SeaMapMouseInfoPopView();
			popCont.addChild(mouse);
			
			var resList:SeaMapResListPopview = new SeaMapResListPopview();
			popCont.addChild(resList);
		}
		
		
		
	}
}