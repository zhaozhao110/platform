package com.editor.module_sql.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_sql.model.presentation.SQLStatementPM;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	public class SQLStatementView extends UIVBox
	{
		public function SQLStatementView()
		{
			super()
			//create_init()
		}
		
		
		public var statementTa:UITextArea;
		public var datagrid72:SandyDataGrid;
		
		//程序生成
		public function create_init():void
		{
			verticalGap = 10;
			padding = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 50;
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			hb.percentWidth =100;
			addChild(hb);
			
			var label69:UILabel = new UILabel();
			label69.text="Statement"
			hb.addChild(label69);
			
			var button73:UIButton = new UIButton();
			button73.visible = false;
			button73.label="Import From SQL File"
			button73.addEventListener('click',function(e:*):void{ pm.importSQLFile();});
			hb.addChild(button73);
			
			var button74:UIButton = new UIButton();
			button74.visible = false;
			button74.label="Save in SQL File"
			button74.addEventListener('click',function(e:*):void{ pm.exportToFile( escape(statementTa.text));});
			button74.x=221
			hb.addChild(button74);
			
			statementTa = new UITextArea();
			statementTa.id="statementTa"
			//statementTa.enterKeyDown_proxy = onKeyUp;
			//statementTa.text= pm.statement.toString()
			statementTa.height=135
			statementTa.percentWidth = 100;
			this.addChild(statementTa);
			
			var button71:UIButton = new UIButton();
			button71.y=179
			button71.label="Execute (Ctrl+Enter)"
			button71.addEventListener('click',function(e:*):void{ pm.executeStatement(statementTa.text);});
			button71.x=10
			this.addChild(button71);
			
			datagrid72 = new SandyDataGrid();
			datagrid72.styleName = "uicanvas"
			datagrid72.verticalScrollPolicy="auto"
			//datagrid72.dataProvider= pm.results
			datagrid72.percentWidth = 100;
			datagrid72.height = 300;
			this.addChild(datagrid72);
			
			var label75:UILabel = new UILabel();
			label75.x=175
			label75.y=181
			//label75.text=pm.results.length+' record(s)'.toString()
			this.addChild(label75);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		
		public var pm:SQLStatementPM;
		
		
		private function onKeyUp(pEvt:KeyboardEvent):void
		{
			if(pEvt.keyCode==Keyboard.ENTER && pEvt.controlKey)
			{
				pm.executeStatement(statementTa.text);
			}
		}
		
		
	}
}