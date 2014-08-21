package com.editor.popup.systemSet.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.AppMainModel;
	import com.editor.popup.systemSet.SystemSetPopwinTab4;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.vo.plus.PlusItemVO;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class SystemSetPopwinTab5ItemRenderer extends SandyHBoxItemRenderer
	{
		public function SystemSetPopwinTab5ItemRenderer()
		{
			super()
			create_init();
		}
		
		private var lb:UILabel;
		private var ti:UITextInput;
		private var addBtn:UIButton;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			
			lb = new UILabel();
			lb.width = 100;
			addChild(lb);
			
			ti = new UITextInput();
			ti.editable = false;
			ti.width = 350;
			addChild(ti);
			
			addBtn = new UIButton();
			addBtn.label = "有新版本"
			//addBtn.addEventListener(MouseEvent.CLICK , onClick);
			addChild(addBtn);
			addBtn.visible = false;
			
		}
		
		public var plus:PlusItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			plus = value as PlusItemVO;
			lb.text = plus.name;
			ti.text = plus.version.toString();
			lb.toolTip = plus.info;
			addBtn.visible = false;
			
			if(plus.oldItem!=null){
				if(plus.checkNewVersion()){
					addBtn.label = "有新版本"
					addBtn.visible = true;
				}
			}else{
				addBtn.label = "本地缺失"
				addBtn.visible = true;
			}
		}
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return iManager.retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy
		}
		
	}
}