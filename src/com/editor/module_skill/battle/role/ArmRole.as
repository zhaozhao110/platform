package com.editor.module_skill.battle.role
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.data.ArmData;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.map.data.SandyMapSourceData;
	import com.sandy.render2D.map2.SandyMapConst2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;

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
				dt.url = (data as ArmData).getActionSign(actionType,imap);
				dt.action = a[i];
				SandyMapLoaderManager.getInstance().addMapItemShowQueue(this,dt);
			}
		}
		
		override public function parserComplete(v:String):void{
			BattleContainer.instace.get_SkillSeqModuleMediator().addLog2(v);
		}
		
		override public function checkIsMaster():Boolean
		{
			return (data as ArmData).isAttack;
		}
		
		override public function set big_bottomX(value:Number):void
		{
			super.big_bottomX = value;
			if(player!=null){
				setX(this.offsetX-player.offsetX);
			}
		}
		
		override public function set big_bottomY(value:Number):void
		{
			super.big_bottomY = value;
			if(player!=null){
				setY(this.offsetY-player.offsetY);
			}
		}
		
		override protected function synchScreen(delta:*=null):void{};
		
		override public function dispose():void
		{
			super.dispose();
			if(player!=null&&player.contains(this)){
				UIComponentUtil.removeMovieClipChild(null,this);
			}
		}
	}
}