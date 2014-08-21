package com.editor.project_pop.projectSearch
{
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_code.CodeEditorModuleMediator;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectListMediator;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ProjectSearchPopwinTab2 extends UIVBox
	{
		public function ProjectSearchPopwinTab2()
		{
			super();
			create_init();
		}
		
		public var big_cb:UICheckBox;
		public var ti:UITextInput;
		public var ti2:UITextInput;
		public var range1_cb:UICheckBox;
		public var range2_cb:UICheckBox;
		public var selectBtn:UIButton;
		public var replaceBtn:UIButton;
		public var searchBtn:UIButton;
		public var cancelBtn:UIButton;
		public var win:ProjectSearchPopwin;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			verticalGap = 0;
			padding = 5;
			enabledPercentSize = true
			
			var hb:UIHBox = new UIHBox();
			hb.height = 25;
			addChild(hb);
			
			big_cb = new UICheckBox();
			big_cb.label = "大小写区分"
			hb.addChild(big_cb);
			
			ti = new UITextInput();
			ti.width = 300;
			ti.height = 25;
			ti.enterKeyDown_proxy = searchBtnClick;
			addChild(ti);
			
			var lb:UILabel = new UILabel();
			lb.text = "替换为："
			lb.height =23
			addChild(lb);
			
			ti2 = new UITextInput();
			ti2.width = 300;
			ti2.height = 25;
			//ti2.tabIndex = 2;
			addChild(ti2);
			
			var sp:ASSpace = new ASSpace();
			sp.height = 10;
			addChild(sp);
			
			
			///////////////////////////////////////////////
			
			hb = new UIHBox();
			hb.height = 30;
			hb.percentWidth =100;
			hb.horizontalGap = 5;
			hb.paddingRight = 10;
			hb.y = 210;
			hb.horizontalAlign = ASComponentConst.horizontalAlign_right;
			addChild(hb);
			
			searchBtn = new UIButton();
			searchBtn.label = "搜索"
			searchBtn.addEventListener(MouseEvent.CLICK,searchBtnClick);
			hb.addChild(searchBtn);
			
			replaceBtn = new UIButton();
			replaceBtn.label = "替换"
			replaceBtn.addEventListener(MouseEvent.CLICK,replaceBtnClick);
			hb.addChild(replaceBtn);
			
			cancelBtn = new UIButton();
			cancelBtn.label = "取消"
			cancelBtn.addEventListener(MouseEvent.CLICK,onCancelClick);
			hb.addChild(cancelBtn);
			
		}
		
		private function searchBtnClick(e:MouseEvent=null):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			if(ti.text.length < 3){
				get_ProjectSearchMediator().showError("搜索至少需要3个字符");
				return 
			}
			if(get_CodeEditorModuleMediator().getSelectedCodeView()!=null){
				BackgroundThreadCommand.instance.local_search(get_CodeEditorModuleMediator().getSelectedCodeView().codeText.text,ti.text,big_cb.selected,"null");
			}
		}
		
		private function replaceBtnClick(e:MouseEvent=null):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			if(ti.text.length < 3){
				get_ProjectSearchMediator().showError("搜索至少需要3个字符");
				return 
			}
			if(get_CodeEditorModuleMediator().getSelectedCodeView()!=null){
				get_CodeEditorModuleMediator().getSelectedCodeView().codeText.getTF().replace(ti.text,ti2.text);
			}
		}
		 
		private function onCancelClick(e:MouseEvent):void
		{
			win.closeWin();
		}
		
		private function get_CodeEditorModuleMediator():CodeEditorModuleMediator
		{
			return iManager.retrieveMediator(CodeEditorModuleMediator.NAME) as CodeEditorModuleMediator;
		}
		
		private function get_ProjectSearchMediator():ProjectSearchMediator
		{
			return iManager.retrieveMediator(ProjectSearchMediator.NAME) as ProjectSearchMediator
		}
		
	}
}