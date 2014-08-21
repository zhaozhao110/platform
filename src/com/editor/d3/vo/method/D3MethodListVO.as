package com.editor.d3.vo.method
{
	import com.sandy.math.HashMap;

	public class D3MethodListVO
	{
		public function D3MethodListVO(a:Array,_isParticle:Boolean=false)
		{
			for(var i:int=0;i<a.length;i++)
			{
				var d:D3MethodItemVO = new D3MethodItemVO(a[i]);
				all_ls.push(d);
				method_map.put(d.id.toString(),d);
				if(d.groups == "method"){
					method_ls.push(d);	
				}else if(d.groups == "camera"){
					camera_ls.push(d);
				}
			}
		}
		
		public var method_map:HashMap = new HashMap();
		private var all_ls:Array = [];
		public var method_ls:Array = [];
		public var camera_ls:Array = [];
		
		public function getItemById(d:int):D3MethodItemVO
		{
			return method_map.find(d.toString());
		}
		
		
	}
}