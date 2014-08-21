package com.editor.module_ui.ui
{
	import com.air.io.ReadFile;
	import com.air.io.ReadImage;
	import com.air.io.WriteFile;
	import com.editor.module_ui.css.PaserCSSXML;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttri;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttriGroup;
	import com.editor.module_ui.view.uiAttri.ComSystemAttriCell;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UIComponentData;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.ASTabBar;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.core.AbstractASBox;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	import com.sandy.style.SandyStyleEmbedData;
	import com.sandy.style.SandyStyleManager;
	import com.sandy.style.SandyStyleNameData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class CreateUIFile
	{
		public function CreateUIFile()
		{
		}
		
		private function get uiData():UIComponentData
		{
			return target.uiData;
		}
		private var write:WriteFile = new WriteFile();
		private var readImg:Loader;
		public var target:UIShowContainer;
				
		public function copyBackgroundImage(fl:File):void
		{
			var url:String = "";
			var par_url:String = uiData.file.parent.nativePath.split(File.separator).join(".");
			var a:Array = par_url.split(".");
			if(a[a.length-1] == "xml"){
				url = uiData.file.parent.nativePath+File.separator+"img"+File.separator+uiData.smallName+"."+fl.extension; 
			}else{
				url = uiData.file.parent.nativePath+File.separator+"xml"+File.separator+"img"+File.separator+uiData.smallName+"."+fl.extension;
			}
			WriteFile.copy(fl,new File(url));
		}
		
		public function loadBackgroundImage():void
		{
			var f:File = uiData.getBackgroundImage();
			if(f!=null){
				if(readImg==null){
					readImg = new Loader();
					readImg.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedComplete);
				}
				var urlReq:URLRequest = new URLRequest(f.url);
				readImg.load(urlReq);
			}
		}
		
		private function loadedComplete(e:Event):void
		{
			var b:Bitmap = readImg.content as Bitmap;
			target.loadBackground(b);
		}
		
		public function parserXML():void
		{
			var f:File = uiData.getXMLFile();
			var read:ReadFile = new ReadFile();
			var c:String = read.readCompressByteArray(f.nativePath);
			var x:XML = XML(c);
			
			var dd:XMLList = x.child("backImage");
			if(dd[0]!=null){
				var backImage_x:XML = XML(dd[0]);
				ComSystemAttriCell.instance.reflashBackImgLoc(int(backImage_x.@x),int(backImage_x.@y));
			}
			
			//从外到里创建组件
			var all_ls:Array = [];
			var comp_ls:Array = [];
			var all_comp_ls:Array = [];
			for each(var p:XML in x.item){
				var d:CreateUIFileCompAttri = new CreateUIFileCompAttri(p);
				var g:CreateUIFileCompAttriGroup;
				if(comp_ls[d.parent]==null){
					g = new CreateUIFileCompAttriGroup();
					if(d.parent == "stage"){
						g.isStage = true;
					}
					comp_ls[d.parent] = g;
					all_comp_ls.push(g);
				}else{
					g = comp_ls[d.parent] as CreateUIFileCompAttriGroup;
				}
				all_ls[d.id] = d;
				g.addItem(d);
			}
						
			//复制过来的，找不到父级,就添加到stage
			/*for each(d in all_ls){
				if(all_ls[d.parent]==null && d.parent != "stage"){
					//comp_ls[d.parent] = null
					d.setAttri("parent","stage");
					g = comp_ls[d.parent] as CreateUIFileCompAttriGroup;
					g.addItem(d);
				}
			}*/
			
			for each(d in all_ls){
				if(comp_ls[d.id]!=null){
					CreateUIFileCompAttriGroup(comp_ls[d.id]).setTarget(d);
				}
			}
			
			all_comp_ls = all_comp_ls.sortOn("index",Array.NUMERIC);
			
			for(var i:int=0;i<all_comp_ls.length;i++){
				g = all_comp_ls[i] as CreateUIFileCompAttriGroup
				g.createChildren();
			}
			
			UIEditCache.reflashCompOutline();
		}
		
		public static function parserStyleName(fl:File,_reflashUI:Boolean=false):SandyStyleNameData
		{
			if(fl == null) return null;
			if(!fl.exists) return null;
			if(parserStyleName_ls == null){
				parserStyleName_ls = AppComponentProxy.instance.style_ls.getListBySameValue("styleName");
			}
			var p:PaserCSSXML = new PaserCSSXML();
			var read:ReadFile = new ReadFile();
			var s:String = read.readCompressByteArray(p.getXMLPath(fl));
			if(StringTWLUtil.isWhitespace(s)){
				return null;
			}
			var d:SandyStyleNameData = p.parserXMLToStyleName(XML(s));
			SandyStyleManager.getInstance().addStyle(d);
			for(var i:int=0;i<parserStyleName_ls.length;i++){
				var value:* = d.getStyle(parserStyleName_ls[i]);
				if(!StringTWLUtil.isWhitespace(value)){
					parserStyleName(ProjectAllUserCache.getInstance().findFileByNameFromCSSXML(SandyStyleEmbedData(value).value))
				}
			}
			if(_reflashUI){
				parserStyleReflashUI();
			}
			
			if(UIEditManager.uiEditor != null){
				UIEditManager.uiEditor.logCont.addLog("解析:"+d.styleName);
			}
			return d;
		}
		
		private static function parserStyleReflashUI():void
		{
			if(UIEditManager.currEditShowContainer == null) return ;
			if(UIEditManager.currEditShowContainer.selectedUI == null) return ;
			var ui:ASComponent = UIEditManager.currEditShowContainer.selectedUI.target;
			if(ui == null) return 
			ui.reflashStyleName();
			/*if(ui is ASTabBar || ui is ASTabNavigator){
				AbstractASBox(ui).reflashDataProvider();
			}*/
		}
		
		
		public static var parserStyleName_ls:Array;
		
	}
}