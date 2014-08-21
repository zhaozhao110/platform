package com.editor.module_gdps.pop.serverList
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.pop.publishSave.GdpsPublishSavePopupwinMediator;
	import com.editor.module_gdps.pop.serverSave.GdpsServerSavePopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class GdpsServerListPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsServerListPopupwinMediator";
		
		public function GdpsServerListPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get listWin():GdpsServerListPopupwin
		{
			return viewComponent as GdpsServerListPopupwin;
		}
		public function get choose_tip():UILabel
		{
			return listWin.choose_tip;
		}
		public function get dgList():SandyDataGrid
		{
			return listWin.dgList;
		}
		public function get cb():UICheckBox
		{
			return listWin.cb;
		}
		public function get saveBtn():UIButton
		{
			return listWin.saveBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			cb.addEventListener(ASEvent.CHANGE , onChangeHandler);
			dgList.addEventListener(ASEvent.CHANGE , onDoubleClickHandler);
			initView();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			cb.removeEventListener(ASEvent.CHANGE , onChangeHandler);
			dgList.removeEventListener(ASEvent.CHANGE , onDoubleClickHandler);
			operatorsList = null;
			popType = null;
		}
		
		public var operatorsList:Array;
		private var popType:String;
		
		private function onChangeHandler(e:ASEvent):void
		{
			if(cb.selected){
				changeSeleted(false);
			}
		}
		
		private function onDoubleClickHandler(e:ASEvent):void
		{
			if(e.isDoubleClick){
				
			}
		}
		
		private function changeSeleted(selected:Boolean):void
		{
			var len:int = operatorsList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				Object(operatorsList[i]).cbSelect = selected;
			}
			dgList.dataProvider = null;
			dgList.dataProvider = operatorsList;
		}
		
		private function hasSeleted():Boolean
		{
			var len:int = operatorsList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				if(operatorsList[i].cbSelect){
					return true;
				}
			}
			return false;
		}
		
		private function getSeleted():Array
		{
			var out:Array = [];
			var len:int = operatorsList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				if(operatorsList[i].cbSelect){
					out.push(operatorsList[i]);
				}
			}
			return out;
		}
		
		private function initView():void
		{
			var dat:OpenPopwinData = OpenPopwinData(listWin.item); //获取上层窗口的传值对象
			popType = dat.type;
			
			showDataGridColumn();
		}
		
		private function showDataGridColumn():void
		{
			var cols:Array = dgList.columns || [];
			
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.headerText = "#";
			dg.columnWidth = 35;
			dg.editable = true;
			dg.renderer = GdpsServerListRenderer;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "serverId";
			dg.headerText = "平台ID";
			dg.columnWidth = 150;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "serverName";
			dg.headerText = "平台名称";
			dg.columnWidth = 280;
			cols.push(dg);
			
			dgList.columns = cols;
			
			showOprList();
		}
		
		private function showOprList():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = showOprListCallBack;
			http.conn(GDPSServices.getLoginProject_opr_url, "POST");
		}
		
		private function showOprListCallBack(a:*):void
		{
			operatorsList = [];
			
			var oprList:Object = a.data;
			
			for (var i:int=0; i < oprList.length; i++) {
				operatorsList.push({serverName:(oprList[i].oprName), serverId:(oprList[i].oprId), cbSelect:false});
			}
			dgList.dataProvider = operatorsList;
		}
		
		public function updateView(b:Boolean):void
		{
			if(b){
				cb.selected = false;
			}
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(!cb.selected &&  !hasSeleted())
			{
				showError("请选择需要更新的平台！");
				return;
			}
			var out:Array = [];
			if(cb.selected)
			{
				out = [{serverName:"系统默认" , serverId:"0"}];
			}
			else
			{
				out= getSeleted();
			}
			
			if(popType == "serverSave")
			{
				serverSaveMediator.updateServer(out);
			}
			else if(popType == "publishSave")
			{
				publisSaveMediator.updateServer(out);
			}
			
			closeWin();
		}
		
		private function get publisSaveMediator():GdpsPublishSavePopupwinMediator
		{
			return retrieveMediator(GdpsPublishSavePopupwinMediator.NAME) as GdpsPublishSavePopupwinMediator;
		}
		
		private function get serverSaveMediator():GdpsServerSavePopupwinMediator
		{
			return retrieveMediator(GdpsServerSavePopupwinMediator.NAME) as GdpsServerSavePopupwinMediator;
		}
		
	}
}