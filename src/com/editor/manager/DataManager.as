package com.editor.manager
{
	import com.editor.vo.stacks.StackDataVO;
	import com.sandy.manager.SandyDataManager;
	import com.sandy.manager.data.SandyData;

	public class DataManager extends SandyDataManager
	{
		////////////// 类型  //////////////////////////
		
		public static const def_col:uint = 0xd4d0c8;
		
		
		////////////// 数据  //////////////////////////
		
		
		
		//项目列表
		public static const pop_projectDirectory:int = 1;
		//控制台
		public static const pop_console:int = 2;
		//code editor
		public static const pop_codeEditor:int = 4;
		//ui editor
		public static const pop_uiEditor:int = 5;
		//component list
		public static const pop_comList:int = 6;
		//ui attri list
		public static const pop_uiAttriList:int = 7;
		//css edit 
		public static const pop_cssEdit:int = 8;
		//css attri list
		public static const pop_cssAttriList:int = 9; 
		//outline 
		public static const pop_outline:int = 10;
		//invertedGroup
		public static const pop_invertedGroup:int = 11;
		//code outline
		public static const pop_codeOutline:int = 12;
		//搜索
		public static const pop_search:int =13;
		//3d outline
		public static const pop3d_outline:int = 14;
		//3d attri
		public static const pop3d_attri:int = 15;
		//3d project
		public static const pop3d_project:int = 16;
		//3d consol
		public static const pop3d_console:int = 17;
		//3d source
		public static const pop3d_source:int = 18;
		//3d particle
		public static const pop3d_particle:int = 19;
		
		//透视图
		//add stack type  + AppMainUIViewStack
		//code
		public static const stack_code:int = 1;
		//ui
		public static const stack_ui:int = 2;
		//css
		public static const stack_css:int = 3;
		//角色编辑
		public static const stack_roleEdit:int = 4;
		//角色动作混合
		public static const stack_actionMix:int = 5;
		//技能编辑
		public static const stack_skill:int = 6;
		//map
		public static const stack_map:int = 7;
		//html
		public static const stack_html:int = 8;
		//剧情
		public static const stack_drama:int = 9;
		//项目打包
		public static const stackPop_projectRes:int = 10;
		//数据库管理
		public static const stack_database:int = 11;
		//后台管理
		public static const stack_backManager:int = 12;
		//45度地图
		public static const stack_mapIso:int = 16;
		//avg
		public static const stack_avg:int = 21;
		//api
		public static const stack_api:int = 22;
		//海岛编辑器
		public static const stack_sea:int =23;
		
		//changelog
		public static const stack_changeLog:int = 19; 
		//横版地图--方格的
		public static const stack_mapTile:int = 20
		
		
		public static const dragAndDrop_avgLibView:int = 2;
		//dropAndDrag
		public static const dragAndDrop_comList:int = 1;
		//3d
		public static const dragAndDrop_3d_outline:int = 3;
		public static const dragAndDrop_3d_meshInfo:int = 4;
		
		
		//组件属性列表
		public static const tabLabel_comAttriList:String = "组件属性列表";
		//"组件列表"
		public static const tabLabel_comList:String = "组件列表";
		//"ui编辑"
		public static const tabLabel_uiEdit:String = "ui编辑";
		//"项目管理"
		public static const tabLabel_projectDirt:String = "项目管理"
		//css
		public static const tabLabel_cssEdit:String = "css编辑"
		//css attri
		public static const tabLabel_cssAttriList:String = "css属性列表";
		//outline
		public static const tabLabel_outline:String = "ui大纲";
		//code outline
		public static const tabLabel_codeOutline:String = "code大纲"
		//invertedGroup
		public static const tabLabel_invertedGroup:String = "虚拟容器"
		public static const tabLabel_backManager:String = "后台管理"
		public static const tabLabel_codeSearch:String = "搜索"
		public static const tabLabel_changeLog:String = "更改记录"
		public static const tabLabel_api:String = "引擎api"
		
		//3d outline
		public static const tabLabel3d_outline:String = "大纲";
		//3d attri
		public static const tabLabel3d_attri:String = "属性";
		//3d project
		public static const tabLabel3d_project:String = "项目";
		//3d consol
		public static const tabLabel3d_console:String = "控制台";
		//3d source
		public static const tabLabel3d_source:String = "源文件"
		//particle
		public static const tabLabel3d_particle:String = "粒子"
		
		public static const codeStack_tab:Array = [tabLabel_projectDirt,tabLabel_codeOutline,tabLabel_codeSearch];
		public static const uiStack_tab:Array = [tabLabel_projectDirt,tabLabel_comList,tabLabel_outline,tabLabel_invertedGroup];
		public static const cssStack_tab:Array = [tabLabel_projectDirt];
			
		
		//成仙
		public static const project_God:String = "God_cn_cn"	
		//宫3
		public static const project_Palace4:String = "Palace4_cn_cn"	
		//皇帝2
		public static const project_king2:String = "King2_cn_cn"
		
		
		public static const com_enumType:int = 1;
		
		//虚拟面板
		public static const comType_4:int = 5;
		//布局组件
		public static const comType_2:int = 2;
		//filter
		public static const comType_7:int = 7;
		//扩展组件
		public static const comType_6:int = 6;
		//虚拟容器
		public static const comType_5:int = 5;
	
		
		public static const default_attri_ls:Array = [1,2,3,4,5,6,7,14,15,16,17,
														18,20,21,26,31,32,40,71,
														72,73,78,13,79,80,82,87,88,91];
		
		public static const default_style_ls:Array = [5,55,88,89];
		
		public static const noComp_ls:Array = [48,49];
		
		
		
		
		public static function init():void
		{
			
		}
		
		public static var pass:String;
	}
}