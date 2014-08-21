package com.editor.project_pop.createXMLVO
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;

	public class AppCreateXMLPopwin extends AppPopupWithEmptyWin
	{
		public function AppCreateXMLPopwin()
		{
			super()
			create_init();
		}
		
		public var ti:UITextInput;
		public var form:UIVBox;
		public var pathForm:UITextInput;
		public var pathButton:UIButton;
		public var tabBar:UITabBar;
		public var dg:UIDataGrid;
		public var textCan:UIVBox;
		private var closeBtn:UIButton;
		public var text:UITextArea;
		public var addTempBtn:UIButton;
		public var insertBtn:UIButton;
		
		private function create_init():void
		{
			form = new UIVBox();
			form.y = 50;
			form.x = 20
			form.width = 350;
			form.height = 350;
			this.addChild(form);
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 25;
			form.addChild(hb);
			
			var lb:UILabel = new UILabel;
			lb.text = "前缀："
			hb.addChild(lb);
			
			ti = new UITextInput();
			ti.width = 400 ;
			ti.height = 22 ;
			hb.addChild(ti);
			
			var sp:ASSpace = new ASSpace();
			sp.height = 5;
			form.addChild(sp);
			
			hb = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 25;
			form.addChild(hb);
			
			lb = new UILabel;
			lb.text = "导入xml："
			hb.addChild(lb);
			
			pathForm = new UITextInput();
			pathForm.width = 350
			pathForm.height = 22;
			pathForm.editable = false;
			hb.addChild(pathForm);
			
			pathButton = new UIButton();
			pathButton.label = "浏览";
			hb.addChild(pathButton);
			
			addTempBtn = new UIButton();
			addTempBtn.label = "插入模版"
			addTempBtn.addEventListener(MouseEvent.CLICK , function(e:MouseEvent):void{textCan.visible=true;});
			hb.addChild(addTempBtn);
			
			sp = new ASSpace();
			sp.height = 5;
			form.addChild(sp);
			
			tabBar = new UITabBar();
			form.addChild(tabBar);
						
			dg = new UIDataGrid();
			dg.name = "UIDataGrid123"
			//dg.styleName = "uicanvas"
			dg.width = 550;
			dg.height = 280;
			dg.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(dg);
			
			var col_a:Array = [];
			var col:ASDataGridColumn = new ASDataGridColumn();
			col.columnWidth = 100;
			col.headerText = "xml字段"
			col.dataField = "xml";
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.columnWidth = 150;
			col.headerText = "AS字段"
			col.dataField = "vo"
			col.editable = true;
			col.renderer = CreateXMLItemRenderer
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.editable = true;
			col.columnWidth = 300;
			col.headerText = "注释"
			col.dataField = "info"
			col.renderer = CreateXMLItemRenderer
			col_a.push(col);
			
			dg.columns = col_a;
			
			////////////////////////////////////////////////////////////////////////////////
			
			textCan = new UIVBox();
			textCan.padding = 5;
			textCan.backgroundColor = 0x444444;
			textCan.styleName = "uicanvas"
			textCan.width = 570;
			textCan.height = 450;
			textCan.visible = false;
			addChild(textCan);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.percentWidth=100;
			textCan.addChild(hb);
			
			insertBtn = new UIButton();
			insertBtn.label = "插入";
			hb.addChild(insertBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭";
			closeBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{textCan.visible=false;});
			hb.addChild(closeBtn);
			
			text = new UITextArea();
			text.enabledPercentSize = true;
			textCan.addChild(text);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 600;
			opts.height = 500;
			opts.title = "生成xml的vo"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true;
			popupSign  		= PopupwinSign.AppCreateXMLPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppCreateXMLPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppCreateXMLPopwinMediator.NAME);
		}
		
	}
}