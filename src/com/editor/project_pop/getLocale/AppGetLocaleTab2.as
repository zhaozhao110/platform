package com.editor.project_pop.getLocale
{
	import com.air.io.SelectFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2Cache;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2_tab;
	import com.sandy.asComponent.controls.ASCalendar;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class AppGetLocaleTab2 extends UIVBox
	{
		public function AppGetLocaleTab2()
		{
			create_init()
		}
		
		public var tab1:AppGetLocaleTab2_tab;
		public var tab2:AppGetLocaleTab2_tab;
		public var tab3:AppGetLocaleTab2_tab;
		public var cal:ASCalendar;
		public var cal_cb:UICheckBox;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5;
			AppGetLocaleTab2Cache.getInstance().tab2 = this;
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 30;
			hb.verticalAlignMiddle = true
			hb.paddingLeft = 10;
			hb.horizontalGap = 10;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			var btn:UIButton = new UIButton();
			btn.label = "导入资源包配置文件"
			btn.addEventListener(MouseEvent.CLICK , onImportClick);
			hb.addChild(btn);
			
			btn = new UIButton();
			btn.label = "导入本地资源包配置文件"
			btn.addEventListener(MouseEvent.CLICK , onImportClick2);
			hb.addChild(btn);
			
			btn = new UIButton();
			btn.label = "保存配置文件"
			btn.addEventListener(MouseEvent.CLICK , onSaveClick);
			hb.addChild(btn);
			
			btn = new UIButton();
			btn.label = "复制打勾文件"
			btn.addEventListener(MouseEvent.CLICK , onSaveClick2);
			hb.addChild(btn);
			
			hb = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 50;
			hb.verticalAlignMiddle = true
			hb.paddingLeft = 10;
			hb.horizontalGap = 10;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			cal_cb = new UICheckBox();
			cal_cb.label = "筛选："
			hb.addChild(cal_cb);
			
			cal = new ASCalendar();
			hb.addChild(cal);
			cal.addEventListener(ASEvent.CHANGE,onCalChange)
				
			var lb:UILabel = new UILabel();
			lb.text = "如果选中筛选，当复制文件的时候，会选择在筛选的时间之后的文件"
			hb.addChild(lb);
			
			var tabNav:UITabBarNav = new UITabBarNav();
			tabNav.enabledPercentSize = true;
			addChild(tabNav);
			
			tab1 = new AppGetLocaleTab2_tab(1);
			tab1.label = "client"
			tab1.enabledPercentSize = true;
			tabNav.addChild(tab1);
			AppGetLocaleTab2Cache.getInstance().client_tab = tab1;
			
			tab2 = new AppGetLocaleTab2_tab(2);
			tab2.label = "config"
			tab2.enabledPercentSize = true;
			tabNav.addChild(tab2);
			AppGetLocaleTab2Cache.getInstance().config_tab = tab2;
			
			tab3 = new AppGetLocaleTab2_tab(3);
			tab3.label = "res"
			tab3.enabledPercentSize = true;
			tabNav.addChild(tab3);
			AppGetLocaleTab2Cache.getInstance().res_tab = tab3;
			
			tabNav.selectedIndex = 0
			
		}
		
		private function onImportClick(e:MouseEvent):void
		{
			var f:FileFilter = new FileFilter("lang", "*.lang;");
			SelectFile.select("资源包配置文件",[f],result_f)
		}
		
		private function result_f(e:Event):void
		{
			AppGetLocaleTab2Cache.getInstance().importc(e.target as File);
		}
		
		private function onImportClick2(e:MouseEvent):void
		{
			AppGetLocaleTab2Cache.getInstance().importc();
		}
		
		private function onSaveClick(e:MouseEvent):void
		{
			AppGetLocaleTab2Cache.getInstance().export();
			iManager.iPopupwin.showMessage("保存成功");
		}
		
		private function onSaveClick2(e:MouseEvent):void
		{
			AppGetLocaleTab2Cache.getInstance().copy();
		}
		
		private function onCalChange(e:ASEvent):void
		{
			
		}
		
	}
}