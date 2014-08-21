package com.editor.d3.editor.group
{
	import away3d.containers.ObjectContainer3D;
	
	import com.d3.component.core.DisplayObject3D;
	import com.editor.d3.editor.D3EditorMapItem;

	public class D3MapItemObject extends D3EditorMapItem
	{
		public function D3MapItemObject()
		{
			super();
			createDisplay()
		}
		
		override public function getObject():ObjectContainer3D
		{
			createDisplay();
			return cont
		}
		
		protected var cont:DisplayObject3D;
		
		private function createDisplay():void
		{
			if(objectParent == null) return ;
			if(cont == null){
				cont = new DisplayObject3D();
				objectParent.addChild(cont);
				reflashMeshInfo()
				addListener()
			}
		}
				
		public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			createDisplay()
			return cont.addChild(child);
		}
		
		public function removeChild(child:ObjectContainer3D):void
		{
			createDisplay()
			cont.removeChild(child);
		}
		
		public function removeChildAt(index:uint):void
		{
			cont.removeChildAt(index);
		}
		
		public function getChildAt(index:uint):ObjectContainer3D
		{
			return cont.getChildAt(index);
		}
		
		
	}
}