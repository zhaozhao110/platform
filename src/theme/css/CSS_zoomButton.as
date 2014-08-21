package theme.css
{
	public class CSS_zoomButton
	{
		[Embed("/theme/img/button/C_ZoomMode_md_up.png")]
		public var upSkin:Class;
		[Embed("/theme/img/button/C_ZoomMode_md_down_Mac.png")]
		public var overSkin:Class;  
		[Embed("/theme/img/button/C_ZoomMode_md_down.png")]
		public var downSkin:Class;
		[Embed("/theme/img/button/C_ZoomMode_md_down.png")]
		public var disabledSkin:Class;
		
		public var width:int = 24;
		public var height:int = 24;
	}
}