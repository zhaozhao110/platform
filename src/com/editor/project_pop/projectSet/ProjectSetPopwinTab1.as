package com.editor.project_pop.projectSet
{
	import com.air.io.FileUtils;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInput;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.controls.text.SandyAutoCompleteComboBox;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectSetPopwinTab1 extends UIVBox
	{
		public function ProjectSetPopwinTab1()
		{
			super();
			create_init();
		}
		
		private var locale_cb:UICombobox;
		private var project_ti:UILabel;
		public var reflash_btn:UIButton;
		private var txt1:UILabel;
		public var showHide_cb:UICheckBox;
		public var passport_ti:SandyAutoCompleteComboBox;
		public var change_btn:UIButton;
		public var win:ProjectSetPopwin;
		public var web_ti:UITextInput;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			padding =5;
			styleName = "uicanvas"
			verticalGap =10;
				
			/////////////////////////////////////////////
			
			var hb:UIHBox = new UIHBox();
			hb.horizontalGap =5;
			hb.height = 40;
			hb.verticalAlignMiddle=true;
			hb.percentWidth = 100;
			addChild(hb);
			
			project_ti = new UILabel()			
			hb.addChild(project_ti);
			
			var btn:UIButton= new UIButton();
			btn.label = "打开"
			btn.addEventListener(MouseEvent.CLICK,onBtn1Click);
			hb.addChild(btn);
			
			
			/////////////////////////////////////////////
			
			hb = new UIHBox();
			hb.height = 30;
			hb.verticalAlignMiddle = true;
			hb.percentWidth = 100;
			hb.horizontalGap =5;
			//hb.styleName = "uicanvas"
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "语言包："
			hb.addChild(lb);
			
			locale_cb = new UICombobox();
			locale_cb.width = 150;
			locale_cb.labelField = "name"
			locale_cb.height = 25;
			hb.addChild(locale_cb);
			
			
			////////////////////////////////////////////////////
			
			var vb:UIVBox = new UIVBox();
			vb.height = 70;
			vb.padding = 2;
			vb.percentWidth = 100;
			vb.styleName = "uicanvas"
			vb.verticalGap = 0;
			addChild(vb);
			
			var txt:UIText = new UIText();
			txt.width = 550
			txt.color = ColorUtils.green;
			txt.text = "刷新整个项目所有文件的缓存,该操作可能需要花费点时间，但不影响你操作其他功能，刷新完成后会提示通知你。"
			vb.addChild(txt);
			
			hb = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 22;
			hb.verticalAlign = ASComponentConst.verticalAlign_top;
			vb.addChild(hb);
			
			reflash_btn = new UIButton();
			reflash_btn.label = "刷新缓存"
			reflash_btn.addEventListener(MouseEvent.CLICK,onBtn2Click);
			vb.addChild(reflash_btn);
			
			txt1 = new UILabel();
			hb.addChild(txt1);
			
			////////////////////////////////////////////////////
			
			////////////////////////////////////////////////////////////////////
			
			hb = new UIHBox();
			//hb.styleName = "uicanvas";
			hb.height = 60;
			hb.horizontalGap = 5;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			showHide_cb = new UICheckBox();
			showHide_cb.label = "显示隐藏文件"
			showHide_cb.addEventListener(ASEvent.CHANGE, showHideChange);
			hb.addChild(showHide_cb);
			if(iManager.iSharedObject.find("","projectAllShow")==1){
				showHide_cb.selected = true;
			}
			
			////////////////////////////////////////////////////////////////////
			
			hb = new UIHBox();
			//hb.styleName = "uicanvas";
			hb.height = 60;
			hb.horizontalGap = 5;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			lb = new UILabel();
			lb.text = "登录的帐号："
			hb.addChild(lb);
			
			passport_ti = new SandyAutoCompleteComboBox();
			passport_ti.dropDownHeight =200;
			passport_ti.width = 150;
			hb.addChild(passport_ti);
			passport_ti.text = AppMainModel.getInstance().user.name;
			
			change_btn = new UIButton();
			change_btn.label = "切换"
			change_btn.addEventListener(MouseEvent.CLICK,onChangePassport)
			hb.addChild(change_btn);
			
			////////////////////////////////////////////
			
			hb = new UIHBox();
			//hb.styleName = "uicanvas";
			hb.height = 60;
			hb.horizontalGap = 5;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			lb = new UILabel();
			lb.text = "项目网页地址："
			hb.addChild(lb);
			
			web_ti = new UITextInput();
			web_ti.width = 350;
			web_ti.enterKeyDown_proxy = web_ti_enter
			hb.addChild(web_ti);
		}
		
		private function web_ti_enter():void
		{
			iManager.iSharedObject.put("",ProjectCache.getInstance().currEditProjectFile.nativePath,web_ti.text);
			SandyEngineGlobal.config.skinSourceURL = web_ti.text
		}
		
		public function reflash():void
		{
			project_ti.text = "项目目录："+ ProjectCache.getInstance().currEditProjectFile.nativePath;
			var fl:File = new File(ProjectCache.getInstance().getLocaleDir());
			if(!fl.exists) return ;
			var a:Array = fl.getDirectoryListing();
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				if(!FileUtils.isSVNFile(File(a[i]).nativePath)){
					b.push(a[i]);
				}
			}
			locale_cb.dataProvider = b;
			locale_cb.selectedIndex = 0;
			txt1.label = "上次执行时间：" + SharedObjectManager.getInstance().find("","parserProject");
			if(AppMainModel.getInstance().projectSet_parseing){
				reflash_btn.visible = false;
			}
			passport_ti.labelField = "shortName"
			passport_ti.dataProvider = AppGlobalConfig.instance.user_vo.all_ls;
			
			web_ti.text = iManager.iSharedObject.find("",ProjectCache.getInstance().currEditProjectFile.nativePath);
			SandyEngineGlobal.config.skinSourceURL = web_ti.text
		}
		
		private function onBtn1Click(e:MouseEvent):void
		{
			FileUtils.openFold(ProjectCache.getInstance().currEditProjectFile.nativePath);
			iManager.iPopupwin.closePoupwin(PopupwinSign.ProjectSetPopwin_sign)
		}
		
		private function onBtn2Click(e:MouseEvent):void
		{
			reflash_btn.visible = false;
			AppMainModel.getInstance().projectSet_parseing = true;
			txt1.label = "上次执行时间：" + TimerUtils.getCurrentTime_str();
			SharedObjectManager.getInstance().put("","parserProject",TimerUtils.getCurrentTime_str());
			BackgroundThreadCommand.instance.parserProject();
			
		}
		
		////////////////////////////////////////////////////////////////////
		
		private function showHideChange(e:ASEvent):void
		{
			if(showHide_cb.selected){
				iManager.iSharedObject.put("","projectAllShow",1)
			}else{
				iManager.iSharedObject.put("","projectAllShow",0)
			}
		}
		
		public function okButtonClick():void
		{
			
		}
		
		///////////////////////////////////////////////////////////////////
		
		private function onChangePassport(e:MouseEvent):void
		{
			var user:String = StringTWLUtil.trim(passport_ti.text);
			if(user == AppMainModel.getInstance().user.name){
				return ;
			}
			if(StringTWLUtil.isWhitespace(user)){
				return ;
			}
			sendAppNotification(AppEvent.changeUser_event,user);
			win.closeWin();
		}
		
		
	}
}