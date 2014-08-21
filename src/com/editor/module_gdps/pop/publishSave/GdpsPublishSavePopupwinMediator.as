package com.editor.module_gdps.pop.publishSave
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class GdpsPublishSavePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPublishSavePopupwinMediator";
		
		public function GdpsPublishSavePopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get saveWin():GdpsPublishSavePopupwin
		{
			return viewComponent as GdpsPublishSavePopupwin;
		}
		public function get saveBtn():UIButton
		{
			return saveWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return saveWin.resetBtn;
		}
		public function get form():UIForm
		{
			return saveWin.form;
		}
		public function get oprTxt():UITextInput
		{
			return saveWin.oprTxt;
		}
		public function get oprBtn():UILinkButton
		{
			return saveWin.oprBtn;
		}
		
		private var menuId:Number;
		private var btnName:String;
		private var confItem:AppModuleConfItem;
		private var serverList:Array;
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + menuId) as GdpsPackagingDataGridMediator;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:* = OpenPopwinData(saveWin.item).data;
			confItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			if (menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
			getOperatorList();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			serverList = null;
			resetForm();
		}
		
		private function resetForm():void
		{
			saveWin.SBid.editable = true;
			saveWin.SBid.text = "";
			saveWin.STopic.text = "";
			saveWin.SDesc.text = "";
		}
		
		/**
		 * 初始化表单数据
		 *
		 * @param btnName
		 */
		private function initForm(btnName:String):void
		{
			if (btnName == "update")
			{
				showUpdateForm();
			}
			else
			{
				saveWin.title = "添加基础数据更新批次号";
				saveWin.SBid.editable = true;
				
				var formatString:String = "yyyymmddHHnnss";
				saveWin.SBid.text = TimerUtils.getFromatTime(TimerUtils.getCurrentTime() / 1000 , formatString);
			}
		}
		
		private function showUpdateForm():void
		{
			saveWin.title = "修改基础数据更新批次号"
			saveWin.SBid.editable = false;
			
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "menuId": menuId, "SBid": grid.selectedItem.SBid };
			http.sucResult_f = showColumnDataCallBack;
			http.conn(GDPSServices.getBatchRecord_url, "POST");
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
//			if (!showOprLabel())
//			{
//				oprTxt.text = "不区分预发布平台[0]";
//				oprBtn.enabled = false;
//				initForm(btnName);
//				
//				return; 
//			}
			
//			oprTxt.text = "";
//			initForm(btnName);
//			oprBtn.enabled = true;
			
			oprTxt.text = "不区分预发布平台[0]";
			oprBtn.enabled = false;
			initForm(btnName);
		}
		
		/**
		 * 修改按钮 显示表单数据回调方法
		 */
		private function showColumnDataCallBack(a:*):void
		{
			var columns:Array = a.data;
			saveWin.SBid.text = columns[0].SBid;
			saveWin.STopic.text = columns[0].STopic;
			saveWin.SDesc.text = columns[0].SDesc;
			
//			var idStr:String = columns[0].SOprid;
//			var a1:Array = idStr.split(",");
//			var out:Array = [];
//			
//			for(var i:int = 0;i < a1.length;i++)
//			{
//				if(a1[i]){
//					var name:String = GDPSDataManager.getInstance().getServerList[a1[i]];
//					
//					out.push({serverName:name , serverId:a1[i]});
//				}
//			}
//			
//			updateServer(out);
		}
		
		public function reactToSaveBtnClick(evt:MouseEvent):void
		{
			if(saveWin.SBid.text == "")
			{
				showError("请填写批次");
				return;
			}
			if(saveWin.STopic.text == "")
			{
				showError("请填写批次标题");
				return;
			}
			if(saveWin.SDesc.text == "")
			{
				showError("请填写更新内容描述");
				return;
			}
			
			var formValues:Object = {};
			
//			if (showOprLabel()) {
//				if (oprTxt.text == "") {
//					showError("请选择指定的运营平台");
//					return;
//				}
//				formValues.SOprid = getServerIdStr();
//			}
//			else
//			{
//				formValues.SOprid = "0";
//			}
			formValues.SOprid = "0";
			formValues.menuId = menuId;
			formValues.SBid = saveWin.SBid.text;
			formValues.STopic = saveWin.STopic.text;
			formValues.SScope = GDPSDataManager.base_data_type;
			formValues.SDesc = saveWin.SDesc.text;
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getSaveBatchRecord_url, "POST");
		}
		
		public function reactToOprBtnClick(evt:MouseEvent):void
		{
			var vo:OpenPopwinData = new OpenPopwinData();
			vo.type = "publishSave";
			vo.openByAirData = new OpenPopByAirOptions();
			vo.popupwinSign = GDPSPopupwinSign.GdpsServerListPopupwin_sign;
			openPopupwin(vo);
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showError("保存成功!");
			dataGridMediator.findPackagingDataByPage(dataGridMediator.packaging_page_bar.pageNo, 20, null);
			closeWin();
		}
		
		public function updateServer(arr:Array):void
		{
			serverList = null;
			serverList = arr;
			
			oprTxt.text = getServerNameStr();
		}
		
		private function getServerNameStr():String
		{
			if(serverList == null) return "";
			
			var out:String = "";
			
			for(var i:int = 0,len:int =  serverList.length; i < len;i++)
			{
				out += serverList[i].serverName + ",";
			}
			
			out = StringTWLUtil.delStringLastChar(out , ",");
			return out;
		}
		
		private function getServerIdStr():String
		{
			if(serverList == null) return "";
			
			var out:String = "";
			
			for(var i:int = 0,len:int =  serverList.length; i < len;i++)
			{
				out += serverList[i].serverId + ",";
			}
			
			out = StringTWLUtil.delStringLastChar(out , ",");
			return out;
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
	}
}