package com.editor.d3.view.attri.preview
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.SphereGeometry;
	import away3d.utils.Cast;
	
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.object.D3Object;
	import com.editor.manager.DataManager;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class MaterialPreview extends D3CompPreviewBase
	{
		public function MaterialPreview()
		{
			super();
		}
		
		override protected function get compType():String
		{
			return "material preview"
		}
		
		private var mesh:Mesh;
		
		override protected function get distance():int
		{
			return 450
		}
				
		override protected function initObject():void
		{
			var cubeGeometry:SphereGeometry = new SphereGeometry(220)
			bodyMaterial = new TextureMaterial();
			bodyMaterial.lightPicker = lightPicker;
			mesh = new Mesh(cubeGeometry, bodyMaterial);
			scene.addChild(mesh);
		}
		
		public function resetBodyMaterial():void
		{
			removeMaterial();
			bodyMaterial = new TextureMaterial();
			bodyMaterial.lightPicker = lightPicker;
			mesh.material = bodyMaterial;
		}
		
		override protected function onResize(event:Event = null):void
		{
			if(stage == null) return ;
			if(view == null) return ;
			view.width = this.width;
			view.height = this.height;
			this.x = stage.stageWidth-300-this.width-20;
			this.y = get_App3DMainUIContainerMediator().rightContainer.y;
		}
		
		/*override protected function onEnterFrame(event:Event):void
		{
			if (moveBool) {
				var pt:Point = getLocalPoint();
				mesh.rotationY = 0.3*(pt.x - lastMouseX)
				mesh.rotationX = 0.3*(pt.y - lastMouseY);
			}
			
			view.render();
		}*/
		
		
	}
}