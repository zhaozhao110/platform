package com.editor.module_skill.timeline.vo
{
	import com.editor.module_skill.preview.PreviewBattle;

	public class TimelineShakeData extends TimelineDataBase
	{
		public function TimelineShakeData()
		{
			isKey = true;
		}
		
		public var shake:Boolean;
		public var range:int;
		public var time:int;
		public var isShoot:Boolean;
		
		override public function getLabel():String
		{
			if(shake){
				return "抖动,"+range+","+time + ",isShoot:" + isShoot;
			}
			return "isShoot:" + isShoot;
		}
		
		override public function save():*
		{
			if(shake){
				return frame+"$"+range+"|"+time+"|"+(isShoot==true?1:0);
			}
			return frame+"$"+(isShoot==true?1:0);
		}
		
		override public function play():void
		{
			if(shake){
				PreviewBattle.instace.shake(range,time);
			}
		}
		
		override public function parser(v:String):void
		{
			var a:Array = v.split("|");
			if(a.length == 1){
				isShoot = int(a[0])==1?true:false;
			}else if(a.length == 3){
				range 	= int(a[0]);
				time 	= int(a[1]);
				shake = true;
				isShoot = int(a[2])==1?true:false;
			}else if(a.length == 2){
				range 	= int(a[0]);
				time 	= int(a[1]);
				shake = true;
			}
		}
	}
}