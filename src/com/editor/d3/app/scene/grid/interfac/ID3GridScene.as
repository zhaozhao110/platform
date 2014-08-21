package com.editor.d3.app.scene.grid.interfac
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	
	import com.editor.d3.app.scene.grid.manager.CameraManager;
	
	import flash.display.Stage;

	public interface ID3GridScene
	{
		function updateDefaultCameraFarPlane():void 
		function zoomDistanceDelta(delta:Number):void 
		function zoomToDistance(distance:Number):void 
		function containerBounds(oC:ObjectContainer3D, sceneBased:Boolean = true):Vector.<Number> 
		function getSceneBounds(excludeGizmos : Boolean = true):Vector.<Number> 
			
		function get camera():Camera3D;
		function get active():Boolean
		function set active(value:Boolean):void
		function get cameraMM():CameraManager
		function set cameraMM(value:CameraManager):void
		function get stage():Stage;
			
	}
}