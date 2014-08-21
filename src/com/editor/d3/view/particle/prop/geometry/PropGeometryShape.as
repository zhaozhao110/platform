package com.editor.d3.view.particle.prop.geometry
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.prop.geometry.shape.PropGeom_cube;
	import com.editor.d3.view.particle.prop.geometry.shape.PropGeom_cylinder;
	import com.editor.d3.view.particle.prop.geometry.shape.PropGeom_ext;
	import com.editor.d3.view.particle.prop.geometry.shape.PropGeom_plane;
	import com.editor.d3.view.particle.prop.geometry.shape.PropGeom_sphere;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;

	public class PropGeometryShape extends ParticleAttriCellBase
	{
		public function PropGeometryShape()
		{
			super();
			
		}
		
		public var cb:UICombobox;
		public var vs:UIViewStack;
		public var plane:PropGeom_plane;
		public var cube:PropGeom_cube;
		public var sphere:PropGeom_sphere;
		public var cylinder:PropGeom_cylinder;
		public var ext:PropGeom_ext;
		
		override protected function create_init():void
		{
			height = 200;
			percentWidth = 100;
			styleName = "uicanvas";
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "shape:"
			lb.width = 80;
			h.addChild(lb);
			
			cb = new UICombobox();
			cb.width =160;
			cb.height = 22;
			h.addChild(cb);
			cb.dataProvider = ["Plane","Cube","Sphere","Cylinder","External Model"]
			cb.addEventListener(ASEvent.CHANGE,onCBChange);
						
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
						
			plane = new PropGeom_plane();
			vs.addChild(plane);
			
			cube = new PropGeom_cube();
			vs.addChild(cube);
			
			sphere = new PropGeom_sphere();
			vs.addChild(sphere);
			
			cylinder = new PropGeom_cylinder();
			vs.addChild(cylinder);
			
			ext = new PropGeom_ext();
			vs.addChild(ext);
			
			cb.setSelectIndex(0,false);
			vs.selectedIndex = 0;
		}
		
		private function onCBChange(e:ASEvent):void
		{
			vs.selectedIndex = cb.selectedIndex;
			if(cb.selectedIndex != 4){
				if(cb.selectedIndex == 0){
					plane.saveObject();
				}else if(cb.selectedIndex == 1){
					cube.saveObject();
				}else if(cb.selectedIndex == 2){
					sphere.saveObject();
				}else if(cb.selectedIndex == 3){
					cylinder.saveObject();
				}
			}		   
		}
		
		override public function changeAnim():void
		{
			super.changeAnim()
			plane.changeAnim();
			cube.changeAnim();
			sphere.changeAnim();
			cylinder.changeAnim();
			ext.changeAnim();
			
			var obj:SubPropObj = currAnimationData.data.geometry.shape;
			if(obj.id == "CubeShapeSubParser"){
				cb.selectedIndex = 1;
			}else if(obj.id == "PlaneShapeSubParser"){
				cb.selectedIndex = 0
			}else if(obj.id == "SphereShapeSubParser"){
				cb.selectedIndex = 2
			}else if(obj.id == "CylinderShapeSubParser"){
				cb.selectedIndex = 3
			}else if(obj.id == "ExternalShapeSubParser"){
				cb.selectedIndex = 4
			}
		}
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			plane.changeComp(c);
			cube.changeComp(c);
			sphere.changeComp(c);
			cylinder.changeComp(c);
			ext.changeComp(c);
		}
		
		
	}
}