package theme.css.dataGrid
{
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;

	public class CSS_list3
	{
		
		public var alternatingItemColors:Array = [0xf8f8f8, 0xffffff];
		public var rowHeight:int = 23;
		
		public var itemRendererStyleName:String = "list_itemRendererStyleName2"
		public var paddingLeft:int = 4;
		public var paddingRight:int = 4; 
		public var paddingTop:int = 4;
		
		public var backgroundFilter:Array = [FilterTool.getDropShadowFilter()];
		
		public var borderStyle:String = "solid";
		public var borderColor:uint = ColorUtils.gray;
		
	}
}