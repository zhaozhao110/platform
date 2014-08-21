package com.editor.module_gdps.pop.dataManageSubmit
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.pop.dataManageCompare.GdpsDataManageComparePopupwinMediator;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsDataManageSubmitPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManageSubmitPopupwinMediator";
		
		public function GdpsDataManageSubmitPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get submitWin():GdpsDataManageSubmitPopupwin
		{
			return viewComponent as GdpsDataManageSubmitPopupwin;
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
		
		public var submitUrl:String = "";
		private var totalBatchText:UILinkButton = null; //修改批次号操作链接
		private var batchNo:String = ""; //记录批次号-用于将当前需要更新公网的数据版本记录到指定批次号中
		private var preTableId:String = "";
		private var verTableId:String = "";
		
		override public function onRegister():void
		{
			super.onRegister();
			
			batchNo = "";
			submitForm.enabled = true;
			
			var popDat:OpenPopwinData = submitWin.item as OpenPopwinData;
			var committer:String = popDat.data.committer; //编辑版上传人
			submitUrl = popDat.data.submitUrl; //提交地址
			preTableId = popDat.data.preTableId;
			verTableId = popDat.data.verTableId;
			
			committerLabel.text = committerLabel.text + committer;
			
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
		
		protected function totalBatchcboxClickCallBack(s:MouseEvent):void
		{
			if (totalBatchcbox.selected)
			{
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.popupwinSign = GDPSPopupwinSign.GdpsPublishRecordPopupwin_sign;
				dat.data = { "rid":preTableId, "dataType":GDPSDataManager.tableDataType };
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
			
			submitForm.enabled = false;
			var publish:Boolean = publishCbox.selected;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "remarks": remarksTextArea.text, "publish": publish.toString(), 
				"batchNo": batchNo, "preTableId": preTableId, "verTableId": verTableId };
			http.sucResult_f = submitFormCallBackFun;
			http.fault_f = submitFault;
			http.conn(submitUrl, "POST");
			
			var str:String = "处理中，请稍等...";
			sendNotification(GDPSAppEvent.showLoadingProgressBarGdps_event, str);
			
			closePoupwin(GDPSPopupwinSign.GdpsDataManageHistory2Popupwin_sign);
			closePoupwin(GDPSPopupwinSign.GdpsDataManageComparePopwin_sign);
			closePoupwin(GDPSPopupwinSign.GdpsDataManageSubmitPopupwin_sign);
		}
		
		private function submitFault(a:* = null):void
		{
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
			showError("保存失败！");
		}
		
		private function submitFormCallBackFun(result:String):void
		{
			submitForm.enabled = true;
			remarksTextArea.text = "";
			if (result == 'success')
			{
				showError("保存成功！");
			}
			else
			{
				showError("保存失败！");
			}
			sendNotification(GDPSAppEvent.hideLoadingProgressBarGdps_event);
		}
		
		private function get comparisonMediator():GdpsDataManageComparePopupwinMediator
		{
			return retrieveMediator(GdpsDataManageComparePopupwinMediator.NAME) as GdpsDataManageComparePopupwinMediator;
		}
		
	}
}