package com.editor.d3.view.outline.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class D3OutlinePopViewItemRenderer extends ASHListItemRenderer
	{
		public function D3OutlinePopViewItemRenderer()
		{
			super();
			create_init()
		}

		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
		}
		
		public var comp:D3TreeNode;
		
		override public function poolChange(value:*):void
		{
			comp = value as D3TreeNode;
			if(comp.isBranch || comp.object.group == D3ComponentConst.comp_group5){
				addIcon()
			}
			
			super.poolChange(value);
			
			label = comp.name;
			
			textfield.selectable = false;
			textfield.width = 200;
			textfield.color = ColorUtils.black;
			textfield.bold = false;
			textfield.mouseChildren = false;
			textfield.mouseEnabled = false;
						
			if(comp.branch&&D3TreeNode(comp.branch).object!=null){
				if(D3TreeNode(comp.branch).object.group == D3ComponentConst.comp_group1){
					var meshPath:String = D3TreeNode(comp.branch).object.configData.getAttri("mainMesh");
					if(comp.path == meshPath){
						textfield.color = ColorUtils.blue;
						textfield.bold = true
					}
				}
				
				var b:* = comp.object.configData.getAttri("rendering");
				if(b!=null){
					if(b == false){
						textfield.color = ColorUtils.gray;
						textfield.bold = false
					}
				}
			}
						
			if(comp.isBranch || comp.object.group == D3ComponentConst.comp_group5){
				if(icon!=null){
					icon.visible = true;
					icon.includeInLayout = true;
				}
			}else{
				if(icon!=null){
					icon.visible = false;
					icon.includeInLayout = false;
				}
			}
		}
		
		override protected function setTextfieldColor(c:*):void{};
		
		override protected function getIconSource():String
		{
			if(comp.isBranch){
				if(comp.object == null){
					return "fold_a";
				}
				if(comp.object.group == D3ComponentConst.comp_group1){
					return "fold10_a"
				}
				if(comp.object.group == D3ComponentConst.comp_group5){
					return "fold_a"
				}
			}
			return "";
		}
		
		override protected function setRendererLabel():void
		{
			label = comp.name;
		}
		
		override protected function getIconWidth():int
		{
			return 20
		}
		
		override protected function getIconHeight():int
		{
			return 20
		}
		
		override protected function item_downHandle(e:MouseEvent):void
		{
			if(e.ctrlKey) return;
			super.item_downHandle(e);
		}
		
		override public function checkDrag():Boolean
		{
			return true;
		}
		
		override protected function createDragProxy():Bitmap
		{
			var b:Bitmap = screenshot();
			FilterTool.setGlow(b);
			return b;
		}
		
		override protected function createDragSource():SandyDragSource
		{
			var ds:SandyDragSource = new SandyDragSource();
			ds.data = comp;
			ds.type = DataManager.dragAndDrop_3d_outline;
			return ds;
		}
		
	}
}