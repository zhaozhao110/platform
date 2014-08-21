package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class TabNavViewBox extends UICanvas
	{
		public function TabNavViewBox()
		{
			super();
		}
		
		
		
		override public function delay_init():Boolean
		{
			return true;
		}
		
		public var fileURL:String;
		
		public function getClassName():String
		{
			var val:String = fileURL.split(".")[0];
			var a:Array = val.split(File.separator);
			return a[a.length-1];
		}
		
		public function check():Boolean
		{
			if(StringTWLUtil.isWhitespace(label)) return false
			if(StringTWLUtil.isWhitespace(fileURL)) return false
			return true;
		}
		
	}
}