package com.editor.module_sql.view
{
	import com.editor.component.controls.UICheckBox;
	import com.sandy.asComponent.core.ASComponent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class PKCheckBoxLock extends UICheckBox
	{
		public function PKCheckBoxLock()
		{
			super()
			create_init()
		}



		//程序生成
		private function create_init():void
		{

			//主文件的属性
			this.label="Lock"
			this.selected=true
			this.addEventListener('click',function(e:*):void{ targetComp.enabled = !selected;});

			//dispatchEvent creationComplete
			initComplete();
		}

			public var targetComp:ASComponent;
						
		
	}
}