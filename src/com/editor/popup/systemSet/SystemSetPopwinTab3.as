package com.editor.popup.systemSet
{
	import com.asparser.TokenColor;
	import com.asparser.TokenConst;
	import com.air.component.codeEditor.SandyCodeEditorShortcut;
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.model.AppMainModel;
	import com.editor.popup.systemSet.component.SystemSetPopwinColorBar;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextFormat;

	public class SystemSetPopwinTab3 extends UIVBox
	{
		public function SystemSetPopwinTab3()
		{
			super();
			//create_init();
		}
		
		public var form:UIVBox;
		public var size_cb:UICombobox;
		public var autoSave_cb:UICombobox;
		public var autoSave_btn:UICheckBox;
		//文字
		public var textColorBar:SystemSetPopwinColorBar;
		//背景
		public var backColorBar:SystemSetPopwinColorBar;
		//注释
		public var infoColorBar:SystemSetPopwinColorBar;
		//字符串
		public var strColorBar:SystemSetPopwinColorBar;
		//cursor
		public var cursorColorBar:SystemSetPopwinColorBar;
		//行数
		public var lineNumColorBar:SystemSetPopwinColorBar;
		//行数分割线
		public var lineColorBar:SystemSetPopwinColorBar;
		//快捷键
		public var shutKey_box:UIDataGrid;
		
		private var fontSize_a:Array = [];
		private var autoSave_a:Array = [];
		
		public var resetBtn:UIButton;
		
		override public function delay_init():Boolean
		{
			form = new UIVBox();
			form.enabledPercentSize = true
			form.padding = 10;
			form.verticalGap = 5
			form.styleName = "uicanvas"
			form.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			this.addChild(form);
			
			
			//////////////////////////////////////////////////////////////////
			
			var vb:UIVBox = new UIVBox();
			vb.styleName = "uicanvas"
			vb.height = 250;
			vb.verticalGap = 5;
			vb.percentWidth = 100;
			form.addChild(vb);
			
			var box:UIHBox = new UIHBox();
			box.height = 25;
			box.horizontalGap = 5;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			box.visible = false;
			vb.addChild(box);
			
			var lb:UILabel = new UILabel();
			lb.text = "字体大小"
			box.addChild(lb);
			
			size_cb = new UICombobox();
			size_cb.width = 100;
			size_cb.height = 23;
			size_cb.labelField = "data";
			box.addChild(size_cb);
			
			fontSize_a.push({data:12});
			fontSize_a.push({data:14});
			fontSize_a.push({data:16});
			fontSize_a.push({data:18});
			fontSize_a.push({data:20});
			fontSize_a.push({data:24});
			fontSize_a.push({data:30});
			size_cb.dataProvider = fontSize_a;
			size_cb.selectedIndex = 1;
			//size_cb.visible = false
			
			textColorBar = new SystemSetPopwinColorBar();
			vb.addChild(textColorBar);
			//textColorBar.colorChange_f = 
			textColorBar.setItem("文字颜色");
			
			backColorBar = new SystemSetPopwinColorBar();
			vb.addChild(backColorBar);
			backColorBar.setItem("背景颜色");
			
			infoColorBar = new SystemSetPopwinColorBar();
			vb.addChild(infoColorBar);
			infoColorBar.setItem("注释颜色");
			
			strColorBar = new SystemSetPopwinColorBar();
			vb.addChild(strColorBar);
			strColorBar.setItem("字符串颜色");
			
			cursorColorBar = new SystemSetPopwinColorBar();
			vb.addChild(cursorColorBar);
			cursorColorBar.setItem("光标颜色");
			
			lineNumColorBar = new SystemSetPopwinColorBar();
			vb.addChild(lineNumColorBar);
			lineNumColorBar.setItem("行数颜色");
			
			lineColorBar = new SystemSetPopwinColorBar();
			vb.addChild(lineColorBar);
			lineColorBar.setItem("行数分割线");
			
			resetBtn = new UIButton();
			resetBtn.label = "还原默认"
			resetBtn.addEventListener(MouseEvent.CLICK , resetBtnClick)
			vb.addChild(resetBtn);
			
			//////////////////////////////////////////////////////////////////
			
			box = new UIHBox();
			box.height = 30;
			box.styleName = "uicanvas"
			box.horizontalGap = 5;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			form.addChild(box);
			
			autoSave_btn = new UICheckBox();
			autoSave_btn.label = "代码自动保存"
			box.addChild(autoSave_btn);
			
			autoSave_cb = new UICombobox();
			autoSave_cb.width = 100;
			autoSave_cb.height = 23;
			box.addChild(autoSave_cb);
			
			autoSave_a.push({label:"10秒",data:10});
			autoSave_a.push({label:"30秒",data:30});
			autoSave_a.push({label:"60秒",data:60});
			autoSave_cb.labelField = "label";
			autoSave_cb.dataProvider = autoSave_a;
			autoSave_cb.selectedIndex = 0;
			
			//////////////////////////////////////////////////////////////////
			
			shutKey_box = new UIDataGrid();
			//shutKey_box.styleName = "list";
			shutKey_box.width = 500;
			shutKey_box.height = 300;
			shutKey_box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(shutKey_box);
			
			var col_a:Array = [];
			var col:ASDataGridColumn = new ASDataGridColumn();
			col.columnWidth = 200;
			col.headerText = "命令"
			col.dataField = "label";
			col_a.push(col);
			
			col = new ASDataGridColumn();
			col.columnWidth = 300;
			col.headerText = "注释"
			col.dataField = "data";
			col_a.push(col);
			shutKey_box.columns = col_a;
			
			reflash();
			return true;
		}
		
		private function resetBtnClick(e:MouseEvent):void
		{
			textColorBar.colorBar.selectedColor = TokenColor.defaultStyle.fontColor;
			backColorBar.colorBar.selectedColor = TokenColor.defaultStyle.editBackgroundColor;
			infoColorBar.colorBar.selectedColor = TokenColor.defaultStyle.infoColor;
			strColorBar.colorBar.selectedColor = TokenColor.defaultStyle.stringColor;
			cursorColorBar.colorBar.selectedColor = TokenColor.defaultStyle.cursor_color;
			lineNumColorBar.colorBar.selectedColor = TokenColor.lineNum_color;
			lineColorBar.colorBar.selectedColor = TokenColor.lineColor;
			
		}
		
		private function reflash():void
		{
			textColorBar.colorBar.selectedColor = TokenColor.fontColor
			backColorBar.colorBar.selectedColor = TokenColor.editBackgroundColor;
			infoColorBar.colorBar.selectedColor = TokenConst.getColor(5).color;
			strColorBar.colorBar.selectedColor = TokenConst.getColor(4).color;
			cursorColorBar.colorBar.selectedColor = TokenColor.cursor_color;
			lineColorBar.colorBar.selectedColor = TokenColor.lineColor;
			lineNumColorBar.colorBar.selectedColor = TokenColor.lineNum_color;
			
			for(var i:int=0;i<fontSize_a.length;i++){
				if(Object(fontSize_a[i]).data == TokenColor.fontSize){
					size_cb.selectedIndex = i;
					break
				}
			}
			
			shutKey_box.dataProvider = SandyCodeEditorShortcut.getShortcut()
			
			if(TokenConst.autoSave_time > 0){
				autoSave_btn.selected = true;
				for(i=0;i<autoSave_a.length;i++){
					if(Object(autoSave_a[i]).data == TokenConst.autoSave_time){
						autoSave_cb.selectedIndex = i;
						break
					}
				}
			}
			
		}
		
		private function textSize_change():void
		{
			TokenColor.fontSize = int(size_cb.selectedItem.data);
			iManager.iSharedObject.put("","fontSize",TokenColor.fontSize);
		}
		
		private function textColor_change():void
		{
			if(textColorBar.colorBar.selectedColor!=null){
				TokenColor.fontColor = textColorBar.colorBar.selectedColor;
				iManager.iSharedObject.put("","fontColor",TokenColor.fontColor);
			}
		}
		
		private function backColor_change():void
		{
			if(backColorBar.colorBar.selectedColor!=null){
				TokenColor.editBackgroundColor = backColorBar.colorBar.selectedColor;
				iManager.iSharedObject.put("","editBackgroundColor",TokenColor.editBackgroundColor);
			}
		}
		
		private function infoColor_change():void
		{
			if(infoColorBar.colorBar.selectedColor!=null){
				TokenConst.setColor(5,infoColorBar.colorBar.selectedColor);
				iManager.iSharedObject.put("","infoColor",infoColorBar.colorBar.selectedColor);
			}
		}
		
		private function strColor_change():void
		{
			if(strColorBar.colorBar.selectedColor!=null){
				TokenConst.setColor(4,strColorBar.colorBar.selectedColor);
				iManager.iSharedObject.put("","strColor",strColorBar.colorBar.selectedColor);
			}
		}
		
		private function cursorColor_change():void
		{
			if(cursorColorBar.colorBar.selectedColor!=null){
				TokenColor.cursor_color = cursorColorBar.colorBar.selectedColor;
				iManager.iSharedObject.put("","cursor_color",TokenColor.cursor_color);
			}
		}
		
		private function lineNum_change():void
		{
			if(lineNumColorBar.colorBar.selectedColor!=null){
				TokenColor.lineNum_color = lineNumColorBar.colorBar.selectedColor;
				iManager.iSharedObject.put("","lineNumColor",TokenColor.lineNum_color);
			}
		}
		
		private function lineColor_change():void
		{
			if(lineColorBar.colorBar.selectedColor!=null){
				TokenColor.lineColor = lineColorBar.colorBar.selectedColor;
				iManager.iSharedObject.put("","lineColor",TokenColor.lineColor);
			}
		}
		
		public function okButtonClick():void
		{
			if(form == null) return ;
			textSize_change()
			textColor_change();
			backColor_change();
			infoColor_change();
			strColor_change();
			cursorColor_change();
			lineColor_change();
			lineNum_change();
			
			if(autoSave_btn.selected){
				TokenConst.autoSave_time = autoSave_cb.selectedItem.data;
				iManager.iSharedObject.put("","autoSave",TokenConst.autoSave_time);
			}else{
				TokenConst.autoSave_time = 0
				iManager.iSharedObject.put("","autoSave",TokenConst.autoSave_time);
			}
			
		}
		
	}
}