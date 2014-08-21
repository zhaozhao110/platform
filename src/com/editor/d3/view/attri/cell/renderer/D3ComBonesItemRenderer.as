package com.editor.d3.view.attri.cell.renderer
{
	import away3d.animators.data.JointPose;
	
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.view.attri.cell.D3ComBones;
	import com.editor.event.App3DEvent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.component.controls.text.SandyAutoCompleteComboBox;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class D3ComBonesItemRenderer extends ASHListItemRenderer
	{
		public function D3ComBonesItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var ti:UILabel;
		private var editBtn:UIAssetsSymbol;
		public var cell:D3ComBones;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			ti = new UILabel();
			ti.width = 200;
			addChild(ti);
			
			editBtn = new UIAssetsSymbol();
			editBtn.source = "edit2_a"
			editBtn.width = 16;
			editBtn.height = 16;
			editBtn.toolTip = "编辑"
			editBtn.buttonMode = true;
			editBtn.addEventListener(MouseEvent.CLICK , onEditHandle);
			addChild(editBtn);
		}
		
		public var comp:D3ObjectBind;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			comp = value as D3ObjectBind;
			comp.itemRenderer = this;
			ti.text = comp.name;
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
			ti.text = "";
		}
		
		private function onEditHandle(e:MouseEvent):void
		{
			iManager.sendAppNotification(D3Event.select3DComp_event,comp);
		}
		
	}
}