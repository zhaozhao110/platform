package com.editor.module_sql
{
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.module_sql.events.SqlModEvent;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.module_sql.view.IndicesView;
	import com.editor.module_sql.view.SQLDataView;
	import com.editor.module_sql.view.SQLStatementView;
	import com.editor.module_sql.view.SQLStructureView;
	import com.editor.module_sql.view.TableListView;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.common.bind.bind.bind;
	import com.sandy.component.controls.SandySpace;
	

	public class SqlMamModule extends UIModule2
	{
		public function SqlMamModule()
		{
			super();
			instance = this;
		}
		
		override protected function get addLogBool():Boolean
		{
			return false;
		}
		
		public static var instance:SqlMamModule;
		public static const MODULENAME:String = "SqlMamModule";
		
		public var button129:UIButton;
		public var button130:UIButton;
		public var tablelistview136:TableListView;
		public var structureTab:SQLStructureView;
		public var dataView:SQLDataView;
		public var indicesview139:IndicesView;
		public var sqlstatementview140:SQLStatementView;
		public var mainPM:MainPM;
		public var label127:UILabel;
		public var button:UIButton;
		private var tabnavigator137:UITabBarNav
		
		public function create_init2():void
		{
			super.create_init();
			
			var applicationcontrolbar125:UIHBox = new UIHBox();
			applicationcontrolbar125.percentWidth = 100;
			applicationcontrolbar125.paddingLeft = 10;
			applicationcontrolbar125.paddingRight = 10;
			applicationcontrolbar125.height = 30;
			applicationcontrolbar125.verticalAlign = ASComponentConst.verticalAlign_middle;
			getToolBar().addChild(applicationcontrolbar125);
			
			label127 = new UILabel();
			applicationcontrolbar125.addChild(label127);
			bind( mainPM, "docTitle", label127,"text",false);  
			
			var spacer128:SandySpace = new SandySpace();
			spacer128.percentWidth=100
			applicationcontrolbar125.addChild(spacer128);
			
			button = new UIButton();
			button.label="Open local DB File"
			applicationcontrolbar125.addChild(button);
			
			button129 = new UIButton();
			button129.label="Open DB File"
			applicationcontrolbar125.addChild(button129);
			
			button130 = new UIButton();
			button130.label="Create DB File"
			applicationcontrolbar125.addChild(button130);
			
			
						
			tablelistview136 = new TableListView();
			tablelistview136.pm = mainPM.tableListPM
			tablelistview136.width=260
			tablelistview136.percentHeight = 100;
			getLeftContainer().addChild(tablelistview136);
			tablelistview136.create_init();
			
			tabnavigator137 = new UITabBarNav();
			tabnavigator137.x = 5;
			tabnavigator137.y = 5;
			tabnavigator137.enabledPercentSize = true;
			tabnavigator137.addEventListener(ASEvent.CHANGE,tabNavChange);
			getRightContainer().addChild(tabnavigator137);
			
			structureTab = new SQLStructureView();
			structureTab.id="structureTab"
			structureTab.styleName = "uicanvas"
			structureTab.label="Structure"
			structureTab.percentWidth=100
			structureTab.percentHeight=100
			structureTab.pm= mainPM.sqlStructureViewPM 
			tabnavigator137.addChild(structureTab);
			structureTab.create_init();
			
			dataView = new SQLDataView();
			dataView.id="dataView"
			dataView.label="data"
			dataView.styleName = "uicanvas"
			dataView.percentWidth=100
			dataView.percentHeight=100
			dataView.pm= mainPM.sqldataViewPM
			tabnavigator137.addChild(dataView);
			dataView.create_init();
			
			/*indicesview139 = new IndicesView();
			indicesview139.styleName = "uicanvas"
			indicesview139.label="Indices"
			indicesview139.percentWidth=100
			indicesview139.percentHeight=100
			indicesview139.pm= mainPM.indicesPM
			tabnavigator137.addChild(indicesview139);
			indicesview139.create_init();*/
			
			sqlstatementview140 = new SQLStatementView();
			sqlstatementview140.styleName = "uicanvas"
			sqlstatementview140.label="SQL"
			sqlstatementview140.percentWidth=100
			sqlstatementview140.percentHeight=100
			sqlstatementview140.pm= mainPM.sqlStatementPM
			tabnavigator137.addChild(sqlstatementview140);
			sqlstatementview140.create_init();
			
			//dispatchEvent creationComplete
			initComplete();
			
			tabnavigator137.selectedIndex = 0;
		}
		
		public static var tabNavSelectedIndex:int;
		
		private function tabNavChange(e:ASEvent):void
		{
			tabNavSelectedIndex = tabnavigator137.selectedIndex;
			iManager.sendAppNotification(SqlModEvent.sqlMamNavTab_change_event);
		}
		
	}
}