package com.editor.d3.view.particle.prop.geometry.shape
{
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.particle.sub.GeometryObj;

	public class PropGeom_cylinder extends ParticleAttriCellBase
	{
		public function PropGeom_cylinder()
		{
			super();
			
			var a:Array = [];
			var d:D3ComAttriItemVO = new D3ComAttriItemVO();
			d.key = "topRadius"
			d.value = "numericStepper"
			d.defaultValue = 50;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "bottomRadius"
			d.value = "numericStepper"
			d.defaultValue = 50;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "height"
			d.value = "numericStepper"
			d.defaultValue = 200;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "segmentsW"
			d.value = "numericStepper"
			d.defaultValue = 10;
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "topClosed"
			d.value = "boolean"
			a.push(d);
			
			d = new D3ComAttriItemVO();
			d.key = "bottomClosed"
			d.value = "boolean"
			a.push(d);
			
			createCompByGroup(a);
			
		}
		
		
		override protected function getCompValue(d:D3ComBase):*
		{
			if(currAnimationData.data.geometry.shape.id != "CylinderShapeSubParser") return null;
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
			obj.id = "CylinderShapeSubParser"
			obj.data = {};
			obj.data.topRadius = getAttri("topRadius").getValue().data;
			obj.data.bottomRadius = getAttri("bottomRadius").getValue().data;
			obj.data.height = getAttri("height").getValue().data;
			obj.data.segmentsW = getAttri("segmentsW").getValue().data;
			obj.data.topClosed = getAttri("topClosed").getValue().data;
			obj.data.bottomClosed = getAttri("bottomClosed").getValue().data;
			return obj;
		}
		
		public function saveObject():void
		{
			currAnimationData.data.geometry.createShape(getObject());
		}
	}
}