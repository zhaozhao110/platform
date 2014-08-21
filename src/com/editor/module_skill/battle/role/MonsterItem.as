package com.editor.module_skill.battle.role
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.control.MapRenderControl;
	import com.editor.module_skill.battle.data.MonsterData;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;

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
		
		override protected function loadSwfComplete(value:*=null):void
		{
			super.loadSwfComplete();
			setTimeout(parserAllBattleAction,1000);
		}
		
		private var _parserAll_b:Boolean;
		//先全部解析战斗的
		private function parserAllBattleAction():void
		{
			if(_parserAll_b) return ;
			_parserAll_b = true;
			var a:Array = SandyMapConst.battle_action_ls;
			for(var i:int=0;i<a.length;i++){
				var dt:SandyMapSourceData = new SandyMapSourceData();
				dt.sceneType = 1;
				dt.url = (data as MonsterData).getActionSign(actionType,imap);
				dt.action = a[i]
				SandyMapLoaderManager.getInstance().addMapItemShowQueue(this,dt);
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