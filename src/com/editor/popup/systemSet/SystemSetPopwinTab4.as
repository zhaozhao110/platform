package com.editor.popup.systemSet
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.air.net.CallCMDProccess;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.popup.systemSet.component.SystemSetPopwinTab4ItemRenderer;
	import com.editor.services.Services;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SystemSetPopwinTab4 extends UIVBox
	{
		public function SystemSetPopwinTab4()
		{
			super();
			//create_init();
		}
		
		public static var isChange:Boolean;
		
		private var form:UIVBox;
		private var logTxt:UITextArea;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas";
			padding = 5;
			
			var lb:UILabel = new UILabel();
			lb.text = "url: " + new File(Services.version_edit_local_url).nativePath;
			addChild(lb);
			lb.height = 25;
			
			form = new UIVBox();
			form.percentWidth = 100;
			form.height = 280;
			form.padding = 10;
			form.verticalGap = 5
			form.styleName = "uicanvas"
			form.itemRenderer = SystemSetPopwinTab4ItemRenderer;
			//form.horizontalAlign = ASComponentConst.horizontalAlign_center;
			this.addChild(form);
						
			var read:ReadFile = new ReadFile();
			var c:String = read.read(Services.version_edit_local_url);
			var x:XML = XML(c);
			form.dataProvider = x.children();
			
			var btn:UIButton = new UIButton();
			btn.label = "复制db";
			btn.addEventListener(MouseEvent.CLICK , copyDB);
			addChild(btn);
			
			logTxt = new UITextArea();
			logTxt.height = 80;
			logTxt.wordWrap = false;
			logTxt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			logTxt.percentWidth = 100;
			addChild(logTxt);
			
			var s:String = iManager.iSharedObject.find("","copyDB");
			if(StringTWLUtil.isWhitespace(s)){
				logTxt.text = "";
			}else{
				logTxt.text = s;
			}
			
			return true;
		}
		
		public function okButtonClick():void
		{
			if(form == null) return ;
			if(!isChange) return ;
			
			var c:String = '<?xml version="1.0" encoding="utf-8"?>'+NEWLINE_SIGN;
			c += '<update xmlns="http://ns.adobe.com/air/framework/update/description/1.0">'+NEWLINE_SIGN;
			var n:int=form.numChildren;
			for(var i:int=0;i<n;i++){
				c += SystemSetPopwinTab4ItemRenderer(form.getChildAt(i)).getXML() + NEWLINE_SIGN;
			}
			c += '</update>'+NEWLINE_SIGN;
			var write:WriteFile = new WriteFile();
			write.write(new File(Services.version_edit_local_url),c);
		}
		
		private var cmd:CallCMDProccess = new CallCMDProccess();
		
		private function copyDB(e:MouseEvent=null):void
		{
			if(StringTWLUtil.isWhitespace(logTxt.text)) return ;
			cmd.start();
			var a:Array = StringTWLUtil.splitNewline(logTxt.text);
			for(var i:int=0;i<a.length;i++){
				var c1:String = StringTWLUtil.trim(a[i]);
				if(!StringTWLUtil.isWhitespace(c1)){
					cmd.write(c1);
				}
			}
			iManager.iSharedObject.put("","copyDB",logTxt.text);
		}
		
		public function delPopwin():void
		{
			cmd.stop();
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
	}
}