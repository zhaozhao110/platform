package com.editor.component.containers
{
	import com.sandy.component.containers.SandyHBox;
	
	public class UIHBox extends SandyHBox
	{
		public function UIHBox()
		{
			super();
			//clipContent = true;
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