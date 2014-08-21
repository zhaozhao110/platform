package com.editor.d3.object
{
	import away3d.lights.LightBase;
	
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.editor.group.D3MapItemLight;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessLight;
	import com.editor.d3.view.attri.cell.renderer.D3ComLightItemRenderer;

	public class D3ObjectLight extends D3Object
	{
		public function D3ObjectLight(from:int)
		{
			super(from);
			proccess = new D3ProccessLight(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group2;
		}
		
		
		
		public var itemRenderer:D3ComLightItemRenderer;
		public var object:D3ObjectBase;
		public var selectedLight:LightBase;
		
		
		public function getLight():LightBase
		{
			if(proccess == null) return null;
			if(proccess.mapItem == null) return null;
			return D3MapItemLight(proccess.mapItem).getLight();
		}
		
	}
}
		