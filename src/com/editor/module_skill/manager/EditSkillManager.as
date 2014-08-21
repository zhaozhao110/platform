package com.editor.module_skill.manager
{
	import com.editor.component.controls.UILabel;
	import com.editor.module_skill.timeline.TimelineRect;
	import com.editor.module_skill.timeline.TimelineRow;
	import com.editor.module_skill.timeline.vo.TimelineDataList;
	import com.editor.module_skill.vo.project.EditSkillProjectItemVO;
	import com.editor.module_skill.vo.skill.EditSkillItemVO;
	import com.sandy.manager.data.SandyData;
	import com.sandy.math.SandyPoint;
	
	import flash.geom.Point;

	public class EditSkillManager
	{
		
		
		public static var currProject:EditSkillProjectItemVO;
		/**
		 * 选中的要编辑的技能
		 */ 
		public static var currSkill:EditSkillItemVO;
		public static var selectRect:TimelineRect; 
		
		public static var timeDataList:TimelineDataList = new TimelineDataList();
		
		/**
		 * 时间轴下面的显示的文字
		 */ 
		public static var timelineBottomTxt:UILabel;
		
		
		public static const total_frames:int = 600;
		public static const timeline_w:int = 6000
		
		public static var row_ls:Array = [];
		
		//攻击方动作层
		public static const row1:int = 1;
		//攻击方位移层
		public static const row2:int = 2;
		//攻击方特效层
		public static const row3:int = 3;
		//受伤方动作层
		public static const row4:int = 4;
		//受伤方位移层
		public static const row5:int = 5;
		//受伤方特效层
		public static const row6:int = 6;
		//场景特效
		public static const row7:int = 7;
		//震动层
		public static const row8:int = 8;
		
		//动作
		public static const editType1:int = 1;
		//位移
		public static const editType2:int = 2;
		//特效
		public static const editType3:int = 3;
		//场景特效
		public static const editType4:int = 4;
		public static const editType5:int = 5;
		
		/**
		 * 普通格子
		 */ 
		public static const rect_type1:int = 1;
		/**
		 * 动作格子
		 */ 
		//public static const rect_type2:int = 2;
		/**
		 * 选中格子
		 */ 
		public static const rect_type3:int = 3;
		/**
		 * 有信息的格子
		 */ 
		public static const rect_type4:int = 4;
		
		
		public static var attack_loc:SandyPoint = new SandyPoint(attack_battleX,battleY)
		public static var defend_loc:SandyPoint = new SandyPoint(defend_battleX,battleY)
		
		public static const battleY:int = 550;
		public static const attack_battleX:int = 300;
		public static const defend_battleX:int = 900
		
			
		public static function init():void
		{
			row_ls.push(new SandyData("攻击方动作层", row1,editType1))
			row_ls.push(new SandyData("攻击方位移层", row2,editType2))
			row_ls.push(new SandyData("攻击方特效层", row3,editType3))
			row_ls.push(new SandyData("受伤方动作层", row4,editType1))
			row_ls.push(new SandyData("受伤方位移层", row5,editType2))
			row_ls.push(new SandyData("受伤方特效层", row6,editType3))
			row_ls.push(new SandyData("场景特效", row7,editType4))
			row_ls.push(new SandyData("震动层", row8,editType5))
		}
		
		public static function getRowStr(row:int):String
		{
			return SandyData(row_ls[row-1]).getValue();
		}
		
		public static function checkIsAttack(row:int):Boolean
		{
			if(row == EditSkillManager.row1 || row == EditSkillManager.row2 || row == EditSkillManager.row3){
				return true;
			}
			return false;
		}
		
	}
}