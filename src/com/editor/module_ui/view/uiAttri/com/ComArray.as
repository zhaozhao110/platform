package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.com.itemRenderer.ComArrayItemRenderer;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ArrayUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ComArray extends ComBase
	{ 
		public function ComArray()
		{
			super();
		}
		
		private var box:UIVBox;
		private var hb1:UIHBox;
		private var hb2:UIHBox;
		private var addBtn:UIAssetsSymbol;
		
		override protected function create_init():void
		{
			width = 260;
			height = 120;
			
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb)
			
			hb1 = new UIHBox();
			hb1.height = 25;
			hb1.percentWidth = 100;
			vb.addChild(hb1);
			
			createLeftTxt(hb1);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建tab"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			hb1.addChild(addBtn);
			
			box = new UIVBox();
			box.styleName = "list"
			box.percentWidth = 100;
			box.height = 90;
			box.itemRenderer = ComArrayItemRenderer;
			box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			box.addEventListener(ASEvent.CHILDADD,onChildAdd)
			vb.addChild(box);
		}
		
		private function onChildAdd(e:ASEvent):void
		{
			var ds:ComArrayItemRenderer = e.data as ComArrayItemRenderer;
			ds.cell = this;
		}
		
		private var temp_ls:Array = [];
		
		public function add(obj:*,ind:int):void
		{
			temp_ls[ind] = obj;
			box.dataProvider = temp_ls;
			//var a:Array = UIEditManager.currEditShowContainer.selectedUI.target.alternatingHGap;
			callUIRender();
			//var b:Array = UIEditManager.currEditShowContainer.selectedUI.target.alternatingHGap;
		}
		
		private function onAdd(e:MouseEvent):void
		{
			temp_ls.push("");
			box.dataProvider = temp_ls;
		}
		
		public function del(ind:int):void
		{
			temp_ls.splice(ind,1);
			box.dataProvider = temp_ls;
			callUIRender();
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			
			if(String(key).toLocaleLowerCase().indexOf("filter")!=-1){
				addBtn.toolTip = "新建filter"
			}else{
				addBtn.toolTip = "新建tab"
			}
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			d.value = ArrayUtils.cloneArray(temp_ls);
			return d;
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			if(!StringTWLUtil.isWhitespace(obj.value)){
				temp_ls = obj.value;
			}else{
				temp_ls = null;
				temp_ls = [];
			}
			box.dataProvider = temp_ls;
			
			
		}
		
	}
}