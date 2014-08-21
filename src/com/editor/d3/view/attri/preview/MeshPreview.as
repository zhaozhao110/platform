package com.editor.d3.view.attri.preview
{
	import away3d.animators.nodes.SkeletonClipNode;
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
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemMesh;
	import com.editor.d3.editor.group.D3MapItemObject;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.manager.DataManager;
	import com.editor.module_skill.battle.role.MapItem;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class MeshPreview extends D3CompPreviewBase
	{
		public function MeshPreview()
		{
			super();
		}
		
		override protected function get compType():String
		{
			return "mesh preview"
		}
		
		override public function setValue(d:D3ObjectBase):void
		{
			super.setValue(d);
			scale_n = 1;
			mapItem.loadMesh(d.file);
		}
						
		protected var mapItem:D3MapItemObject;
				
		override protected function initObject():void
		{
			bodyMaterial = new TextureMaterial();
			bodyMaterial.lightPicker = lightPicker;
			mapItem = new D3MapItemObject();
			mapItem.objectParent = scene;
			mapItem.isAttriPreview = true
			mapItem.view = view;
			mapItem.getObject().y = -this.height/2;
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			//if(ispanning) updatePOIPosition();
			if(mapItem!=null) mapItem.render();
		}
		
		private function updatePOIPosition():void
		{
			var pan2:Point = getLocalPoint();
			
			var dx:Number = (pan2.x - pan.x)
			var dy:Number = (pan2.y - pan.y)
			
			pan = getLocalPoint()
			//trace(dy,dx)
			mapItem.getObject().moveUp(dy);
			mapItem.getObject().moveLeft(dx);
		}		
		
		override protected function onResize(event:Event = null):void
		{
			if(stage == null) return ;
			if(view == null) return ;
			view.width = this.width;
			view.height = this.height;
			//view.y = this.height/2;
			this.x = stage.stageWidth-300-this.width-20;
			this.y = get_App3DMainUIContainerMediator().rightContainer.y;
		}
		
		override protected function onMouseWheel(e:MouseEvent):void
		{
			e.preventDefault();
			if(e.delta > 0){
				if(scale_n < 1) scale_n = 1;
				scale_n = scale_n + .1;
				if(mapItem!=null&&mapItem.getObject()!=null)mapItem.getObject().scale(scale_n);
			}else{
				if(scale_n > 1) scale_n = 1;
				scale_n = scale_n - .1
				if(scale_n > 0){
					if(mapItem!=null&&mapItem.getObject()!=null)mapItem.getObject().scale(scale_n);
				}
			}
		}
		
		
	}
}