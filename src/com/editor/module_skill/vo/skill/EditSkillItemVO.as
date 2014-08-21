package com.editor.module_skill.vo.skill
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	public class EditSkillItemVO implements ICloneInterface
	{
		public function EditSkillItemVO(x:XML=null)
		{
			if(x!=null){
				parser(x);
			}
		}
		
		//
		public var id:Number;
		public var name:String;
		public var name1:String;
		public var info:String;
		//a:技能释放距离 1_20 1等于,2小于等于,3大于等于
		public var releaseRange:String;
		//g:目标类型(0-自己 1-敌人)
		public var targetType:int;
		//v:职业限制(空表示不限制)
		public var voc:int;
		public var armType:int;
		public var attackId:int;
		
		private var _isEdited:Boolean;
		public function get isEdited():Boolean
		{
			return _isEdited;
		}
		public function set isEdited(value:Boolean):void
		{
			_isEdited = value;
			if(isEdited){
				name1 = ColorUtils.addColorTool(name1,ColorUtils.red);
			}
		}
				
		public function getSaveId():String
		{
			if(voc == 5){
				return id + "," + BattleContainer.instace.battleItemContainer.attackPlayer.getId();
			}
			return id.toString();
		}
		
		public function checkIsMonsterSkill():Boolean
		{
			return voc == 5;
		}
		
		private function parser(x:XML):void
		{
			id = Number(x.@i);
			name = x.@n;
			info = x.toString();
			targetType = int(x.@g);
			voc = int(x.@v);
			armType = int(x.@q);
			releaseRange = x.@a;
			
			name1 = id + " / " + name;
		}
		
		/**
		 * 是否符合该职业
		 */ 
		public function checkVoc(_voc:int):Boolean
		{
			if(voc == 0) return true;
			if(voc == _voc) return true;
			return false;
		}
		
		public function getReleaseRange():int
		{
			var a:Array = releaseRange.split("_");
			return int(a[1]);
		}
		
		/**
		 * 2:距离太远
		 * 3:距离太近
		 */ 
		public function checkIsInReleaseRange(n:int):int
		{
			var a:Array = releaseRange.split("_");
			var type:int = int(a[0]);
			if(type == 1){
				if(n == int(a[1])){
					return 0;
				}
			}else if(type == 2){
				if(n <= int(a[1])){
					return 0;
				}
				return 2;
			}else if(type == 3){
				if(n >= int(a[1])){
					return 0;
				}
				return 3;
			}
			return -1
		}
		
		public function cloneObject():*
		{
			var item:EditSkillItemVO =  new EditSkillItemVO();
			ToolUtils.clone(this,item);
			return item;
		}
		 
	}
}