package com.editor.d3.view.particle.prop.geometry.shape
{
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.particle.sub.GeometryObj;

	public class PropGeom_cube extends ParticleAttriCellBase
	{
		public function PropGeom_cube()
		{
			super();
			
			var a:Array = [];
			var d:D3ComAttriItemVO = new D3ComAttriItemVO();
			d.key = "width"
			d.value = "numericStepper"
			d.defaultValue = 5;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "height"
			d.value = "numericStepper"
			d.defaultValue = 5;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "depth"
			d.value = "numericStepper"
			d.defaultValue = 5;
			a.push(d);
			
			createCompByGroup(a);
		}
				
		override protected function getCompValue(d:D3ComBase):*
		{
			if(currAnimationData.data.geometry.shape.id != "CubeShapeSubParser") return null;
			var k:String = d.key;
			return currAnimationData.data.geometry.shape.getAttri(k);
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			saveObject()
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "CubeShapeSubParser"
			obj.data = {};
			obj.data.width = getAttri("width").getValue().data;
			obj.data.height = getAttri("height").getValue().data;
			obj.data.depth = getAttri("depth").getValue().data;
			return obj;
		}
		
		public function saveObject():void
		{
			if(currAnimationData == null) return ;
			currAnimationData.data.geometry.createShape(getObject());
		}
		
	}
}