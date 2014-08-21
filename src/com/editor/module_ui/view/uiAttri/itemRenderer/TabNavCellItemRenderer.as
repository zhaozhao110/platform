package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.sandy.asComponent.containers.ASViewStack;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class TabNavCellItemRenderer extends ASListItemRenderer
	{
		public function TabNavCellItemRenderer()
		{
			super();
			create_init();	
		}
		
		private var ti:UITextInput;
		private var input:UITextInput;
		private var openBtn:UIAssetsSymbol;
		private var box:TabNavViewBox;
		private var delBtn:UIAssetsSymbol;
		public var cell:TabNavCell;
		private var lb2:UILabel;
		private var addImg:UIAssetsSymbol;
		
		override protected function renderTextField():void{};
		
		override public function get height():Number
		{
			return 50;
		}
		
		private function create_init():void
		{
			height = 50;
			width = 250
			mouseEnabled = false;
			mouseChildren = true;
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 25;
			hb2.percentWidth = 100;
			addChild(hb2);
			
			lb2 = new UILabel();
			lb2.text = "tab名：";
			lb2.width = 50;
			hb2.addChild(lb2);
			
			ti = new UITextInput();
			ti.height = 22;
			ti.width = 100;
			ti.enterKeyDown_proxy = ti_keyDown;
			hb2.addChild(ti);
			
			delBtn = new UIAssetsSymbol();
			delBtn.source = "close2_a"
			delBtn.toolTip = "删除"
			delBtn.buttonMode = true;
			delBtn.addEventListener(MouseEvent.CLICK , onDelHandle);
			hb2.addChild(delBtn);
			
			addImg = new UIAssetsSymbol();
			addImg.source = "add_a"
			addImg.buttonMode = true;
			addImg.toolTip = "编辑"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			hb2.addChild(addImg);
			
			var hb:UIHBox = new UIHBox();
			hb.y = 25;
			hb.height = 25;
			hb.percentWidth = 100;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "选择文件："
			hb.addChild(lb);
			
			input = new UITextInput();
			input.height = 22
			input.percentWidth = 100;
			input.enterKeyDown_proxy = enterKeyDown
			hb.addChild(input);
			
			openBtn = new UIAssetsSymbol();
			openBtn.source = "openFold_a"
			openBtn.width = 18;
			openBtn.height = 18;
			hb.addChild(openBtn);
			openBtn.addEventListener(MouseEvent.CLICK , onClickHandle);
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			var path:String = ProjectCache.getInstance().getProjectOppositePath(input.text);
			var fl:File = new File(path);
			if(!fl.exists){
				SandyManagerBase.getInstance().showError("文件不存在");
				return ;
			}
			var ui_d:OpenFileInUIEditorEventVO = new OpenFileInUIEditorEventVO();
			ui_d.file = fl
			ui_d.type = AppCreateClassFilePopwinVO.file_type3
			sendAppNotification(AppModulesEvent.openFile_inUIEditor_event,ui_d)
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			SelectFile.select("选择文件",[],onResult)
		}
		
		private function onResult(e:Event):void
		{
			var fl:File = e.target as File;
			input.text = ProjectCache.getInstance().getOppositePath(fl.nativePath);
			enterKeyDown()
		}
		
		private function ti_keyDown():void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			box.label = ti.text;
		}
		
		private function enterKeyDown():void
		{
			var t:String = input.text;
			if(t.indexOf(".")==-1){
				var s:String = input.text;
				if(s.substring(0,1) == File.separator){
					s = s.substring(1,s.length);
				}
				box.fileURL = s;
			}else{
				box.fileURL = ProjectCache.getInstance().getOppositePath(input.text);
			}
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			box = value as TabNavViewBox;
			if(box == null) return ;
			if(UIEditManager.currEditShowContainer.selectedUI.target is ASViewStack){
				lb2.text = "view名："
			}else if(UIEditManager.currEditShowContainer.selectedUI.target is ASTabNavigator){
				lb2.text = "tab名："
			}
			ti.text = box.label;
			input.text = box.fileURL;
			input.toolTip = input.text;
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
			box = null;
			ti.text = "";
			input.text = "";
			input.toolTip = "";
		}
		
		private function onDelHandle(e:MouseEvent):void
		{
			UIEditManager.currEditShowContainer.selectedUI.tabNav_removeTab(ti.text);
			cell.reflash();
		}
		
	}
}