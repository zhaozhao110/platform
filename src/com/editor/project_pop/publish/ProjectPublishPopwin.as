package com.editor.project_pop.publish
{
	import com.air.io.SelectFile;
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.project_pop.publish.view.ProjectPubTab1;
	import com.editor.project_pop.publish.view.ProjectPubTab2;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectPublishPopwin extends AppPopupWithEmptyWin
	{
		public function ProjectPublishPopwin()
		{
			super()
			create_init();
		}
		
		public var form:UIVBox;
		public var tab1:ProjectPubTab1;
		public var tab2:ProjectPubTab2;
		public var textTi:UITextInput;
		public var selectBtn:UIButton;
		
		private function create_init():void
		{
			form = new UIVBox();
			form.y = 10;
			form.x = 10;
			form.width = 980;
			form.height = 650;
			form.verticalGap = 5;
			this.addChild(form);
			
			var hb:UIHBox = new UIHBox();
			hb.verticalAlignMiddle = true
			hb.styleName = "uicanvas";
			hb.height = 30;
			hb.percentWidth = 100;
			form.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "选择服务器目录：(一般是通过映射网络驱动器)   ";
			hb.addChild(lb);
			
			textTi = new UITextInput();
			textTi.width = 550;
			textTi.editable = false;
			hb.addChild(textTi);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择目录"
			hb.addChild(selectBtn);
			
			hb = new UIHBox();
			hb.verticalAlignMiddle = true
			hb.styleName = "uicanvas";
			hb.height = 30;
			hb.percentWidth = 100;
			form.addChild(hb);
			
			lb = new UILabel();
			lb.text = "将选择的文件列表复制到服务器上";
			hb.addChild(lb);
			
			var tabNav:UITabBarNav = new UITabBarNav();
			tabNav.creationPolicy = ASComponentConst.creationPolicy_none
			tabNav.enabledPercentSize = true;
			form.addChild(tabNav);
						
			tab2 = new ProjectPubTab2();
			tab2.label = "assets发布"
			tab2.enabledPercentSize = true;
			tabNav.addChild(tab2);
			
			tab1 = new ProjectPubTab1();
			tab1.label = "资源发布"
			tab1.enabledPercentSize = true;
			tabNav.addChild(tab1);
			
			tabNav.selectedIndex = 0;
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1000;
			opts.height = 700;
			opts.title = "项目发布"
			opts.minimizable = true
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.ProjectPublishPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectPublishPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectPublishPopwinMediator.NAME);
		}
		
		
	}
}