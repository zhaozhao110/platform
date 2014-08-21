package com.editor.services
{
	import com.air.io.FileUtils;
	import com.sandy.SandyEngineGlobal;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class Services
	{
		public function Services()
		{
		}
		
		public static function init():void
		{
			trace("File.applicationDirectory:"+File.applicationDirectory.nativePath);
			
			update_xml = server_res_url + update_xml;
			db_url = server_res_url + db_url;
			api_url = server_res_url + api_url
			temp_url = server_res_url + temp_url;
			changeLog_url = server_res_url + changeLog_url;
			editSkill_background = server_res_url + editSkill_background;
		}
		
		public static const server_res_url:String = "http://192.168.0.4:11111/editor/"
		//public static const server_res_url:String = "http://localhost:11111/editor/"
		public static var update_xml:String = "version.xml"
		public static var db_url:String = "db"
		public static var api_url:String = "api"
		public static var temp_url:String = "temple_as.zip";
		public static var changeLog_url:String = "changeLog"
		public static var editSkill_background:String = "mapBackground.jpg"
		public static const app_fold_url:String = "E:\\hg_res\\as-platform\\engineEditor"
		
		//编辑是在assets下面，查询是在bin-debug 下面的assets里
		//db是嵌入到程序中
		public static const db_local_url:String = File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"db";
		//从服务器下载
		public static const api_local_url:String = File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"api";
		//从服务器下载
		public static const temp_local_url:String = FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor"+File.separator+"temple_as.zip";
		//从服务器下载,其他帐号都是访问这个地址
		public static const changeLog_local_url:String = File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"changeLog";
		
		//系统管理员编辑，是放在assets下面
		public static var changeLog_edit_local_url:String = "D:\\changeLog";
		//version.xml
		//public static var version_edit_local_url:String = "G:\\klive\\kuaipan\\baidu\\project\\editor\\version.xml"
		public static var version_edit_local_url:String = "F:\\kuaipan\\project\\editor\\version.xml"
		
		public static var assets_fold_url:String = "/assets/"
		public static var plus_fold_url:String = "/plus/"
		
		public static const resource_xml_url:String = "resource.xml";
		public static const dict_xml_url:String = "dict.xml";
		public static const motion_xml_url:String = "motion.xml"
		public static const action_xml_url:String = "action.xml"
		public static const skill_xml_url:String = "skill.xml"
		public static const mapDefine_xml_url:String = "mapDefine.xml";
		public static const motionLvl_xml_url:String = "motionLevel.xml"
		public static const skillSequence_xml_url:String = "skillSequence.xml";
		public static const actionMix_xml_url:String = "actionMix.xml"
		public static const mapRes_xml_url:String = "mapRes.xml";
		public static const plot_xml_url:String = "plot.xml";
		public static const tool_swf:String = "assets/tool.swf"
			
	}
}