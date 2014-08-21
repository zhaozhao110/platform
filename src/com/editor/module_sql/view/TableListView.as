package com.editor.module_sql.view
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_sql.model.presentation.TableListPM;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.common.bind.bind.bind;
	
	import flash.data.SQLTableSchema;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class TableListView extends UIVBox
	{
		public function TableListView()
		{
			super()
			//create_init()
		}
		
		
		public var tableList:UIVBox;
		
		//程序生成
		public function create_init():void
		{	
			padding = 10;
			verticalGap = 5;
			
			var lb:UILabel = new UILabel();
			lb.height = 25;
			lb.text = "Tables";
			addChild(lb);
			
			tableList = new UIVBox();
			tableList.id="tableList"
			tableList.enabeldSelect = true;
			tableList.rowHeight = 25;
			tableList.addEventListener(ASEvent.CHANGE,tableListChange);
			tableList.labelField="name"
			tableList.styleName = "list";
			tableList.enabledPercentSize = true;
			addChild(tableList);
						
			var button114:UIButton = new UIButton();
			button114.label="Add Table"
			button114.addEventListener('click',function(e:*):void{ pm.createNewTable();});
			addChild(button114);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		public static var tableSelectedIndex:int;
		
		private function tableListChange(e:ASEvent):void
		{
			tableSelectedIndex = tableList.selectedIndex;
			pm.selectTable( tableList.selectedItem as SQLTableSchema);
		}
		
		public var pm:TableListPM;
		
	}
}