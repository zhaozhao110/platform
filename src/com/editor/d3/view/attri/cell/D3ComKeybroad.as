package com.editor.d3.view.attri.cell
{
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.manager.D3KeybroadManager;
	import com.sandy.asComponent.containers.ASDataGridColumn;

	public class D3ComKeybroad extends D3ComCellBase
	{
		public function D3ComKeybroad()
		{
			super();
		}
		
		override protected function create_init():void
		{
			super.create_init();
			_create_init();
		}
		
		override public function setValue():void
		{
			super.setValue();
		}
		
		private var dgL:UIDataGrid;
		
		private function _create_init():void
		{
			width = 260;
			height = 110;
			
			var v:UIVBox = new UIVBox();
			v.paddingRight=2;
			v.styleName = "uicanvas";
			v.enabledPercentSize = true;
			addChild(v);
			
			dgL = new UIDataGrid();
			dgL.enabledPercentSize = true;
			dgL.verticalScrollPolicy = "auto";
			dgL.horizontalScrollPolicy = "auto";
			v.addChild(dgL);
			
			var list:Array = [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.dataField = "label";
			dg.headerText = "名称";
			dg.columnWidth = 180;
			list.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "data";
			dg.headerText = "快捷键";
			dg.columnWidth = 50;
			list.push(dg);
			
			dgL.columns = list;
			
			dgL.dataProvider = D3KeybroadManager.getInstance().keyBroad_ls;
		}
		
		
		
		
	}
}