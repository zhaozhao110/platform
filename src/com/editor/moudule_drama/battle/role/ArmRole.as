package com.editor.moudule_drama.battle.role
{
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.data.ArmData;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	import com.editor.moudule_drama.battle.role.MapItem;
	import com.editor.moudule_drama.battle.role.PlayerRole;

	/**
	 * 武器,该容器被添加到PlayerRole容器里
	 */ 
	public class ArmRole extends MapItem 
	{
		public function ArmRole(_imap:ISandyMap2=null)
		{
			super(_imap);
		}
		
		public var player:PlayerRole;
		
		public function setPlayer(pl:PlayerRole):void
		{
			player = pl;
			setX(this.offsetX-player.offsetX);
			setY(this.offsetY-player.offsetY);
		}
		
		override public function render(ida:*):void
		{
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
				SandyMapLoaderManager.getInstance().addMapItemShowQueue2(this,(data as ArmData).getActionSign(actionType,imap),a[i]);
			}
		}

		override public function parserComplete(v:String):void{
			BattleContainer.instace.get_SkillSeqModuleMediator().addLog2(v);
		}
		
		override public function checkIsMaster():Boolean
		{
			return (data as ArmData).isAttack;
		}
		
		override protected function setBottomX(value:Number):void
		{
			big_bottomX = value;
			if(player!=null){
				setX(this.offsetX-player.offsetX);
			}
		}
		
		override protected function setBottomY(value:Number):void
		{
			big_bottomY = value;
			if(player!=null){
				setY(this.offsetY-player.offsetY);
			}
		}
		
		override public function synchScreen(force:Boolean=false):void{};
		
		override public function dispose():void
		{
			super.dispose();
			if(player!=null&&player.contains(this)){
				player.removeChild(this);
			}
		}
	}
}