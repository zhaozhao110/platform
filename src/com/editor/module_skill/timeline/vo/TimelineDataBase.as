package com.editor.module_skill.timeline.vo
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.preview.PreviewBattle;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.timeline.TimelineRect;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;

	public class TimelineDataBase implements ITimelineDataBase
	{
		public function TimelineDataBase()
		{
		}
		
		//是关键帧
		private var _isKey:Boolean;
		public function get isKey():Boolean
		{
			return _isKey;
		}
		public function set isKey(value:Boolean):void
		{
			_isKey = value;
		}

		
		private var _row:int;
		public function get row():int
		{
			return _row;
		}
		public function set row(value:int):void
		{
			_row = value;
		}

		private var _frame:int;
		public function get frame():int
		{
			return _frame;
		}
		public function set frame(value:int):void
		{
			_frame = value;
		}
		
		public function getData():String
		{
			return "";
		}
		
		public function getLabel():String
		{
			return "";
		}
		
		public function reflash():void
		{
			var rect:TimelineRect;
			rect = TimelineContainer.instance.getTimeRect(row,frame);
			if(rect!=null){
				rect.type = EditSkillManager.rect_type4;
				rect.check();
			}			
		}
		
		public function remove():void
		{
			var rect:TimelineRect;
			rect = TimelineContainer.instance.getTimeRect(row,frame);
			if(rect!=null){
				rect.type = EditSkillManager.rect_type1;
				dispose();
				rect.check();
			}
		}
		
		/**
		 * 战斗预览的时候
		 */ 
		public function play():void{}
		
		/**
		 * 战斗编辑的时候
		 */ 
		public function preview():void{}
		
		/**
		 * 保存配置
		 */ 
		public function save():*{return ""}
		
		public function parser(v:String):void{};
		
		public function dispose():void
		{
			EditSkillManager.timeDataList.dispose(row,frame);
		}
		
		
		
		protected function getEditPlayer():RoleBase
		{
			if(checkIsAttack()){
				return getEditAttackPlayer();
			}
			return getEditDefendPlayer();
		}
		
		protected function getEditAttackPlayer():RoleBase
		{
			return BattleContainer.instace.battleItemContainer.attackPlayer;
		}
		
		protected function getEditDefendPlayer():RoleBase
		{
			return BattleContainer.instace.battleItemContainer.defendPlayer;
		}
		
		protected function getPlayer():RoleBase
		{
			if(checkIsAttack()){
				return getAttackPlayer();
			}
			return getDefendPlayer();
		}
		
		protected function getAttackPlayer():RoleBase
		{
			return PreviewBattle.instace.battleItemContainer.attackPlayer;
		}
		
		protected function getDefendPlayer():RoleBase
		{
			return PreviewBattle.instace.battleItemContainer.defendPlayer;
		}
		
		protected function checkIsAttack():Boolean
		{
			return EditSkillManager.checkIsAttack(row);
		}
		
		protected function get_EditSkillProxy():EditSkillProxy
		{
			return iManager.retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}