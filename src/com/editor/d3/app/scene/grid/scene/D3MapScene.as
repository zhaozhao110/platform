package com.editor.d3.app.scene.grid.scene
{
	import com.d3.component.core.DisplayObject3D;

	public class D3MapScene extends DisplayObject3D
	{
		public function D3MapScene()
		{
			super();
		}
		
		public function removeAllItems():void
		{
			while(numChildren>0){
				getChildAt(0).dispose();
			}
		}
	}
	
}