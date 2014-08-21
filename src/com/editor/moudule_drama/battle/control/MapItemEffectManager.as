package com.editor.moudule_drama.battle.control
{
	
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.moudule_drama.battle.data.CreateMapItemData;
	import com.editor.moudule_drama.battle.data.EffectData;
	import com.editor.moudule_drama.battle.role.EffectItem;
	import com.sandy.render2D.map.SandyMapSprite;
	import com.sandy.render2D.map.manager.SandyItemEffectManager;
	import com.sandy.render2D.map2.SandyMapSprite2;
	import com.sandy.render2D.map2.interfac.ISandyMap2;
	import com.sandy.render2D.map2.manager.SandyItemEffectManager2;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;

	public class MapItemEffectManager extends SandyItemEffectManager2
	{
		public function MapItemEffectManager(downSp:SandyMapSprite2=null,upSp:SandyMapSprite2=null,_map:ISandyMap2=null)
		{
			super(downSp,upSp,_map);
		}
				
		
		/**
		 * 播放特效
		 */ 
		public function addEffect(info:AppResInfoItemVO,isAttack:Boolean):EffectItem
		{
			if(info==null) return null;
			
			var parentSp:SandyMapSprite2;
			if(info.effectIsUp){
				//是在人的上面
				parentSp = upSprite;
			}else{
				//在人的下面
				parentSp = downSprite;
			}
			
			var effectData:EffectData = CreateMapItemData.createEffect(info,isAttack);
			
			var effect:EffectItem = new EffectItem(map);
			effect.render(effectData);
			parentSp.addChild(effect);
			reflashEffectDepth(parentSp);
			add_effect(effect);
			return effect;
		}
		
		private function reflashEffectDepth(sp:SandyMapSprite2):void
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