package com.editor.module_ui.view.uiAttri
{
	import com.air.io.ReadImage;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComButton;
	import com.editor.module_ui.view.uiAttri.com.ComColor;
	import com.editor.module_ui.view.uiAttri.com.ComFile;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.itemRenderer.COMCacheUIItemRenderer;
	import com.editor.module_ui.view.uiAttri.itemRenderer.ComSystemLoadSourceItemRenderer;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.NumberUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.desktop.Clipboard;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.System;
	import flash.utils.getTimer;

	public class ComSystemAttriCell extends UIVBox
	{
		public static var instance:ComSystemAttriCell;
		
		public function ComSystemAttriCell()
		{
			super();
			instance = this;
			
			var fl:ComButton = new ComButton();
			fl.reflashFun = loadBackground;
			d = new ComAttriItemVO();
			d.key = "导入背景图";
			fl.item = d;
			addChild(fl as DisplayObject);
			var dd:ComBaseVO = new ComBaseVO();
			dd.key = "loadBackground";
			dd.value = "导入背景图";
			fl.setValue(dd);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "背景图坐标："
			hb.addChild(lb);
			
			lb = new UILabel();
			lb.text = "x：";
			hb.addChild(lb);
				
			backX_ti = new UITextInput();
			backX_ti.width = 50;
			backX_ti.text = "0";
			backX_ti.restrict = "0-9"
			backX_ti.enterKeyDown_proxy = onBackImgLoc;
			hb.addChild(backX_ti);
			
			lb = new UILabel();
			lb.text = "y："
			hb.addChild(lb);
			
			backY_ti = new UITextInput();
			backY_ti.width = 50;
			backY_ti.text = "0";
			backY_ti.restrict = "0-9"
			backY_ti.enterKeyDown_proxy = onBackImgLoc;
			hb.addChild(backY_ti);
						
			var ds:ComBoolean = new ComBoolean();
			ds.reflashFun = showBackground;
			var d:ComAttriItemVO = new ComAttriItemVO();
			d.key = "显示/隐藏背景图";
			ds.item = d;
			addChild(ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showBackground";
			dd.value = true
			ds.setValue(dd);
			
			ds = new ComBoolean();
			ds.reflashFun = lockBackground;
			d = new ComAttriItemVO();
			d.key = "锁定背景图";
			ds.item = d;
			addChild(ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "lockBackground";
			dd.value = false
			ds.setValue(dd);
			
			var col_ds:ComColor = new ComColor();
			col_ds.reflashFun = setBackgroundColor;
			d = new ComAttriItemVO();
			d.key = "背景颜色";
			col_ds.item = d;
			addChild(col_ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "setBackgroundColor";
			dd.value = ColorUtils.black;
			col_ds.setValue(dd);
			
			ds = new ComBoolean();
			ds.reflashFun = showInventedBorder;
			d = new ComAttriItemVO();
			d.key = "显示/隐藏虚拟边框";
			ds.item = d;
			addChild(ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showInventedBorder";
			dd.value = false
			ds.setValue(dd);
			
			var btn:ComButton = new ComButton();
			btn.reflashFun = showAllComp;
			d = new ComAttriItemVO();
			d.key = "显示/隐藏所有组件";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "showAllComp";
			dd.value = "显示/隐藏所有组件"
			btn.setValue(dd);
			
			hb = new UIHBox();
			hb.percentWidth =100;
			hb.height = 25;
			addChild(hb);
			
			copyBtn2 = new UIButton();
			copyBtn2.label = "复制界面"
			copyBtn2.addEventListener(MouseEvent.CLICK , onCopyView);
			hb.addChild(copyBtn2);
			
			copyBtn3 = new UIButton();
			copyBtn3.label = "黏贴界面"
			copyBtn3.toolTip = "黏贴后需要重新打开view"
			copyBtn3.addEventListener(MouseEvent.CLICK , onParseView);
			hb.addChild(copyBtn3);
			
			hb = new UIHBox();
			hb.percentWidth =100;
			hb.height = 25;
			addChild(hb);
			
			createEventBtn = new UIButton();
			createEventBtn.label = "创建所有组件的事件函数"
			createEventBtn.addEventListener(MouseEvent.CLICK , onCreateBtn);
			hb.addChild(createEventBtn);
			
			var vb2:UIVBox = new UIVBox();
			vb2.paddingLeft = 2;
			vb2.paddingTop = 2;
			vb2.styleName = "uicanvas"
			vb2.width = 270;
			vb2.height = 200;
			addChild(vb2);
			
			var flf:ComFile = new ComFile();
			flf.reflashFun = loadAssets;
			flf.height = 25;
			d = new ComAttriItemVO();
			d.key = "导入资源库";
			flf.item = d;
			vb2.addChild(flf as DisplayObject);
			flf.addImg.visible = false;
			
			loadAllResBtn = new UIButton();
			loadAllResBtn.label = "一键导入全部"
			loadAllResBtn.toolTip = "第一次打开平台的时候，自动会执行一次加载所有资源的操作"
			vb2.addChild(loadAllResBtn);
			loadAllResBtn.addEventListener(MouseEvent.CLICK , onLoadAllRes);
			
			source_vb = new UIVBox();
			source_vb.labelField = "sign";
			source_vb.styleName = "list";
			source_vb.width = 260;
			source_vb.height = 150
			source_vb.itemRenderer = ComSystemLoadSourceItemRenderer;
			source_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			vb2.addChild(source_vb);
			
			onLoadAllRes()
			
			tab2 = new UITabBarNav();
			tab2.percentWidth =100;
			tab2.height = 350
			addChild(tab2);
			
			var vb3:UIVBox = new UIVBox();
			vb3.label = "全局组件缓存" 
			vb3.styleName = "uicanvas"
			tab2.addChild(vb3);
			
			var hb11:UIHBox = new UIHBox();
			hb11.height = 25;
			hb11.verticalAlignMiddle = true;
			vb3.addChild(hb11);
			
			globalCompBtn = new UIButton();
			globalCompBtn.label = "复制多个选中的组件"
			globalCompBtn.addEventListener(MouseEvent.CLICK , onGlobalCompClick);
			hb11.addChild(globalCompBtn);
			
			noGlobalCompBtn = new UIButton();
			noGlobalCompBtn.label = "取消所有选中状态"
			noGlobalCompBtn.addEventListener(MouseEvent.CLICK , onNoGlobalCompClick);
			hb11.addChild(noGlobalCompBtn);
			
			cache_vb = new UIVBox();
			cache_vb.labelField = "sign";
			cache_vb.styleName = "list";
			cache_vb.width = 260;
			cache_vb.height = 250;
			cache_vb.itemRenderer = COMCacheUIItemRenderer;
			cache_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			cache_vb.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN , onCacheClick);
			vb3.addChild(cache_vb);
						
			tab2.selectedIndex = 0;
		}
		
		private var createEventBtn:UIButton;
		private var globalCompBtn:UIButton;
		private var noGlobalCompBtn:UIButton;
		
		private function onCreateBtn(e:MouseEvent):void
		{
			System.setClipboard(UIEditManager.currEditShowContainer.cache.copyAllCompEventCode());
		}
		
		private function onGlobalCompClick(e:MouseEvent):void
		{
			var a:Array = COMCacheUIItemRenderer.cbGroup.selectedList;
			for(var i:int=0;i<a.length;i++){
				UIEditManager.getInstance().globalParse(a[i]);
			}
		}
		
		private function onNoGlobalCompClick(e:MouseEvent):void
		{
			COMCacheUIItemRenderer.cbGroup.setAllButtonNoSelect();
		}
		
		private function onLoadAllRes(e:MouseEvent=null):void
		{
			var a:Array = AppMainModel.getInstance().applicationStorageFile.loadAssets_ls;
			if(a == null) return ;
			if(a.length == 0) return ;
			for(var i:int=0;i<a.length;i++){
				loadAssetsURL(a[i],false);
			}
		}
		
		private var copyBtn2:UIButton;
		private var copyBtn3:UIButton;
		
		public static var globalCopyViewPath:File;
		
		private function onCopyView(e:MouseEvent):void
		{
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.uiData == null) return ;
			globalCopyViewPath = UIEditManager.currEditShowContainer.uiData.getXMLFile();
			copyBtn3.toolTip = "已经复制了"+globalCopyViewPath.nativePath+"<br>黏贴后需要重新打开view";
			iManager.iPopupwin.showMessage("复制成功，请打开你要黏贴到的界面，然后点黏贴界面按钮");
		}
		
		private function onParseView(e:MouseEvent):void
		{
			if(globalCopyViewPath == null) return ;
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.uiData == null) return ;
			var fl1:File = globalCopyViewPath;
			var fl2:File = UIEditManager.currEditShowContainer.uiData.getXMLFile();
			WriteFile.copy(fl1,fl2);
		}
		
		private function onCacheClick(e:MouseEvent):void
		{
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= <root><menuitem label="清除所有缓存" data="1"/></root>
			dat.click_f  	= clearEditCache;
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function clearEditCache(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			if(evt.@data == "1"){ 
				UIEditCache.cacheUI_ls = null;
				UIEditCache.cacheUI_ls = [];
				reflashCacheVBox()
			}
		}
		
		public function reflashCacheVBox():void
		{
			cache_vb.dataProvider = UIEditCache.cacheUI_ls;
		}
		
		
		private var tab2:UITabBarNav;
		private var cache_vb:UIVBox;
		private var source_vb:UIVBox;	
		private var loadAllResBtn:UIButton;
		private var backX_ti:UITextInput;
		private var backY_ti:UITextInput;
		public var cell:ComAttriCell;
		private var souce_ls:Array = [];
		private var source_map:Array = [];
		
		private function onBackImgLoc():void
		{
			UIEditManager.currEditShowContainer.background.x = int(backX_ti.text);
			UIEditManager.currEditShowContainer.background.y = int(backY_ti.text);
		}
		
		public function reflashBackImgLoc(bx:Number=NaN,by:Number=NaN):void
		{
			if(NumberUtils.isNumber(bx)){
				UIEditManager.currEditShowContainer.background.x = bx
			}
			if(NumberUtils.isNumber(by)){
				UIEditManager.currEditShowContainer.background.y = by
			}
			backX_ti.text = UIEditManager.currEditShowContainer.background.x.toString();
			backY_ti.text = UIEditManager.currEditShowContainer.background.y.toString();
		}
		
		private function loadAssets(d:IComBase):void
		{
			var dv:IComBaseVO = d.getValue();
			loadAssetsURL(ProjectCache.getInstance().getProjectOppositePath(dv.value));
		}
		
		private function loadAssetsURL(url:String,load:Boolean=true):void
		{
			if(StringTWLUtil.isWhitespace(url)) return ;
			var fl:File = new File(url);
			if(fl.exists){
				if(load){
					var ld:ASLoader = new ASLoader();
					ld.complete_fun = loadComplete
					ld.complete_args = fl
					ld.load(fl.nativePath,false,true);
				}
				
				var obj:Object = {};
				obj.name = fl.name;
				obj.path = fl.nativePath;
				obj.time = TimerUtils.getSec_hour();
				obj.time2 = getTimer();
				obj.sign = "load: " + obj.time + "/" + obj.name;
				source_map[obj.path] = obj;
				
				var save_a:Array = [];
				souce_ls = [];souce_ls = [];
				for each(obj in source_map){
					if(obj!=null){
						souce_ls.push(obj);
						save_a.push(obj.path);
					}
				}
				souce_ls = souce_ls.sortOn("time2",Array.NUMERIC|Array.DESCENDING);
				source_vb.dataProvider = souce_ls;
				
				AppMainModel.getInstance().applicationStorageFile.putKey_loadAssets_ls(save_a.join("|"));
			}
		}
		
		private function loadComplete(fl:File):void
		{
			UIEditManager.uiEditor.logCont.addLog("加载:"+ fl.nativePath);
		}
		
		private var allUIVisible:Boolean;
		private function showAllComp(d:IComBase):void
		{
			if(!allUIVisible){
				allUIVisible = true
				UIEditManager.currEditShowContainer.cache.showAllComp();
			}else{
				allUIVisible = false;
				UIEditManager.currEditShowContainer.cache.hideAllComp();
			}
		}
		
		private function setBackgroundColor(d:IComBase):void
		{
			var dv:IComBaseVO = d.getValue();
			UIEditManager.currEditShowContainer.setBackgroundColor(dv.value);
		}
		
		private function showInventedBorder(d:IComBase):void
		{
			var dv:IComBaseVO = d.getValue();
			var bool:Boolean;
			if(dv.value == "true" || dv.value == true){
				bool = true
			}else{
				bool = false
			}
			var a:Array = UIEditManager.currEditShowContainer.cache.tree.getAllList();
			for each(var p:UITreeNode in  a){
				if(p!=null && p.obj is UIShowCompProxy && (UIShowCompProxy(p.obj).target.isContainer||UIShowCompProxy(p.obj).checkIsMultView())){
					UIShowCompProxy(p.obj).target.showBorderInUIEdit(bool);
				}
			}
		}
		
		private function showBackground(d:IComBase):void
		{
			var dv:IComBaseVO = d.getValue();
			if(dv.value == "true"){
				UIEditManager.currEditShowContainer.setBackgroundVisible(true);
			}else{
				UIEditManager.currEditShowContainer.setBackgroundVisible(false);
			}
		}
		
		private function lockBackground(d:IComBase):void
		{
			var dv:IComBaseVO = d.getValue();
			if(dv.value == "true"){
				UIEditManager.currEditShowContainer.lockBackground = true
			}else{
				UIEditManager.currEditShowContainer.lockBackground = false
			}
		}
		
		private var readImg:ReadImage;
		
		private function loadBackground(d:IComBase):void
		{
			if(readImg==null){
				readImg = new ReadImage();
				readImg.complete_f = backgroundLoadComplete;
			}
			readImg.load();
		}
		
		private function backgroundLoadComplete():void
		{
			UIEditManager.currEditShowContainer.loadBackground(readImg.content,readImg.selectedFile);
		}
		
		
	}
}