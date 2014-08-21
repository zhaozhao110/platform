package com.editor.module_skill.timeline
{
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.mediator.SkillSeqLeftContainerMediator;
	import com.editor.module_skill.timeline.vo.TimelineActionData;
	import com.editor.module_skill.timeline.vo.TimelineEffectData;
	import com.editor.module_skill.timeline.vo.TimelineMoveData;
	import com.editor.module_skill.timeline.vo.TimelineResData;
	import com.editor.module_skill.timeline.vo.TimelineShakeData;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.core.ASEmptySprite;
	import com.sandy.asComponent.core.ASSprite;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.data.SandyData;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TimelineRect extends ASSprite
	{
		public function TimelineRect()
		{
			super();
			//create_init();
		}
		
		public static const rectWidth:int = 10;
		public static const rectHeight:int = 20;
		
		public var row:TimelineRow;
		
		public var type:int = 1;
		
		public function create_init():void
		{
			name = "TimelineRect"
			disabled_parentMeasured = true;
						
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0xa6a6a6;
			
			backgroundColor = 0xffffff;
			backgroundAlpha = 0;
			
			width = rectWidth;
			height = 20;
			
			mouseEnabled = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK , onClickHandle)
			
			row.frame_ls[getFrame().toString()] = this;
		}
		
		public function reset():void
		{
			noSelect();
		}
		
		public function getRow():int
		{
			return (data as SandyData).getKey();
		}
		
		public function getFrame():int
		{
			return listIndex + 1;
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			if(EditSkillManager.currSkill == null){
				iManager.applicationMediator.showError("先选择技能");
				return ;
			}
			
			if(TimelineContainer.instance.bottomC!=null){
				TimelineContainer.instance.bottomC.setInfo("选中: " + EditSkillManager.getRowStr(getRow()) + " / 帧: " +  getFrame());
			}
			
			if(EditSkillManager.selectRect!=null){
				EditSkillManager.selectRect.noSelect();	
			}
			if(EditSkillManager.selectRect!=null){
				EditSkillManager.selectRect.row.noSelect();	
			}
			
			EditSkillManager.selectRect = this;
						
			row.select();
			
			get_SkillSeqLeftContainerMediator().edit(data as SandyData);
			
			EditSkillManager.timeDataList.reflashText();
			
			select();
		}
		
		private function get_SkillSeqLeftContainerMediator():SkillSeqLeftContainerMediator
		{
			return iManager.retrieveMediator(SkillSeqLeftContainerMediator.NAME) as SkillSeqLeftContainerMediator;
		}
		
		override public function select():void
		{
			super.select();
			type = EditSkillManager.rect_type3;
			check();
		}
		
		override public function noSelect():void
		{
			super.noSelect();
			type = EditSkillManager.rect_type1;
			check();
		}
		
		public function check():void
		{
			if(selected){
				checkColor();
				return ;
			}
						
			if(getRow() == EditSkillManager.row1 || getRow() == EditSkillManager.row4){
				var rect:TimelineActionData = EditSkillManager.timeDataList.getDataBase(getRow(),getFrame()) as TimelineActionData;
				if(rect!=null){
					type = EditSkillManager.rect_type4	
				}else{
					type = EditSkillManager.rect_type1;
				}
			}
			
			if(getRow() == EditSkillManager.row2 || getRow() == EditSkillManager.row5){
				var rect1:TimelineMoveData = EditSkillManager.timeDataList.getDataBase(getRow(),getFrame()) as TimelineMoveData;
				if(rect1!=null && rect1.isKey){
					type = EditSkillManager.rect_type4	
				}else{
					type = EditSkillManager.rect_type1;
				}
			}
			
			if(getRow() == EditSkillManager.row3 || getRow() == EditSkillManager.row6){
				var rect2:TimelineEffectData = EditSkillManager.timeDataList.getDataBase(getRow(),getFrame()) as TimelineEffectData;
				if(rect2!=null){
					type = EditSkillManager.rect_type4	
				}else{
					type = EditSkillManager.rect_type1;
				}
			}
			
			if(getRow() == EditSkillManager.row7){
				var rect3:TimelineResData = EditSkillManager.timeDataList.getDataBase(getRow(),getFrame()) as TimelineResData;
				if(rect3!=null){
					type = EditSkillManager.rect_type4	
				}else{
					type = EditSkillManager.rect_type1;
				}
			}
			
			if(getRow() == EditSkillManager.row8){
				var rect4:TimelineShakeData = EditSkillManager.timeDataList.getDataBase(getRow(),getFrame()) as TimelineShakeData;
				if(rect4!=null){
					type = EditSkillManager.rect_type4	
				}else{
					type = EditSkillManager.rect_type1;
				}
			}
						
			checkColor();
		}
		
		private function checkColor():void
		{			
			if(type == EditSkillManager.rect_type1){
				backgroundAlpha = 0;
			}else if(type == EditSkillManager.rect_type3){
				backgroundColor = ColorUtils.white;
				backgroundAlpha = 1;
			}else if(type == EditSkillManager.rect_type4){
				backgroundColor = ColorUtils.red;
				backgroundAlpha = 1;
			}
		}
		
	}
}