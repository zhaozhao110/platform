package com.editor.module_roleEdit.vo.res
{
	
	import com.editor.manager.DataManager;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.editor.module_actionMix.vo.ActionMixConfigVO;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.services.Services;
	import com.sandy.error.SandyError;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.utils.ToolUtils;
	
	public class AppResInfoItemVO
	{
		public function AppResInfoItemVO(xml:XML=null,tp:int=0)
		{
			type = tp;
			if(xml!=null) parserXML(xml);
		}
		
		/**
		 * 狩魂
		 1 怪物
		 2 NPC
		 3 采集物
		 4 战斗特效
		 5 玩家
		 6 场景动画
		 7 陷阱
		 8 状态特效
		 */ 
		
		public var type:int;
		public var id:int;
		public var name:String;
		public var name1:String;
		
		
		private var _tileNum:int;
		/**
		 * 资源所占格子数 , 或者 动作组ID
		 */ 
		public function get tileNum():int
		{
			return _tileNum;
		}
		public function set tileNum(value:int):void
		{
			if(value == 0){
				_tileNum = 1;
				return 
			}
			_tileNum = value;
		}
		
		/**
		 * 1：飞行类[无视障碍] 2-地面类[有障碍限制]） -- 动作组
		 */ 
		public var monsterType:int;
		/**
		 *怪物职业 
		 * User:
		 针对形象：动作组
		 针对特效：表示全局层次
		 针对武器：武器类型
		 */		
		public var monsterVoc:int;
		/**
		 * 总的面数
		 */ 
		public var totalForward:int;
		/**
		 * 播放次数
		 */ 
		public var playTimes:int=0;
		/**
		 * 是否是飞行类的，需要程序管理
		 */ 
		public var effectType:int;
		/**
		 * 特效在人的上面还是下面
		 */ 
		public var effectIsUp:Boolean = true;
		/**
		 * 音效
		 */ 
		public var sound:int;
		/**
		 * 1: 绑在人上,不随着人移动,只是获取人的坐标 , 2:在格子上 3,绑在人上，并随着人移动 4,绑在攻击方上
		 */ 
		public var isBindingPlayer:Number ;
		/**
		 * 打坐的图片
		 */ 
		public var dazuoPlayer:Number;
		
		public var sex:int;
		
		public var voc:int
		
		/**
		 * 所对应的预览的mapItem的mapIndex;
		 */ 
		public var preview_mapItemIndex:String;
		/**
		 * 所对应的编辑的mapItem的mapIndex;
		 */ 
		public var edit_mapItemIndex:String;
		//攻击方
		public var isAttack:Boolean;
		
		public var grade:int;
		public var isBattleMode:Boolean;
		
		private function parserXML(x:XML):void
		{
			id 				= int(x.@i);
			name 			= x.@n;
			
			monsterType 	= int(x.@c);
			
			//职业,等级,是否是场景（0场景1战斗）
			var str:String = x.@a;
			if(str.indexOf(",")==-1){
				monsterVoc = int(str);
			}else{
				var a:Array = str.split(",");
				monsterVoc		= int(a[0]);
				grade			= int(a[1]);
				isBattleMode	= int(a[2])==1?true:false;
			}			
			tileNum = monsterVoc;
			
			if(type == RoleEditManager.resType_monster){
				if(monsterVoc == 1){
					isBattleMode = true;
				}
			}else if(type == RoleEditManager.resType_npc){
				if(grade == 1){
					isBattleMode = true;
				}
			}			
			
			str 	= x.@b
			if(str.indexOf(",")==-1){
				totalForward = int(str);
			}else{
				a = str.split(",");
				
				totalForward 	= int(a[0]);
				effectIsUp 		= int(a[1]) == 0?true:false;
				
				sound 			= int(a[2]);
				isBindingPlayer = int(a[3]);
				
				if(type == 5){
					sex = int(a[1]);
					voc = int(a[2]);
				}
			}
						  
			/*if(id == 1140){
				totalForward = 2;
			}*/
						
			name1 = name + "("+totalForward+"面)";
			
			if(RoleEditManager.currProject!=null){
				if(RoleEditManager.currProject.data == DataManager.project_God){
					totalForward = 4;
				}else if(RoleEditManager.currProject.data == DataManager.project_king2){
					totalForward = 4;
					
					if(int(x.@a) == 1){
						isBattleMode = true
					}else{
						isBattleMode = false;
					}
				}
			}
		}
		
		
		/**
		 * 获取战斗的swf的路径
		 */ 
		public function getSwfURL():String
		{
			return ActionMixManager.currProject.userSWFUrl + "/" + id + ".swf";
		}
		
		public function clone():AppResInfoItemVO
		{
			var it:AppResInfoItemVO = new AppResInfoItemVO();
			ToolUtils.clone(this,it);
			it.type = type;
			return it;
		}
		
	}
}