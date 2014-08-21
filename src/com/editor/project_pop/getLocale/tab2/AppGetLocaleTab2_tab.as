package com.editor.project_pop.getLocale.tab2
{
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.air.io.FileUtils;
	import com.air.io.SandyFileProxy;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.project_pop.getLocale.component.AppGetLocaleActionRenderer;
	import com.editor.project_pop.getLocale.component.AppGetLocaleItemRenderer;
	import com.editor.project_pop.getLocale.component.AppGetLocaleSelectHeadRenderer;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class AppGetLocaleTab2_tab extends UIVBox
	{
		public function AppGetLocaleTab2_tab(tp:int)
		{
			super();
			type = tp
			create_init();
		}
		
		public var type:int;
		private var config_fileBtn:SandyTextInputWithLabelWithSelectFile;
		private var file_vlist:UIDataGrid;
		private var config_file:File;
		private var pathTI:UITextInput;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			padding = 5;
			
			config_fileBtn = new SandyTextInputWithLabelWithSelectFile();
			config_fileBtn.height = 30;
			config_fileBtn.addEventListener(ASEvent.CHANGE,config_select);
			config_fileBtn.percentWidth = 100;
			if(type == 1){
				config_fileBtn.label = "client："
			}else if(type == 2){
				config_fileBtn.label = "config："
			}else if(type == 3){
				config_fileBtn.label = "res："
			}
			config_fileBtn.openDirectory = true;
			addChild(config_fileBtn);
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 30;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "当前路径："
			hb.addChild(lb);
			
			pathTI = new UITextInput();
			pathTI.percentWidth = 100;
			hb.addChild(pathTI);
			
			var btn:UIButton = new UIButton();
			btn.label = "转到"
			btn.addEventListener(MouseEvent.CLICK , ongoto)
			hb.addChild(btn);
			
			file_vlist = new UIDataGrid();
			file_vlist.uiowner = this;
			//file_vlist.doubleClickEnabled = true
			file_vlist.enabledPercentSize = true;
			addChild(file_vlist);
			file_vlist.addEventListener(ASEvent.CHANGE,fileTreeChangeHandle)
			
			var col_a:Array = [];
			var col:ASDataGridColumn = new ASDataGridColumn();
			col.editable = true;
			col.columnWidth = 550;
			col.headerText = "全/不选中"
			col.dataField = "xml";
			col.renderer = AppGetLocaleItemRenderer
			col.head_renderer = AppGetLocaleSelectHeadRenderer
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.editable = true;
			col.columnWidth = 150;
			col.headerText = "创建时间"
			col.dataField = "creationDate_str"
			col.sortField = "creationDate_num"
			col.sortable = true
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.editable = true;
			col.columnWidth = 150;
			col.headerText = "修改时间"
			col.dataField = "modificationDate_str"
			col.sortField = "modificationDate_num"
			col.sortable = true;
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.editable = true;
			col.columnWidth = 100;
			col.headerText = "操作"
			col.dataField = "info"
			col.renderer = AppGetLocaleActionRenderer
			col_a.push(col);
			
			file_vlist.columns = col_a;
			
		}
		
		public function onSelectChange(value:Boolean):void
		{
			var n:int = file_vlist.getListNumChildren();
			for(var i:int=0;i<n;i++){
				AppGetLocaleItemRenderer(DisplayObjectContainer(file_vlist.getListChildAt(i)).getChildAt(0)).mySelect(value);
			}
		}
		
		private function config_select(e:ASEvent):void
		{
			var file:File = e.data as File;
			setConfigFile(file.nativePath);	
		}
		
		public function setConfigFile(file:String):void
		{
			if(StringTWLUtil.isWhitespace(file)) return ;
			var f:File = new File(file);
			if(!f.exists) return ;
			config_file = f;
			config_fileBtn.text = f.nativePath;
			setPath(config_file.nativePath);
		}
		
		public function getConfigFile():String
		{
			if(config_file==null) return "";
			return config_file.nativePath;
		}
		
		private function ongoto(e:MouseEvent):void
		{
			setPath(pathTI.text);
		}
		
		public function reflashPath():void
		{
			setPath(pathTI.text);
		}
		
		public function setPath(path:String):void
		{
			if(StringTWLUtil.isWhitespace(path)) return 
			var file:File = new File(path);
			if(file == null) return; 
			if(!file.exists) return;
			
			pathTI.text = file.nativePath;
			var a:Array = file.getDirectoryListing();
			a = a.sortOn("isDirectory",Array.NUMERIC|Array.DESCENDING);
			
			var b:Array = [];
			if(config_file.nativePath != file.nativePath){
				b.push("file_up");
			}
			a = b.concat(a);
			var aa:Array = [];
			for(var i:int=0;i<a.length;i++){
				if(a[i] is File){
					var fl:File = File(a[i]);
					if(!FileUtils.isSVNFile(fl.name)){
						aa.push(new SandyFileProxy(fl));
					}
				}else{
					aa.push(a[i]);
				}
			}
			file_vlist.dataProvider = aa;
		}
		
		public function getTextInputFile():File
		{
			return new File(pathTI.text)
		}
		
		public function getSelectedFile():*
		{
			return file_vlist.selectedItem 
		}
		
		private function fileTreeChangeHandle(e:ASEvent):void
		{
			var _selectedItem2:* = getSelectedFile();
			if(_selectedItem2 == null) return ;
			if(e.isRightClick){
				/*if(selectedItem == "file_up"){
				setPath( (getTextInputFile().parent as File).nativePath );
				return ;
				}*/
				//later_winRightClick();
				return ;
			}
			if(e.isDoubleClick){
				if(_selectedItem2 == "file_up"){
					setPath( (getTextInputFile().parent as File).nativePath );
					return ;
				}
				var fl:SandyFileProxy = _selectedItem2;
				if(fl.isDirectory){
					setPath(SandyFileProxy(getSelectedFile()).nativePath);
				}
			}
		}
		
		public function gotoParent():void
		{
			if(config_file.nativePath == getTextInputFile().nativePath) return ;
			setPath(getTextInputFile().parent.nativePath);
		}
		
	}
}