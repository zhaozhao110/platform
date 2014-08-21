package com.editor.module_roleEdit.manager
{
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
	import com.sandy.render2D.map.data.SandyMapConst;

	public class RoleEditManager
	{
		//当前操作的项目
		//{name:"" data:""}
		public static var currProject:RoleEditProjectItemVO;
	
		//数据字典里的资源类型
		public static const resType_dict:int = 53;
		
		
		//怪物
		public static const resType_monster:int = 1;
		//NPC
		public static const resType_npc:int = 2;
		//采集物
		public static const resType_gather:int = 3;
		//战斗特效
		public static const resType_battleEffect:int = 4;
		//玩家
		public static const resType_player:int = 5;
		//场景动画
		public static const resType_motion:int = 6;
		//武器
		public static const resType_arm:int = 7;
		//坐骑
		public static const resType_pet:int = 8;
		
		
		
		public static var god_action_ls:Array = [];
		public static var god_battleAction_ls:Array =[];
		public static var god_noBattleAction_ls:Array = [];
		
		public static function init():void
		{
			
			//成仙
			god_battleAction_ls.push(SandyMapConst.status_attack1_type);
			god_battleAction_ls.push(SandyMapConst.status_attack2_type);
			god_battleAction_ls.push(SandyMapConst.status_attack3_type);
			god_battleAction_ls.push(SandyMapConst.status_attack4_type);
			god_battleAction_ls.push(SandyMapConst.status_attack5_type);
			god_battleAction_ls.push(SandyMapConst.status_attack6_type);
			god_battleAction_ls.push(SandyMapConst.status_attackPaodong_type);
			god_battleAction_ls.push(SandyMapConst.status_attackDaiji_type);
			god_battleAction_ls.push(SandyMapConst.status_shoushang_type)
			god_battleAction_ls.push(SandyMapConst.status_shoushang2_type)
			god_battleAction_ls.push(SandyMapConst.status_buff_type)
			god_battleAction_ls.push(SandyMapConst.status_gedang_type)
			god_battleAction_ls.push(SandyMapConst.status_jifei_type)
			god_battleAction_ls.push(SandyMapConst.status_jifeipaqi_type)
			god_battleAction_ls.push(SandyMapConst.status_shanbi_type)
			god_battleAction_ls.push(SandyMapConst.status_shiwang_type)
				
			god_noBattleAction_ls.push(SandyMapConst.status_daiji_type);
			god_noBattleAction_ls.push(SandyMapConst.status_paodong_type);
			god_noBattleAction_ls.push(SandyMapConst.status_qima_daiji_type);
			god_noBattleAction_ls.push(SandyMapConst.status_qima_yidong_type);
			god_noBattleAction_ls.push(SandyMapConst.status_dazuo_type);
			god_noBattleAction_ls.push(SandyMapConst.status_louti1_type);
			god_noBattleAction_ls.push(SandyMapConst.status_tiaoyue_type);
		}
		
	}
}