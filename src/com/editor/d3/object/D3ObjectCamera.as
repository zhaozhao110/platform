package com.editor.d3.object
{
	import away3d.cameras.Camera3D;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.editor.group.D3MapItemCamera;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessCamera;

	public class D3ObjectCamera extends D3Object
	{
		public function D3ObjectCamera(from:int)
		{
			super(from);
			proccess = new D3ProccessCamera(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group14;
		}
		
		
		public var object:D3ObjectBase;
		public var selectedLight:Camera3D;
		
		public function getCamera():Camera3D
		{
			if(proccess == null) return null;
			if(proccess.mapItem == null) return null;
			return D3MapItemCamera(proccess.mapItem).getCamera();
		}
		
		public function get isGlobalCamera():Boolean
		{
			if(D3SceneManager.getInstance().displayList.globalCamera == null) return false;
			return this.uid == D3SceneManager.getInstance().displayList.globalCamera.uid;
		}
		
	}
}