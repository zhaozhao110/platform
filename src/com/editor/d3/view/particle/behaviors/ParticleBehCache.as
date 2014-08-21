package com.editor.d3.view.particle.behaviors
{
	import com.editor.d3.view.particle.behaviors.plug.acceleration.Beh_Acceleration;
	import com.editor.d3.view.particle.behaviors.plug.bezier.Beh_bezier;
	import com.editor.d3.view.particle.behaviors.plug.billboard.Beh_billboard;
	import com.editor.d3.view.particle.behaviors.plug.colorTween.Beh_colorTween;
	import com.editor.d3.view.particle.behaviors.plug.follow.Beh_Follow;
	import com.editor.d3.view.particle.behaviors.plug.initialColor.Beh_initialColor;
	import com.editor.d3.view.particle.behaviors.plug.orbit.Beh_orbit;
	import com.editor.d3.view.particle.behaviors.plug.oscillator.Beh_Oscillator;
	import com.editor.d3.view.particle.behaviors.plug.position.Beh_position;
	import com.editor.d3.view.particle.behaviors.plug.rotationTween.Beh_rotationTween;
	import com.editor.d3.view.particle.behaviors.plug.scaleTween.Beh_scaleTween;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.Beh_segmentedColor;
	import com.editor.d3.view.particle.behaviors.plug.segmentedScale.Beh_segmentedScale;
	import com.editor.d3.view.particle.behaviors.plug.spriteSheet.Beh_SpriteSheet;
	import com.editor.d3.view.particle.behaviors.plug.time.Beh_time;
	import com.editor.d3.view.particle.behaviors.plug.toHead.Beh_toHead;
	import com.editor.d3.view.particle.behaviors.plug.velocity.Beh_velocity;
	import com.editor.d3.vo.particle.ParticleAnimationObj;

	public class ParticleBehCache
	{
		public function ParticleBehCache()
		{
			init();
		}
		
		public var plus_a:Array;
		public static var plusC_a:Array = [];
		public var plusC_b:Array = [];
		
		public function init():void
		{
			if(plus_a != null) return ;
			
			var a:Array = [];
			a.push({label:"Time",data:"ParticleTimeNodeSubParser",i:1});
			//A particle animation node used to set the starting velocity of a particle.
			a.push({label:"Velocity",data:"ParticleVelocityNodeSubParser",i:2,inf:"轴速度"});
			//A particle animation node used to apply a constant acceleration vector to the motion of a particle.
			//越远加速越快
			a.push({label:"Acceleration",data:"ParticleAccelerationNodeSubParser",inf:"加速",i:3});
			//A particle animation node used to set the starting position of a particle.
			a.push({label:"Position",data:"ParticlePositionNodeSubParser",i:4});
			//A particle animation node that controls the rotation of a particle to always face the camera.
			a.push({label:"Billboard",data:"ParticleBillboardNodeSubParser",i:5});
			//A particle animation node used to create a follow behaviour on a particle system.
			a.push({label:"Follow",data:"ParticleFollowNodeSubParser",i:6});
			//A particle animation node used to control the scale variation of a particle over time.
			a.push({label:"Scale Tween",data:"ParticleScaleNodeSubParser",i:7});
			//分段
			a.push({label:"Segmented Scale",data:"ParticleSegmentedScaleNodeSubParser",i:8});
			//Expects a <code>ColorTransform</code> object representing the color transform applied to the particle.
			a.push({label:"Initial Color",data:"ParticleInitialColorNodeSubParser",i:9});
			//A particle animation node used to control the color variation of a particle over time.
			a.push({label:"Color Tween",data:"ParticleColorNodeSubParser",i:10});
			a.push({label:"Segmented Color",data:"ParticleSegmentedColorNodeSubParser",i:11});
			//A particle animation node used to control the position of a particle over time using simple harmonic motion.
			a.push({label:"Oscillator",data:"ParticleOscillatorNodeSubParser",inf:"振荡",i:12});
			a.push({label:"Rotation Tween",data:"ParticleRotationalVelocityNodeSubParser",i:13});
			//A particle animation node used to control the position of a particle over time around a circular orbit.
			//圆轨道
			a.push({label:"Orbit",data:"ParticleOrbitNodeSubParser",i:14});
			//A particle animation node used to control the position of a particle over time along a bezier curve.
			a.push({label:"Bezier Curve",data:"ParticleBezierCurveNodeSubParser",i:15});
			//* A particle animation node used when a spritesheet texture is required to animate the particle.
			//* NB: to enable use of this node, the <code>repeat</code> property on the material has to be set to true.
			a.push({label:"SpriteSheet",data:"ParticleSpriteSheetNodeSubParser",i:16});
			//A particle animation node used to control the rotation of a particle to match its heading vector.
			a.push({label:"Rotate To Heading",data:"ParticleRotateToHeadingNodeSubParser",i:17});			
			
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var d:ParticleAttriPlugVO = new ParticleAttriPlugVO(a[i]);
				d.data = {};
				out.push(d);
			}
			
			plus_a = out;
		}
		
		public function getIndexByData(s:String):int
		{
			var out:Array = [];
			for(var i:int=0;i<plus_a.length;i++){
				var d:ParticleAttriPlugVO = plus_a[i] as ParticleAttriPlugVO
				if(d.id ==s){
					return d.index;
				}
			}
			return -1;
		}
		
		public function getLastArray():Array
		{
			var out:Array = [];
			for(var i:int=0;i<plus_a.length;i++){
				var d:ParticleAttriPlugVO = plus_a[i] as ParticleAttriPlugVO;
				var ui:ParticleAttriPlugBase = plusC_b[d.index.toString()]
				if(ui==null){
					out.push(d);
				}else{
					if(!ui.enabled2){
						out.push(d);
					}
				}
			}
			return out;
		}
		
		public function getPlusVO(type:int):ParticleAttriPlugVO
		{
			return plus_a[type-1] as ParticleAttriPlugVO
		}
		
		public function getPlusBase(type:int):ParticleAttriPlugBase
		{
			return plusC_b[type.toString()]
		}
		
		public function delBehObj(key:String):void
		{
			for each(var ui:ParticleAttriPlugBase in plusC_b){
				if(ui.plusObj.id == key){
					plusC_b[ui.plusObj.index] = null;
					break;
				}
			}
		}
		
		public var isInitied:Boolean;
		
		public function createPlus(type:int):Boolean
		{			
			isInitied = true
			var ui:ParticleAttriPlugBase = plusC_a[type.toString()]
			if(ui!=null){
				ui.plusObj = getPlusVO(type);
				ui.label = ui.plusObj.name;
				if(plusC_b[type.toString()] == null){
					plusC_b[type.toString()] = ui;
				}
				return false
			}
			
			if(type == 1){
				ui = new Beh_time();
			}else if(type == 2){
				ui = new Beh_velocity();
			}else if(type == 3){
				ui = new Beh_Acceleration();
			}else if(type == 4){
				ui = new Beh_position();
			}else if(type == 5){
				ui = new Beh_billboard();
			}else if(type == 6){
				ui = new Beh_Follow();
			}else if(type == 7){
				ui = new Beh_scaleTween();
			}else if(type == 8){
				ui = new Beh_segmentedScale();
			}else if(type == 9){
				ui = new Beh_initialColor();
			}else if(type == 10){
				ui = new Beh_colorTween();
			}else if(type == 11){
				ui = new Beh_segmentedColor()
			}else if(type == 12){
				ui = new Beh_Oscillator();
			}else if(type == 13){
				ui = new Beh_rotationTween();
			}else if(type == 14){
				ui = new Beh_orbit();
			}else if(type == 15){
				ui = new Beh_bezier();
			}else if(type == 16){
				ui = new Beh_SpriteSheet();
			}else if(type == 17){
				ui = new Beh_toHead();
			}
			
			ui.plusObj = getPlusVO(type);
			ui.label = ui.plusObj.name;
			plusC_b[type.toString()] = ui;
			plusC_a[type.toString()] = ui;
			
			return true
		}
				
		public function saveObject():Array
		{
			var a:Array = [];
			for each(var ui:ParticleAttriPlugBase in plusC_b){
				if(ui!=null&&ui.plusObj.enabled){
					ui.saveObject();
					a.push(ui.plusObj.getObject());
				}
			}
			return a;
		}
		
		
	}
}