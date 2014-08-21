package com.editor.project_pop.getLocale.component
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2_tab;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class AppGetLocaleSelectHeadRenderer extends ASHListItemRenderer
	{
		public function AppGetLocaleSelectHeadRenderer()
		{
			super();
			horizontalAlign = ASComponentConst.horizontalAlign_center;
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var select_cb:UICheckBox;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = false;
			select_cb = new UICheckBox();
			select_cb.label = "全/不选中"
			select_cb.addEventListener(ASEvent.CHANGE,onSelectChange)
			addChild(select_cb);
		}
		
		private function onSelectChange(e:ASEvent):void
		{
			get_AppGetLocaleTab2_tab().onSelectChange(select_cb.selected);
		}
		
		private function get_AppGetLocaleTab2_tab():AppGetLocaleTab2_tab
		{
			return AppGetLocaleTab2_tab(uiowner.uiowner);
		}
	}
}