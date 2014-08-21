package com.editor.module_gdps.pop.dataBaseSubmit
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.view.dataBase.mediator.GdpsDataBaseDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsDataBaseSubmitPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String  = "GdpsDataBaseSubmitPopwinMediator";
		
		public function GdpsDataBaseSubmitPopwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get submitWin():GdpsDataBaseSubmitPopupwin
		{
			return viewComponent as GdpsDataBaseSubmitPopupwin;
		}
		public function get publishCbox():UICheckBox
		{
			return submitWin.publishCbox;
		}
		public function get totalBatchcbox():UICheckBox
		{
			return submitWin.totalBatchcbox;
		}
		public function get committerLabel():UILabel
		{
			return submitWin.committerLabel;
		}
		public function get remarksTextArea():UITextArea
		{
			return submitWin.remarksTextArea;
		}
		public function get submitForm():UIButton
		{
			return submitWin.submitForm;
		}
		public function get cancelBtn():UIButton
		{
			return submitWin.cancelBtn;
		}
		public function get hbox():UIHBox
		{
			return submitWin.hbox;
		}
		public function get submitRidsText():UILabel
		{
			return submitWin.submit_rids_desc;
		}
		
		public var submitUrl:String = "";
		private var totalBatchText:UILinkButton//修改批次号操作链接
		private var batchNo:String = ""; //记录批次号-用于将当前需要更新公网的数据版本记录到指定批次号中
		private var preTableId:String = "";
		private var verTableId:String = "";
		private var selectedBoxRidArray:Array = [];
		private var confItem:AppModuleConfItem;
		
		public function get total_batchcbox():UICheckBox
		{
			return this.totalBatchcbox;
		}
		public function get total_batchText():UILinkButton
		{
			return this.totalBatchText;
		}
		public function setBatchNo(batchNo:String):void
		{
			this.batchNo = batchNo;
		}
		public function setTotalBatchText(totalBatchText:UILinkButton):void
		{
			this.totalBatchText = totalBatchText;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			batchNo = "";
			submitForm.enabled = true;
			//比较窗口提交过来的数据
			var popDat:Object = OpenPopwinData(submitWin.item).data;
			submitUrl = GDPSServices.submitSqlData2Version_url; //提交地址
			preTableId = popDat.confItem.extend.queryTableId;
			verTableId = popDat.confItem.extend.versionTableId;
			confItem = popDat.confItem;
			selectedBoxRidArray = popDat.ridArray;
			committerLabel.text = committerLabel.text + CacheDataUtil.getUserId();
			submitRidsText.text = "提交的db记录ID：" + selectedBoxRidArray.join(",");
			publishCbox.addEventListener(MouseEvent.CLICK, publishcboxClickCallBack);
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			batchNo = "";
			publishCbox.removeEventListener(MouseEvent.CLICK, publishcboxClickCallBack);
			publishCbox.selected = false;
			setTotalBatchcbox(false);
			totalBatchText = null;
		}
		
		private function setTotalBatchcbox(b:Boolean):void
		{
			totalBatchcbox.visible = b;
			totalBatchcbox.includeInLayout = b;
			
			if(b){
				totalBatchcbox.addEventListener(MouseEvent.CLICK, totalBatchcboxClickCallBack);
			}else{
				totalBatchcbox.removeEventListener(MouseEvent.CLICK,totalBatchcboxClickCallBack);
				totalBatchcbox.label = "是否需要添加至总更新批次";
				totalBatchcbox.selected = false;
			}
		}
		
		private function publishcboxClickCallBack(event:MouseEvent):void
		{
			if (publishCbox.selected)
			{
				setTotalBatchcbox(true);
			}
			else
			{
				setTotalBatchcbox(false);
				
				if(totalBatchText && hbox.contains(totalBatchText)){
					hbox.removeChild(totalBatchText);
				}
			}
		}
		
		private function totalBatchcboxClickCallBack(s:MouseEvent):void
		{
			if (totalBatchcbox.selected)
			{
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.popupwinSign = GDPSPopupwinSign.GdpsPublishRecordPopupwin_sign;
				dat.data = { "rid":preTableId, "dataType":GDPSDataManager.sqlDataType };
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else
			{
				batchNo = "";
				totalBatchcbox.label = "是否需要添加至总更新批次";
				if(totalBatchText && hbox.contains(totalBatchText)){
					hbox.removeChild(totalBatchText);
				}
			}
		}
		
		public function reactToCancelBtnClick(e:MouseEvent):void
		{
			remarksTextArea.text = "";
			if (publishCbox.selected)
			{
				publishCbox.selected = false;
				setTotalBatchcbox(false);
				if (totalBatchText && hbox.contains(totalBatchText))
				{
					hbox.removeChild(totalBatchText);
				}
			}
			closeWin();
		}
		
		public function reactToSubmitFormClick(e:MouseEvent):void
		{
			if (remarksTextArea.text == "")
			{
				showError("备注说明不能为空");
				return;
			}
			var publish:Boolean = publishCbox.selected;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "remarks": remarksTextArea.text, "publish": publish.toString(), 
				"batchNo": batchNo, "preTableId": preTableId, "verTableId": verTableId, 
				"rids": selectedBoxRidArray.join(",") };
			http.sucResult_f = submitFormCallBackFun;
			http.conn(submitUrl, "POST");
		}
		
		private function submitFormCallBackFun(result:String):void
		{
			dataGridMediator.findDatabaseFileDataByPage(dataGridMediator.databaseFile_page_bar.pageNo, 20, null);
			remarksTextArea.text = "";
			closeWin();
			if (result == 'success')
			{
				showError("保存成功！");
			}
			else
			{
				showError("保存失败！");
			}
		}
		
		private function get dataGridMediator():GdpsDataBaseDataGridMediator
		{
			return retrieveMediator(GdpsDataBaseDataGridMediator.NAME + confItem.menuId) as GdpsDataBaseDataGridMediator;
		}
	}
}