package com.editor.module_skill.battle.role
{
	import com.editor.module_skill.battle.data.PlayerRoleData;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.utils.MapUtils;
	
	import flash.geom.Point;

	public class RoleBase extends MapItem
	{
		public function RoleBase(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		public var arm:ArmRole;
		
		
		override public function update(delta:*=null):int
		{
			//已经在删除中
			if(isDiposed) return 0;
			var tp:int = super.update(delta);
			move();
			return tp;
		}
		
		override protected function move(delta:*=null):void
		{
			super.move(); 
			if(nextPoint != null){
				moveToPoint();
			}else{
				moveToPointFinish();
			}
		}
		
		/**
		 * 中断移动 , 战斗时，停止移动，切换到走格子模式
		 */ 
		override public function skipMove(_action:String=""):void
		{
			if(nextPoint == null) return ;
			goto_attackDaiji_status();
			nextPoint = null ;
		}

		private var effect_ls:Array = [];
		
		public function addEffect(effect:EffectItem):void
		{
			effect_ls[effect.getMapIndex()] = effect;
		}
		
		public function getEffect(mapItemInd:String):EffectItem
		{
			return effect_ls[mapItemInd] as EffectItem;
		}
	}
}