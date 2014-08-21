package com.editor.module_api.itemRenderer
{
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ApiTileItemRenderer extends ASListItemRenderer
	{
		public function ApiTileItemRenderer()
		{
			super();
			
		}
		
		override protected function __init__():void
		{
			super.__init__();
			backgroundColor = 0xe0eaf1;
			borderStyle = ASComponentConst.borderStyle_solid;
			borderColor = 0xb3cee1;
		}
		
		override public function set row_backgroundColor(value:*):void{}
		override public function set backgroundColor(value:*):void{}
		override protected function item_overHandle(e:MouseEvent):void{}
		override protected function item_outHandle(e:MouseEvent):void{}
		override public function select():void{};
		override public function noSelect():void{};
		
		override public function get backgroundColor():*
		{
			return 0xe0eaf1;
		}
			
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			var c1:String = Object(data).name;
			if(Object(data).isGetter){
				c1 += "(isGetter)"
			}else if(Object(data).isSetter){
				c1 += "(isSetter)"
			}
			var c2:String = StringTWLUtil.replaceWhiteSpace( Object(data).info); 
			this.toolTip = c1 + "<br>" + c2;
		}
		
	}
}