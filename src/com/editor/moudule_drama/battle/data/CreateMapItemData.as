package com.editor.moudule_drama.battle.data
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.battle.BattleContainer;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.math.SandyPoint;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.utils.Random;
	import com.editor.moudule_drama.battle.data.ArmData;
	import com.editor.moudule_drama.battle.data.EffectData;
	import com.editor.moudule_drama.battle.data.MonsterData;
	import com.editor.moudule_drama.battle.data.PlayerRoleData;

	public class CreateMapItemData
	{
		
		
		private static var mapItem_index:int;
		public static var battle:BattleContainer;
		
		
		public static function createMonsterData(item:AppResInfoItemVO,isAttack:Boolean):MonsterData
		{
			var data:MonsterData = new MonsterData();
			data.mapItem_index		= mapItem_index++;
			data.type 				= SandyMapConst.map_item_type_monster;
			data.isAttack			= isAttack;
			
			data.name 				= "test" + Random.integer(10);
			data.id					= item.id.toString();
			if(isAttack){
				data.loc 			= EditSkillManager.attack_loc;
			}else{
				data.loc 			= EditSkillManager.defend_loc;
			}
			
			data.motionData			= get_EditSkillProxy().motion_ls.getMotionById(item.id);
			data.motionId			= data.motionData.id;
			
			if(data.motionData == null){
				battle.mediator.showError("MapCreateLoadData createPlayer motionData is null," + item.id)
			}
			
			data.resInfoItem		= item;
			
			data.offsetX	 		= data.motionData.originalPoint.x;
			data.offsetY 			= data.motionData.originalPoint.y;
			
			/*if(!isAttack){
			data.loc.x += data.motionData.size.width;
			}*/
			
			//data.data 				= user;
			//trace("addItem player at: index: " + data.mapItem_index , "id:"+ data.id , "x:" + data.loc.x , "y:" + data.loc.y )
			return data;
		}
		
		
		public static function createEffect(item:AppResInfoItemVO,isAttack:Boolean):EffectData
		{
			var data:EffectData = new EffectData();
			data.mapItem_index		= mapItem_index++;
			data.type 				= SandyMapConst.map_item_type_effect;
			data.isAttack			= isAttack;
			
			data.name 				= "test" + Random.integer(10);
			data.id					= data.name;
			if(item.totalForward==1){
				if(isAttack){
					data.loc 			= BattleContainer.instace.battleItemContainer.attackPlayer.pixelLoc;
				}else{
					data.loc 			= BattleContainer.instace.battleItemContainer.defendPlayer.pixelLoc;
				}
			}else{
				data.loc = new SandyPoint(0,0);
			}
			
			data.offsetX = 0;
			data.offsetY = 0;
			
			data.resInfoItem		= item;
			
			//data.data 				= user;
			//trace("addItem player at: index: " + data.mapItem_index , "id:"+ data.id , "x:" + data.loc.x , "y:" + data.loc.y )
			return data;
		}
		
		public static function createPlayerData(item:AppResInfoItemVO,isAttack:Boolean):PlayerRoleData
		{
			var data:PlayerRoleData = new PlayerRoleData();
			data.mapItem_index		= mapItem_index++;
			data.type 				= SandyMapConst.map_item_type_Player;
						
			data.name 				= "test" + Random.integer(10);
			data.id					= item.id.toString();
			if(isAttack){
				data.loc 			= EditSkillManager.attack_loc;
			}else{
				data.loc 			= EditSkillManager.defend_loc;
			}
			
			data.motionData			= get_EditSkillProxy().motion_ls.getMotionById(item.id);
			data.motionId			= data.motionData.id;
						
			if(data.motionData == null){
				battle.mediator.showError("MapCreateLoadData createPlayer motionData is null," + item.id)
			}
			
			data.resInfoItem		= item;
			
			data.offsetX	 		= data.motionData.originalPoint.x;
			data.offsetY 			= data.motionData.originalPoint.y;
			
			/*if(!isAttack){
				data.loc.x += data.motionData.size.width;
			}*/
			
			//data.data 				= user;
			//trace("addItem player at: index: " + data.mapItem_index , "id:"+ data.id , "x:" + data.loc.x , "y:" + data.loc.y )
			return data;
		}
		
		public static function createArmData(item:AppResInfoItemVO,isAttack:Boolean):ArmData
		{
			var data:ArmData = new ArmData();
			data.mapItem_index		= mapItem_index++;
			data.motionData			= get_EditSkillProxy().motion_ls.getMotionById(item.id);
			data.motionId			= data.motionData.id;
			data.loc 				= new SandyPoint(0,0);
			data.isAttack			= isAttack;
			
			if(data.motionData == null){
				battle.mediator.showError("MapCreateLoadData createPlayer motionData is null," + item.id)
			}
			
			data.resInfoItem		= item;
			
			data.offsetX	 		= data.motionData.originalPoint.x;
			data.offsetY 			= data.motionData.originalPoint.y;
			
			//data.data 				= user;
			//trace("addItem player at: index: " + data.mapItem_index , "id:"+ data.id , "x:" + data.loc.x , "y:" + data.loc.y )
			return data;
		}
		
		private static function get_EditSkillProxy():EditSkillProxy
		{
			return SandyEngineGlobal.iManager.retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
	}
}