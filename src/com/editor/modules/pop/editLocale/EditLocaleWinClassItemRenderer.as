package com.editor.modules.pop.editLocale
{
	import com.asparser.Field;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ColorUtils;

	public class EditLocaleWinClassItemRenderer extends ASHListItemRenderer
	{
		public function EditLocaleWinClassItemRenderer()
		{
			super();
		}
		
		private var item:Field;
		
		override public function get label():String
		{
			if(item == null) return "";
			return item.toString()
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
			toolTip = ProjectCache.getInstance().getOppositePath(item.filePath);
		}
		
		
		
	}
}