package com.editor.popup.systemSet.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.popup.systemSet.SystemSetPopwinTab4;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class SystemSetPopwinTab4ItemRenderer extends SandyHBoxItemRenderer
	{
		public function SystemSetPopwinTab4ItemRenderer()
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
			ti.height = 22
			addChild(ti);
			
			addBtn = new UIButton();
			addBtn.label = "刷新"
			addBtn.addEventListener(MouseEvent.CLICK , onClick);
			addChild(addBtn);
		}
		
		private var type:String ;
		private var cont:String;
		private var isXML:Boolean;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			isXML = false;
			var x:XML = XML(value);
			if(!StringTWLUtil.isWhitespace(x)){
				type = StringTWLUtil.trim(x.localName().toString());
				try{
					cont = StringTWLUtil.trim(x.text()[0].toString());
				}catch(e:Error){
					isXML = true;
					cont = x.toString();
				}
				lb.text = type
				ti.text = StringTWLUtil.removeNewlineChar(cont);
			}
			
			if(type == "url" || type == "description"){
				addBtn.visible = false;
			}
		}
		
		public function getXML():String
		{
			if(isXML) return ti.text;
			cont = StringTWLUtil.trim(ti.text);
			var c:String = '<'+type+'>';
			if(type == "description"){
				c += "<![CDATA["+ ti.text+']]>'
			}else{
				c += ti.text;
			}
			c += '</'+type+'>'
			return c;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(type == "versionNumber"){
				var a:Array = cont.split(".");
				a[a.length-1] = int(a[a.length-1])+1;
				cont = a.join(".");
				ti.text = cont;
			}else{
				cont = TimerUtils.getCurrentTime().toString();
				ti.text = cont;
			}
			SystemSetPopwinTab4.isChange = true;
		}
		
	}
}