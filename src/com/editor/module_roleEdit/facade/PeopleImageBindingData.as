package com.editor.module_roleEdit.facade
{
	import com.editor.manager.DataManager;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.render2D.map.data.SandyMapConst;
	
	public class PeopleImageBindingData
	{
		private static var instance:PeopleImageBindingData ;
		public static function getInstance():PeopleImageBindingData{
			if(instance == null){
				instance =  new PeopleImageBindingData();
				//instance.__init__()
			}
			return instance;
		}
		
		
		public var topInfoTxt:String = "";
				
		public var dataGrid_ls:Array ;
	
		public static var status_ls:Array = [];
		
		
		public function init():void
		{
			//if(RoleEditManager.currProject.data == "God_cn_cn"){
				status_ls = RoleEditManager.god_action_ls;
			//}
		}
		
		/**
		 * 部分
		 * 
		 * @param action_cls 当前动画包含的AppMotionActionVO数组个数
		 */ 
		public function createManyActionList(action_cls:Array,resItem:AppResInfoItemVO):Array
		{ 
			//if(RoleEditManager.currProject.data == DataManager.project_God_cn_cn){
			return createManyActionList_god(action_cls,resItem);
			/*}
			return null;*/
		}
		
		private function createManyActionList_god(action_cls:Array,resItem:AppResInfoItemVO):Array
		{
			dataGrid_ls = null;
			dataGrid_ls = [];
			var a:Array = [];
			var isBattle:Boolean = resItem.isBattleMode;
			
			if(isBattle){
				a = RoleEditManager.god_battleAction_ls
			}else{
				a = RoleEditManager.god_noBattleAction_ls;
			}
			
			for(var i:int=0;i<a.length;i++){
				var it:ActionData = new ActionData();
				it.type = a[i];
				it.type_str = getTypeStr(it.type);
				dataGrid_ls.push(it);
			}
			return dataGrid_ls;
		}
		
		public function getTypeStr(type:String):String
		{
			return SandyMapConst.getActionTypeStr(type);
		}
		
		
	}
}