package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILinkButton;
	import com.editor.services.Services;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.SandySpace;
	
	import flash.events.MouseEvent;

	public class GdpsPageBar extends UIHBox
	{
		public function GdpsPageBar()
		{
			super();
			
			create_init();
		}
		
		public var cmb_Choose:UICombobox;
		private var btn_First:UIButton;
		private var btn_Pre:UIButton;
		private var btn_Next:UIButton;
		private var btn_Last:UIButton;
		private var link_paperInfo:UILinkButton;
		private var icon:UIImage;
		
		private function create_init():void
		{
		    height = 22;
			percentWidth = 100;
			horizontalAlign = "right";
			
			btn_First = new UIButton();
			btn_First.label = "☜";
			btn_First.toolTip = "第一页";
			btn_First.addEventListener(MouseEvent.CLICK , onBtnFirstClick);
			addChild(btn_First);
			
			btn_Pre = new UIButton();
			btn_Pre.label = "◁";
			btn_Pre.toolTip = "上一页";
			btn_Pre.addEventListener(MouseEvent.CLICK , onBtnPreClick);
			addChild(btn_Pre);
			
			cmb_Choose = new UICombobox();
			cmb_Choose.width = 100;
			cmb_Choose.height = 22;
			cmb_Choose.dropDownHeight = 200;
			cmb_Choose.addEventListener(ASEvent.CHANGE , onCurrentPageChange);
			addChild(cmb_Choose);
			
			btn_Next = new UIButton();
			btn_Next.label = "▷";
			btn_Next.toolTip = "下一页";
			btn_Next.addEventListener(MouseEvent.CLICK , onBtnNextClick);
			addChild(btn_Next);
			
			btn_Last = new UIButton();
			btn_Last.label = "☞";
			btn_Last.toolTip = "最后一页";
			btn_Last.addEventListener(MouseEvent.CLICK , onBtnLastClick);
			addChild(btn_Last);
			
			var hbox:UIHBox = new UIHBox();
			hbox.width = 150;
			hbox.horizontalAlign = "right";
			hbox.verticalAlign = "middle";
			hbox.paddingRight = 10;
			addChild(hbox);
			
			icon = new UIImage();
			icon.width = 16;
			icon.height = 16;
			icon.source = Services.assets_fold_url + "img/page_ok.png";
			hbox.addChild(icon);
			
			link_paperInfo = new UILinkButton();
			link_paperInfo.alpha = 0.5;
			link_paperInfo.visible = showPageInfo;
			link_paperInfo.includeInLayout = showPageInfo;
			link_paperInfo.color = paperInfoColor;
			hbox.addChild(link_paperInfo);
			
			initComplete();
		}
		
		private function onBtnFirstClick(e:MouseEvent):void
		{
			if(pageNo > 1){
				pageNo = 1;
				onPageNoChange();
			}
		}
		
		private function onBtnPreClick(e:MouseEvent):void
		{
			if(pageNo > 1){
				pageNo--;
				onPageNoChange();
			}
		}
		
		private function onBtnNextClick(e:MouseEvent):void
		{
			if(pageNo < totalPageNum){
				pageNo++;
				onPageNoChange();
			}
		}
		
		private function onBtnLastClick(e:MouseEvent):void
		{
			if(pageNo < totalPageNum){
				pageNo = totalPageNum;
				onPageNoChange();
			}
		}
		
		private function onCurrentPageChange(e:ASEvent):void{
			pageNo = cmb_Choose.selectedIndex + 1;
			onPageNoChange();
		}
		
		public var pageNo:int = 1;
		public var pageLimit:int = 20;
		public var totalCount:int = 0;
		public var pageData:int = 0;
		public var totalPageNum:int = 0;
		public var pageNoChangeFun:Function;

		private var isSelect:Boolean = false;
		private var _isOkIcon:Boolean = true;
		private var _paperInfoColor:uint = 0x666666;
		private var _showPageInfo:Boolean = true;
		
		
		private function onPageNoChange():void{
			if(!isSelect  ){
				pageNoChangeFun(pageNo,pageLimit);
			}
			isSelect = false;
		}
		
		public function setBtnStatus():void{
			
			totalPageNum = totalCount % pageLimit == 0 ? totalCount / pageLimit : (Math.floor(totalCount /pageLimit) + 1);
			
			btn_First.enabled = true;
			btn_Pre.enabled = true;
			btn_Next.enabled = true;
			btn_Last.enabled = true;
			cmb_Choose.enabled = true;
			
			if(pageData > 0){
				if(pageNo == 1){
					btn_First.enabled = false;
					btn_Pre.enabled = false;
				}
				if(pageNo == totalPageNum){
					btn_Next.enabled = false;
					btn_Last.enabled = false;
				}
				isSelect = true;
				
				var comData:Array = new Array();
				
				for(var i:int=1; i<=totalPageNum; i++){
					comData.push("〖第"+i+"页〗");
				}
				
				cmb_Choose.dataProvider= comData;
				
				cmb_Choose.selectedIndex= pageNo-1;
				
				link_paperInfo.label=pageData+"/"+totalCount;
				link_paperInfo.toolTip = "当前显示："+pageData+" 条数据<br>"+"总共："+totalCount+" 条数据<br>"+"总共："+totalPageNum+" 页"
				isOkIcon = true;
				paperInfoColor = 0x666666;
				isSelect = false;
			}else{
				btn_First.enabled = false;
				btn_Pre.enabled = false;
				btn_Next.enabled = false;
				btn_Last.enabled = false;
				cmb_Choose.enabled = false;
				cmb_Choose.dataProvider = [];
				link_paperInfo.label="没有数据!";
				link_paperInfo.toolTip = "当前没有任何数据！"
				isOkIcon = false;
				paperInfoColor = 0x990000;
				isSelect = false;
			}
		}
		
		public function get showPageInfo():Boolean
		{
			return _showPageInfo;
		}
		
		public function set showPageInfo(value:Boolean):void
		{
			_showPageInfo = value;
			
			link_paperInfo.visible = icon.visible = value;
		}
		
		public function get paperInfoColor():uint
		{
			return _paperInfoColor;
		}
		
		public function set paperInfoColor(value:uint):void
		{
			_paperInfoColor = value;
			link_paperInfo.color = _paperInfoColor;
		}
		
		public function get isOkIcon():Boolean
		{
			return _isOkIcon;
		}
		
		public function set isOkIcon(value:Boolean):void
		{
			_isOkIcon = value;
			
			if(value){
				icon.source = Services.assets_fold_url + "img/page_ok.png";
			}else{
				icon.source = Services.assets_fold_url + "img/page_error.png";
			}
		}
	}
}