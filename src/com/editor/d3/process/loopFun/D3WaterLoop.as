package com.editor.d3.process.loopFun
{
	import away3d.materials.methods.SimpleWaterNormalMethod;
	
	import com.editor.d3.app.scene.grid.vo.D3LoopFunData;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.process.D3ProccessGeometry;
	import com.sandy.math.HashMap;

	public class D3WaterLoop extends D3LoopFunData
	{
		public function D3WaterLoop()
		{
			super();
		}
		
		public var proccess:D3ProccessGeometry;
		public var waterMethod:SimpleWaterNormalMethod;
		
		override public function call():void
		{
			if(waterMethod == null || proccess == null) return ;
			
			var map:Object = (waterMethod.data as D3ObjectMethod).configData.getAttriObj();
			
			var water1OffsetX:Number = Number(map["water1OffsetX"]);
			if(!isNaN(water1OffsetX)) waterMethod.water1OffsetX += water1OffsetX;
			
			var water1OffsetY:Number = Number(map["water1OffsetY"]);
			if(!isNaN(water1OffsetY)) waterMethod.water1OffsetY += water1OffsetY;
			
			var water2OffsetX:Number = Number(map["water2OffsetX"]);
			if(!isNaN(water2OffsetX)) waterMethod.water2OffsetX += water2OffsetX;
			
			var water2OffsetY:Number = Number(map["water2OffsetY"]);
			if(!isNaN(water2OffsetY)) waterMethod.water2OffsetY += water2OffsetY;
		}
		
		
	}
}