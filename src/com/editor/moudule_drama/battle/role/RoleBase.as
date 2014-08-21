package com.editor.moudule_drama.battle.role
{
	import com.editor.moudule_drama.battle.data.PlayerRoleData;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.utils.MapUtils;
	
	import flash.geom.Point;
	import com.editor.moudule_drama.battle.role.EffectItem;
	import com.editor.moudule_drama.battle.role.MapItem;

	public class RoleBase extends MapItem
	{
		public function RoleBase(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		private var _nextPoint:SandyPoint;
		/**
		 * 下一个要移动的点(像素)
		 */
		public function get nextPoint():SandyPoint
		{
			return _nextPoint;
		}
		public function set nextPoint(value:SandyPoint):void
		{
			_nextPoint = value;
		}
		
		
		override public function update():int
		{
			//已经在删除中
			if(isDiposed) return 0;
			var tp:int = super.update();
			move();
			return tp;
		}
		
		override protected function move():void
		{
			super.move(); 
			if(nextPoint != null){
				moveToPoint();
			}else{
				moveToPointFinish();
			}
		}
		
		/**
		 * 获取移动速度
		 */ 
		protected function getMoveSpeed():Number
		{
			return PlayerRoleData(data).moveSpeed;
		}
		
		/**
		 * 中断移动 , 战斗时，停止移动，切换到走格子模式
		 */ 
		public function skipMove(_action:String=""):void
		{
			if(nextPoint == null) return ;
			goto_attackDaiji_status();
			nextPoint = null ;
		}
		
		/**
		 * 移动到下一个点
		 * @return true:已经移动到了目的地，可以走一个格子 , false:还有一段距离
		 */ 
		protected function moveToPoint():Boolean
		{
			var currPoint:SandyPoint = pixelLoc;
			//现在角色的位置--上一次取到的坐标
			var distance:Number = Point.distance(currPoint,nextPoint);
			
			if(distance <= getMoveSpeed()/2){
				//goto_daiji_status();
				return true;
			}
			
			createForward(currPoint,nextPoint);
			//动作类型
			goto_attackPaodong_status()
			//求出时间
			var moveNum:Number	= distance / getMoveSpeed();
			if(moveNum <=0 ){
				//SandyError.error("move speed is 0 at: " +this);
				//goto_daiji_status();
				return true;
			}
			
			//x方向移动的速度
			var stepX:Number 	= (nextPoint.x - currPoint.x)/moveNum;
			//y方向移动的速度
			var stepY:Number 	= (nextPoint.y - currPoint.y)/moveNum;
			
			//本身人物的移动
			this.setBottomX(this.getBottomX()+stepX)
			this.setBottomY(this.getBottomY()+stepY)
			
			return false;
		}
		
		protected function moveToPointFinish(force:Boolean=false):void
		{
			if(moveEnd_f!=null) moveEnd_f();
		}
		
		/**
		 * 算出走路时的方向
		 */ 
		public function createForward(pixel:SandyPoint=null,nextPixel:SandyPoint=null):int
		{
			if(pixel == null){
				pixel = pixelLoc;
			}
			if(nextPixel == null) return this.forward;
			this.forward = MapUtils.getDirection(pixel,nextPixel,0,2);
			return forward;
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