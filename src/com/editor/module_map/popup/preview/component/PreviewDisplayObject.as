package com.editor.module_map.popup.preview.component
{
	import com.editor.component.containers.UICanvas;

	public class PreviewDisplayObject extends UICanvas
	{
		private var eventList:Array = [];
		public function PreviewDisplayObject()
		{
			super();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{ 
			eventList.push([type,listener,useCapture]);
			super.addEventListener(type,listener, useCapture, priority, useWeakReference) 
		} 
		
		override public function dispose():void
		{
			super.dispose();
			
			var len:int = eventList.length;
			for(var i:uint=0;i<len;i++)
			{
				removeEventListener(eventList[i][0], eventList[i][1], eventList[i][2]);
			} 
			eventList = null;
			
			
		}
		
		
	}
}