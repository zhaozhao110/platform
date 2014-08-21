package com.editor.module_gdps.pop.publishTest
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.module_gdps.view.publish.mediator.GdpsPublishDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class GdpsPublishTestPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPublishTestPopupwinMediator";
		
		public function GdpsPublishTestPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get publishTestPopwin():GdpsPublishTestPopupwin
		{
			return viewComponent as GdpsPublishTestPopupwin;
		}
		public function get server_execute_datagrid():SandyDataGrid
		{
			return publishTestPopwin.server_execute_datagrid;
		}
		public function get chooseTip():UILabel
		{
			return publishTestPopwin.choose_tip;
		}
		public function get submitBtn():UIButton
		{
			return publishTestPopwin.submitBtn;
		}
		public function get resetBtn():UIButton
		{
			return publishTestPopwin.resetBtn;
		}
		public function get clientSvnCodeCbox():UICheckBox
		{
			return publishTestPopwin.client_svn_code_cbox;
		}
		public function get serverSvnCodeCbox():UICheckBox
		{
			return publishTestPopwin.server_svn_code_cbox;
		}
		public function get resSvnCodeCbox():UICheckBox
		{
			return publishTestPopwin.res_svn_code_cbox;
		}
		public function get clientVersionShowlog():UIButton
		{
			return publishTestPopwin.client_version_showlog;
		}
		public function get serverVersionShowlog():UIButton
		{
			return publishTestPopwin.server_version_showlog;
		}
		public function get resVersionShowlog():UIButton
		{
			return publishTestPopwin.res_version_showlog;
		}
		
		private var confItem:AppModuleConfItem; //左侧菜单请求的信息
		private var detailTableId:int; //批次明细表id
		private var selectedId:String; //当前批次号
		
		override public function onRegister():void
		{
			super.onRegister();
			var dat:OpenPopwinData = publishTestPopwin.item as OpenPopwinData; //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			detailTableId = confItem.extend.detailTableId;
			
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_server);
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			submitBtn.enabled = true;
			selectedId = "";
			clientSvnCodeCbox.removeEventListener(MouseEvent.CLICK, clientSvnCodeCboxHandler);
			serverSvnCodeCbox.removeEventListener(MouseEvent.CLICK, serverSvnCodeCboxHandler);
			resSvnCodeCbox.removeEventListener(MouseEvent.CLICK, resSvnCodeCboxHandler);
			
		}
		
		private function get dataGridMediator():GdpsPublishDataGridMediator
		{
			return retrieveMediator(GdpsPublishDataGridMediator.NAME + confItem.menuId) as GdpsPublishDataGridMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.publish_grid;
			selectedId = grid.selectedItem.SBid;
			chooseTip.text = "当前批次号【" + selectedId + "】";
			publishTestPopwin.add_tip.text = "默认更新当前项目的所有开发测试服务器。";
			server_execute_datagrid.dataProvider = [];
			findRecordByPage();
			
			clientSvnCodeCbox.addEventListener(MouseEvent.CLICK, clientSvnCodeCboxHandler);
			serverSvnCodeCbox.addEventListener(MouseEvent.CLICK, serverSvnCodeCboxHandler);
			resSvnCodeCbox.addEventListener(MouseEvent.CLICK, resSvnCodeCboxHandler);
		}
		
		private function findDataGridColumn():void
		{
			if (detailTableId <= 0)
			{
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": detailTableId, "SState": "1" };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			var cols:Array = server_execute_datagrid.columns || [];
			for (var i:int = 0; i < columns.length; i++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = columns[i].NWidth;
				dgc.sortable = false;
				cols.push(dgc);
			}
			server_execute_datagrid.columns = cols;
			
			initView();
		}
		
		/**
		 * 加载批次明细数据
		 */
		public function findRecordByPage():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": selectedId };
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchDetail_url, "POST" );
		}
		
		private function showTotalBatchRecord(a:*):void
		{
			var value:* = a.data;
			server_execute_datagrid.dataProvider = value;
		}
		
		/**
		 * 加载客户端代码svn面板
		 */
		private function clientSvnCodeCboxHandler(event:MouseEvent):void
		{
			if (clientSvnCodeCbox.selected) //显示版本日志框
			{
				publishTestPopwin.client_version_frame.visible = true;
			}
			else //关闭版本日志框
			{
				publishTestPopwin.client_version_frame.visible = false;
				publishTestPopwin.client_version_text.text = "";
			}
		}
		
		/**
		 * 加载服务端代码svn面板
		 */
		private function serverSvnCodeCboxHandler(event:MouseEvent):void
		{
			if (serverSvnCodeCbox.selected)
			{
				publishTestPopwin.server_version_frame.visible = true;
			}
			else
			{
				publishTestPopwin.server_version_frame.visible = false;
				publishTestPopwin.server_version_text.text = "";
			}
		}
		
		/**
		 * 加载资源文件代码svn面板
		 */
		private function resSvnCodeCboxHandler(event:MouseEvent):void
		{
			if (resSvnCodeCbox.selected)
			{
				publishTestPopwin.res_version_frame.visible = true;
			}
			else
			{
				publishTestPopwin.res_version_frame.visible = false;
				publishTestPopwin.res_version_text.text = "";
			}
		}
		
		public function reactToClientVersionShowlogClick(evt:MouseEvent):void
		{
			openSvnPopwin("C");
		}
		
		public function reactToServerVersionShowlogClick(evt:MouseEvent):void
		{
			openSvnPopwin("S");
		}
		
		public function reactToResVersionShowlogClick(evt:MouseEvent):void
		{
			openSvnPopwin("R");
		}
		
		public function openSvnPopwin(type:String):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "type": type };
			dat.popupwinSign = GDPSPopupwinSign.GdpsPublishSvnLogPopupwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		public function reactToSubmitBtnClick(evt:MouseEvent):void
		{
			if (selectedId == null || selectedId == "")
			{
				showError("请先选择需要更新的批次号！");
				return;
			}
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要更新当前批次【" + selectedId + "】到发布测试服吗？";
			mes.okFunction = submitBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function submitBtnFunc():Boolean
		{
			//获取版本号
			var clientNO:String = "";
			var serverNO:String = "";
			var resNO:String = "";
			if (clientSvnCodeCbox.selected)
			{
				if (publishTestPopwin.client_version_text.text == "")
				{
					showError("请先选择需要更新的客户端代码SVN版本号");
					return true;
				}
				clientNO = publishTestPopwin.client_version_text.text;
			}
			if (serverSvnCodeCbox.selected)
			{
				if (publishTestPopwin.server_version_text.text == "")
				{
					showError("请先选择需要更新的服务端代码SVN版本号");
					return true;
				}
				serverNO = publishTestPopwin.server_version_text.text;
			}
			if (resSvnCodeCbox.selected)
			{
				if (publishTestPopwin.res_version_text.text == "")
				{
					showError("请先选择需要更新的资源文件SVN版本号");
					return true;
				}
				resNO = publishTestPopwin.res_version_text.text;
			}
			submitBtn.enabled = false;
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": selectedId, "clientNO": clientNO, "serverNO": serverNO, "resNO": resNO };
			http.sucResult_f = submitBtnFuncCallback;
			http.conn(GDPSServices.getPublishTest_url, "POST");
		
			return true;
		}
		
		private function submitBtnFuncCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			dataGridMediator.findPublishDataByPage(dataGridMediator.publish_page_bar.pageNo, 20, null);
			resetPanel();
			closeWin();
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			closeWin();
		}
		
		private function resetPanel():void
		{
			this.server_execute_datagrid.dataProvider = [];
			this.submitBtn.enabled = true;
			this.clientSvnCodeCbox.selected = false;
			this.publishTestPopwin.client_version_frame.visible = false;
			this.publishTestPopwin.client_version_rb2.selected = false;
			this.publishTestPopwin.client_version_text.text = "";
			this.publishTestPopwin.server_version_frame.visible = false;
			this.publishTestPopwin.server_version_rb2.selected = false;
			this.publishTestPopwin.server_version_text.text = "";
			this.publishTestPopwin.res_version_frame.visible = false;
			this.publishTestPopwin.res_version_rb2.selected = false;
			this.publishTestPopwin.res_version_text.text = "";
		}
	}
}