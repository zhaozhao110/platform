package com.editor.moudule_drama.battle.role
{
	import com.editor.module_actionMix.vo.mix.ActionMixItemVO;
	import com.editor.module_actionMix.vo.mix.ActionMixTypeVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.data.MapItemData;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.SandyMapItem;
	import com.sandy.render2D.mapBase.animation.AnimationManager;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.SandyMapItem2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.geom.Matrix;
	
	public class MapItem extends SandyMapItem2
	{
		public function MapItem(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		override public function render(ida:*):void
		{			
			super.render(ida);
			
		}
		
		public function getMotionData():AppMotionItemVO
		{
			return MapItemData(data).motionData;
		}
		
		public function getResInfoItem():AppResInfoItemVO
		{
			return MapItemData(data).resInfoItem;
		}
		
		
		override protected function setBottomX(value:Number):void
		{
			
		}
		
		override protected function setBottomY(value:Number):void
		{
			
		}
		override public function setName(m:String):void
		{
			
		}
		
		
		override protected function getBottomX():Number
		{
			if(flip){
				return super.getBottomX()-getMotionData().size.width;
			}
			return super.getBottomX();
		}
		
		
		/**
		 * 是4方向还是8方向
		 */ 
		override public function getTotalForward(action:String):int
		{
			return 1;
		}
		
		override public function getTimeline(_action2:String):String
		{
			return getMotionData().getTimelineByType(_action2);
		}
		
		override public function getPngInfo(forward:int,ind:int,action:String):SandyRectangle
		{
			if(getMotionData().getActionByType(action) == null){
				return null;
			}
			if(getMotionData().getActionByType(action).getForward(forward) == null){
				return null;
			}
			return getMotionData().getActionByType(action).getForward(forward).getRectangle(ind);
		}
		
		override public function getColumn(action:String):int
		{
			if(getMotionData().getActionByType(action)!=null){
				return getMotionData().getActionByType(action).column;
			}
			return 0
		}
		
		override public function getOriginal_width():int
		{
			return getMotionData().size.width;
		}
		
		override public function getOriginal_height():int
		{
			return getMotionData().size.height;
		}
		
		override public function get isInScreen():Boolean
		{
			return true;
		}
		
		override protected function checkInScreen():Boolean
		{
			return true;
		}
		
		override public function synchScreen(force:Boolean=false):void{};
		
		override public function dispatchMouseOver():Boolean
		{
			return false;
		}
		
		override public function dispatchMouseClick():Boolean
		{
			return false;
		}
		
		override public function getMouseClickEnable():Boolean
		{
			return false;
		}
		
		/**
		 * 子类覆盖
		 */ 
		protected function move():void{};
		
		override protected function addShadowBitmap(sign:String):void{};
		
		override public function goto_daiji_status():void
		{
			goto_attackDaiji_status();
		}
		
		override public function set actionType(value:String):void
		{
			if(mixTimeline!=null){
				if(mixTimeline.id != int(value) && int(value) > 0){
					mixTimeline.dispose();
				}
			}
			
			super.actionType = value;
		}
		
		override protected function parserMixMotion():void
		{
			super.parserMixMotion();
			
			if(mixTimeline!=null){
				if(mixTimeline.id == int(actionType)){
					playMixMotion();
					return ;
				}
			}
			
			var item:ActionMixItemVO = BattleContainer.instace.get_EditSkillProxy().mix_ls.getItemById(int(actionType));
			if(item == null) return ;
			
			mixTimeline.id = item.id;
			
			var out:Array = [];
			for(var i:int=0;i<item.list.length;i++)
			{
				var rend:ActionMixTypeVO = item.list[i] as ActionMixTypeVO;
				var urlSign:String = SandyMapConst2.getURLSign(MapItemData(data).getActionSign("",imap),rend.actionType);
				for(var j:int=0;j<rend.total;j++){
					mixTimeline.add(rend.getSign(),AnimationManager.getAnimActionRect(urlSign,SandyMapConst.right,rend.frameIndex));
				}
			}
			mixTimeline.filter();
			
			playMixMotion();
		}
		
		
		override public function getTotalFrame(_act:String=""):int
		{
			if(StringTWLUtil.isWhitespace(_act)){
				_act = actionType;
			}
			if(checkPlayMixMotion()){
				return mixTimeline.getTotalFrames();
			}
			return getMotionData().getActionByType(_act).getTotalFrame();
		}
		
		
	}
}