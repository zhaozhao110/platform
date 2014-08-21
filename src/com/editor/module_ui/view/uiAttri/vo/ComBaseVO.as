package com.editor.module_ui.view.uiAttri.vo
{
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ComBaseVO implements IComBaseVO
	{
		public function ComBaseVO()
		{
		}
		
		private var _key:String;
		public function get key():String
		{
			return _key;
		}
		public function set key(value:String):void
		{
			_key = value;
		}

		private var _target:IComBase;
		public function set target(value:IComBase):void
		{
			_target = value;
		}
		public function get target():IComBase
		{
			return _target;
		}
				
		private var _value:*;
		public function get value():*
		{
			return _value;
		}
		public function set value(value:*):void
		{
			_value = value;
		}
		
		
		
		
		public function getCSSXML():String
		{
			var c:String = '<item key="'+key+'" '
			c += ' type="'+target.item.type+'">';
			c += '<![CDATA[';
			if(value is File){
				c += File(value).name;
			}else if(value is Array){
				c += (value as Array).join(";");
			}else{
				c += value;
			}
			c += ']]>'
			c += '</item>'
			return c;
		}
		
		public function getCSSFile():String
		{
			return "";
		}
		
		public function createCSSXML(d:CSSComponentData,a:Array):void
		{
			
		}
		
		protected function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		protected function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
	}
}