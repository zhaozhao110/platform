package com.editor.d3.vo.group
{
	public class D3GroupListVO
	{
		public function D3GroupListVO(a:Array,_isParticle:Boolean=false)
		{
			isParticle = _isParticle
				
			for(var i:int=0;i<a.length;i++)
			{
				var d:D3GroupItemVO = new D3GroupItemVO(a[i]);
				group_ls[d.id.toString()] = d;
				map1[d.name] = d;
				if(d.enAdd){
					enAdd_ls.push(d);
				}
			}
		}
		
		public var map1:Array = [];
		public var enAdd_ls:Array = [];
		public var isParticle:Boolean;
		public var group_ls:Array = [];
		
		public function getItem(id:int):D3GroupItemVO
		{
			return group_ls[id.toString()] as D3GroupItemVO;	
		}
		
		public function getItemByName(s:String):D3GroupItemVO
		{
			return map1[s] as D3GroupItemVO;
		}
		
	}
}