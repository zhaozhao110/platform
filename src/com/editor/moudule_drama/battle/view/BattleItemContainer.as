package com.editor.moudule_drama.battle.view
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.control.MapItemEffectManager;
	import com.editor.moudule_drama.battle.data.CreateMapItemData;
	import com.editor.moudule_drama.battle.role.ArmRole;
	import com.editor.moudule_drama.battle.role.EffectItem;
	import com.editor.moudule_drama.battle.role.MonsterItem;
	import com.editor.moudule_drama.battle.role.PlayerRole;
	import com.editor.moudule_drama.battle.role.RoleBase;
	import com.sandy.render2D.map.interfac.ISandyItemEffectManager;
	import com.sandy.render2D.map.manager.SandyItemEffectManager;
	import com.sandy.render2D.map2.SandyMapItemScene2;
	import com.sandy.render2D.map2.interfac.ISandyItemEffectManager2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	

	public class BattleItemContainer extends SandyMapItemScene2
	{
		public function BattleItemContainer(_imap:ISandyMap2=null)
		{
			super(_imap);
		}
		
		override protected function getEffectManagerClass():Class
		{
			return MapItemEffectManager;
		}
		
		override public function dispose():void
		{
			super.dispose();
			attackPlayer = null;
			defendPlayer = null;
		}
				
		/**
		 * 攻击方
		 */ 
		public var attackPlayer:RoleBase;
		/**
		 * 防御方
		 */ 
		public var defendPlayer:RoleBase;
		
		
		/**
		 * 添加特效
		 */ 
		public function addEffect(item:AppResInfoItemVO,isAttack:Boolean):EffectItem
		{
			return (itemEffectManager as MapItemEffectManager).addEffect(item,isAttack);
		}
		
		/**
		 * 添加玩家
		 */ 
		public function addPlayer(item:AppResInfoItemVO,isAttack:Boolean):PlayerRole
		{
			if(item == null) return null;
			if(isAttack){
				if(attackPlayer!=null){
					attackPlayer.dispose();
				}
			}else{
				if(defendPlayer!=null){
					defendPlayer.dispose();
				}
			}
			var pl:PlayerRole = new PlayerRole(imap);
			pl.render(CreateMapItemData.createPlayerData(item,isAttack));
			add_itemSprite(pl);
			if(isAttack){
				attackPlayer = pl;
			}else{
				defendPlayer = pl;
			}
			return pl;
		}
		
		/**
		 * 添加怪物
		 */ 
		public function addMonster(item:AppResInfoItemVO,isAttack:Boolean):MonsterItem
		{
			if(item == null) return null;
			if(isAttack){
				if(attackPlayer!=null){
					attackPlayer.dispose();
				}
			}else{
				if(defendPlayer!=null){
					defendPlayer.dispose();
				}
			}
			var pl:MonsterItem = new MonsterItem(imap);
			pl.render(CreateMapItemData.createMonsterData(item,isAttack));
			add_itemSprite(pl);
//			if(isAttack){
//				attackPlayer = pl;
//			}else{
//				defendPlayer = pl;
//			}
			return pl;
		}
		
		/**
		 * 添加武器
		 */ 
		public function addArm(item:AppResInfoItemVO,isAttack:Boolean):ArmRole
		{
			if(item == null) return null;
			if(isAttack){
				if(attackPlayer!=null){
					PlayerRole(attackPlayer).removeArm();
				}
			}else{
				if(defendPlayer!=null){
					PlayerRole(defendPlayer).removeArm();
				}
			}
			if(isAttack){
				var pl:ArmRole = new ArmRole(imap);
				pl.render(CreateMapItemData.createArmData(item,isAttack));
				PlayerRole(attackPlayer).addArm(pl);
			}else{
				pl = new ArmRole(imap);
				pl.render(CreateMapItemData.createArmData(item,isAttack));
				PlayerRole(defendPlayer).addArm(pl);
			}
			return pl
		}
		
	}
}