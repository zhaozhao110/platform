package com.editor.d3.app.view.ui.middle
{
	import com.editor.component.containers.UICanvas;
	import com.editor.d3.app.view.ui.left.App3DLeftContainer;

	public class App3DSceneContainer extends UICanvas
	{
		public function App3DSceneContainer()
		{
			super();
			create_init()
		}
				
		
		private function create_init():void
		{
			enabledPercentSize = true;			
		}
	}
}