package com.editor.module_gdps.pop.lookOperators
{
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.utils.ColorUtils;

	public class GdpsLookOperatorsPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsLookOperatorsPopupwinMediator";
		
		public function GdpsLookOperatorsPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get optWin():GdpsLookOperatorsPopupwin
		{
			return viewComponent as GdpsLookOperatorsPopupwin;
		}
		public function get choose_tip():UILabel
		{
			return optWin.choose_tip;
		}
		public function get dgList():UIDataGrid
		{
			return optWin.dgList;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initColumns();
			initData();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			dgList.dispose();
			choose_tip.htmlText = "";
		}
		
		private function initColumns():void
		{
			var list:Array = dgList.columns || [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.dataField = "optId";
			dg.headerText = "运营商ID";
			dg.columnWidth = 200;
			dg.sortable = true;
			list.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "optName";
			dg.headerText = "运营商名称";
			dg.columnWidth = 420;
			list.push(dg);
			
			dgList.columns = list;
		}
		
		private function initData():void
		{
			var optInfo:String = OpenPopwinData(optWin.item).data as String;
			var platform:String = OpenPopwinData(optWin.item).addData as String;
			var list:Array = [];
			var a:Array = optInfo.split(",");
			var reg:RegExp = /\[(\d+)\]$/;
			
			for (var i:int = 0; i < a.length; i++) 
			{
				var content:String = a[i];
				var b:Array = content.match(reg);
				
				if(b.length == 2){
					list.push({"optName":content.replace(b[0] , "") , "optId":b[1]});
				}
			}
			
			dgList.dataProvider = list;
			
			choose_tip.htmlText = "运营商列表【" + ColorUtils.addColorTool("当前平台："+platform , 0xcc0000) + "】";
		}
	}
}