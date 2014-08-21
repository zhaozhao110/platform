package com.editor.module_roleEdit.vo.motion
{
	import com.sandy.math.SandyRectangle;
	
	import flash.geom.Rectangle;

	/**
	 * 动作的方向
	 */ 
	public class AppMotionForwardVO
	{
		public function AppMotionForwardVO(x:XML=null)
		{
			if(x!=null) parser(x);
		}
		
		public var forward_type:int;
		public var forward:int;
		public var frame_ls:Array=[];
		//public var shadow_ls:Array = [];
		
		private function parser(x:XML):void
		{
			forward = int(x.@t);
			
			var a:Array = String(x.@i).split("|");
			for(var i:int=0;i<a.length;i++)
			{
				var b:Array = String(a[i]).split(",");
				var rec:SandyRectangle = new SandyRectangle(b[0],b[1],b[2],b[3]);
				frame_ls.push(rec);
			}
			
			/*a = String(x.@s).split("|");
			for(i=0;i<a.length;i++)
			{
				b = String(a[i]).split(",");
				rec = new SandyRectangle(b[0],b[1],b[2],b[3]);
				shadow_ls.push(rec);
			}*/
		}
		
		public function addRectangle(ind:int,rec:Rectangle):void
		{
			var rect:SandyRectangle = new SandyRectangle();
			rect.cloneRect(rec);
			frame_ls[ind] = rect;
		}
		
		public function getRectangle(ind:int):SandyRectangle
		{
			return frame_ls[ind] as SandyRectangle;
		}
		
		public function removeFrame():void
		{
			frame_ls = null;frame_ls = [];
		}
		
		/*
		public function addShadowRectangle(ind:int,rec:Rectangle):void
		{
			var rect:SandyRectangle = new SandyRectangle();
			rect.cloneRect(rec);
			shadow_ls[ind] = rect;
		}
		
		public function getShadowRectangle(ind:int):SandyRectangle
		{
			return shadow_ls[ind] as SandyRectangle;
		}
		*/
		public function save():String
		{
			if(forward > 0){
				
				var tmp_frame_ls:Array = [];
				for(var i:int=0;i<frame_ls.length;i++)
				{
					var rec:SandyRectangle = frame_ls[i] as SandyRectangle;
					tmp_frame_ls.push(rec.print2());
				}
				/*
				var tmp_shadow_ls:Array = [];
				for(i=0;i<shadow_ls.length;i++)
				{
					rec = shadow_ls[i] as SandyRectangle;
					tmp_shadow_ls.push(rec.save());
				}
				*/
				return forward + "_" + tmp_frame_ls.join("|")+"_"+"";
			}
			
			return "";
		}
	}
}