package com.editor.d3.vo.comp
{
	import com.sandy.utils.StringTWLUtil;

	public class D3CompListVO
	{
		public function D3CompListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++)
			{
				var d:D3CompItemVO = new D3CompItemVO(a[i]);
				comp_ls.push(d);
				if(!StringTWLUtil.isWhitespace(d.en)){
					if(en_ls.indexOf(d.en)==-1){
						en_ls.push(d.en);
					}
				}
			}
		}
		
		public var comp_ls:Array = [];
		public var en_ls:Array = [];

		public function getItemByName(t:String):D3CompItemVO
		{
			for(var i:int=0;i<comp_ls.length;i++){
				var d:D3CompItemVO = comp_ls[i] as D3CompItemVO;
				if(d.name == t){
					return d;
				}
			}
			return null;
		}
		
		public function getItemByGroup1(g:int):D3CompItemVO
		{
			for(var i:int=0;i<comp_ls.length;i++){
				var d:D3CompItemVO = comp_ls[i] as D3CompItemVO;
				if(d.group == g){
					return d;
				}
			}
			return null;
		}
		
		public function getItemByEN(t:String):D3CompItemVO
		{
			for(var i:int=0;i<comp_ls.length;i++){
				var d:D3CompItemVO = comp_ls[i] as D3CompItemVO;
				if(d.en == t){
					return d;
				}
			}
			return null;
		}
		
		public function getItemById(d:int):D3CompItemVO
		{
			for(var i:int=0;i<comp_ls.length;i++){
				var c:D3CompItemVO = comp_ls[i] as D3CompItemVO;
				if(c.id == d){
					return c;
				}
			}
			return null;
		}
	}
}