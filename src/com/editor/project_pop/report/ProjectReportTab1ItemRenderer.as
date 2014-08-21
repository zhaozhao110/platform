package com.editor.project_pop.report
{
	import com.asparser.Field;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.TimerUtils;
	
	import flash.filesystem.File;
	
	public class ProjectReportTab1ItemRenderer extends ASHListItemRenderer
	{
		public function ProjectReportTab1ItemRenderer()
		{
			super();
		}
		
		private var item:Field;
		
		override public function get label():String
		{
			if(item == null) return "";
			return item.filenam + "/ row: " + (item.index+1)
		}
		
		override public function get color():*
		{
			return ColorUtils.black;
		}
		
		override public function poolChange(value:*):void
		{
			item = value as Field;
			super.poolChange(value);
			
			mouseEnabled = true;
			
			var fl:File = new File(item.filePath);
			if(fl.exists){
				toolTip = item.filePath + "<br>" + TimerUtils.getFromatTime(fl.modificationDate.time/1000);
			}
			
		}
		
				
	}
}