package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class ComAddAttriBox extends UIVBox
	{
		public function ComAddAttriBox()
		{
			super();
			create_init();
		}
		
		private var ti:UITextInput;
		private var cb:UICombobox;
		private var cb2:UICombobox;
		private var addBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			styleName = "uicanvas";
			visible = false;
			percentWidth = 100;
			height = 80;
			backgroundColor = ColorUtils.black;
			borderColor = ColorUtils.white;
			paddingTop = 4;
			
			var hb1:UIHBox = new UIHBox();
			hb1.horizontalGap = 5;
			hb1.height = 25;
			hb1.percentWidth = 100;
			addChild(hb1);
			
			var lb:UILabel = new UILabel();
			lb.text = "属性名："
			lb.color = ColorUtils.white;
			hb1.addChild(lb);
			
			ti = new UITextInput();
			ti.width = 100;
			hb1.addChild(ti);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 25;
			hb2.percentWidth = 100;
			hb2.horizontalGap = 5;
			addChild(hb2);
			
			lb = new UILabel();
			lb.text = "属性类型："
			lb.color = ColorUtils.white;
			hb2.addChild(lb);
			
			cb = new UICombobox();
			cb.width = 150;
			cb.dropDownWidth = 150
			cb.height = 23;
			hb2.addChild(cb);
			
			var a:Array = [];
			a.push("input");
			a.push("color");
			a.push("file");
			a.push("boolean");
			a.push("array");
			a.push("numericStepper");
			a.push("autoCompleteComboBox");
			cb.dataProvider = a;
			cb.selectedIndex = 0;
			
			var hb3:UIHBox = new UIHBox();
			hb3.height = 25;
			hb3.percentWidth = 100;
			hb3.horizontalGap = 5;
			addChild(hb3);
			
			lb = new UILabel();
			lb.text = "数据类型："
			lb.color = ColorUtils.white;
			hb3.addChild(lb);
			
			cb2 = new UICombobox();
			cb2.width = 150;
			cb2.height = 23;
			hb3.addChild(cb2);
			
			a = [];
			a.push("number");
			a.push("string");
			a.push("boolean");
			a.push("array");
			a.push("color");
			cb2.dataProvider = a;
			cb2.selectedIndex = 0;
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建属性"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			hb3.addChild(addBtn);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			var d:ComAttriItemVO = new ComAttriItemVO();
			d.key = ti.text;
			d.dataType = cb2.selectedItem;
			d.value = cb.selectedItem;
			UIEditManager.currEditShowContainer.cache.addExpandCompAttri(d,UIEditManager.currEditShowContainer.selectedUI.data.name);
			UIEditManager.currEditShowContainer.selectedUI.selectedThis();
			visible = false;
		}
		
	}
}