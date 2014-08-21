package com.editor.module_map2
{
	import com.editor.component.LogContainer;
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_map2.popview.MapInfoPopView2;
	import com.editor.module_map2.popview.MapSmallImgPopView2;
	import com.editor.module_map2.popview.MapSourceInfoPopView2;
	import com.editor.module_map2.popview.MapSourcePopView2;
	import com.editor.module_map2.popview.MouseInfoPopView2;
	import com.editor.module_map2.view.MapEditor2BottomContainer;
	import com.editor.module_map2.view.MapEditor2TopContainer;
	

	public class MapEditor2Module extends UICanvas
	{
		public function MapEditor2Module()
		{
			super();
			create_init();
		}
		
		public static const MODULENAME:String = "MapEditor2Module";
		
		public var topToolBar:MapEditor2TopContainer;
		public var botContainer:MapEditor2BottomContainer;
		public var logContainer:LogContainer;
		public var mouseInfoPop:MouseInfoPopView2;
		public var mapInfoPop:MapInfoPopView2;
		public var smallImgPop:MapSmallImgPopView2;
		public var sourcePop:MapSourcePopView2;
		public var souceInfoPop:MapSourceInfoPopView2;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding = 10;
			mouseEnabled = true
			
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			vb.verticalGap = 5;
			addChild(vb);
			
			topToolBar = new MapEditor2TopContainer();
			vb.addChild(topToolBar);
			
			botContainer = new MapEditor2BottomContainer();
			vb.addChild(botContainer);
			
			var lb:UILabel = new UILabel();
			lb.height = 23;
			lb.text = "右键取消操作，空格可以拖动地图"
			vb.addChild(lb);
			
			var pop_v:UICanvas = new UICanvas();
			pop_v.enabledPercentSize = true;
			addChild(pop_v);
			
			mouseInfoPop = new MouseInfoPopView2();
			pop_v.addChild(mouseInfoPop);
			
			mapInfoPop = new MapInfoPopView2();
			pop_v.addChild(mapInfoPop);
			
			smallImgPop = new MapSmallImgPopView2();
			pop_v.addChild(smallImgPop);
			
			sourcePop = new MapSourcePopView2();
			pop_v.addChild(sourcePop);
			
			souceInfoPop = new MapSourceInfoPopView2();
			pop_v.addChild(souceInfoPop);
			
			logContainer = new LogContainer();
			addChild(logContainer);
		}
		
	}
}