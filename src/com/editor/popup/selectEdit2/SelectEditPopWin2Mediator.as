package com.editor.popup.selectEdit2
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class SelectEditPopWin2Mediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SelectEditPopWin2Mediator"
		public function SelectEditPopWin2Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():SelectEditPopWin2
		{
			return viewComponent as SelectEditPopWin2
		}
		public function get txt():UILabel
		{
			return createWin.txt;
		}
		public function get list():UIVlist
		{
			return createWin.list;
		}
		public function get input():UITextInputWidthLabel
		{
			return createWin.input;
		}
		
		private var item:SelectEditPopWin2VO;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = createWin.item as OpenPopwinData;
			
			item = dat.data as SelectEditPopWin2VO;
			
			txt.text = item.label;
			
			list.labelField = item.labelField;
			list.addEventListener(ASEvent.CHANGE , onListChange)
			list.dataProvider = item.data;
			
			input.enterKeyDown_proxy = okBtnClick;
		}
		
		private function onListChange(e:ASEvent):void
		{
			if(!e.isDoubleClick) return ;
			(getOpenDataProxy() as OpenPopwinData).callBackFun(list.getSelectItem(),item);
			closeWin();
		}
		
		private function okBtnClick():void
		{
			list.dataProvider = findItem()
		}
		
		private function findItem():Array
		{
			if(StringTWLUtil.isWhitespace(input.text)){
				return item.data;
			}
			var out:Array = [];
			var a:Array = item.data as Array;
			for(var i:int=0;i<a.length;i++){
				if(Object(a[i])[item.findItemById].toString().indexOf(input.text)!=-1){
					out.push(a[i]);
				}
			}
			return out;
		}
		
	}
}