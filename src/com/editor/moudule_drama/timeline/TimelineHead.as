package com.editor.moudule_drama.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.moudule_drama.timeline.data.TimelineConst;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;

	public class TimelineHead extends UICanvas
	{
		public function TimelineHead()
		{
			super();
			create_init();
		}
		
		private var lastLen:int = 1;
		public function create_init():void
		{
			this.height = 20;
			
			var len:int = width/TimelineConst.FRAME_WIDTH;
			for(var i:int=lastLen;i<=len;i++)
			{
				if(i != 0)
				{
					if( i%5 == 0 || i == 1){
						var txt:UILabel = new UILabel();
						txt.text = i.toString();
						txt.x = (i-1)*TimelineConst.FRAME_WIDTH;
						addChild(txt);
					}
					if( i%5 == 0 || i == 1){
						var bot:TimelineHeadBot = new TimelineHeadBot();
						bot.x = (i-1)*TimelineConst.FRAME_WIDTH + TimelineConst.FRAME_WIDTH/2;
						bot.y = this.height - 4;
						addChild(bot);
					}
				}
				
			}
			
			lastLen = len;
			
			for(var j:int=numChildren-1;i>=0;i--)
			{
				var lb:UILabel = getChildAt(j) as UILabel;
				if(lb && lb.x > lastLen)
				{
					removeChild(lb);
					lb.dispose();
					lb = null;
				}
			}
			
			
		}
		
		
		
		
	}
}