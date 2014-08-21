package com.editor.component.containers
{
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.SandyViewStack;
	
	public class UIViewStack extends SandyViewStack
	{
		public function UIViewStack()
		{
			super();
			creationPolicy = ASComponentConst.creationPolicy_all;
		}
	}
}