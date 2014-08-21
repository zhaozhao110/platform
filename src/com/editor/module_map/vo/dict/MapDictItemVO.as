package com.editor.module_map.vo.dict
{
	import com.sandy.utils.interfac.ICloneInterface;
	
	public class MapDictItemVO implements ICloneInterface
	{
		public function MapDictItemVO(p:XML=null)
		{
			if(p!=null)
			{
				c   = p.@c;
				v   = p.@v;
				d	= p.text();
			}
		}
		
		public var c:String = ""; 
		public var v:String = ""; 
		public var d:String = "";
		
		public function getKey():*
		{
			return c
		}
		
		public function getValue():*
		{
			return v;
		}
		
		public function getInfo():*
		{
			return d; 
		}
		
		public function cloneObject():*
		{
			var it:MapDictItemVO = new MapDictItemVO();
			it.c = c;
			it.v = v;
			it.d = d;
			return it;
		}
				
	}
}