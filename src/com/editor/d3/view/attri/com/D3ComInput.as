package com.editor.d3.view.attri.com
{
	import away3d.animators.data.JointPose;
	
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.object.D3ObjectLight;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.utils.NumberUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.system.System;

	public class D3ComInput extends D3ComBase
	{
		public function D3ComInput()
		{
			super();
		}
		
		private var input:UITextInput;
		
		override protected function create_init():void
		{
			super.create_init();
			dragAndDrop = true;
			
			input = new UITextInput();
			input.height = 20;
			input.doubleClickEnabled = true;
			input.addEventListener(ASEvent.DOUBLE_CLICK,onInputDouble);
			input.percentWidth = 100;
			input.enterKeyDown_proxy = enterKeyDown;
			addChild(input);
		}
		
		private function enterKeyDown():void
		{
			if(item.dataType == "uint"){
				if(input.text.indexOf("0x")==-1){
					iManager.iPopupwin.showError("数据类型是uint");
					return ;
				}
			}
			callUIRender();
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			var v:* = getCompValue();
			if(StringTWLUtil.isNumber(v)){
				input.text = NumberUtils.toFixed(v,5).toString();
			}else{
				input.text = v;
			}
			
			if(attriId == 45 && comp.compItem){
				input.text = comp.compItem.name;
			}
			
			if(item.getExpand3(0) == "1"){
				input.editable = false;
			}else{
				input.editable = true;
			}
			
			if(key == "width" || key == "height"){
				if(comp.group != D3ComponentConst.comp_group6){
					input.editable = true;
				}
			}
			
			if(attriId >= 22 && attriId <= 27){
				if(comp is D3ObjectLight){
					input.editable = false;
				}
			}
			
			if(comp.isMethod && key == "name"){
				input.editable =false;
			}
			
			if(comp.isGlobal && key == "name"){
				input.editable = false;
			}
			
			if(key == "path"){
				this.toolTip = input.text;
			}else{
				this.toolTip = "";
			}
		}
		
		override protected function resetCom():void
		{
			input.text = "";
		}
		
		override public function getValue():D3ComBaseVO
		{
			if(item.dataType == "number"){
				if(StringTWLUtil.isWhitespace(input.text)) return null;
			}
			var d:D3ComBaseVO = createComBaseVO();
			if(key == "name"){
				if(comp.checkIsInProject()){
					if(!StringTWLUtil.isWhitespace(comp.proccess.suffix)){
						if(input.text.indexOf(".")==-1){
							input.text = input.text + "." + comp.proccess.suffix;
						}
					}
				}
			}
			d.data = input.text;
			return d
		}
		
		private function onInputDouble(e:ASEvent):void
		{
			System.setClipboard(input.text);
		}
		
		override protected function onDragEnterHandle():Boolean
		{
			var ds:SandyDragSource = getDragSource() as SandyDragSource;
			if(ds == null) return false;
			if(attriId == 51){
				//mainMesh
				if(D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group7){
					return true;
				}	
			}else if(attriId == 52){
				//bindBone
				if(D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group7){
					return true;
				}
				if(D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group10){
					return true;
				}
			}else if(attriId == 53){
				//boneName
				if(ds.data is JointPose){
					return true;
				}
			}else if(attriId == 124){
				if(D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group14){
					return true;
				}
			}else if(attriId == 125){
				if(D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group1 ||
					D3TreeNode(ds.data).object.group == D3ComponentConst.comp_group7){
					return true;
				}
			}
			
			return false;
		}
		
		override protected function registerDrag_mouseDown():void{}
		
		override protected function onDragDropHandle(e:Event):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			
			var preText:String = input.text;
			
			if(attriId == 53){
				if(preText == JointPose(getDragSource().data).name) return ;
				input.text = JointPose(getDragSource().data).name;
				enterKeyDown();
				iManager.iDragAndDrop.endDrag(true);
				return ;
			}
			
			var d:D3TreeNode = getDragSource().data as D3TreeNode;
			if(preText == d.path) return ;
			input.text = d.path;
			enterKeyDown();
			iManager.iDragAndDrop.endDrag(true);
		}
		
		
	}
}