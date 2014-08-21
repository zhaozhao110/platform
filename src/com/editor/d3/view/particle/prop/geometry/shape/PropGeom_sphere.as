package com.editor.d3.view.particle.prop.geometry.shape
{
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.particle.sub.GeometryObj;

	public class PropGeom_sphere extends ParticleAttriCellBase
	{
		public function PropGeom_sphere()
		{
			super();
			
			var a:Array = [];
			var d:D3ComAttriItemVO = new D3ComAttriItemVO();
			d.key = "radius"
			d.value = "numericStepper"
			d.defaultValue = 5;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "segmentsW"
			d.value = "numericStepper"
			d.defaultValue = 8;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "segmentsH"
			d.value = "numericStepper"
			d.defaultValue = 8;
			a.push(d);
			
			createCompByGroup(a);
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			if(currAnimationData.data.geometry.shape.id != "SphereShapeSubParser") return null;
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
			obj.id = "SphereShapeSubParser"
			obj.data = {};
			obj.data.radius = getAttri("radius").getValue().data;
			obj.data.segmentsW = getAttri("segmentsW").getValue().data;
			obj.data.segmentsH = getAttri("segmentsH").getValue().data;
			return obj;
		}
		
		public function saveObject():void
		{
			currAnimationData.data.geometry.createShape(getObject());
		}
	}
}