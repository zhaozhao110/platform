package com.editor.moudule_drama.view.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.moudule_drama.view.render.RowResViewListRenderer;

	/**
	 * 层属性
	 * @author sun
	 * 
	 */	
	public class DramaAttributeEditor_Row extends UICanvas
	{
		public function DramaAttributeEditor_Row()
		{
			super();
			create_init();
		}
		
		/**容器**/
		public var vbox:UIVBox;		
		/**属性标题**/
		public var titleInput:UITextInputWidthLabel;
		/**当前未显示资源列表 container**/
		public var canvas1:UICanvas;
		/**当前未显示资源列表 vbox**/
		public var notDisplayResListVbox:UIVBox;
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.x = 10; vbox.y = 10;
			vbox.verticalGap = 10;
			addChild(vbox);
			
			/**属性标题**/
			titleInput = new UITextInputWidthLabel();
			titleInput.width = 174; titleInput.height = 20;
			titleInput.editable = false;
			titleInput.label = "层名称：";
			titleInput.text = "对话层";
			vbox.addChild(titleInput);
			
			
			/**资源列表**/
			canvas1 = new UICanvas();
			vbox.addChild(canvas1);
			
			var label1:UILabel = new UILabel();
			label1.text = "关键帧未显示资源：";
			canvas1.addChild(label1);			
			notDisplayResListVbox = new UIVBox();
			notDisplayResListVbox.x = 0; notDisplayResListVbox.y = 24;
			notDisplayResListVbox.width = 180; notDisplayResListVbox.height = 200;
			notDisplayResListVbox.padding = 2;
			notDisplayResListVbox.verticalGap = 3;
			notDisplayResListVbox.backgroundColor = 0xE5E5E5;
			notDisplayResListVbox.verticalScrollPolicy = "auto";
			notDisplayResListVbox.itemRenderer = RowResViewListRenderer;
			notDisplayResListVbox.enabeldSelect = true;
			canvas1.addChild(notDisplayResListVbox);
		}
		
	}
}