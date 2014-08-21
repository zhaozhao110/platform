package com.editor.popup2.texturepacker.component
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class UIPanel extends UICanvas
	{
		public function UIPanel()
		{
			super();
			this.borderStyle = ASComponentConst.borderStyle_solid;
			this.borderColor = 0x808080;
		}
		
	}
}