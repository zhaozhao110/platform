package com.editor.module_roleEdit.vo.motion
{
	import com.sandy.error.SandyError;
	import com.sandy.math.SandyPoint;
	import com.sandy.math.SandyRectangle;
	
	public class AppMotionItemVO
	{
		public function AppMotionItemVO(x:XML=null)
		{
			if(x!=null) parserXML(x);
		}
		
		/**
		 * 原始的原点
		 */ 
		public var originalPoint:SandyPoint;
		/**
		 * 原始图片的宽高
		 */ 
		public var size:SandyRectangle;
		/**
		 * 名称显示坐标
		 */ 
		public var namePoint:String;
		
		public var id:int;
		public var action_ls:Array = [];
		
		private var nameY:Array;
		private var nameY_ls:Array = [];
		
		private function parserXML(x:XML):void
		{
			id = int(x.@i);
						
			var size_a:Array = String(x.@s).split(",");
			size = new SandyRectangle(0,0,size_a[0],size_a[1]);
						
			var originalTxt:String = x.@o;
			
			if(originalTxt!=""){
				if(originalTxt.indexOf(",")==-1){
					throw new SandyError("AppResInfoItemVO offsetPoint is null")
				}
				originalPoint = new SandyPoint();
				originalPoint.splitString(originalTxt);
				if(!originalPoint.check()){
					throw new SandyError("AppResInfoItemVO offsetPoint is null")
				}
				if(originalPoint.x > 1500 || originalPoint.y > 1500){
					throw new SandyError("AppResInfoItemVO offsetPoint is null")
				}
			}
			else{
				originalPoint = new SandyPoint();
				originalPoint.x = 0;
				originalPoint.y = 0
			}
				
			var namePointTxt:String = x.@n;
			if(namePointTxt!=""){
				namePoint = namePointTxt;
			}
			else{
				namePointTxt = '0';
			}
			nameY = String(x.@n).split(",");
			
			for each(var p:XML in x.m)
			{
				var it:AppMotionActionVO = new AppMotionActionVO(p);
				it.item = this;
				action_ls[it.type] = it;
			}
		}
		
		public function getActionByType(tp:String):AppMotionActionVO
		{
			return action_ls[tp] as AppMotionActionVO;
		}
		
		public function getTimelineByType(tp:String):String
		{
			if(getActionByType(tp)==null) return "";
			return getActionByType(tp).timeline;
		}
		
		public function setActionItem(tp:String,it:AppMotionActionVO):void
		{
			action_ls[tp] = it;
		}
		
		public function getNameY(tp:String):int
		{
			if(nameY.length == 1){
				return int(nameY[0]); 
			}
			return int(nameY_ls[tp]);
		}
	}
}