package com.editor.module_avg.vo.sec
{
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	public class AVGSectionItemVO implements ICloneInterface
	{
		public function AVGSectionItemVO(x:XML=null)
		{
			if(x == null) return ;
			name = x.@n;
			index = int(x.@i);
			
			for each(var iX:XML in x.f)
			{
				var d:AVGFrameItemVO = new AVGFrameItemVO(iX);
				frame_ls.push(d);
			}
		}
		
		public function cloneObject():*
		{
			var d:AVGSectionItemVO = new AVGSectionItemVO();
			ToolUtils.clone(this,d);
			return d;
		}
		
		public var index:int;
		public var name:String;
		public var frame_ls:Array = [];
		
		public function createFrame():void
		{
			var d:AVGFrameItemVO = new AVGFrameItemVO();
			d.index = frame_ls.length+1;
			frame_ls.push(d);
		}
		
		public function copyFrame(f:AVGFrameItemVO,ind:int):int
		{
			var ff:AVGFrameItemVO = f.cloneObject()
			ff.index = ind;
			frame_ls.splice(ind,0,ff);
			reflashAllFrameIndex()
			return f.index;
		}
		
		public function reflashAllFrameIndex():void
		{
			for(var i:int=0;i<frame_ls.length;i++){
				AVGFrameItemVO(frame_ls[i]).index = i+1;
			}
		}
		
		public function removeFrame(d:AVGFrameItemVO):void
		{
			for(var i:int=0;i<frame_ls.length;i++){
				if(AVGFrameItemVO(frame_ls[i]).index==d.index){
					frame_ls.splice(i,1);
					reflashAllFrameIndex()
					break;
				}
			}
		}
		
		public function getFrame(ind:int):AVGFrameItemVO
		{
			return frame_ls[ind] as AVGFrameItemVO;
		}
		
		public function getXML():String
		{
			var x:String = '<s n="'+name+'" i="'+index+'">'
			for(var i:int=0;i<frame_ls.length;i++){
				x += AVGFrameItemVO(frame_ls[i]).getXML();
			}
			x += "</s>"
			return x;
		}
		
	}
}