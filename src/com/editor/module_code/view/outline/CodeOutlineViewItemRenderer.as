package com.editor.module_code.view.outline
{
	import com.asparser.Field;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.StringTWLUtil;

	public class CodeOutlineViewItemRenderer extends ASHListItemRenderer
	{
		public function CodeOutlineViewItemRenderer()
		{
			super();
		}
		
		override protected function renderTextField():void{};
		
		private var lb:UILabel;
		
		override protected function __init__():void
		{
			super.__init__();
			name = "CodeOutlineViewItemRenderer"
			
			mouseEnabled = true
				
			lb = new UILabel();
			lb.mouseEnabled = true
			addChild(lb);
		}
		
		private var f:Field;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			f = value as Field;
			if(f == null){
				lb.htmlText = "";
				return ;
			}
			if(f.name == "-1"){
				lb.htmlText = "--私有变量--"
			}else if(f.name == "-2"){
				lb.htmlText = "--私有静态变量--"
			}else if(f.name == "-3"){
				lb.htmlText = "--公有函数--"
			}else if(f.name == "-4"){
				lb.htmlText = "--公有静态函数--"
			}else if(f.name == "-5"){
				lb.htmlText = "--私有函数--"
			}else if(f.name == "-6"){
				lb.htmlText = "--私有静态函数--"
			}else if(f.name == "-7"){
				lb.htmlText = "--公有函数--"
			}else if(f.name == "-8"){
				lb.htmlText = "--公有静态函数--"
			}else{
				lb.htmlText = StringTWLUtil.createSpace() + f.toString();
				toolTip = lb.htmlText+"<br>注释:"+f.info;
			}
		}
		
		
	}
}