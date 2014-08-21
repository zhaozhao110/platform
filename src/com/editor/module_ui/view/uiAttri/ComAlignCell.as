package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.view.uiAttri.com.ComBoolean;
	import com.editor.module_ui.view.uiAttri.com.ComButton;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.itemRenderer.MultCompItemRenderer;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.NumberUtils;
	
	import flash.display.DisplayObject;

	public class ComAlignCell extends UIVBox
	{
		public function ComAlignCell()
		{
			super();
			
			if(instance == null){
				instance = this;
			}
			
			var ds:ComBoolean = new ComBoolean();
			ds.reflashFun = openAlign;
			d = new ComAttriItemVO();
			d.key = "打开/关闭对齐功能";
			ds.item = d;
			addChild(ds as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "openAlign";
			dd.value = false
			ds.setValue(dd);
			
			var btn:ComButton = new ComButton();
			btn.reflashFun = topAlign;
			var d:ComAttriItemVO = new ComAttriItemVO();
			d.key = "顶对齐";
			btn.item = d;
			addChild(btn as DisplayObject);
			var dd:ComBaseVO = new ComBaseVO();
			dd.key = "topAlign";
			dd.value = "顶对齐"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = bottomAlign;
			d = new ComAttriItemVO();
			d.key = "底对齐";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "bottomAlign";
			dd.value = "底对齐"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = leftAlign;
			d = new ComAttriItemVO();
			d.key = "左对齐";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "leftAlign";
			dd.value = "左对齐"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = rightAlign;
			d = new ComAttriItemVO();
			d.key = "右对齐";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "rightAlign";
			dd.value = "右对齐"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = horGapAlign;
			d = new ComAttriItemVO();
			d.key = "水平平均间隔";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "horGapAlign";
			dd.value = "水平平均间隔"
			btn.setValue(dd);
			
			btn = new ComButton();
			btn.reflashFun = verGapAlign;
			d = new ComAttriItemVO();
			d.key = "垂直平均间隔";
			btn.item = d;
			addChild(btn as DisplayObject);
			dd = new ComBaseVO();
			dd.key = "verGapAlign";
			dd.value = "垂直平均间隔"
			btn.setValue(dd);
			
			var vb3:UILabel = new UILabel();
			vb3.text = "组件列表,只有设置了大小的组件才会被选中" 
			addChild(vb3);
			
			multComp_vb = new UIVBox();
			multComp_vb.labelField = "sign";
			multComp_vb.styleName = "list";
			multComp_vb.width = 260;
			multComp_vb.height = 150;
			multComp_vb.itemRenderer = MultCompItemRenderer;
			multComp_vb.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(multComp_vb);
			
		}
		
		public static var instance:ComAlignCell;
		public var multComp_vb:UIVBox;
		public var cell:ComAttriCell;
		
		private function horGapAlign(d:IComBase=null):void
		{
			if(selectedComps.length < 3) return;
			var a:Array = selectedComps;
			a = a.sortOn("x",Array.NUMERIC);
			var y1:int = UIShowCompProxy(a[0]).x+UIShowCompProxy(a[0]).target.width;
			var y2:int = UIShowCompProxy(a[a.length-1]).x
			
			var n3:int;
			for(var i:int=1;i<a.length-1;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				n3 += p.target.width;
			}
			
			var n2:int = (NumberUtils.getPositiveNumber(y1-y2)-n3)/(a.length-1);
			var n4:int=y1+n2;
			for(i=1;i<a.length-1;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("x",n4);
				n4 += p.target.width+n2;
			}
		}

		private function verGapAlign(d:IComBase=null):void
		{
			if(selectedComps.length < 3) return;
			var a:Array = selectedComps;
			a = a.sortOn("y",Array.NUMERIC);
			var y1:int = UIShowCompProxy(a[0]).y+UIShowCompProxy(a[0]).target.height;
			var y2:int = UIShowCompProxy(a[a.length-1]).y
			
			var n3:int;
			for(var i:int=1;i<a.length-1;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				n3 += p.target.height;
			}
			
			var n2:int = (NumberUtils.getPositiveNumber(y1-y2)-n3)/(a.length-1);
			var n4:int=y1+n2;
			for(i=1;i<a.length-1;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("y",n4);
				n4 += p.target.height+n2;
			}
		}
				
		private function topAlign(d:IComBase=null):void
		{
			if(selectedComps.length == 0) return;
			var a:Array = selectedComps;
			a = a.sortOn("y",Array.NUMERIC);
			var n:int;
			for(var i:int=0;i<a.length;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				if(i == 0){
					n = p.target.y;
				}
				if(n>p.target.y){
					n = p.target.y;
				}
			}
			for(i=0;i<a.length;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("y",n);
			}
		}
		
		private function bottomAlign(d:IComBase=null):void
		{
			if(selectedComps.length == 0) return;
			var a:Array = selectedComps;
			a = a.sortOn("y",Array.NUMERIC);
			var n:int;
			for(var i:int=0;i<a.length;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				if(i == 0){
					n = p.target.y;
				}
				if(n<(p.target.y+p.target.height)){
					n = p.target.y;
				}
			}
			for(i=0;i<a.length;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("y",n);
			}
		}
		
		private function leftAlign(d:IComBase=null):void
		{
			if(selectedComps.length == 0) return;
			var a:Array = selectedComps;
			a = a.sortOn("x",Array.NUMERIC);
			var n:int;
			for(var i:int=0;i<a.length;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				if(i == 0){
					n = p.target.x;
				}
				if(n>p.target.x){
					n = p.target.x;
				}
			}
			for(i=0;i<a.length;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("x",n);
			}
		}
		
		private function rightAlign(d:IComBase=null):void
		{
			if(selectedComps.length == 0) return;
			var a:Array = selectedComps;
			a = a.sortOn("x",Array.NUMERIC);
			var n:int;
			for(var i:int=0;i<a.length;i++){
				var p:UIShowCompProxy = a[i] as UIShowCompProxy;
				if(i == 0){
					n = p.target.x;
				}
				if(n<(p.target.x+p.target.width)){
					n = p.target.x;
				}
			}
			for(i=0;i<a.length;i++){
				p = a[i] as UIShowCompProxy;
				p.reflashAttri("x",n);
			}
		}
		
		private function openAlign(d:IComBase=null):void
		{
			var dv:IComBaseVO = d.getValue();
			if(dv.value == "true"){
				showSelectComp(true);
			}else{
				showSelectComp(false);
			}
		}
		
		public var actionIsOpen:Boolean;
		public function showSelectComp(v:Boolean,needShow:Boolean=true):void
		{
			if(v){
				if(actionIsOpen) return ;
				actionIsOpen = true
				if(needShow){
					UIEditManager.currEditShowContainer.selectRect_sp.visible = true;
				}
				
				var a:Array = UIEditManager.currEditShowContainer.cache.getAllComp();
				for each(var t:UITreeNode in a){
					if(t!=null){
						if(t.obj is UIShowCompProxy){
							if(UIShowCompProxy(t.obj).target!=null){
								if(selectedComps.indexOf(UIShowCompProxy(t.obj))==-1){
									UIShowCompProxy(t.obj).target.showBorderInUIEdit();
								}
							}
						}
					}
				}
				
			}else{
				if(!actionIsOpen) return ;
				actionIsOpen = false
				selectedComps.length = 0;
				multComp_vb.dataProvider = null;
				UIEditManager.currEditShowContainer.selectRect_sp.visible = false;
				UIEditManager.currEditShowContainer.cache.allCompShowWhileBorder();
			}
		}
		
		private var selectedComps:Array = [];
		public function setSelectComp(a:Array):void
		{
			selectedComps = a;
			multComp_vb.dataProvider = a;
		}
		
		public function delSelectComp(u:UIShowCompProxy):void
		{
			if(u == null) return ;
			var n:int = selectedComps.indexOf(u);
			if(n>=0){
				u.target.showBorderInUIEdit();
				selectedComps.splice(n,1);
			}
			multComp_vb.dataProvider = selectedComps;
		}
		
		public function addSelectComp(u:UIShowCompProxy):void
		{
			var n:int = selectedComps.indexOf(u);
			if(n==-1){
				selectedComps.push(u);
			}
			multComp_vb.dataProvider = selectedComps;
		}
		
	}
}