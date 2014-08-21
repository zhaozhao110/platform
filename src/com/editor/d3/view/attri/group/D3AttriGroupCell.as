package com.editor.d3.view.attri.group
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIPopImage;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.view.attri.D3ComTypeManager;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.controls.ASHRule;
	import com.sandy.asComponent.controls.ASPopupImage;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	import com.sandy.gameTool.groupSelect.GroupSelectEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class D3AttriGroupCell extends UIVBox
	{
		public function D3AttriGroupCell()
		{
			super();
			percentWidth =100;
			verticalGap = 1;
		}
		
		public var target:ID3AttriGroup;
		private var titleTxt:UILabel;
		private var titleHB:UIHBox;
		private var setBtn:UIPopImage;
		private var hs:ASHRule;
		private var cont:UIVBox;
		private var expandBtn1:UIAssetsSymbol;
		private var expandBtn2:UIAssetsSymbol;
		public var group:D3GroupItemVO;
		
		public function createAttris(g:D3GroupItemVO):void
		{
			group = g;
			var a:Array;
			a = g.attri.split(",");
			var att_ls:Array = [];
			for(var i:int;i<a.length;i++){
				var attid:int = int(a[i]);
				if(attid > 0){
					var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemById(attid.toString());
					att_ls.push(d);
				}
			}
			att_ls.sortOn("key");
			
			if(att_ls.length == 0){
				visible = false;
				includeInLayout = false
				return ;
			}
			
			visible = true;
			includeInLayout = true;
			
			if(titleTxt == null){
				titleHB = new UIHBox();
				titleHB.verticalAlignMiddle = true;
				titleHB.percentWidth =100;
				titleHB.height = 22;
				addChild(titleHB);
				
				var expand_c:UICanvas = new UICanvas();
				expand_c.width = 15;
				expand_c.height = 15;
				titleHB.addChild(expand_c);
				
				expandBtn1 = new UIAssetsSymbol();
				expandBtn1.source = "menu11_a"
				expandBtn1.buttonMode = true;
				expandBtn1.addEventListener(MouseEvent.MOUSE_DOWN , onExpand1);
				expand_c.addChild(expandBtn1);
				
				expandBtn2 = new UIAssetsSymbol();
				expandBtn2.source = "menu12_a"
				expandBtn2.buttonMode = true;
				expandBtn2.addEventListener(MouseEvent.MOUSE_DOWN , onExpand2);
				expand_c.addChild(expandBtn2);
				
				titleTxt = new UILabel();
				titleTxt.width =  215;
				titleHB.addChild(titleTxt);
				
				setBtn = new UIPopImage();
				setBtn.width = 23;
				setBtn.height = 16;
				setBtn.source = "set1_a"
				setBtn.labelField = "label"
				setBtn.dropDownWidth = 110;
				titleHB.addChild(setBtn);
				setBtn.rowSelectChange_proxy = onSetChange;
			}
			titleTxt.text = " --- " + g.name + " --- ";
			titleTxt.bold = true;
			titleTxt.visible = true
			
			if(group.enAdd){
				a = [];
				a.push({label:"删除",data:"1"});
				a.push({label:"最大化",data:"2"});
				a.push({label:"最小化",data:"3"});
				setBtn.dataProvider = a;
				setBtn.visible = true;
			}else{
				setBtn.visible = false
			}
				
			expandBtn1.visible = true;
			expandBtn2.visible = false
			
			if(cont == null){
				cont = new UIVBox();
				cont.percentWidth = 100;
				addChild(cont);
			}
			
			for(i=0;i<att_ls.length;i++){
				_createItemRenderer(att_ls[i] as D3ComAttriItemVO)
			}
			
			if(hs == null){
				var sp:ASSpace = new ASSpace();
				sp.height = 2;
				sp.width = 100;
				addChild(sp);
				
				hs = new ASHRule();
				hs.height = 1;
				hs.width = 260
				addChild(hs);
				hs.color = ColorUtils.gray;
				
				sp = new ASSpace();
				sp.height = 2;
				sp.width = 100;
				addChild(sp);
			}
			
			if(cont.numChildren == 0){
				UIComponentUtil.removeMovieClipChild(null,this);
			}else{
				max();
			}
		}
		
		//创建每一行
		private function _createItemRenderer(d:D3ComAttriItemVO):void
		{
			if(d == null) return ;
			if(StringTWLUtil.isWhitespace(d.key)){
				SandyError.error("key is null at,"+d.id);
				return ;
			}
			if(target.curr_attri_map.exists(d.key))return ;
			var db:ID3ComBase = target.attri_ls[d.key] as ID3ComBase;
			if(db==null){
				db = D3ComTypeManager.getComByType(d.value);
				cont.addChild(db as DisplayObject);
				target.attri_ls[d.key] = db;
			}else{
				cont.addChild(db as DisplayObject);
			}
			db.target = this;
			db.item = d;
			db.group = group;
			db.reflashFun = target.comReflash;
			target.curr_attri_map.put(d.key,db);
		}
		
		private function onSetChange(e:ASEvent):void
		{
			if(e.addData.data == 1){
				var m:OpenMessageData = new OpenMessageData();
				if(group.id == 2){
					m.info = "确定要删除"+group.name+"? , 并且将会删除所有anims和bones";	
				}else{
					m.info = "确定要删除"+group.name+"?";
				}
				m.okFunction = confirm_del;
				iManager.iPopupwin.showConfirm(m);
			}else if(e.addData.data ==2 ){
				target.maxGroupCell(this);
			}else if(e.addData.data ==3 ){
				min();
			}
		}
		
		private function confirm_del():Boolean
		{
			deleteGroup();
			D3ProjectCache.dataChange = true;
			return true;
		}
		
		public function deleteGroup():void
		{
			if(group.id == 2){
				var d:D3GroupItemVO = D3ComponentProxy.getInstance().group_ls.getItem(7);
				if(d!=null && target.findGroupCell(d)!=null){
					target.findGroupCell(d).deleteGroup();
				}
				d = D3ComponentProxy.getInstance().group_ls.getItem(8);
				if(d!=null && target.findGroupCell(d)!=null){
					target.findGroupCell(d).deleteGroup();
				}
			}
			target.comp.proccess.deleteAttriGroup(group);
			target.removeGroup(this);
		}
		
		public function max():void
		{
			onExpand2()
		}
		
		public function min():void
		{
			onExpand1()
		}
		
		private function onExpand1(e:MouseEvent=null):void
		{
			cont.visible = false;
			cont.includeInLayout = false;
			expandBtn1.visible =false;
			expandBtn2.visible = true;
		}
		
		private function onExpand2(e:MouseEvent=null):void
		{
			cont.visible = true
			cont.includeInLayout = true
			expandBtn1.visible = true
			expandBtn2.visible = false
		}
	}
}