package com.editor.module_ui.ui
{
	import com.editor.module_ui.ui.vo.OutlineData;
	import com.editor.module_ui.vo.ComponentData;
	import com.sandy.asComponent.core.ASComponent;

	public class GetUIOutline
	{
		private static var _instance:GetUIOutline;
		public static function get instance():GetUIOutline
		{
			if(_instance == null){
				_instance = this;
			}
			return _instance;
		}
		
		public var outline_ui:OutlineData;
		
		//{branch: * , leaf: [  ]}
		public function outline(ui:ASComponent):void
		{
			var len:int = ui.numChildren;
			outline_ui = ui;
			for(var i:int=0;i<len;i++)
			{
				var c_ui:ASComponent = ui.getChildAt(i) as ASComponent;
				if(c_ui.data == ComponentData){
					outline_ui.add(c_ui);
					
				}
			}
		}
	}
}