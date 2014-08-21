package com.editor.component.controls
{
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.SandyTabBar;
	
	public class UITabBar extends SandyTabBar
	{
		public function UITabBar()
		{
			super();
			creationPolicy = ASComponentConst.creationPolicy_all;
		}
	}
}