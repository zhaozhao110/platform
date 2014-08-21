package com.editor.module_skill.timeline.vo
{
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.EffectItem;
	import com.editor.module_skill.preview.PreviewBattle;
	import com.sandy.utils.StringTWLUtil;

	public class TimelineResData extends TimelineDataBase
	{
		public function TimelineResData()
		{
			isKey = true;
		}
		
		public var list:Array = [];
		
		public function addItem(item:AppResInfoItemVO):void
		{
			if(!check(item)){
				list.push(item);
			}
		}
		
		public function check(item:AppResInfoItemVO):Boolean
		{
			for(var i:int=0;i<list.length;i++){
				if((list[i] as AppResInfoItemVO).id == item.id){
					return true;
				}
			}
			return false;
		}
		
		override public function save():*
		{
			var aa:Array = [];
			for(var i:int=0;i<list.length;i++){
				aa.push((list[i] as AppResInfoItemVO).id);
			}
			return frame+"$"+aa.join("|");
		}
		
		override public function parser(v:String):void
		{
			var a:Array = v.split("|");
			for(var i:int=0;i<a.length;i++)
			{
				var item:AppResInfoItemVO = get_EditSkillProxy().resInfo_ls.getCloneResInfoItemById(a[i]);
				if(item!=null){
					addEffect(item);
					list.push(item);
				}
			}
		}
		
		private function addEffect(item:AppResInfoItemVO):void
		{
			var effect:EffectItem = BattleContainer.instace.battleItemContainer.addEffect(item,false)
			if(effect == null) return ;
			item.edit_mapItemIndex = effect.getMapIndex();
		}
		
		public function removeItem(item:AppResInfoItemVO):void
		{
			for(var i:int=0;i<list.length;i++){
				if((list[i] as AppResInfoItemVO).id == item.id){
					list.splice(i,1);
					break;
				}
			}
			if(list.length == 0){
				remove();
			}
		}
		
		override public function getData():String
		{
			return list.length.toString();
		}
		
		override public function getLabel():String
		{
			var out:String = "";
			for(var i:int=0;i<list.length;i++){
				out += (list[i] as AppResInfoItemVO).name + ","
			}
			return out;
		}
		
		override public function play():void
		{
			var effect:EffectItem;
			for(var i:int=0;i<list.length;i++){
				var mapItemIndex:String = AppResInfoItemVO(list[i]).preview_mapItemIndex.toString();
				if(!StringTWLUtil.isWhitespace(mapItemIndex)){
					effect = PreviewBattle.instace.battleItemContainer.getRoleByMapItemIndex(mapItemIndex) as EffectItem;
					if(effect!=null){
						effect.play();
					}
				}
			}
		}
		
		override public function preview():void
		{
			for(var i:int=0;i<list.length;i++){
				var mapItemIndex:String = (list[i] as AppResInfoItemVO).edit_mapItemIndex;
				var effect:EffectItem = BattleContainer.instace.battleItemContainer.getRoleByMapItemIndex(mapItemIndex) as EffectItem;
				if(effect!=null){
					effect.play();
				}
			}
		}
	}
}