package com.editor.project_pop.tweenExplorer
{
	import com.air.component.SandyHtmlLoader;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UISwfLoader;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.editor.services.Services;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	
	public class TweenExplorerPopwinTab5 extends UIVBox
	{
		public function TweenExplorerPopwinTab5()
		{
			super();
			//create_init();
		}
		
		public var lb:UILabel;
		public var loader:SandyHtmlLoader;
		
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			verticalGap = 10;
			padding = 5
			
			hbox = new UIHBox();
			hbox.height = 250;
			hbox.horizontalGap =10;
			hbox.percentWidth =100;
			addChild(hbox);
				
			create_left();
			create_right()
			create_bot();
			reflashTi()
			
			return true;
		}
		
		private var hbox:UIHBox;
		private var ns_ls:Array = [];
		
		private function create_left():void
		{
			var h:UIVBox = new UIVBox();
			h.padding =10;
			h.width = 400;
			h.percentHeight = 100;
			h.styleName = "uicanvas"
			h.verticalGap = 10;
			hbox.addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "-- multiplier --"
			h.addChild(lb);
			
			var a:Array = []
			a.push("redMultiplier");
			a.push("greenMultiplier")
			a.push("blueMultiplier")
			a.push("alphaMultiplier")
			for(var i:int=0;i<a.length;i++){
				ns_ls.push(h.addChild(createNS(a[i])))
			}
		}
		
		private function create_right():void
		{
			var h:UIVBox = new UIVBox();
			h.padding =10;
			h.width = 400;
			h.percentHeight = 100;
			h.styleName = "uicanvas"
			h.verticalGap = 10;
			hbox.addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "-- offset --"
			h.addChild(lb);
			
			var a:Array = []
			a.push("redOffset");
			a.push("greenOffset")
			a.push("blueOffset")
			a.push("alphaOffset")
			for(var i:int=0;i<a.length;i++){
				var ns:UINumericStepperWidthLabel = h.addChild(createNS(a[i])) as UINumericStepperWidthLabel;
				ns.value = 0;
				ns_ls.push(ns);
			}
		}
		
		private var img:UIImage;
		private var ti:UITextInput;
		
		private function create_bot():void
		{
			ti = new UITextInput();
			ti.height = 20;
			ti.width = 400;
			addChild(ti);
			
			img = new UIImage();
			img.source = Services.server_res_url + "img/1.jpg";
			addChild(img);
		}
		
		private function reflashTi():void
		{
			ti.text = "new ColorTransform(";
			for(var i:int=0;i<ns_ls.length;i++){
				var ns:UINumericStepperWidthLabel = ns_ls[i] as UINumericStepperWidthLabel;
				ti.text += ns.value+",";
			}
			ti.text = ti.text.substr(0,ti.text.length-1);
			ti.text += ")"
		}
		
		private function getColor():ColorTransform
		{
			var c:ColorTransform = new ColorTransform()
			for(var i:int=0;i<ns_ls.length;i++){
				var ns:UINumericStepperWidthLabel = ns_ls[i] as UINumericStepperWidthLabel;
				c[ns.data] = ns.value;
			}
			return c;
		}
		
		private function createNS(s:String):UINumericStepperWidthLabel
		{
			var ns:UINumericStepperWidthLabel = new UINumericStepperWidthLabel();
			ns.data = s;
			ns.minimum = -100;
			ns.width = 300;
			ns.label = s;
			ns.maximum =100
			ns.stepSize = .1;
			ns.value = 1;
			ns.enterKeyDown_proxy = nsChange
			ns.addEventListener(ASEvent.CHANGE,nsChange);
			ns.getLabel().width = 120;
			return ns;
		}
		
		private function nsChange(e:*=null):void
		{
			reflashTi()
			if(img.content!=null){
				var b:Bitmap = img.content as Bitmap;
				b.transform.colorTransform = getColor();
			}
		}
		
		
	}
}