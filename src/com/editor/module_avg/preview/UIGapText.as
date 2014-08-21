package com.editor.module_avg.preview
{
	import com.editor.component.controls.UIText;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class UIGapText extends UIText
	{
		public function UIGapText()
		{
			super();
		}
		
		private var allText:String;
		private var textIndex:int;
		private var interval:uint;
		public var colors:Array;
		
		override public function set text(value:String):void
		{
			super.text = "";
			
			textIndex = 0;
			clearInterval(interval);interval = 0;
			allText = value
				
			if(StringTWLUtil.isWhitespace(value)){
				super.text = "";
				return ;
			}
			
			play()
		}
		
		public function set text2(value:String):void
		{
			allText = value
			super.text = value;
			setColors()
		}
		
		private function setColors():void
		{
			if(colors == null) return ;
			for(var i:int=0;i<colors.length;i++){
				var obj:Object = colors[i];
				setColorOne(obj);	
			}
		}
		
		private function setColorOne(obj:Object):void
		{
			var from:int = int(obj.from);
			var end:int = int(obj.end);
			var color:* = obj.color;
			for(var i:int=from;i<end;i++){
				var tf:TextFormat = new TextFormat();
				tf.color = color;
				if(i <= (super.text.length-1)){
					getTextField().setTextFormat(tf,i,i+1);
				}
			}
		}
		
		private function play():void
		{
			interval = setInterval(addText,50);
		}
		
		public function isPlaying():Boolean
		{
			return interval != 0;
		}
		
		private function addText():void
		{
			if(allText.length >= (textIndex+1)){
				var s:String = allText.substring(textIndex,textIndex+1);
				super.text = super.text+s;
				setColors()
				textIndex += 1
			}else{
				clearInterval(interval);
				interval = 0;
			}
		}
		
		public function setAll():void
		{
			clearInterval(interval);
			interval = 0;
			super.text = allText;
		}
		
	}
}