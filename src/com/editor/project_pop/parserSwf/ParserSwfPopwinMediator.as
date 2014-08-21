package com.editor.project_pop.parserSwf
{
	import com.air.io.FileUtils;
	import com.air.io.SelectFile;
	import com.asparser.Field;
	import com.asparser.TypeDBCache;
	import com.asparser.swf.as3swf.data.SWFSymbol;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.HashMap;
	import com.sandy.resource.ResourceManager;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.setTimeout;

	public class ParserSwfPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ParserSwfPopwinMediator"
		public function ParserSwfPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ParserSwfPopwin
		{
			return viewComponent as ParserSwfPopwin
		}
		public function get fileTI1():UITextInput
		{
			return resWin.fileTI1; 
		}
		public function get button24():UIButton
		{
			return resWin.button24;
		}
		public function get vb1():UIVBox
		{
			return resWin.vb1;
		}
		public function get vb2():UIVBox
		{
			return resWin.vb2;
		}
		public function get vb3():UIVlist
		{
			return resWin.vb3;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			vb1.labelField = "name";
			vb1.enabeldSelect = true
			vb1.addEventListener(ASEvent.CHANGE,onvb1Change)
				
			vb2.labelFunction = vb2LabelFun
			vb2.enabeldSelect = true
			vb2.addEventListener(ASEvent.CHANGE,onvb2Change)
			
			vb3.labelFunction = vb3LabelFun;
			vb3.enabeldSelect = true
			vb3.doubleClickEnabled = true
			vb3.addEventListener(ASEvent.CHANGE,onvb3Change);
			
			resWin.swfBtn.addEventListener(MouseEvent.CLICK , onParserProject);
		}
		
		public function reactToButton24Click(e:MouseEvent):void
		{
			SelectFile.select("swf文件",[new FileFilter("swf","*.swf")],result_f)
		}
		
		private var file_map:HashMap = new HashMap();
		private var file_ls:Array = [];
		
		private function result_f(e:Event):void
		{
			var file:File = e.target as File;
			if(file.exists && !file_map.exists(file.nativePath)){
				var d:ParserSwfData = new ParserSwfData();
				d.file = file;
				d.name = file.name;
				file_map.put(file.nativePath,d);
				file_ls.push(d);
				var a:Array = file_ls;
				vb1.dataProvider = a;
				vb1.setSelectIndex(a.length-1);
			}
			resWin.showSwf();
		}
		
		private function onvb1Change(e:ASEvent):void
		{
			var d:ParserSwfData = vb1.getSelectItem() as ParserSwfData;
			if(d!=null){
				d.parser();
				if(d.symbol == null){
					vb2.dataProvider = null;
					return ;
				}
				vb2.dataProvider = d.symbol.getSymbolsArray()
				vb2.setSelectIndex(0);
			}else{
				vb2.dataProvider = null;
			}
		}
		
		private function vb2LabelFun(d:SWFSymbol,dc:ASDataGridColumn):String
		{
			var a:Array = TypeDBCache.getHash("getFlaExport");
			if(a!=null){
				a = a[d.name] as Array;
				if(a!=null&&a.length>0){
					return d.name;
				}else{
					return ColorUtils.addColorTool(d.name,ColorUtils.red);
				}
			}
			return ColorUtils.addColorTool(d.name,ColorUtils.red);
		}
		
		private function onvb2Change(e:ASEvent):void
		{
			var d:SWFSymbol = vb2.getSelectItem() as SWFSymbol;
			var a:Array = TypeDBCache.getHash("getFlaExport");
			if(a!=null){
				a = a[d.name] as Array;
				vb3.dataProvider = a;
			}else{
				vb3.dataProvider = null;
			}
		}
		
		private function vb3LabelFun(d:Field,dc:ASDataGridColumn):String
		{
			return d.filenam+"/ row: " + d.index;
		}
		
		private function onvb3Change(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:Field = e.addData as Field;
				var fl:File = new File(d.filePath); 
				if(fl.exists&&!fl.isDirectory){
					var dd:OpenFileData = new OpenFileData();
					dd.file = fl;
					dd.rowIndex = d.index;
					sendAppNotification(AppModulesEvent.openEditFile_event,dd);
				}
			}
		}
		
		
		/////////////////////////////// project ////////////////////////////////////
		
		private function onParserProject(e:MouseEvent):void
		{
			resWin.showProject();
			resWin.txt.htmlText = "";
			
			//parser
			//bin-debug\assets\swf
			var f:File = new File(ProjectCache.getInstance().getBin()+File.separator+"assets"+File.separator+"swf");
			var a:Array = FileUtils.getDirectoryListing(f,"swf");
						
			//bin-debug\theme\assets\swf
			f = new File(ProjectCache.getInstance().getBin()+File.separator+"theme"+File.separator+"assets"+File.separator+"swf");
			var b:Array = FileUtils.getDirectoryListing(f,"swf");
			parserDebugSwf(a.concat(b))
		}
		
		private static var exclude_ls:Array = ["client.swf"];
		
		private var debugSwf_ls:Array = [];
		private function parserDebugSwf(a:Array):void
		{
			debugSwf_ls = a;
			laterParserProject();
		}
		
		private function _parserDebugSwf(f:File):void
		{
			if(exclude_ls.indexOf(f.name)!=-1){
				laterParserProject();
				return ;
			}
			
			resWin.txt.htmlText += "正在解析,"+f.nativePath+"<br>";
			
			var d:ParserSwfData = new ParserSwfData();
			d.file = f;
			d.name = f.name;
			d.parser();
			
			if(d.symbol == null){
				resWin.txt.htmlText += ColorUtils.addColorTool("该swf没有任何导出类",ColorUtils.green)+"<br>";
				laterParserProject();
				return ;
			}
			
			var a:Array = d.symbol.getSymbolsArray()
			if(a.length == 0){
				resWin.txt.htmlText += ColorUtils.addColorTool("该swf没有任何导出类",ColorUtils.blue)+"<br>";
				laterParserProject();
				return ;
			}
			
			var haveV:Boolean;
			for(var i:int=0;i<a.length;i++){
				var s:SWFSymbol = a[i] as SWFSymbol;
				var b:Array = TypeDBCache.getHash("getFlaExport");
				if(b!=null){
					b = b[s.name] as Array;
					if(!StringTWLUtil.isWhitespace(s.name)){
						if(b == null || b.length == 0){
							haveV = true
							resWin.txt.htmlText += "导出类【"+ColorUtils.addColorTool(s.name,ColorUtils.red)+"】没有在任何代码中使用，请检查代码"+"<br>";
						}
					}
				}
			}
			
			if(!haveV){
				resWin.txt.htmlText += ColorUtils.addColorTool("该swf,good!",ColorUtils.cyan)+"<br>";
			}
			
			laterParserProject();
		}
		
		private function laterParserProject():void
		{
			setTimeout(_laterParserProject,1);
		}
		
		private function _laterParserProject():void
		{
			if(debugSwf_ls.length > 0){
				_parserDebugSwf(debugSwf_ls.shift());
			}else{
				resWin.txt.htmlText += "---------解析完成----------"+"<br>";
			}
		}
		
		
		
		
	}
}