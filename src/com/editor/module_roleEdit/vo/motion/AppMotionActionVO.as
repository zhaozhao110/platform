package com.editor.module_roleEdit.vo.motion
{
	import com.editor.manager.DataManager;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.sandy.error.SandyError;
	import com.sandy.math.SandyPoint;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.data.SandyMapConst;
	

	/**
	 * 角色的动作 , 下一级是方向
	 */ 
	public class AppMotionActionVO
	{
		public function AppMotionActionVO(x:XML=null)
		{
			if(x!=null) parser(x);
		}
		
		public var type:String;
		public var timeline:String = "";
		public var item:AppMotionItemVO;
		public var forward_ls:Array = [];
		
		/**
		 * 列数
		 * 1/4,2/5,3/3,4/1,5/1,6/4,7/5,8/5,9/5,10/4
		 */ 
		public var column:int;
				
		private function parser(x:XML):void
		{
			type = x.@t;
			timeline = x.@i;
			column = int(x.@c);
			
			for each(var p:XML in x.f)
			{
				var it:AppMotionForwardVO = new AppMotionForwardVO(p);
				forward_ls[it.forward.toString()] = it;
			}
			
		}
		
		public function getTotalFrame():int
		{
			var out:int;
			var a:Array = timeline.split(",");
			for(var i:int=0;i<a.length;i++){
				var b:Array = String(a[i]).split("/");
				out += int(b[1]);
			}
			return out;
		}
		
		public function createForward(forward:int):AppMotionForwardVO
		{
			if(forward_ls[forward.toString()] != null){
				return forward_ls[forward.toString()] as AppMotionForwardVO;
			}
			
			var it:AppMotionForwardVO = new AppMotionForwardVO();
			it.forward = forward;
			forward_ls[forward.toString()] = it;
			return it;
		}
		
		public function getForward(forward:int):AppMotionForwardVO
		{
			return forward_ls[forward.toString()] as AppMotionForwardVO
		}
		
		public function save(totalF:int):String
		{
			var out:String = "";
			out += type + "_" + column + "_" +timeline + "$";
			
			var tmp_forward_ls:Array = []
			for each(var it:AppMotionForwardVO in forward_ls){
				if(it!=null){
					//if(RoleEditManager.currProject.data == DataManager.project_God_cn_cn){
					if(totalF <= SandyMapConst.forward_2){
						if(it.forward == SandyMapConst.right){
							tmp_forward_ls.push(it.save());
						}
					}else if(totalF <= SandyMapConst.forward_4){
						if(it.forward == SandyMapConst.top || it.forward == SandyMapConst.bottom){
							tmp_forward_ls.push(it.save());
						}
					}else if(totalF <= SandyMapConst.forward_8){
						if(it.forward == SandyMapConst.top || 
							it.forward == SandyMapConst.bottom ||
							it.forward == SandyMapConst.right ||
							it.forward == SandyMapConst.right_top || 
							it.forward == SandyMapConst.right_bot){
							tmp_forward_ls.push(it.save());
						}
					}
					/*}else{
						//1140
						tmp_forward_ls.push(it.save());
					}*/
					
						
				}
			}
			out += tmp_forward_ls.join("*");
			return out;
		}
		
		
	}
}