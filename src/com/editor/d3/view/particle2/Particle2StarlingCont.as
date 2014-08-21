package com.editor.d3.view.particle2
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UISwfLoader;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.LoadContextUtils;
	
	import flash.display.Loader;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class Particle2StarlingCont extends UICanvas
	{
		public function Particle2StarlingCont()
		{
			super();
			create_init();
		}
		
		private var swfLoader:HTMLLoader;
		
		private function create_init():void
		{
			backgroundColor = ColorUtils.black;
			enabledPercentSize = true;
			styleName = "uicanvas"
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
				
			var c:UICanvas = new UICanvas();
			c.width = 1408;
			c.height = 796;
			addChild(c);
			
			swfLoader = new HTMLLoader();
			swfLoader.width = 1400;
			swfLoader.height = 790;
			c.addChild(swfLoader);
		}
		
		public function load():void
		{
			swfLoader.load(new URLRequest(get_AppConfigProxy().config_hash.find("starlingParticle")));
		}
		
		private function get_AppConfigProxy():AppGlobalConfig
		{
			return AppGlobalConfig.instance;
		}
	}
}