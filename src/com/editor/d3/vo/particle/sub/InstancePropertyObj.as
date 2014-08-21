package com.editor.d3.vo.particle.sub
{
	import com.editor.d3.vo.particle.SubPropObj;
	
	public class InstancePropertyObj extends SubPropObj
	{
		public function InstancePropertyObj()
		{
			super();
			
			if(position == null){
				position = new SubPropObj();
				position.attriType = 1;
				position.initAttri([1,2,3]);
			}
			
			if(scale == null){
				scale = new SubPropObj();
				scale.attriType = 1;
				scale.initAttri([4,5,6]);
			}
			
			if(rotation == null){
				rotation = new SubPropObj();
				rotation.attriType = 1;
				rotation.initAttri([7,8,9])
			}
			
			if(timeOffset == null){
				timeOffset = new SubPropObj();
				timeOffset.attriType = 1;
				timeOffset.initAttri([12]);
			}
			
			if(playSpeed == null){
				playSpeed = new SubPropObj();
				playSpeed.attriType = 1;
				playSpeed.initAttri([13]);
			}
		}
		
		override public function get id():String
		{
			return "InstancePropertySubParser"
		}
		
		public var position:SubPropObj;
		public var playSpeed:SubPropObj;
		public var timeOffset:SubPropObj;
		public var scale:SubPropObj;
		public var rotation:SubPropObj;
				
		override public function putAttri(k:String,v:*):void
		{
			if(k == "x" || k == "y" || k == "z"){
				position.putAttri(k,v);
			}
			if(k == "scaleX" || k == "scaleY" || k == "scaleZ"){
				scale.putAttri(k,v);
			}
			if(k == "rotationX" || k == "rotationY" || k == "rotationZ"){
				rotation.putAttri(k,v);
			}
			if(k == "time offset"){ 
				timeOffset.putAttri(k,v);
			}
			if(k == "play speed"){
				playSpeed.putAttri(k,v);
			}
		}
		
		override public function getAttri(k:String):*
		{
			if(k == "x" || k == "y" || k == "z"){
				return position.getAttri(k);
			}
			if(k == "scaleX" || k == "scaleY" || k == "scaleZ"){
				return scale.getAttri("scale"+k.toUpperCase());
			}
			if(k == "rotationX" || k == "rotationY" || k == "rotationZ"){
				return rotation.getAttri("rotation"+k.toUpperCase());
			}
			if(k == "time offset"){ 
				return timeOffset.getAttri(k);
			}
			if(k == "play speed"){
				return playSpeed.getAttri(k);
			}
			return null;
		}
		
		override public function parser(obj:Object):void
		{
			id = obj.id;
			position.parser(obj.data.position);
			scale.parser(obj.data.scale);
			rotation.parser(obj.data.rotation);
			timeOffset.parser(obj.data.timeOffset);
			playSpeed.parser(obj.data.playSpeed);
		}
		
		override public function getObject():Object
		{
			var obj:Object = {};
			obj.id = id;
			obj.data = {};
			if(position!=null) obj.data.position = position.getObject();
			if(scale!=null) obj.data.scale = scale.getObject();
			if(rotation!=null) obj.data.rotation = rotation.getObject();
			if(timeOffset!=null) obj.data.timeOffset = timeOffset.getObject();
			if(playSpeed!=null) obj.data.playSpeed = playSpeed.getObject();
			return obj;
		}
		
		
	}
}