package com.editor.module_gdps.pop.serverSave
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.publishServer.mediator.GdpsPublishServerDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGrid;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.ArrayCollection;
	import com.sandy.math.HashMap;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class GdpsServerSavePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsServerSavePopupwinMediator";
		
		public function GdpsServerSavePopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get saveWin():GdpsServerSavePopupwin
		{
			return viewComponent as GdpsServerSavePopupwin;
		}
		public function get saveBtn():UIButton
		{
			return saveWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return saveWin.resetBtn;
		}
		public function get svnBtn():UILinkButton
		{
			return saveWin.svnBtn;
		}
		public function get dbBtn():UILinkButton
		{
			return saveWin.dbBtn;
		}
		public function get form():UIForm
		{
			return saveWin.form;
		}
		public function get oprCB():UICombobox
		{
			return saveWin.oprCB;
		}
		public function get oprBtn():UILinkButton
		{
			return saveWin.oprBtn;
		}
		public function get oprAreaTxt():UITextArea
		{
			return saveWin.oprAreaTxt;
		}
		
		private var menuId:Number;
		private var btnName:String;
		private var confItem:AppModuleConfItem;
		private var serverList:Array;
		
		public var _platformList:Array;
		public var _operatorsMap:HashMap;
		
		private function get dataGridMediator():GdpsPublishServerDataGridMediator
		{
			return retrieveMediator(GdpsPublishServerDataGridMediator.NAME + menuId) as GdpsPublishServerDataGridMediator;
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
			oprCB.addEventListener(ASEvent.CHANGE, serverOprChangeHandler);
			
			getOperatorList();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			serverList = null;
			saveWin.SBid.editable = true;
			oprCB.removeEventListener(ASEvent.CHANGE , serverOprChangeHandler);
			resetForm();
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
				saveWin.title = "添加服务端数据更新批次号"
				saveWin.SBid.editable = true;
				
				var formatString:String = "yyyymmddHHnnss";
				saveWin.SBid.text = TimerUtils.getFromatTime(TimerUtils.getCurrentTime() / 1000 , formatString);
			}
		}
		
		private function showUpdateForm():void
		{
			saveWin.title = "修改服务端数据更新批次号";
			saveWin.SBid.editable = false;
			
			var grid:ASDataGrid = dataGridMediator.packaging_grid;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "menuId": menuId, "SBid": grid.selectedItem.SBid };
			http.sucResult_f = showColumnDataCallBack;
			http.conn(GDPSServices.getBatchRecord_url);
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
				oprCB.dataProvider = [{label:"不区分预发布平台[0]" , data:"0"}];
				oprCB.selectedIndex = 0;
				oprCB.enabled = false;
				oprBtn.enabled = false;
				initForm(btnName);
				return;
			}
			
			oprBtn.enabled = true;
			oprCB.enabled = true;
			
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
			
			oprCB.dataProvider = _platformList;
			oprCB.selectedIndex = 0;
			
			reflashOprView();
			initForm(btnName);
		}
		
		// 下拉框change事件
		private function serverOprChangeHandler(event:ASEvent):void 
		{
			reflashOprView();
		}
		
		private function reflashOprView():void
		{
			var _selectedPf:String = oprCB.selectedItem.data;
			if(_selectedPf == "0") return;
			var tips:String = _operatorsMap.find(_selectedPf);
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
				
				oprAreaTxt.htmlText =  _content;
			} else {
				showError('当前预发布平台还未添加相关运营商，无需更新。');
			}
		}
		
		public function reactToDbBtnClick(event:MouseEvent):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = GDPSPopupwinSign.GdpsServerVersionPopupwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		public function reactToSvnBtnClick(event:MouseEvent):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "type" : "S", "source" : GDPSDataManager.server_data_type };
			var _oprid:String = "0";
			if (showOprLabel()) 
			{
				_oprid = oprCB.selectedItem.data;
			}
			dat.data.oprid = _oprid;
			dat.popupwinSign = GDPSPopupwinSign.GdpsPublishSvnLogPopupwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
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
			saveWin.server_svn_version.text = columns[0].NServerRevision;
			saveWin.server_db_version.text = columns[0].SScriptVersion;
			
			var idStr:String = columns[0].SOprid;
			
			for each (var obj:Object in _platformList)
			{
				if (String(obj.data) == idStr)
				{
					oprCB.selectedItem = obj;
					break;
				}
			}
			
			if(oprCB.selectedItem == null){
				oprCB.selectedIndex = 0;
			}
			
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
			
			if(saveWin.server_svn_version.text == ""){
				showError("资源SVN版本号不能为空");
				return;
			}
			//添加表单参数
			var formValues:Object = {};
			if (showOprLabel()) {
				if (oprCB.selectedItem == null || oprCB.selectedItem.data == null) {
					showError("请选择指定的预发布平台");
					return;
				}
				formValues.SOprid = oprCB.selectedItem.data;
			}
			else
			{
				formValues.SOprid = "0";
			}
			formValues.menuId = menuId;
			formValues.SBid = saveWin.SBid.text;
			formValues.STopic = saveWin.STopic.text;
			formValues.SScope = GDPSDataManager.server_data_type;
			formValues.SDesc = saveWin.SDesc.text;
			formValues.NServerRevision = saveWin.server_svn_version.text;
			formValues.SScriptVersion = saveWin.server_db_version.text;
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formValues;
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getSaveBatchRecord_url);
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
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
		
		public function reactToOprBtnClick(evt:MouseEvent):void
		{
			if(oprCB.selectedItem == null) return;
			var _selectedPf:String = oprCB.selectedItem.data;
			if(StringTWLUtil.isWhitespace(_selectedPf) || _selectedPf == "0") return;
			var tips:String = _operatorsMap.find(_selectedPf);
			var vo:OpenPopwinData = new OpenPopwinData();
			vo.data = tips;
			vo.addData = oprCB.selectedItem.label;
			vo.openByAirData = new OpenPopByAirOptions();
			vo.popupwinSign = GDPSPopupwinSign.GdpsLookOperatorsPopupwin_sign;
			openPopupwin(vo);
		}
		
		public function updateServer(arr:Array):void
		{
			serverList = null;
			serverList = arr;
			
//			oprTxt.text = getServerNameStr();
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
		
		private function resetForm():void
		{
			saveWin.SBid.text = "";
			saveWin.STopic.text = "";
			saveWin.SDesc.text = "";
			saveWin.server_svn_version.text = "";
			saveWin.server_db_version.text = "";
		}
	}
}