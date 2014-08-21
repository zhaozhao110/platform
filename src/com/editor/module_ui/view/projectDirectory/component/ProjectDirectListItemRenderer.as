package com.editor.module_ui.view.projectDirectory.component
{
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	public class ProjectDirectListItemRenderer extends ASHListItemRenderer
	{
		public function ProjectDirectListItemRenderer()
		{
			super();
			height = 22;
			verticalAlign = ASComponentConst.verticalAlign_middle;
		}
		
		private var file:*;
		
		override public function poolChange(value:*):void
		{
			if(value == "file_up"){
				file = "file_up"
			}else{
				file = value as File;
			}
						
			super.poolChange(value);
			
			if(value == "file_up"){
				label = "["+StringTWLUtil.space_sign_en+"] ... "
				renderTextField();
			}
			
			addIcon();
		}
		
		override protected function getIconSource():String
		{
			if(file == "file_up"){
				return "fold2_a"; 
			}
			if(file.isDirectory){
				return "fold2_a";
			}
			return "file_a";
		}
		
		override protected function getIconWidth():int
		{
			if(file == "file_up"){
				return 16
			}
			if(file.isDirectory){
				return 16
			}
			return 14
		}
		
		override protected function getIconHeight():int
		{
			if(file == "file_up"){
				return 13;
			}
			if(file.isDirectory){
				return 13
			}
			return 16
		}
		
		override public function set styleName(val:Object):void
		{
			super.styleName = val;
		}
	}
}