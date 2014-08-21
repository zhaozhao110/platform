package com.editor.d3.vo.project
{
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;

	public class D3ProjectVO
	{
		public function D3ProjectVO()
		{
			
		}
		
		private static var _instance:D3ProjectVO;
		public static function get instance():D3ProjectVO
		{
			if(_instance == null){
				_instance = new D3ProjectVO();
			}
			return _instance;
		}
		
		private var attri_obj:Object;
		
		public function parse(s:String):void
		{
			attri_obj = JSON.parse(s);
			if(StringTWLUtil.isWhitespace(getAttri("defaultScene"))){
				setAttri("defaultScene","scene1");	
			}
		}
		
		public function setAttri(key:String,v:*):void
		{
			attri_obj[key] = v;
		}
		
		public function getAttri(key:String):*
		{
			return attri_obj[key];
		}
		
	}
}