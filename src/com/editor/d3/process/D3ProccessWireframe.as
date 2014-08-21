package com.editor.d3.process
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemWireframe;
	import com.editor.d3.object.D3ObjectGeometry;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectWireframe;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;

	public class D3ProccessWireframe extends D3ProccessObject
	{
		public function D3ProccessWireframe(d:D3ObjectWireframe)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group12;
		}
		
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			mapItem.createWireframe();
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemWireframe;
		}
		
	}
}