package com.editor.module_mapIso
{
	import com.editor.component.LogContainer;
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_mapIso.popview.MapInfoPopView;
	import com.editor.module_mapIso.popview.MapSmallImgPopView;
	import com.editor.module_mapIso.popview.MapSourceInfoPopView;
	import com.editor.module_mapIso.popview.MapSourcePopView;
	import com.editor.module_mapIso.popview.MouseInfoPopView;
	import com.editor.module_mapIso.view.MapEditorIsoTopContainer;
	import com.editor.module_mapIso.view.MapIsoBottomContainer;

	public class MapEditorIsoModule extends UICanvas
	{
		public function MapEditorIsoModule()
		{
			super();
			create_init();
		}
		
		public static const MODULENAME:String = "MapEditorIsoModule";
		
		public var topToolBar:MapEditorIsoTopContainer;
		public var botContainer:MapIsoBottomContainer;
		public var logContainer:LogContainer;
		public var mouseInfoPop:MouseInfoPopView;
		public var mapInfoPop:MapInfoPopView;
		public var smallImgPop:MapSmallImgPopView;
		public var sourcePop:MapSourcePopView;
		public var souceInfoPop:MapSourceInfoPopView;
		
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
			
			topToolBar = new MapEditorIsoTopContainer();
			vb.addChild(topToolBar);
			
			botContainer = new MapIsoBottomContainer();
			vb.addChild(botContainer);
			
			var lb:UILabel = new UILabel();
			lb.height = 23;
			lb.text = "右键取消操作，空格可以拖动地图"
			vb.addChild(lb);
			
			var pop_v:UICanvas = new UICanvas();
			pop_v.enabledPercentSize = true;
			addChild(pop_v);
			
			mouseInfoPop = new MouseInfoPopView();
			pop_v.addChild(mouseInfoPop);
			
			mapInfoPop = new MapInfoPopView();
			pop_v.addChild(mapInfoPop);
			
			smallImgPop = new MapSmallImgPopView();
			pop_v.addChild(smallImgPop);
			
			sourcePop = new MapSourcePopView();
			pop_v.addChild(sourcePop);
			
			souceInfoPop = new MapSourceInfoPopView();
			pop_v.addChild(souceInfoPop);
			
			logContainer = new LogContainer();
			addChild(logContainer);
		}
		
	}
}