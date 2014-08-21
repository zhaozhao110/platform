package com.editor.module_gdps.pop.serverPublish
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.publishServer.mediator.GdpsPublishServerDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGrid;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.math.HashMap;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class GdpsServerPublishPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsServerPublishPopupwinMediator";
		
		public function GdpsServerPublishPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get publishResPopwin():GdpsServerPublishPopupwin
		{
			return viewComponent as GdpsServerPublishPopupwin;
		}
		public function get chooseTip():UILabel
		{
			return publishResPopwin.choose_tip;
		}
		public function get submitBtn():UIButton
		{
			return publishResPopwin.submitBtn;
		}
		public function get resetBtn():UIButton
		{
			return publishResPopwin.resetBtn;
		}
		
		private var confItem:AppModuleConfItem;//左侧菜单请求的信息
		private var selectedId:String; //当前批次号
		private var menuId:Number;
		private var btnName:String;
		private var serverList:Array;
		
		public var _platformList:Array;
		public var _operatorsMap:HashMap;
		public var selectPrtItem:Object;
		
		override public function onRegister():void
		{
			super.onRegister();
			var dat:* = OpenPopwinData(publishResPopwin.item).data;
			confItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_server);
			initView();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			submitBtn.enabled = true;
			selectedId = "";
			selectPrtItem = null;
		}
		
		private function get dataGridMediator():GdpsPublishServerDataGridMediator
		{
			return retrieveMediator(GdpsPublishServerDataGridMediator.NAME + confItem.menuId) as GdpsPublishServerDataGridMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			selectedId = grid.selectedItem.SBid;
			chooseTip.htmlText = "当前批次号【" + ColorUtils.addColorTool(selectedId,0xFF0000) + "】";
			publishResPopwin.revision_tip.htmlText = "更新SVN版本号: " + ColorUtils.addColorTool(grid.selectedItem.NServerRevision,0xFF0000);
			var dbversion:String = grid.selectedItem.SScriptVersion;
			if(dbversion != null && dbversion != '')
			{
				publishResPopwin.dbvision_tip.htmlText = "更新DB版本号: " + ColorUtils.addColorTool(dbversion,0xFF000);
			}
			else 
			{
				publishResPopwin.dbvision_tip.htmlText = "未更新DB版本";
			}
			publishResPopwin.revision_tip.htmlText = "更新SVN版本号: " + ColorUtils.addColorTool(grid.selectedItem.NServerRevision,0xFF0000);
			publishResPopwin.topic_tip.htmlText = "更新主题: " + ColorUtils.addColorTool(grid.selectedItem.STopic,0xFF0000);
			publishResPopwin.desc_tip.htmlText = "更新描述: " + ColorUtils.addColorTool(grid.selectedItem.SDesc,0xFF0000);
			
			getOperatorList();
		}
		
		
		public function reactToSubmitBtnClick(evt:MouseEvent):void
		{
			if (selectedId == null || selectedId == "")
			{
				showError("请先选择需要发布的批次号！");
				return;
			}
			
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要发布当前服务端资源批次【" + ColorUtils.addColorTool(selectedId,0xFF0000) + "】到外网测试服吗？";
			mes.okFunction = submitBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
			
		}
		
		private function submitBtnFunc():Boolean
		{
			submitBtn.enabled = false;
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": selectedId };
			http.sucResult_f = submitBtnFuncCallback;
			http.conn(GDPSServices.get_serverData_publish_url);
			
			return true;
		}
		
		private function submitBtnFuncCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			selectedId = "";
			resetPanel();
			closeWin();
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			selectedId = "";
			resetPanel();
			closeWin();
		}
		
		private function resetPanel():void
		{
			this.submitBtn.enabled = true;
			publishResPopwin.revision_tip.htmlText = "";
			publishResPopwin.topic_tip.htmlText = "";
			publishResPopwin.desc_tip.htmlText = "";
		}
		
		private function showOprLabel():Boolean
		{
			if (CacheDataUtil.getProjectType() == "1" ) // webgame暂时不需要选择指定的平台版本
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 获取当前产品的运营平台信息
		 */
		private function getOperatorList():void
		{
			if (!showOprLabel())
			{
				initTxt();
				return;
			}
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = showOprListCallBack;
			http.conn(GDPSServices.getLoginProject_opr_url);
		}
		
		private function showOprListCallBack(a:*):void
		{
			_platformList = new Array();
			_operatorsMap = new HashMap();
			
			var oprList:Object = a.data;
			for (var i:int=0; i<oprList.length; i++) {
				var s:String = StringTWLUtil.trim(oprList[i].oprName);
				s = StringTWLUtil.removeNewline(s);
				_platformList.push({label:(s + "[" + oprList[i].oprId + "]"), data:(oprList[i].oprId)});
				_operatorsMap.put(oprList[i].oprId, oprList[i].oprs);
			}
			
			showUpdateForm();
		}
		
		private function showUpdateForm():void
		{
			var grid:ASDataGrid = dataGridMediator.packaging_grid;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "menuId": menuId, "SBid": grid.selectedItem.SBid };
			http.sucResult_f = showColumnDataCallBack;
			http.conn(GDPSServices.getBatchRecord_url);
		}
		
		private function showColumnDataCallBack(a:*):void
		{
			var columns:Array = a.data;
			var idStr:String = columns[0].SOprid;
			
			for each (var obj:Object in _platformList)
			{
				if (String(obj.data) == idStr)
				{
					selectPrtItem = obj;
					break;
				}
			}
			reflashOprView();
		}
		
		private function reflashOprView():void
		{
			if(selectPrtItem == null || selectPrtItem.data == null || selectPrtItem.data == "0"){
				initTxt();
				return;
			}
			publishResPopwin.platform.htmlText = "预发布平台: " + ColorUtils.addColorTool(selectPrtItem.label,0xFF0000);
			
			var tips:String = _operatorsMap.find(selectPrtItem.data);
			if (tips != null && tips != 'undefind') {
				var _content:String = "";
				var _tips:Array = tips.split(",");
				var colorArr:Array = GDPSDataManager.colorsLib;
				for (var i:int = 0; i < _tips.length; i++) 
				{
					var index:int = uint(colorArr.length * Math.random());
					var color:uint = colorArr[index];
					_content += ColorUtils.addColorTool(_tips[i] , color) + "，";
				}
				
				_content = _content.substring(0,_content.length-1);
				
				publishResPopwin.prt_tip.htmlText =  _content;
			} else {
				initTxt();
			}
		}
		
		private function initTxt():void
		{
			publishResPopwin.prt_tip.htmlText = "";
			publishResPopwin.platform.htmlText = "预发布平台: " + ColorUtils.addColorTool("不区分预发布平台[0]",0xFF0000);
		}
	}
}