package com.editor.vo
{
	import com.sandy.math.ICacheData;
	import com.sandy.utils.ToolUtils;

	public class LocaleData implements ICacheData
	{
		public function LocaleData()
		{
		}
		
		public var key:String;
		public var value:String;
		public var filePath:String;
		
		public function toString():String
		{
			return key + "=" + value;
		}
		
		public function getId1():*
		{
			return key;	
		}
		public function getId2():*
		{
			return value;
		}
		public function getId3():*
		{
			return filePath;
		}
		
		public function cloneObject():*
		{
			var user:LocaleData = new LocaleData();	
			ToolUtils.clone(this,user);
			return user;
		}
	}
}