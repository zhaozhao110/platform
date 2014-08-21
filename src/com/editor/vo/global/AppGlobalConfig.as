package com.editor.vo.global
{
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.manager.DataManager;
	import com.editor.module_actionMix.vo.ActionMixConfigVO;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_map.vo.MapEditorConfigVO;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_roleEdit.vo.RoleEditConfigVO;
	import com.editor.module_sea.vo.SeaMapConfigVO;
	import com.editor.module_skill.vo.EditSkillConfigVO;
	import com.editor.moudule_drama.vo.DramaConfigVO;
	import com.editor.project_pop.projectRes.vo.ProjectResConfigVO;
	import com.editor.vo.pop.AppPopinfoListVO;
	import com.editor.vo.project.AppProjectListVO;
	import com.editor.vo.stacks.StackListVO;
	import com.editor.vo.temple.TempleListVO;
	import com.editor.vo.user.UserInfoListVO;
	import com.sandy.error.SandyError;
	import com.sandy.manager.data.SandyXMLListVO;
	import com.sandy.math.HashMap;
	
	import flash.data.SQLResult;

	/**
	 * assets/xml的配置文件
	 */ 
	public class AppGlobalConfig
	{
		public function AppGlobalConfig()
		{
			if(_instance!=null){
				SandyError.error("AppGlobalConfig is only");
			}
			_instance = this;
		}
		
		private static var _instance:AppGlobalConfig
		public static function get instance():AppGlobalConfig{
			if(_instance == null){
				new AppGlobalConfig();
			}
			return _instance;
		}
		
		public var seaMap_vo:SeaMapConfigVO;
		public var roleEdit_vo:RoleEditConfigVO;
		public var actionMix_vo:ActionMixConfigVO;
		public var editSkill_vo:EditSkillConfigVO;
		public var avg_vo:AVGConfigVO;
		public var mapEditor_vo:MapEditorConfigVO;
		public var mapIsoEditor_vo:MapEditorIsoManager;
		public var mapEditor2_vo:MapEditor2Manager;
		public var projects:AppProjectListVO;
		public var dramaV_vo:DramaConfigVO;
		public var stack_list:StackListVO;
		public var projectRes_vo:ProjectResConfigVO;
		public var popInfo_vo:AppPopinfoListVO;
		public var user_vo:UserInfoListVO;
		public var temple_vo:TempleListVO;
		
		public var version:String;
		public var download:String;
		public var serverDirManager:String;
		public var upload:String;
		public var help_website:String;
		public var res_url:String;
		public var file_url:String;
		public var img_url:String;
		public var socket_port:int;
		public var socket_url:String;
		public var as3_api:String;
		public var config_hash:HashMap = new HashMap();
		
		public function querySql():void
		{
			var statement:String = "select * from projects";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			projects = new AppProjectListVO(res);
			
			statement = "select * from config";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			var a:Array = res.data;
			var len:int = a.length;
			for(var i:int=0;i<len;i++){
				var obj:Object = a[i];
				if(obj.key == "version"){
					version = obj.value;
				}else if(obj.key == "download"){
					download = obj.value;
				}else if(obj.key == "serverDirManager"){
					serverDirManager = obj.value;
				}else if(obj.key == "upload"){
					upload = obj.value;
				}else if(obj.key == "help"){
					help_website = obj.value;
					res_url = help_website + "/fileDB/UserUploadFile/"
					file_url = res_url + "file/"
					img_url = res_url + "image/"
				}else if(obj.key == "socket"){
					var aa:Array = String(obj.value).split(",");
					socket_port = int(aa[0]);
					socket_url = aa[1];
				}else if(obj.key == "as3_api"){
					as3_api = obj.value;
				}else{
					config_hash.put(obj.key,obj.value);
				}
			}
			
			var xml:XML ;
			
			statement = "select * from stacks_xml";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			a = res.data;
			len = a.length;
			for(i=0;i<len;i++){
				obj = a[i];
				xml = XML(obj.value);
				if(obj.id == DataManager.stack_roleEdit){
					roleEdit_vo = new RoleEditConfigVO(xml);
				}else if(obj.id == DataManager.stack_actionMix){
					actionMix_vo = new ActionMixConfigVO(xml);
				}else if(obj.id == DataManager.stack_skill){
					editSkill_vo = new EditSkillConfigVO(xml);
				}else if(obj.id == DataManager.stack_map){
					mapEditor_vo = new MapEditorConfigVO(xml);
				}else if(obj.id == DataManager.stack_drama){
					dramaV_vo = new DramaConfigVO(xml);
				}else if(obj.id == DataManager.stackPop_projectRes){
					projectRes_vo = new ProjectResConfigVO(xml);
				}else if(obj.id == DataManager.stack_mapIso){
					mapIsoEditor_vo = MapEditorIsoManager.getInstance();
					mapIsoEditor_vo.parser(xml);
				}else if(obj.id == DataManager.stack_mapTile){
					mapEditor2_vo = MapEditor2Manager.getInstance();
					mapEditor2_vo.parser(xml);
				}else if(obj.id == DataManager.stack_avg){
					avg_vo = new AVGConfigVO(xml);
				}else if(obj.id == DataManager.stack_sea){
					seaMap_vo = new SeaMapConfigVO(xml);
				}
			}
			
			statement = "select * from stacks";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			a = res.data;
			stack_list = new StackListVO(a);
			
			statement = "select * from popInfo";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			a = res.data;
			popInfo_vo = new AppPopinfoListVO(a);
			
			statement = "select * from user";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			a = res.data;
			user_vo = new UserInfoListVO(a);
			
			statement = "select * from temp";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			a = res.data;
			temple_vo = new TempleListVO(a);
		}
	}
}