package com.editor.moudule_drama.battle.role
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.control.MapRenderControl;
	import com.editor.moudule_drama.battle.data.PlayerRoleData;
	import com.sandy.render2D.map.SandyMapItem;
	import com.sandy.render2D.map.interfac.IAnimationLevelData;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	import com.editor.moudule_drama.battle.role.ArmRole;
	import com.editor.moudule_drama.battle.role.RoleBase;

	public class PlayerRole extends RoleBase
	{
		public function PlayerRole(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		override protected function __init__():void
		{
			super.__init__();
			createAnimationLevel();	
		}
		
		override public function render(ida:*):void
		{			
			data = ida;
			
//			if(checkIsMaster()){
//				(imap.getRenderControl() as MapRenderControl).setUserPlayer(this);
//			}else{
//				flip = true;
//			}
			flip = true;
			super.render(ida);
			
			goto_attackDaiji_status();
		}
		
		override protected function loadSwfComplete(domain:ApplicationDomain=null):void
		{
			super.loadSwfComplete(domain);
			setTimeout(parserAllBattleAction,1000);
		}
		
		private var _parserAll_b:Boolean;
		//先全部解析战斗的
		private function parserAllBattleAction():void
		{
			if(_parserAll_b) return ;
			_parserAll_b = true;
			var a:Array = SandyMapConst2.battle_action_ls;
			for(var i:int=0;i<a.length;i++){
				SandyMapLoaderManager.getInstance().addMapItemShowQueue2(this,(data as PlayerRoleData).getActionSign(actionType,imap),a[i]);
			}
		}
		
		override public function parserComplete(v:String):void{
			BattleContainer.instace.get_SkillSeqModuleMediator().addLog2(v);
		}
		
		override public function checkIsMaster():Boolean
		{
			return true;
		}
				
		override public function update():int
		{
			var tp:int = super.update();
			if(arm!=null){
				arm.update();
			}
			return tp;
		}
		
		override public function set actionType(value:String):void
		{
			super.actionType = value;
			if(arm!=null){
				arm.actionType = value;
			}
		}
		
		/***********************  武器  *********************/
		
		
		public var arm:ArmRole;
		
		/**
		 * 添加武器
		 */ 
		public function addArm(pl:ArmRole):void
		{
			arm = pl;
			arm.setPlayer(this);
			addChild(arm);
			
			anLevel.put(arm);
			anLevel.action_ls = BattleContainer.instace.get_EditSkillProxy().motionLvl_ls.getGroup(getResInfoItem().monsterVoc).action_ls;
		}
		
		override public function getAnimationLevelData(_act:String):IAnimationLevelData
		{
			return BattleContainer.instace.get_EditSkillProxy().mix_ls.getItemByActionGroup(getResInfoItem().monsterType,int(_act));
		}
		
		public function removeArm():void
		{
			if(arm!=null){
				arm.dispose();
			}
			arm = null;
		}
		
		
		
	}
}