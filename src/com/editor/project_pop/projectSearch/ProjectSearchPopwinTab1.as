package com.editor.project_pop.projectSearch
{
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectListMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.pop.pathList.OpenPathListPopWinVO;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectSearchPopwinTab1 extends UIVBox
	{
		public function ProjectSearchPopwinTab1()
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
			
			////////////////////////////////////////////
			
			var vb:UIVBox = new UIVBox();
			vb.paddingTop = 5;
			vb.height = 75;
			vb.verticalGap = 10;
			vb.percentWidth = 100;
			vb.styleName = "uicanvas"
			addChild(vb);
			
			range1_cb = new UICheckBox();
			range1_cb.selected = true
			range1_cb.label = "选择整个项目目录"
			range1_cb.addEventListener(ASEvent.CHANGE,range1Change)
			vb.addChild(range1_cb);
			
			hb = new UIHBox();
			hb.height = 25;
			vb.addChild(hb);
			
			range2_cb = new UICheckBox();
			range2_cb.width = 250
			range2_cb.label = "在目录下:"+get_ProjectDirectListMediator().getTextInputFile().nativePath;
			range2_cb.data = get_ProjectDirectListMediator().getTextInputFile().nativePath;
			range2_cb.toolTip = range2_cb.label;
			range2_cb.addEventListener(ASEvent.CHANGE,range2Change)
			hb.addChild(range2_cb);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择包目录"
			selectBtn.addEventListener(MouseEvent.CLICK,onSelectBtnClick);
			hb.addChild(selectBtn);
			
			
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
		
		
		public function getSearchPath():String
		{
			if(range1_cb.selected){
				return ProjectCache.getInstance().getProjectSrcURL();
			}
			if(range2_cb.selected){
				return String(range2_cb.data);
			}
			return "";
		}
		
		private function onCancelClick(e:MouseEvent):void
		{
			win.closeWin();
		}
		
		private function onSelectBtnClick(e:MouseEvent):void
		{
			var win:OpenPathListPopWinVO = new OpenPathListPopWinVO();
			win.call_f = getFileURL;
			win.isDirectory = true
			var openData:OpenPopwinData = new OpenPopwinData();
			openData.popupwinSign = PopupwinSign.AppPathListPopwin_sign;
			openData.data = win;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			openData.openByAirData = opt;
			iManager.iPopupwin.openPopupwin(openData);
		}
		
		private function getFileURL(fl:File):void
		{
			range2_cb.label = "在目录下:"+fl.nativePath;
			range2_cb.toolTip = range2_cb.label;
			range2_cb.data = fl.nativePath;
		}
		
		private function range1Change(e:ASEvent):void
		{
			range2_cb.setSelect(!range1_cb.selected,false);
		}
		
		private function range2Change(e:ASEvent):void
		{
			range1_cb.setSelect(!range2_cb.selected,false);	
		}
		
		private function searchBtnClick(e:MouseEvent=null):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			if(ti.text.length < 3){
				get_ProjectSearchMediator().showError("搜索至少需要3个字符");
				return 
			}
			BackgroundThreadCommand.instance.global_search(ti.text,getSearchPath(),big_cb.selected,"null");
			win.closeWin();
		}
		
		private function replaceBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			if(ti.text.length < 3){
				get_ProjectSearchMediator().showError("搜索至少需要3个字符");
				return 
			}
			BackgroundThreadCommand.instance.global_replace(ti.text,getSearchPath(),big_cb.selected,ti2.text);
			//win.closeWin();
		}
		
		private function get_ProjectDirectListMediator():ProjectDirectListMediator
		{
			return iManager.retrieveMediator(ProjectDirectListMediator.NAME) as ProjectDirectListMediator;
		}
		
		private function get_ProjectSearchMediator():ProjectSearchMediator
		{
			return iManager.retrieveMediator(ProjectSearchMediator.NAME) as ProjectSearchMediator
		}
	}
}