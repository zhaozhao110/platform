package com.editor.d3.pop.eidtLua
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.FilterTool;
	
	import flash.events.MouseEvent;

	public class EditLuaEditor extends UIVBox
	{
		public function EditLuaEditor()
		{
			super();
			if(instance == null){
				instance = this;
			}
			create_init();
		}
		
		public static var instance:EditLuaEditor;
		
		private var closeBtn:UIButton;
		private var saveBtn:UIButton;
		private var codeTxt:UITextArea;
		
		
		private function create_init():void
		{
			width = 500;
			height = 600;
			padding = 5;
			backgroundColor = DataManager.def_col;
			styleName = "uicanvas"
			this.filters = [FilterTool.getDropShadowFilter()]
			
			var h:UIHBox = new UIHBox();
			h.height = 40;
			h.percentWidth = 100;
			h.styleName = "uicanvas"
			h.paddingLeft = 10;
			h.horizontalGap = 30
			h.verticalAlignMiddle = true;
			h.mouseEnabled = true;
			h.addEventListener(MouseEvent.MOUSE_UP , onTileUp);
			h.addEventListener(MouseEvent.MOUSE_DOWN , onTileDown);
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "Lua Editor"
			lb.bold = true;
			lb.fontSize = 16;
			h.addChild(lb);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存"
			saveBtn.addEventListener(MouseEvent.CLICK , onSave);
			h.addChild(saveBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭"
			closeBtn.addEventListener(MouseEvent.CLICK , onClose);
			h.addChild(closeBtn);
			
			codeTxt = new UITextArea();
			codeTxt.enabledPercentSize = true;
			codeTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(codeTxt);
			
		}
		
		private function onSave(e:MouseEvent):void
		{
			save_f(codeTxt.text);
			onClose();
		}
		
		private function onTileUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		private function onTileDown(e:MouseEvent):void
		{
			this.startDrag();	
		}
		
		private function onClose(e:MouseEvent=null):void
		{
			get_App3DMainUIContainerMediator().hideCurveEditor();
		}
		
		public function getObject():Object
		{
			return codeTxt.text;
		}
		
		public function changeAnim(b:*):void
		{
			codeTxt.text = b;
		}
		
		public var save_f:Function;
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
	}
}