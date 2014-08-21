package com.editor.module_actionMix.manager
{
	import com.editor.module_actionMix.vo.ActionMixActionListVO;
	import com.editor.module_actionMix.vo.ActionMixData;
	import com.editor.module_actionMix.vo.project.ActionMixProjectItemVO;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;
	import com.sandy.render2D.map.data.SandyMapConst;

	public class ActionMixManager	
	{
		//当前操作的项目
		//{name:"" data:""}
		public static var currProject:ActionMixProjectItemVO;
		
		public static var topInfoTxt:String = "";
		
		
		public static var actionList:ActionMixActionListVO = new ActionMixActionListVO();
		
		
		public static var god_action_ls:Array = [];
		
		public static function init():void
		{
			if(god_action_ls.length>0) return ;
			
			var a:Array = [];
			a.push(SandyMapConst.status_attackDaiji_type);
			a.push(SandyMapConst.status_attackPaodong_type);
			a.push(SandyMapConst.status_attack1_type);
			a.push(SandyMapConst.status_attack2_type);
			a.push(SandyMapConst.status_attack3_type);
			a.push(SandyMapConst.status_attack4_type);
			a.push(SandyMapConst.status_attack5_type);
			a.push(SandyMapConst.status_attack6_type);
			
			a.push(SandyMapConst.status_shoushang_type)
			a.push(SandyMapConst.status_shoushang2_type)
			a.push(SandyMapConst.status_buff_type)
			a.push(SandyMapConst.status_gedang_type)
			a.push(SandyMapConst.status_jifei_type)
			a.push(SandyMapConst.status_jifeipaqi_type)
			a.push(SandyMapConst.status_shanbi_type)
			a.push(SandyMapConst.status_shiwang_type);
			a.push(SandyMapConst.status_dazuo_type);
			a.push(SandyMapConst.status_daiji_type);
			a.push(SandyMapConst.status_paodong_type);
			
			for(var i:int=0;i<a.length;i++){
				var vo:ActionMixData = new ActionMixData();
				vo.type = a[i];
				vo.type_str = SandyMapConst.getActionTypeStr(a[i]);
				god_action_ls.push(vo);
			}
		}
		
		public static function getIndexByAction(action:String):int
		{
			for(var i:int=0;i<god_action_ls.length;i++){
				var vo:ActionMixData = god_action_ls[i] as ActionMixData
				if(vo.type == action){
					return i
				}
			}
			return -1;
		}
		
	}
}