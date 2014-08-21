package com.editor.d3.pop.preMesh
{
	import away3d.materials.TextureMaterial;
	
	import com.editor.component.controls.UIButton;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemMesh;
	import com.editor.d3.editor.group.D3MapItemObject;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.view.attri.preview.D3CompPreviewBase;
	import com.editor.manager.DataManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class App3DPreMeshPreview extends D3CompPreviewBase
	{
		public function App3DPreMeshPreview(v:App3DPreMeshWin)
		{
			super();
			meshWin = v;
			addButton();
		}
		
		private var meshWin:App3DPreMeshWin;
		
		override protected function get compType():String
		{
			return "mesh2 preview"
		}
		
		override protected function creatTitle():void
		{
			
		}
		
		public function setData(f:File):void
		{
			if(f == null) return ;
			scale_n = 1;
			mapItem.loadMesh(f);
		}
		
		protected var mapItem:D3MapItemObject;
		
		override protected function initObject():void
		{
			bodyMaterial = new TextureMaterial();
			bodyMaterial.lightPicker = lightPicker;
			mapItem = new D3MapItemObject();
			mapItem.objectParent = scene;
			mapItem.isAttriPreview = true;
			mapItem.view = view;
			mapItem.getObject().y = -this.height/2;
		}
		
		private var okButton:UIButton;
		private function addButton():void
		{
			okButton = new UIButton();
			okButton.label = "确定"
			addChild(okButton);
			okButton.bottom = 5;
			okButton.right = 10;
			okButton.addEventListener(MouseEvent.CLICK , onOkClick);
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			super.onEnterFrame(event);
			if(ispanning) updatePOIPosition();
			if(mapItem!=null) mapItem.render();
		}
		
		private function updatePOIPosition():void
		{
			var pan2:Point = getLocalPoint();
			
			var dx:Number = (pan2.x - pan.x) * (Vector3D.distance(camera.position, mapItem.getObject().scenePosition)/500);
			var dy:Number = (pan2.y - pan.y) * (Vector3D.distance(camera.position, mapItem.getObject().scenePosition)/500);
			
			pan = getLocalPoint()
			//trace(dy,dx)
			mapItem.getObject().moveUp(dy);
			mapItem.getObject().moveLeft(dx);
		}		
		
		override protected function onMouseWheel(e:MouseEvent):void
		{
			e.preventDefault();
			if(e.delta > 0){
				if(scale_n < 1) scale_n = 1;
				scale_n = scale_n + .1;
				if(mapItem!=null) mapItem.getObject().scale(scale_n);
			}else{
				if(scale_n > 1) scale_n = 1;
				scale_n = scale_n - .1
				if(scale_n > 0){
					if(mapItem!=null) mapItem.getObject().scale(scale_n);
				}
			}
		}

		override protected function onResize(event:Event = null):void
		{
			if(stage == null) return ;
			if(view == null) return ;
			view.width = this.width;
			view.height = this.height;
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			meshWin.selectFile(mapItem.getMessFile());
		}
		
	}
}