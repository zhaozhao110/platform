package com.editor.d3.view.particle.prop.material
{
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.particle.SubPropObj;

	public class PropColorMaterial extends ParticleAttriCellBase
	{
		public function PropColorMaterial()
		{
			super();
		}
		
		public var cell:PropMaterialCell;
		
		override protected function create_init():void
		{
			super.create_init();
			
			var b:Array = D3ComponentProxy.getInstance().particle_group_ls.getItem(3).expend1.split(",");
			var a:Array = D3ComponentProxy.getInstance().particle_attri_ls.getArray(b);
			createCompByGroup(a);
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			saveObject()
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			if(currAnimationData.data.material.id != "ColorMaterialSubParser") return null;
			var k:String = d.key;
			return currAnimationData.data.material.getAttri(k);
		}
		
		public function getObject():SubPropObj
		{
			var obj:SubPropObj = new SubPropObj();
			obj.id = "ColorMaterialSubParser"
			obj.data = {};
			for each(var d:D3ComBase in attri_ls){
				obj.data[d.key] = d.getValue().data;
			}
			return obj;
		}
		
		public function saveObject():void
		{
			if(cell.isReseting) return ;
			currAnimationData.data.material = null;
			currAnimationData.data.material = getObject();
		}
		
	}
}