package com.editor.moudule_drama.battle.role
{
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.control.MapRenderControl;
	import com.editor.moudule_drama.battle.data.MonsterData;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	import com.editor.module_skill.battle.role.RoleBase;

	public class MonsterItem extends RoleBase
	{
		public function MonsterItem(_map:ISandyMap2=null)
		{
			super(_map);
		}
		
		override public function render(ida:*):void
		{			
			data = ida;
			
			if(checkIsMaster()){
				(imap.getRenderControl() as MapRenderControl).setUserPlayer(this);
			}else{
				flip = true;
			}
			
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
				SandyMapLoaderManager.getInstance().addMapItemShowQueue2(this,(data as MonsterData).getActionSign(actionType,imap),a[i]);
			}
		}
		
		override public function parserComplete(v:String):void{
			BattleContainer.instace.get_SkillSeqModuleMediator().addLog2(v);
		}
		
		override public function checkIsMaster():Boolean
		{
			return MonsterData(data).isAttack;
		}
		
	}
}