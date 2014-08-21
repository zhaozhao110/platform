package com.editor.d3.view.attri.group
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.view.attri.cell.D3ComKeybroad;
	import com.editor.d3.view.attri.group.comp.D3AttriGroup;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	//系统
	public class D3AttriGroup2View extends D3AttriGroupViewBase
	{
		public function D3AttriGroup2View()
		{
			super();
			instance = this;
			
		}
		
		public static var instance:D3AttriGroup2View;
				
		override protected function createView():void
		{
			if(showAllHBox!=null){
				createSystemAttris()
				return ;
			}
			
			///////////////////////////////////////
			showAllHBox = createHBox();
			addChild(showAllHBox);
			
			createLeftTxt("所有物体",showAllHBox);
			
			showAllBtn = new UIButton();
			showAllBtn.label = "显示/隐藏"
			showAllBtn.addEventListener(MouseEvent.CLICK , onShowAll);
			showAllHBox.addChild(showAllBtn);
			
			///////////////////////////////////////
			tridentHBox = createHBox();
			addChild(tridentHBox);
			
			createLeftTxt("坐标系",tridentHBox);
			
			tridentBtn = new UIButton();
			tridentBtn.label = "显示/隐藏"
			tridentBtn.toolTip = "(K)"
			tridentBtn.addEventListener(MouseEvent.CLICK , onTrident);
			tridentHBox.addChild(tridentBtn);
			
			///////////////////////////////////////
			gridHBox = createHBox();
			addChild(gridHBox);
			
			createLeftTxt("网格",gridHBox);
			
			girdBtn = new UIButton();
			girdBtn.label = "显示/隐藏"
			girdBtn.toolTip = "(L)"
			girdBtn.addEventListener(MouseEvent.CLICK , onGrid);
			gridHBox.addChild(girdBtn);
			
			var b:* = iManager.iSharedObject.find("","3d_trident");
			if(b!=null)D3SceneManager.getInstance().currScene.setTridentVisible(b)
			b = iManager.iSharedObject.find("","3d_grid");
			if(b!=null)D3SceneManager.getInstance().currScene.setGridVisible(b)
				
			var k:D3ComKeybroad = new D3ComKeybroad();
			addChild(k);
			
			var sp:ASSpace = new ASSpace();
			sp.height = 5;
			sp.width = 10;
			addChild(sp);
			
			createSystemAttris();
		}
		
		private var systemGroup:D3AttriGroup
		private function createSystemAttris():void
		{
			if(systemGroup != null){
				systemGroup.reflashAllAttri();
				return ;
			}
			var g:D3GroupItemVO = D3ComponentProxy.getInstance().group_ls.getItem(48);
			systemGroup = new D3AttriGroup();
			systemGroup.comp = D3SceneManager.getInstance().displayList.globalNode.object;
			addChild(systemGroup);
			systemGroup.createGroupView(g);
			systemGroup.reflashAllAttri();
		}
		
		private function createHBox():UIHBox
		{
			var h:UIHBox = new UIHBox();
			h.width = 260;
			h.height = 25;
			h.verticalAlign = ASComponentConst.verticalAlign_middle;
			h.horizontalGap = 2;
			return h
		}
				
		protected function createLeftTxt(n:String,h:UIHBox):void
		{
			var leftTxt:UILabel = new UILabel();
			leftTxt.width = 100;
			leftTxt.backgroundColor = ColorUtils.white;
			h.addChild(leftTxt);
			leftTxt.text = n;
		}
		
		
		////////////////////// show all ///////////////////////////
		
		private var showAllHBox:UIHBox;
		private var showAllBtn:UIButton;
		
		private function onShowAll(e:MouseEvent):void
		{
			if(showAllBtn.data == null){
				showAllBtn.data = false
			}else{
				showAllBtn.data = !showAllBtn.data;
			}
			//D3SceneManager.getInstance().currScene.setVisibleAllObject(showAllBtn.data);
		}
		
		//////////////////// show trident //////////////////////////
		private var tridentHBox:UIHBox;
		private var tridentBtn:UIButton;
		
		public function onTrident(e:*=null):void
		{
			iManager.iSharedObject.put("","3d_trident",D3SceneManager.getInstance().currScene.setTridentVisible())
		}
		
		///////////////////////////////////////
		private var gridHBox:UIHBox;
		private var girdBtn:UIButton;
		
		public function onGrid(e:*=null):void
		{
			iManager.iSharedObject.put("","3d_grid",D3SceneManager.getInstance().currScene.setGridVisible());
		}
		
	}
}