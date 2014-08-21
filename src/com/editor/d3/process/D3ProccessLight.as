package com.editor.d3.process
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemLight;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	
	import flash.geom.Vector3D;

	public class D3ProccessLight extends D3ProccessObject
	{
		public function D3ProccessLight(d:D3ObjectLight)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group2;
		}
		
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			mapItem.createLight();
			D3SceneManager.getInstance().displayList.addLight(comp as D3ObjectLight);
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.attriId == 72){
				//选中目标点
				(mapItem as D3MapItemLight).onDirectTargetMeshDown();
			}
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemLight;
		}
		
		
	}
}