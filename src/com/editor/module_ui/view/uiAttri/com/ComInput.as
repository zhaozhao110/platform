package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UITextInput;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ComInput extends ComBase
	{
		public function ComInput()
		{
			super();
		}
		
		private var input:UITextInput;
		private var addBtn:UIAssetsSymbol;
		
		override protected function create_init():void
		{
			super.create_init();
			
			input = new UITextInput();
			input.height = 22
			input.percentWidth = 100;
			input.enterKeyDown_proxy = enterKeyDown;
			addChild(input);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.width = 16;
			addBtn.visible = false;
			addBtn.includeInLayout = false
			addBtn.toolTip = "编辑文本"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			addChild(addBtn);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextAreaPopwin_sign
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = compItem.name+"的"+key+"属性";
			d.text = input.text;
			d.okButtonFun = editFinish
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function editFinish(s:String):void
		{
			input.text = s;
			if(!_checkValid()){
				if(key == "text" || key == "htmlText" || key == "label"){
					input.text = "";
				}
			}
		}
		
		private function enterKeyDown():Boolean
		{
			if(!_checkValid()) return false;
			callUIRender();
			return true;
		}
		
		private function _checkValid():Boolean
		{
			if(key == "text"){
				if(input.text.indexOf("<")!=-1 || 
					input.text.indexOf(">")!=-1 ||
					input.text.indexOf("/")!=-1 ||
					input.text.indexOf("\\")!=-1){
					iManager.iPopupwin.showError("有非法字符，如果需要可以设置在htmlText");
					return false;
				}
			}
			if(key == "id"){
				var t:UITreeNode = UIEditManager.currEditShowContainer.cache.findCompById(input.text);
				if(t!=null){
					if(UIShowCompProxy(t.obj).target.uid!=UIEditManager.currEditShowContainer.selectedUI.target.uid){
						iManager.iPopupwin.showError("有相同的id的组件");
						return false;
					}
				}
			}
			if(key == "name"){
				t = UIEditManager.currEditShowContainer.cache.findCompByName(input.text);
				if(t!=null){
					if(UIShowCompProxy(t.obj).target.uid!=UIEditManager.currEditShowContainer.selectedUI.target.uid){
						iManager.iPopupwin.showError("有相同的name的组件");
						return false;
					}
				}
			}
			return true
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = input.text;
			return d;
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			if(item!=null){
				if(!StringTWLUtil.isWhitespace(item.expand)){
					if(item.expand.split(",")[0]==0){
						input.editable = false;
					}
				}
			}
			
			input.text = "";
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			if(obj!=null){
				if(!StringTWLUtil.isWhitespace(obj.value)){
					input.text = obj.value;
				}
			}
			
			if(key == "text" || key == "htmlText" || key == "label"){
				addBtn.visible = true;
				addBtn.includeInLayout = true
			}else{
				addBtn.visible = false
				addBtn.includeInLayout = false
			}
		}
		
		override protected function resetCom():void
		{
			input.text = "";
		}
		
		override public function checkIsDel():Boolean
		{
			return StringTWLUtil.isWhitespace(input.text);
		}
		
		
	}
}