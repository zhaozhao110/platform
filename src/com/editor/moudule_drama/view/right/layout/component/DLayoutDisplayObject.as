package com.editor.moudule_drama.view.right.layout.component
{
	import com.editor.component.containers.UICanvas;

	public class DLayoutDisplayObject extends UICanvas
	{
		protected var _vo:Object;
		private var _ident:String;
		
		private var eventList:Array = [];
		public function DLayoutDisplayObject()
		{
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{ 
			eventList.push([type,listener,useCapture]);
			super.addEventListener(type,listener, useCapture, priority, useWeakReference) 
		} 
		
		public function get vo():Object
		{
			return _vo;
		}
		public function set vo(value:Object):void
		{
			_vo = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_vo = null;
			if(eventList == null) return ;
			var len:int = eventList.length;
			for(var i:uint=0;i<len;i++)
			{
				removeEventListener(eventList[i][0], eventList[i][1], eventList[i][2]);
			} 
			eventList = null;
			
			
		}
		
		/**ID**/
		public function get ident():String
		{
			var out:String = "";
			if(vo && vo.id)
			{
				out = String(vo.id);
			}else
			{
				out = _ident;
			}
			return out;
		}
		/**ID**/
		public function set ident(value:String):void
		{
			_ident = value;
		}
		
		
		
	}
}