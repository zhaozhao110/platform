package com.editor.module_html.vo
{
	public class OpenWebPageData
	{
		public function OpenWebPageData()
		{
		}
		
		public var webURL:String;
		/**
		 * 1: self;
		 * 2: blank
		 */ 
		public var target:int = 2;
		
		public static const OPENWEB_SELF:int = 1;
		public static const OPENWEB_BLANK:int = 2;
	}
}