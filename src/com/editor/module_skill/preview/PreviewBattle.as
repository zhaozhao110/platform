package com.editor.module_skill.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.control.MapRenderControl;
	import com.editor.module_skill.battle.data.CreateMapItemData;
	import com.editor.module_skill.battle.role.EffectItem;
	import com.editor.module_skill.battle.role.PlayerRole;
	import com.editor.module_skill.battle.view.BattleBackground;
	import com.editor.module_skill.battle.view.BattleItemContainer;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.mediator.SkillSeqRightContainerMediator;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.timeline.vo.TimelineDataList;
	import com.editor.module_skill.timeline.vo.TimelineEffectData;
	import com.editor.module_skill.timeline.vo.TimelineResData;
	import com.editor.module_skill.vo.skill.EditSkillItemVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map.SandyMap;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapData;
	import com.sandy.render2D.map2.SandyMap2;
	import com.sandy.render2D.map2.data.SandyMapData2;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	public class PreviewBattle extends SandyMap2
	{
		public function PreviewBattle()
		{
			super("PreviewBattle");
			instace = this;
			create_init();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public static var instace:PreviewBattle;
		private var currFrameTxt:UIText;
		
		override protected function __map_init__():void
		{
			super.__map_init__();
			
			//渲染初始化
			renderControl = new MapRenderControl(this);
			
			//地图数据
			mapData = new SandyMapData2();
			mapData.stageOffsetX = 0;
			mapData.stageOffsetY = 0;
			
			
		}
		
		private function create_init():void
		{
						
			ground = new BattleBackground(this);
			addChild(ground as DisplayObject);
			
			roleScene = new BattleItemContainer(this);
			addChild(roleScene as DisplayObject);
			battleItemContainer = roleScene as BattleItemContainer;
			
			currFrameTxt = new UIText();
			currFrameTxt.color = ColorUtils.red;
			addChild(currFrameTxt);
			
			startEnterFrame()
			renderComplete();
		}
		
		public var battleItemContainer:BattleItemContainer;
		private var lastFrame:int;
		
		public function start():void
		{
			//初始化场景
			startEnterFrame()
			BattleContainer.instace.stopEnterFrame();
			addPlayer();
			addEffect()
			addResEffect()
			renderComplete();
			lastFrame = EditSkillManager.total_frames;
			//检测距离是否正确，不正确就移动
			setTimeout(playTimeline,2000);	
		}
		
		public function playAgain():void
		{
			playTimeline()
		}
		
		private var currFrame:Number;
		
		//播放时间轴
		private function playTimeline():void
		{
			if(battleItemContainer.attackPlayer!=null){
				battleItemContainer.attackPlayer.moveEnd_f = null;
			}
			currFrame = 0;
		}
		
		override protected function callFrame(delta:*=null):void
		{
			super.callFrame(delta);
			if(!isNaN(currFrame)){
				currFrame += 1;
				if(currFrame > lastFrame){
					currFrame = 1;
				}
				currFrameTxt.text = "当前帧位置: " + currFrame;
				EditSkillManager.timeDataList.play(currFrame);
			}
			renderControl.update(delta);
			
			visible = true;
		}
		
		override public function renderComplete():void
		{
			super.renderComplete();
			mapShow();
		}
		
		private function addResEffect():void
		{
			var attack_a:Array = [];
			var a:Array = EditSkillManager.timeDataList.getRow(EditSkillManager.row7)
			for(var i:int=0;i<a.length;i++){
				var d:TimelineResData = a[i] as TimelineResData;
				if(d!=null){
					var b:Array = d.list;
					for(var j:int=0;j<b.length;j++){
						var res:AppResInfoItemVO = b[j] as AppResInfoItemVO;
						attack_a[res.id] = res
					}
				}
			}
			
			var attack_aa:Array = [];
			
			var effect:EffectItem;
			for each(res in attack_a){
				if(res!=null){
					attack_aa.push(res);
				}
			}
			//按照特效的全局层次
			attack_aa = attack_aa.sortOn("monsterVoc",Array.NUMERIC);
			
			for(i=0;i<attack_aa.length;i++){
				res = attack_aa[i] as AppResInfoItemVO;
				effect = battleItemContainer.addEffect(res,false);
				res.preview_mapItemIndex = effect.getMapIndex();
			}
		}
		
		private function addEffect():void
		{
			var attack_a:Array = [];
			var a:Array = EditSkillManager.timeDataList.getRow(EditSkillManager.row3)
			for(var i:int=0;i<a.length;i++){
				var d:TimelineEffectData = a[i] as TimelineEffectData;
				if(d!=null){
					var b:Array = d.list;
					for(var j:int=0;j<b.length;j++){
						var res:AppResInfoItemVO = b[j] as AppResInfoItemVO;
						attack_a[res.id] = res
					}
				}
			}
			
			var defend_a:Array = [];
			a = EditSkillManager.timeDataList.getRow(EditSkillManager.row6)
			for(i=0;i<a.length;i++){
				d = a[i] as TimelineEffectData;
				if(d!=null){
					b = d.list;
					for(j=0;j<b.length;j++){
						res = b[j] as AppResInfoItemVO;
						defend_a[res.id] = res
					}
				}
			}
			
			var attack_aa:Array = [];
			var defend_aa:Array = [];
			
			var effect:EffectItem;
			for each(res in attack_a){
				if(res!=null){
					attack_aa.push(res);
				}
			}
			//按照特效的全局层次
			attack_aa = attack_aa.sortOn("monsterVoc",Array.NUMERIC);
			
			for each(res in defend_a){
				if(res!=null){
					defend_aa.push(res);
				}
			}
			defend_aa = defend_aa.sortOn("monsterVoc",Array.NUMERIC);
			
			for(i=0;i<attack_aa.length;i++){
				res = attack_aa[i] as AppResInfoItemVO;
				effect = battleItemContainer.addEffect(res,true);
				res.preview_mapItemIndex = effect.getMapIndex();
				battleItemContainer.attackPlayer.addEffect(effect);
			}
			
			for(i=0;i<defend_aa.length;i++){
				res = defend_aa[i] as AppResInfoItemVO;
				effect = battleItemContainer.addEffect(res,false)
				res.preview_mapItemIndex = effect.getMapIndex();
				battleItemContainer.defendPlayer.addEffect(effect);
			}
		}
		
		private function addPlayer():void
		{
			if(BattleContainer.instace.battleItemContainer.attackPlayer is PlayerRole){
				battleItemContainer.addPlayer(BattleContainer.instace.battleItemContainer.attackPlayer.getResInfoItem(),true)
				battleItemContainer.addArm((BattleContainer.instace.battleItemContainer.attackPlayer as PlayerRole).arm.getResInfoItem(),true)
			}else{
				battleItemContainer.addMonster(BattleContainer.instace.battleItemContainer.attackPlayer.getResInfoItem(),true)
			}
			if(BattleContainer.instace.battleItemContainer.defendPlayer is PlayerRole){
				battleItemContainer.addPlayer(BattleContainer.instace.battleItemContainer.defendPlayer.getResInfoItem(),false)
				battleItemContainer.addArm((BattleContainer.instace.battleItemContainer.defendPlayer as PlayerRole).arm.getResInfoItem(),false)
			}else{
				battleItemContainer.addMonster(BattleContainer.instace.battleItemContainer.defendPlayer.getResInfoItem(),false)
			}
		}
		
		/**
		 * 检测距离
		 */ 
		private function checkBetween():void
		{
			var currSkill:EditSkillItemVO = EditSkillManager.currSkill;
			trace("需要距离: " + currSkill.getReleaseRange(),battleItemContainer.defendPlayer.pixelLoc.x)
			if(currSkill.checkIsInReleaseRange(getBetween())==2 || currSkill.checkIsInReleaseRange(getBetween())==3){
				battleItemContainer.attackPlayer.moveEnd_f = playTimeline;
				battleItemContainer.attackPlayer.nextPoint = new SandyPoint(battleItemContainer.defendPlayer.pixelLoc.x-currSkill.getReleaseRange(),EditSkillManager.battleY);
			}
		}
		
		/**
		 * 获取两个玩家之间的距离
		 */ 
		private function getBetween():int
		{
			return battleItemContainer.defendPlayer.pixelLoc.x - battleItemContainer.attackPlayer.pixelLoc.x;
		}
		
		
		public function stop():void
		{
			mapStatus = SandyMapConst.map_status_hide;
			stopEnterFrame();
			//renderControl.configListeners(false);
			currFrame = NaN;
			//删除所有物体
			roleScene.dispose();
			//不移动
			//renderControl.dispose();
			//group
			//ground.dispose();
			
			BattleContainer.instace.startEnterFrame();
		}
		
		public function stopEnterFrame():void
		{
			stopTimer();
		}
		
		public function startEnterFrame():void
		{
			startTimer();
		}
	}
}