package com.editor.module_gdps.pop.left
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.right.GdpsRightContainerMediator;
	import com.editor.module_gdps.proxy.GdpsTreeConfigProxy;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppMapModuleConfItem;
	import com.editor.module_gdps.vo.module.AppModuleConfBase;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.module_gdps.vo.module.AppMotionModuleConfItem;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class GdpsLeftContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsLeftContainerMediator";
		
		public function GdpsLeftContainerMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get leftCell():GdpsLeftContainer
		{
			return viewComponent as GdpsLeftContainer;
		}
		public function get myTree():UITree
		{
			return leftCell.myTree;
		}
		public function get searchTxt():UITextInput
		{
			return leftCell.searchTxt;
		}
		public function get searchBtn():UIButton
		{
			return leftCell.searchBtn;
		}
		public function get resetBtn():UIButton
		{
			return leftCell.resetBtn;
		}
		
		private var initData:XML;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			leftCell.visible = true;
			searchTxt.enterKeyDown_proxy = searchMenuFunc;
			myTree.addEventListener(ASEvent.CHANGE, onTreeChangeHandle);
		}
		
		public function respondToInitCompleteGDPSEvent(noti:Notification):void
		{
			rightMediator.tabNav.removeAllChildren();
			
			queryTreeList();
			
			if(GDPSDataManager.getInstance().getUserInfo.getProjectId != GDPSDataManager.systemManagerType){
				queryServerName();
			}
		}
		
		private function queryServerName():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = showOprListCallBack;
			http.conn(GDPSServices.getLoginProject_opr_url);
		}
		
		private function showOprListCallBack(a:*):void
		{
			var options:Array = [];
			var oprList:Object = a.data;
			
			options[0] = "不区分发布平台[0]";
			for (var i:int=0; i<oprList.length; i++) {
				var obj:Object = oprList[i];
				options[obj.oprId] = obj.oprName + "[" + obj.oprId + "]";
			}
			
			GDPSDataManager.getInstance().setServersList = options;
		}
		
		private function queryTreeList():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = treeDataResult;
			http.conn(GDPSServices.getLeftTreeData_url, "POST");
		}
		
		private function treeDataResult(a:Array):void
		{
			treeProxy.parser(a);
			var xml:XML = treeProxy.createXML();
			myTree.dataProvider = xml;
			myTree.setAllOpen();
			initData = xml;
		}
		
		public function reactToSearchBtnClick(e:MouseEvent):void
		{
			searchMenuFunc();
		}
		
		private function searchMenuFunc():void
		{
			if(searchTxt.text == ""){
				showError("请输入文字后再进行搜索");
			}else{
				
				var xml:XML = initData.copy();
				
				myTree.dataProvider = callSearch(xml);
				myTree.setAllOpen();
			}
		}
		
		/**
		 * 递归遍历树结构
		 */
		private function callSearch(xml:XML):XML
		{
			var a:String = searchTxt.text;
			for each(var item:XML in xml.children()){
				
				var parentName:String = item.@name;
				if(item.children().length() > 0)
				{
					callSearch(item);
				}
			
				if(parentName.search(a)== -1)
				{	
					if(item.children().length() == 0)
					{
						delete xml.i[item.childIndex()];
					}
				}
			}
			
			return xml;
		}
		
		
		public function reactToResetBtnClick(e:MouseEvent):void
		{
			myTree.dataProvider = initData.copy();
			myTree.setAllOpen();
			searchTxt.text = "";
		}
		
		public function reflashTreeList():void
		{
			queryTreeList();
		}
		
		private var menuid:int;//所属菜单ID
		private var moduleId:int;//所属模块ID-pid
		
		private function onTreeChangeHandle(e:ASEvent):void
		{
			var treeData:ASTreeData = myTree.selectedItem as ASTreeData;
			if(treeData == null) return;
			moduleId = treeData.obj.@pid;
			menuid = treeData.obj.@id;
			if(e.addData.isBranch)
			{
				return;
			}
			else if(!e.addData.isBranch && moduleId == 0){
				showError("加载失败，未找到匹配的模块！");
				return;
			}else if(moduleId == 0){
				return;
			}
			var httpObj:Object = {};
			httpObj.menuid = menuid;
			
			var len:int = rightMediator.tabNav.numChildren;
			for (var i:int = 0; i < len; i++){
				if (Object(rightMediator.tabNav.getChildAt(i)).data == httpObj.menuid){
					rightMediator.tabNav.selectedIndex = i;
					return;
				}
			}
			
			//获取菜单的详细信息--加载模块类型；加载表名id等等。。。
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator(true);
			http.args2 = httpObj;
			http.sucResult_f = moveInfoResult;
			http.conn(GDPSServices.getLeftTreeMoreInfo_url, "POST");
		}
		
		
		/**
		 * 加载模块
		 * 
		 * @param a
		 */
		//TODO 此处判别加载哪个模块 可以在获取菜单详细信息时由后台传递对应的模块ID过来处理
		private function moveInfoResult(a:Object):void
		{
			var item:AppModuleConfBase;
			if (moduleId%100 == 7)//地图编辑资源
			{
				item = new AppMapModuleConfItem(a);
			}
			else if (moduleId%100 == 6)//动画资源
			{ 
				item = new AppMotionModuleConfItem(a);
			}
			else if (moduleId%100 == 5 || moduleId%100 == 3 || moduleId%100 == 8 
				|| moduleId%100 == 9 || moduleId%100 == 4 || moduleId%100 == 2)
			{ //基础数据管理模块,基础表对象定义管理模块 ,db数据,检测打包,更新发布,文件对象定义
				item = new AppModuleConfItem(a);
			}
			else
			{
				showError("加载失败，未找到匹配的模块！");
				return;
			}
			rightMediator.showContentView(item);
		}
		
		private function get rightMediator():GdpsRightContainerMediator
		{
			return retrieveMediator(GdpsRightContainerMediator.NAME) as GdpsRightContainerMediator;
		}
		
		private function get treeProxy():GdpsTreeConfigProxy
		{
			return retrieveProxy(GdpsTreeConfigProxy.NAME) as GdpsTreeConfigProxy;
		}
	}
}