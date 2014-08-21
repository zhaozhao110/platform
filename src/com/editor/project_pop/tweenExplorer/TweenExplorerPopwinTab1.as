package com.editor.project_pop.tweenExplorer
{
	import com.air.component.SandyHtmlLoader;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UISwfLoader;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.utils.ColorUtils;

	public class TweenExplorerPopwinTab1 extends UIVBox
	{
		public function TweenExplorerPopwinTab1()
		{
			super();
			//create_init();
		}
		
		public var lb:UILabel;
		public var loader:SandyHtmlLoader;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			verticalGap = 10;
			padding = 5
			
			lb = new UILabel();
			lb.text = "以下功能都已经实现，请使用ASTween来替代TweenLite,用法都一样"
			lb.color = ColorUtils.red;
			lb.height = 25;
			addChild(lb);
			
			loader = new SandyHtmlLoader();
			loader.width = 555;
			loader.height = 520
			loader.loadURL(AppGlobalConfig.instance.config_hash.find("tween_swf"))
			addChild(loader);
			
			return true;
		}
		
		
	}
}