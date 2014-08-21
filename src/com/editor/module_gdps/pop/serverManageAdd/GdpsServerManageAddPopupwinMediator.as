package com.editor.module_gdps.pop.serverManageAdd
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.serverManage.mediator.GdpsServerManagerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class GdpsServerManageAddPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsServerManageAddPopupwinMediator";
		
		public function GdpsServerManageAddPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get serverWin():GdpsServerManageAddPopupwin
		{
			return viewComponent as GdpsServerManageAddPopupwin;
		}
		public function get SNameTxt():UITextInput
		{
			return serverWin.SNameTxt;
		}
		public function get GSNameTxt():UITextInput
		{
			return serverWin.GSNameTxt;
		}
		public function get descTxt():UITextArea
		{
			return serverWin.descTxt;
		}
		public function get NAreaIdTxt():UITextInput
		{
			return serverWin.NAreaIdTxt;
		}
		public function get NGameidTxt():UITextInput
		{
			return serverWin.NGameid;
		}
		public function get NOpridTxt():UITextInput
		{
			return serverWin.NOpridTxt;
		}
		public function get STypeCb():UICombobox
		{
			return serverWin.STypeCb;
		}
		public function get SStateCb():UICombobox
		{
			return serverWin.SStateCb;
		}
		public function get saveBtn():UIButton
		{
			return serverWin.saveBtn;
		}
		public function get closeBtn():UIButton
		{
			return serverWin.closeBtn;
		}
		public function get resetBtn():UIButton
		{
			return serverWin.resetBtn;
		}
		public function get NNidTxt():UITextInput
		{
			return serverWin.NNidTxt;
		}
		public function get SNetlineCb():UICombobox
		{
			return serverWin.SNetlineCb;
		}
		public function get SDomainTxt():UITextInput
		{
			return serverWin.SDomainTxt;
		}
		public function get SWebUrlTxt():UITextInput
		{
			return serverWin.SWebUrlTxt;
		}
		public function get SWebKeyTxt():UITextInput
		{
			return serverWin.SWebKeyTxt;
		}
		public function get SLoginUrlTxt():UITextInput
		{
			return serverWin.SLoginUrlTxt;
		}
		public function get STicketUrlTxt():UITextInput
		{
			return serverWin.STicketUrlTxt;
		}
		public function get DStartTxt():UITextInput
		{
			return serverWin.DStartTxt;
		}
		
		private var popType:String;
		private var confItem:AppModuleConfItem;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var data:Object = OpenPopwinData(serverWin.item).data;
			popType = data.btnName;
			confItem = data.confItem;
			
			initView();
		}
		
		private function initView():void
		{
			if(popType == "add"){
				
				SStateCb.dataProvider = [{label:"未部署[2]",value:2}];
				SStateCb.selectedIndex = 0;
				serverWin.title = "添加服务器";
				resetView();
				NOpridTxt.text = "101";
				NNidTxt.text = "1";
				SWebUrlTxt.text = "/game/interface/oper.do?";
				SLoginUrlTxt.text = "/login.do";
				STicketUrlTxt.text = "/getLoginTicket.do";
				DStartTxt.text = TimerUtils.getFromatTime(TimerUtils.getCurrentTime() / 1000 , "yyyy-mm-dd HH:nn:ss");
				
			}else if(popType == "modify"){
				
				SStateCb.dataProvider = GDPSDataManager.serverStates;
				serverWin.title = "修改服务器定义";
				reflashView();
			}
		}
		
		public function reactToCloseBtnClick(e:MouseEvent):void
		{
			closeWin();
		}
		
		public function reactToResetBtnClick(e:MouseEvent):void
		{
			resetView();
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(SNameTxt.text == ""){
				showError("请填写服务器名称！");
				return;
			}
			if(GSNameTxt.text == ""){
				showError("请填写服务器内显示名称！");
				return;
			}
			if(NAreaIdTxt.text == ""){
				showError("请填写所属项目ID！");
				return;
			}
			if(DStartTxt.text == ""){
				showError("请填写开服时间！");
				return;
			}
			
			var reg:RegExp = /^(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})$/;
			if(!reg.test(DStartTxt.text))
			{
				showError("开服时间格式错误，格式必须为：yyyy-mm-dd HH:nn:ss，如2013-12-14 14:15:30");
				return;
			}
			
			var formValues:Object = {};
			formValues.menuId = confItem.menuId;
			formValues.SSname = SNameTxt.text;
			formValues.SGsname = GSNameTxt.text;
			formValues.SType = STypeCb.selectedItem.value;
			formValues.SState = SStateCb.selectedItem.value;
			formValues.NGameid = NGameidTxt.text;
			formValues.NAreaId = NAreaIdTxt.text;
			formValues.NOprid = NOpridTxt.text;
			formValues.SDesc = descTxt.text;
			formValues.NNid = NNidTxt.text;
			formValues.SNetline = SNetlineCb.selectedItem.value;
			formValues.SDomain = SDomainTxt.text;
			formValues.SWebUrl = SWebUrlTxt.text;
			formValues.SWebKey = SWebKeyTxt.text;
			formValues.SLoginUrl = SLoginUrlTxt.text;
			formValues.STicketUrl = STicketUrlTxt.text;
			formValues.DStart = DStartTxt.text;
			
			if(popType == "modify"){
				var dg:SandyDataGrid = dataGridMediator().list;
				formValues.NSid = dg.selectedItem.NSid;
			}
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getServerMamangeSave_url, "POST");
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showError("保存成功!");
			dataGridMediator().findTableSpaceDataByPage(dataGridMediator().pageBar.pageNo, 20, null);
			closeWin();
		}
		
		private function resetView():void
		{
			SNameTxt.text = "";
			GSNameTxt.text = "";
			NGameidTxt.text = "";
			NAreaIdTxt.text = "";
			NOpridTxt.text = "";
			NNidTxt.text = "";
			descTxt.text = "";
			SDomainTxt.text = "";
			SWebUrlTxt.text = "";
			SWebKeyTxt.text = "";
			SLoginUrlTxt.text = "";
			STicketUrlTxt.text = "";
			DStartTxt.text = "";
		}
		
		private function reflashView():void
		{
			var dg:SandyDataGrid = dataGridMediator().list;
			var item:Object = dg.selectedItem;
			SNameTxt.text = item.SSname;
			GSNameTxt.text = item.SGsname;
			NGameidTxt.text = item.NGameid;
			NAreaIdTxt.text = item.NAreaId;
			NOpridTxt.text = item.NOprid;
			descTxt.text = item.SDesc;
			NNidTxt.text = item.NNid;
			SDomainTxt.text = item.SDomain;
			SWebUrlTxt.text = item.SWebUrl;
			SWebKeyTxt.text = item.SWebKey;
			SLoginUrlTxt.text = item.SLoginUrl;
			STicketUrlTxt.text = item.STicketUrl;
			DStartTxt.text = item.DStart;
			
			var type:int = int(item.SState);
			var arr:Array = SStateCb.dataProvider;
			if(arr != null){
				for each(var item1:Object in arr)
				{
					if(item1.value == type){
						SStateCb.selectedItem = item1;
						break;
					}
				}
				if(SStateCb.selectedItem == null){
					SStateCb.selectedIndex = 0;
				}
			}
			
			type = int(item.SType);
			arr = STypeCb.dataProvider;
			if(arr != null){
				for each(var item2:Object in arr)
				{
					if(item2.value == type){
						STypeCb.selectedItem = item2;
						break;
					}
				}
				if(STypeCb.selectedItem == null){
					STypeCb.selectedIndex = 0;
				}
			}
			
			type = int(item.SNetline);
			arr = SNetlineCb.dataProvider;
			if(arr != null){
				for each(var item3:Object in arr)
				{
					if(item3.value == type){
						SNetlineCb.selectedItem = item3;
						break;
					}
				}
				if(SNetlineCb.selectedItem == null){
					SNetlineCb.selectedIndex = 0;
				}
			}
			
			
		}
		
		private function dataGridMediator():GdpsServerManagerDataGridMediator
		{
			return retrieveMediator(GdpsServerManagerDataGridMediator.NAME + confItem.menuId) as GdpsServerManagerDataGridMediator;
		}
	}
}