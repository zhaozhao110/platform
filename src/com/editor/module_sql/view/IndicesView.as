package com.editor.module_sql.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILabel;
	import com.editor.module_sql.component.IndicesViewItemRenderer;
	import com.editor.module_sql.model.presentation.IndicesPM;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.common.bind.bind.bind;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.data.SQLIndexSchema;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class IndicesView extends UICanvas
	{
		public function IndicesView()
		{
			super()
			//create_init()
		}
		
		public var datagrid36:SandyDataGrid
		
		//程序生成
		public function create_init():void
		{
			
			//主文件的属性
			this.width=608
			this.height=300
			
			datagrid36 = new SandyDataGrid();
			datagrid36.top=36
			datagrid36.left=10
			datagrid36.right=10
			datagrid36.bottom=10
			this.addChild(datagrid36);
			
			var columns37:Array = new Array();
			
			
			var datagridcolumn38:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn38.headerText="Index Name"
			datagridcolumn38.dataField="name"
			columns37.push(datagridcolumn38);
			
			var datagridcolumn39:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn39.headerText="Table"
			datagridcolumn39.dataField="table"
			columns37.push(datagridcolumn39);
			
			var datagridcolumn40:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn40.headerText="Creation Statement"
			datagridcolumn40.dataField="sql"
			columns37.push(datagridcolumn40);
			
			var datagridcolumn41:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn41.headerText="Remove"
			datagridcolumn41.dataField="table"
			datagridcolumn41.columnWidth=75
			datagridcolumn41.renderer = IndicesViewItemRenderer;
			columns37.push(datagridcolumn41);
			
			datagrid36.columns = columns37;
			
			var label45:UILabel = new UILabel();
			label45.x=10
			label45.y=10
			label45.text="Index List"
			this.addChild(label45);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
	
		
		public var pm:IndicesPM;
		
		private var tmpIndex:SQLIndexSchema;
		
		public function removeIndex(pItem:Object):void
		{
			tmpIndex = pItem as SQLIndexSchema;
			var d:OpenMessageData = new OpenMessageData()
			d.info = "Are you sure you want to drop this index ("+ tmpIndex.name +") ?";
			d.okFunction = answer;
			pm.mainPM.app.showConfirm(d);
		}
		
		private function answer(pEvt:*=null):Boolean
		{
			if( tmpIndex!=null) pm.removeIndex( tmpIndex);
			return true;
		}
		
		
	}
}