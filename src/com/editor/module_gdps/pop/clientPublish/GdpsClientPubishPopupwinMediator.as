package com.editor.module_gdps.pop.clientPublish
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.view.publishClient.mediator.GdpsPublishClientDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class GdpsClientPubishPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsClientPubishPopupwinMediator";
		
		private var confItem:AppModuleConfItem; //左侧菜单请求的信息
		private var selectedId:String; //当前批次号
		
		public function GdpsClientPubishPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get publishResPopwin():GdpsClientPubishPopupwin
		{
			return viewComponent as GdpsClientPubishPopupwin;
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
		
		private function get dataGridMediator():GdpsPublishClientDataGridMediator
		{
			return retrieveMediator(GdpsPublishClientDataGridMediator.NAME + confItem.menuId) as GdpsPublishClientDataGridMediator;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			var dat:* = OpenPopwinData(publishResPopwin.item).data;
			confItem = dat.confItem;
			
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_client);
			
			initView();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			submitBtn.enabled = true;
			selectedId = "";
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			selectedId = grid.selectedItem.SBid;
			chooseTip.htmlText = "当前批次号【" + ColorUtils.addColorTool(selectedId,0xff0000) + "】";
			publishResPopwin.revision_tip.htmlText = "更新SVN版本号: " + ColorUtils.addColorTool(grid.selectedItem.NClientRevision,0xff0000);
			publishResPopwin.topic_tip.htmlText = "更新主题: " + ColorUtils.addColorTool(grid.selectedItem.STopic,0xff0000);
			publishResPopwin.desc_tip.htmlText = "更新描述: " + ColorUtils.addColorTool(grid.selectedItem.SDesc,0xff0000);
		}
		
		public function reactToSubmitBtnClick(evt:MouseEvent):void
		{
			if (selectedId == null || selectedId == "")
			{
				showError("请先选择需要发布的批次号！");
				return;
			}
			
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要发布当前客户端资源批次【" + ColorUtils.addColorTool(selectedId,0xff0000) + "】到外网测试服吗？";
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
			http.conn(GDPSServices.get_clientData_publish_url);
			
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
			submitBtnFuncCallback(null);
		}
		
		private function resetPanel():void
		{
			this.submitBtn.enabled = true;
			publishResPopwin.revision_tip.htmlText = "";
			publishResPopwin.topic_tip.htmlText = "";
			publishResPopwin.desc_tip.htmlText = "";
		}
	}
}