package com.editor.moudule_drama.timeline
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.mediator.SkillSeqLeftContainerMediator;
	import com.editor.module_skill.timeline.vo.TimelineActionData;
	import com.editor.module_skill.timeline.vo.TimelineEffectData;
	import com.editor.module_skill.timeline.vo.TimelineMoveData;
	import com.editor.module_skill.timeline.vo.TimelineShakeData;
	import com.editor.moudule_drama.timeline.data.TimelineConst;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframeType;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TimelineRect extends ASComponent
	{
		private var _id:String;
		/**父窗口**/
		public var parentTimelineTile:TimelineTile;
		
		public var type:int;
		public var frame:int;
		public var rowId:String;
		public function TimelineRect()
		{
			super();
			
		}
		
		private var sp:Shape;
		public function create_init():void
		{
			width = TimelineConst.FRAME_WIDTH;
			height = TimelineConst.FRAME_HEIGHT;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			if(!sp)
			{
				var sp:Shape = new Shape();
				sp.x = 1; sp.y = 1;
				addChild(sp);
			}
			
			sp.graphics.clear();
			
			sp.graphics.beginFill(0x808080);
			sp.graphics.drawRect(0,0,8,19);
			sp.graphics.endFill();
			
			if(type == TimelineKeyframeType.FRAME_SOLID)
			{
				/**普通帧**/
				sp.graphics.beginFill(0x4D4D4D);
				sp.graphics.lineStyle(0,0,0);
				
			}else if(type == TimelineKeyframeType.FRAME_HOLLOW)
			{
				/**空白帧**/
				sp.graphics.beginFill(0xCCC8C0);
				sp.graphics.lineStyle(0, 0, 0);
			}else if(type == TimelineKeyframeType.FRAME_TWEEN)
			{
				/**补间帧**/
				sp.graphics.beginFill(0xCCC8C0);
				sp.graphics.lineStyle(1, 0x0F5499);
			}
			
			sp.graphics.drawCircle(4,13,3);
			sp.graphics.endFill();
			
		}
				
		/**ID**/
		override public function get id():String
		{
			return _id;
		}
		/**ID**/
		override public function set id(value:String):void
		{
			_id = value;
		}
			
		
	}
}