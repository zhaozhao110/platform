package com.editor.d3.object
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.process.D3ProccessWireframe;

	public class D3ObjectWireframe extends D3Object
	{
		public function D3ObjectWireframe(from:int)
		{
			super(from);
			proccess = new D3ProccessWireframe(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group12;
		}
		
		
	}
}