package com.editor.component.controls
{
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.SandyTabNavigator;
	
	public class UITabBarNav extends SandyTabNavigator
	{
		public function UITabBarNav()
		{
			super();
			creationPolicy = ASComponentConst.creationPolicy_all;
		}
		
		override public function set mouseChildren(enable:Boolean):void
		{
			super.mouseChildren = enable;
			if(!mouseChildren && !mouseEnabled){
				setEnabledEffect()
			}else{
				alpha = cache_alpha;
			}
		}
		
		private var cache_alpha:Number=1;
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			if(value != .51){
				cache_alpha = alpha;
			}
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
			if(!mouseChildren && !mouseEnabled){
				setEnabledEffect()
			}else{
				alpha = cache_alpha;
			}
		}
		
		protected function setEnabledEffect():void
		{
			alpha = .51;
		}
		
	}
}