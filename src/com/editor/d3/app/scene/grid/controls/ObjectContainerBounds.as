package com.editor.d3.app.scene.grid.controls
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.tools.utils.Bounds;
	
	import flash.geom.Vector3D;
	
	public class ObjectContainerBounds extends WireframePrimitiveBase {
		private var _container : ObjectContainer3D;
		private var segmentIndex : int;
		private var _showBounds : Boolean;
		
		override public function get showBounds() : Boolean
		{
			return _showBounds;
		}
		override public function set showBounds(value:Boolean):void
		{
			if (value == _showBounds)
				return;
			
			_showBounds = value;
			
			if (_showBounds) 
				updateContainerBounds();
		}

		public function ObjectContainerBounds(color:uint = 0xffffff) {
			super(color, 0.5);
			//rotationY = 90;
		}
		
		public function setParentContainer(c:ObjectContainer3D):void
		{
			_container = c;
			_container.addChild(this);
		}

		public function updateContainerBounds():void{
			buildGeometry();
		}
		
		override protected function buildGeometry():void{
			if (!showBounds) return;

			Bounds.getObjectContainerBounds(_container, false);
			
			var armXLen:Number = (Bounds.maxX - Bounds.minX) * 0.25;
			var armYLen:Number = (Bounds.maxY - Bounds.minY) * 0.25;
			var armZLen:Number = (Bounds.maxZ - Bounds.minZ) * 0.25;
			
			segmentIndex=0;
			addCorner(new Vector3D(Bounds.maxX, Bounds.maxY, Bounds.maxZ), new Vector3D(-armXLen, -armYLen, -armZLen));
			addCorner(new Vector3D(Bounds.maxX, Bounds.maxY, Bounds.minZ), new Vector3D(-armXLen, -armYLen,  armZLen));
			addCorner(new Vector3D(Bounds.maxX, Bounds.minY, Bounds.maxZ), new Vector3D(-armXLen,  armYLen, -armZLen));
			addCorner(new Vector3D(Bounds.maxX, Bounds.minY, Bounds.minZ), new Vector3D(-armXLen,  armYLen,  armZLen));
			addCorner(new Vector3D(Bounds.minX, Bounds.maxY, Bounds.maxZ), new Vector3D( armXLen, -armYLen, -armZLen));
			addCorner(new Vector3D(Bounds.minX, Bounds.maxY, Bounds.minZ), new Vector3D( armXLen, -armYLen,  armZLen));
			addCorner(new Vector3D(Bounds.minX, Bounds.minY, Bounds.maxZ), new Vector3D( armXLen,  armYLen, -armZLen));
			addCorner(new Vector3D(Bounds.minX, Bounds.minY, Bounds.minZ), new Vector3D( armXLen,  armYLen,  armZLen));
		}
		
		private function addCorner(corner : Vector3D, directions : Vector3D):void{
			updateOrAddSegment(segmentIndex++, corner.clone(), corner.clone().add(new Vector3D(directions.x, 0, 0)));
			updateOrAddSegment(segmentIndex++, corner.clone(), corner.clone().add(new Vector3D(0, directions.y, 0)));
			updateOrAddSegment(segmentIndex++, corner.clone(), corner.clone().add(new Vector3D(0, 0, directions.z)));
		}
		
		override protected function updateBounds():void{
			_bounds.fromExtremes(0, 0, 0, 0, 0, 0);
		}		
	}
}
