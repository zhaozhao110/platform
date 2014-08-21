package com.editor.d3.view.attri.group
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.group.comp.D3AttriGroupAddAttri;
	import com.editor.d3.view.attri.group.comp.D3AttriGroupTitle;
	import com.editor.d3.view.attri.preview.D3CompPreviewBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.event.App3DEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.ASHRule;
	import com.sandy.asComponent.controls.ASPopupButton;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.math.HashMap;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class D3AttriGroupViewBase extends UIVBox implements ID3AttriGroup
	{
		public function D3AttriGroupViewBase()
		{
			super();
			name = "D3AttriGroupViewBase"
			enabledPercentSize = true
			padding = 2;
			paddingLeft = 5;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			styleName = "uicanvas";
		}
		
		private var _comp:D3ObjectBase;
		public function get comp():D3ObjectBase
		{
			return _comp;
		}
		public function set comp(value:D3ObjectBase):void
		{
			_comp = value;
		}
		
		//全部
		private var _attri_ls:Array = [];
		public function get attri_ls():Array
		{
			return _attri_ls;
		}
		public function set attri_ls(value:Array):void
		{
			_attri_ls = value;
		}

		//当前显示的
		private var _curr_attri_map:HashMap = new HashMap();
		public function get curr_attri_map():HashMap
		{
			return _curr_attri_map;
		}
		public function set curr_attri_map(value:HashMap):void
		{
			_curr_attri_map = value;
		}

		public var curr_group_map:HashMap = new HashMap();
		public var group_map:HashMap = new HashMap();
		
		private var attriTitle:D3AttriGroupTitle;
		private var addCompBtn:D3AttriGroupAddAttri;
		private var cont:UIVBox;
				
		public function changeComp(c:D3ObjectBase=null):void
		{
			comp = c;
			
			var a:Array = group_map.toArray();
			for(var i:int=0;i<a.length;i++){
				if(cont.contains(a[i] as DisplayObject)){
					cont.removeChild(a[i] as DisplayObject);
				}
			}
			curr_attri_map.clear();
			curr_group_map.clear();
			
			createView();
			
			D3CompPreviewBase.hideAll();
			if(c!=null && c.proccess){
				c.proccess.selected();
			}
			
			reflashAllAttri();
			
			if(addCompBtn){
				var _addCompVisible:Boolean=false;
				if(comp!=null){
					if(comp.group == D3ComponentConst.comp_group1 || 
						comp.group == D3ComponentConst.comp_group7 ||
						comp.group == D3ComponentConst.comp_group11 ||
						comp.group == D3ComponentConst.comp_group14){
						_addCompVisible = true;
					}
					if(comp.fromUI == D3ComponentConst.from_project){
						_addCompVisible = false;
					}
					if(comp.compItem&&comp.compItem.isSkyBox){
						_addCompVisible = false;
					}
				}
				
				addCompBtn.includeInLayout = _addCompVisible
				addCompBtn.visible = _addCompVisible;
				if(_addCompVisible){
					addCompBtn.reflashInfo();
				}
			}
			
			if(c!=null && c.proccess){
				c.proccess.initReflashFun();
			}
			visible = true;
		}
		
		public function reflashAttriNow(c:D3ObjectBase):void
		{
			if(comp.uid == c.uid) reflashAllAttri();
		}
		
		protected function createView():void
		{
			if(comp == null) return ;
			
			if(attriTitle == null){
				attriTitle = new D3AttriGroupTitle();
				attriTitle.target = this;
				addChild(attriTitle);
			}
			attriTitle.relfashMenu();
			
			if(addCompBtn == null){
				addCompBtn = new D3AttriGroupAddAttri();
				addCompBtn.target = this;
				addChild(addCompBtn);
			}
			
			var group_ls2:Array = [];
			var group_ls:Array = comp.getGroups();
			for(var i:int=0;i<group_ls.length;i++){
				var gid:int = int(group_ls[i]);
				var g:D3GroupItemVO = D3ComponentProxy.getInstance().group_ls.getItem(gid);
				if(g!=null&&group_ls2.indexOf(g)==-1) group_ls2.push(g);
			}
			group_ls2.sortOn(["enAdd","name"],[Array.NUMERIC,null]);
			
			_createCont()
			
			for(i=0;i<group_ls2.length;i++){
				_createGroupView(group_ls2[i] as D3GroupItemVO)
			}
		}
		
		private function _createCont():void
		{
			if(cont == null){
				cont = new UIVBox();
				cont.percentWidth = 100;
				cont.verticalGap = 1;
				cont.name = "D3AttriGroupViewBase_cont";
				addChild(cont);
			}
		}
		
		public function createGroupView(g:D3GroupItemVO):void
		{
			_createGroupView(g);
			reflashAllAttri();
			reflashGroupIndex();
		}
		
		private function reflashGroupIndex():void
		{
			var group_ls2:Array = [];
			var group_ls:Array = comp.getGroups();
			for(var i:int=0;i<group_ls.length;i++){
				var gid:int = int(group_ls[i]);
				var g:D3GroupItemVO = D3ComponentProxy.getInstance().group_ls.getItem(gid);
				if(g!=null&&group_ls2.indexOf(g)==-1) group_ls2.push(g);
			}
			group_ls2.sortOn(["enAdd","name"],[Array.NUMERIC,null]);
			
			var a:Array = group_map.toArray();
			for(i=0;i<a.length;i++){
				if(cont.contains(a[i] as DisplayObject)){
					cont.removeChild(a[i] as DisplayObject);
				}
			}
			for(i=0;i<group_ls2.length;i++){
				_createGroupView(group_ls2[i] as D3GroupItemVO,true);
			}
		}
		
		//创建组
		protected function _createGroupView(g:D3GroupItemVO,isSort:Boolean=false):void
		{
			_createCont()
			
			var gv:D3AttriGroupCell = group_map.find(g.id.toString());
			if(gv == null){
				gv = new D3AttriGroupCell();
				gv.target = this;
				group_map.put(g.id.toString(),gv);
			}
			if(!cont.contains(gv)) cont.addChild(gv);
			if(!isSort) gv.createAttris(g)
			curr_group_map.put(g.id.toString(),gv);
		}
		
		public function removeGroup(d:D3AttriGroupCell):void
		{
			curr_group_map.remove(d.group.id.toString());
			if(cont.contains(d)){
				cont.removeChild(d);
				callLater(function():void{invalidate_measured = true;})
			}
		}
		
		public function findGroupCell(d:D3GroupItemVO):D3AttriGroupCell
		{
			return curr_group_map.find(d.id.toString()) as D3AttriGroupCell;
		}
		
		protected function reflashAllAttri(c:D3ObjectBase=null):void
		{
			for(var key:String in curr_attri_map.getContent()){
				var d:ID3ComBase = curr_attri_map.find(key) as ID3ComBase;
				d.comp = c == null?comp:c;
				d.setValue();
			}
		}
		
		public function getComBaseBykey(k:String):ID3ComBase
		{
			return attri_ls[k] as ID3ComBase;
		}
		
		public function d3ObjectToReflashAttri(c:D3ObjectBase):void
		{
			if(comp == null) return ;
			if(comp.uid == c.uid){
				var abc:Array = D3ComponentConst.d3CompToReflashAttri_ls;
				var a:Array = [];
				for(var i:int=0;i<abc.length;i++){
					a.push(D3ComAttriItemVO(abc[i]).key);
				}
				for(var key:String in curr_attri_map.getContent()){
					var d:ID3ComBase = curr_attri_map.find(key) as ID3ComBase;
					if(a.indexOf(d.key)!=-1){
						d.setValue();
					}
				}
			}
		}
		
		public function maxGroupCell(g:D3AttriGroupCell):void
		{
			for(var i:int=0;i<cont.numChildren;i++){
				if(D3AttriGroupCell(cont.getChildAt(i)).uid != g.uid){
					D3AttriGroupCell(cont.getChildAt(i)).min();
				}
			}
		}
		
		public function comReflash(d:ID3ComBase):void
		{
			comp.proccess.comReflash(d);
		}
		
		////////////////////////////////////////////////////////////////
		
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
	}
}