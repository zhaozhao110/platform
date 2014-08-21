package com.editor.project_pop.addScout
{
	import flash.events.ErrorEvent;
	import flash.filesystem.File;

	public class AddScoutTool
	{
		public function AddScoutTool()
		{
		}
		
		public var addTelemetryTag:Boolean=true;
		public var addLog:Function;
		
		public function processFile(file:File):String
		{
			try
			{
				var swfTagHelper:SWFTagHelper = new SWFTagHelper(file, addTelemetryTag);
				swfTagHelper.addEventListener(ErrorEvent.ERROR, errorHandler);
				var success:String = swfTagHelper.process("_scout","");
				return success;
			}
			catch (error:Error)
			{
				return "";
			}
			return "";
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			addLog(event.text);
		}
		
	}
}