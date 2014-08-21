package com.editor.d3.object
{
	import away3d.extrusions.Elevation;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.editor.group.D3MapItemTerrain;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessTerrain;

	public class D3ObjectTerrain extends D3Object
	{
		public function D3ObjectTerrain(from:int)
		{
			super(from);
			proccess = new D3ProccessTerrain(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
			D3SceneManager.getInstance().displayList.terrain = this;
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group3;
		}
		
		public function getElevation():Elevation
		{
			return D3ProccessTerrain(proccess).mapItem.getObject() as Elevation;
		}
		
		
	}
}