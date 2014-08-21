package com.editor.moudule_drama.timeline.vo.interfaces
{
	import flash.display.DisplayObject;

	/**
	 * 显示对象状态
	 * @author sun <br>
	 * 
	 * play,loop,visible 1=true 0=false
	 */	
	public interface ITimelineViewProperties_BaseVO
	{
		function clone():ITimelineViewProperties_BaseVO;
		
		function get targetId():String;
		function set targetId(value:String):void;
				
		function get x():int;
		function set x(value:int):void;
		
		function get y():int;		
		function set y(value:int):void;
		
		function get width():int;		
		function set width(value:int):void;
		
		function get height():int;		
		function set height(value:int):void;
		
		function get index():int;		
		function set index(value:int):void;
		
		function get alpha():Number;		
		function set alpha(value:Number):void;
		
		function get scaleX():Number;		
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;		
		function set scaleY(value:Number):void;
		
		function get rotation():int;		
		function set rotation(value:int):void;
		
		function get play():int;		
		function set play(value:int):void;
		
		function get playParameters():String;		
		function set playParameters(value:String):void;
		
		function get loop():int;		
		function set loop(value:int):void;
		
		function get data():*;		
		function set data(value:*):void;
		
	}
}
