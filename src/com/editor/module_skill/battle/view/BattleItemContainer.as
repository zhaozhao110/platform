package com.editor.module_skill.battle.view
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.data.CreateMapItemData;
	import com.editor.module_skill.battle.data.EffectData;
	import com.editor.module_skill.battle.role.ArmRole;
	import com.editor.module_skill.battle.role.EffectItem;
	import com.editor.module_skill.battle.role.MonsterItem;
	import com.editor.module_skill.battle.role.PlayerRole;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.sandy.render2D.map2.SandyMapItemScene2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.mapBase.SandyMapSpriteBase;
	
	import flash.display.DisplayObject;
	

	public class BattleItemContainer extends SandyMapItemScene2
	{
		public function BattleItemContainer(_imap:ISandyMap2=null)
		{
			super(_imap);
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			attackPlayer = null;
			defendPlayer = null;
		}
		
		override protected function __init__():void
		{
			super.__init__();
				
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
			if(isAttack){
				attackPlayer = pl;
			}else{
				defendPlayer = pl;
			}
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
					if(attackPlayer is MonsterItem) return null;
					PlayerRole(attackPlayer).removeArm();
				}
			}else{
				if(defendPlayer!=null){
					if(defendPlayer is MonsterItem) return null;
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
		
		
		/**
		 * 播放特效
		 */ 
		public function addEffect(info:AppResInfoItemVO,isAttack:Boolean):EffectItem
		{
			if(info==null) return null;
			
			var parentSp:SandyMapSpriteBase;
			if(info.effectIsUp){
				//是在人的上面
				parentSp = upEffectSprite;
			}else{
				//在人的下面
				parentSp = downEffectSprite;
			}
			
			var effectData:EffectData = CreateMapItemData.createEffect(info,isAttack);
			
			var effect:EffectItem = new EffectItem(map);
			effect.render(effectData);
			parentSp.addChild(effect);
			reflashEffectDepth(parentSp);
			add_itemSprite(effect);
			return effect;
		}
		
		private function reflashEffectDepth(sp:SandyMapSpriteBase):void
		{
			var sort_children:Array = [];
			for(var i:int=0;i<sp.numChildren;i++)
			{
				var effect:EffectItem = sp.getChildAt(i) as EffectItem;
				if(effect!=null){
					sort_children.push({ mapItem:effect,
						depth:sp.getChildIndex(effect as DisplayObject),
						depth2:effect.getResInfoItem().monsterVoc });
				}
			}
			sort_children = sort_children.sortOn( "depth2", Array.NUMERIC);
			var len:int = sort_children.length;
			for(i=0;i<len;i++)
			{
				var child:EffectItem = Object(sort_children[i]).mapItem;
				if(child != null && i !=  Object(sort_children[i]).depth){
					if( sp.contains(child)){
						sp.setChildIndex( child, i);
					}
				}
			}
		}
	}
}