package com.editor.d3.view.attri.preview
{
	import away3d.animators.data.JointPose;
	
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.view.attri.preview.itemRenderer.MeshInfoListItemRenderer;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.system.System;

	public class MeshInfoPreview extends D3CompPreviewBase
	{
		public function MeshInfoPreview()
		{
			super();
			_create_init()
		}
		
		override protected function get compType():String
		{
			return "meshInfo preview"
		}
		
		override protected function uiShow():void
		{
			this.x = stage.stageWidth-300-this.width-20;
			this.y = get_App3DMainUIContainerMediator().rightContainer.y;
			
		}
		
		override protected function createSphere():void{}
		override protected function creatTitle():void{};
		
		private var jointPoseVBox:UIVlist;
		private var jointInfoTxt:UIText;
		
		private function _create_init():void
		{
			width = 260;
			height = 600;
			backgroundColor = DataManager.def_col;
			
			var v:UIVBox = new UIVBox();
			v.verticalGap = 5;
			v.enabledPercentSize = true;
			addChild(v);
			
			var lb:UIText = new UIText();
			v.addChild(lb);
			lb.width = 240;
			lb.height = 50;
			lb.htmlText = " --- " + "meshInfo" + " --- <br>需要3D物体加载动作后才能查看<br>双击复制骨骼名";
			lb.bold = true;
			
			jointInfoTxt = new UIText();
			jointInfoTxt.width =240;
			v.addChild(jointInfoTxt);
						
			jointPoseVBox = new UIVlist();
			jointPoseVBox.dragAndDrop = true;
			jointPoseVBox.percentWidth = 100;
			jointPoseVBox.styleName = "list"
			jointPoseVBox.percentHeight =100;
			jointPoseVBox.doubleClickEnabled = true;
			jointPoseVBox.itemRenderer = MeshInfoListItemRenderer
			jointPoseVBox.addEventListener(ASEvent.CHANGE,jointPoseChange);
			jointPoseVBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			v.addChild(jointPoseVBox);			
		}
		
		override public function setValue(d:D3ObjectBase):void
		{
			super.setValue(d);
			jointPoseVBox.labelField = "name";
			jointPoseVBox.dataProvider = null;
			var a:Array = [];
			if(comp.proccess == null) return ;
			if(comp.getD3ObjProccess().mapItem == null) return ;
			
			var p:D3ProccessObject = comp.getD3ObjProccess();
			jointInfoTxt.htmlText = "骨骼数:"+p.mapItem.getMeshInfo();
			
			var v:Vector.<JointPose> = p.mapItem.getJointPoses();
			if(v == null){
				jointPoseVBox.dataProvider = null;
				return ;
			}
			for(var i:int=0;i<v.length;i++){
				a.push(v[i]);
			}
			jointPoseVBox.dataProvider = a;
		}
		
		private function jointPoseChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,JointPose(jointPoseVBox.selectedItem).name);
			}
		}
		
		
		
	}
}