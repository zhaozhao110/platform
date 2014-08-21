package com.editor.d3.view.outline.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.view.outline.D3OutlineMenu;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;

	public class D3OutlinePopListCell extends UICanvas
	{
		public function D3OutlinePopListCell()
		{
			super();
			
			width = 160;
			height = 285;
			
			borderStyle = ASComponentConst.borderStyle_solid;
			borderThickness = 1;
			borderColor = ColorUtils.black;
			
			contTile = new UIVlist();
			contTile.itemRenderer = D3OutlinePopViewItemRenderer
			contTile.enabeldSelect = true;
			contTile.dragAndDrop = true;
			contTile.rightClickEnabled = true;
			contTile.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,contTileRightDown);
			contTile.addEventListener(MouseEvent.MOUSE_DOWN,contTileDown);
			contTile.styleName = "list2"
			contTile.width = 158;
			contTile.height = 285;
			contTile.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(contTile);
			contTile.rowSelectChange_proxy = tileChange;
			
			addEventListener(Event.ADDED_TO_STAGE , _toAddHandle)
		}
		
		override public function select():void
		{
			super.select();
			backgroundFilter = [getDropShadowFilter()];
			borderColor = ColorUtils.red;
			borderThickness = 2;
		}
		
		private function getDropShadowFilter():BitmapFilter{
			var color:Number = 0xcc0000;
			var angle:Number = 45;
			var alpha:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.MEDIUM;
			return new DropShadowFilter(2,angle,color,alpha,2,2,1,quality,inner,knockout);
		}
		
		override public function noSelect():void
		{
			super.noSelect();
			backgroundFilter = null;
			borderColor = ColorUtils.black;
			borderThickness = 1;
		}
		
		private function _toAddHandle(e:Event):void
		{
			var n:int = this.parent.getChildIndex(this);
			if(n>0){
				preNode = this.parent.getChildAt(n-1) as D3OutlinePopListCell;
				preNode.nextNode = this;
			}
		}
		
		override protected function uiHide():void
		{
			super.uiHide();
			contTile.selectedIndex = -1;
		}
		
		public var target:D3OutlinePopHBox;
		public var contTile:UIVlist;
		public var preNode:D3OutlinePopListCell;
		public var nextNode:D3OutlinePopListCell;
		public var file:D3TreeNode;
		public static var selectedCell:D3OutlinePopListCell;
		
		public function setDataProvider(f:D3TreeNode):void
		{
			file = f;
			target.file_map.put(f.path,this);
			contTile.dataProvider = f.getList();
		}
		
		override public function reflashDataProvider():void
		{
			setDataProvider(file);
		}
		
		private function contTileRightDown(e:MouseEvent):void
		{
			contTile.setSelectIndex(-1,true,true);
			D3OutlineMenu.getInstance().openRightMenu(file,false);
		}
		
		private function contTileDown(e:MouseEvent):void
		{
			contTile.setSelectIndex(-1,true,true);
		}
		
		private function tileChange(e:ASEvent=null):void
		{
			get_D3OutlinePopViewMediator().infoTxt.text = "";
			
			if(contTile.selectedIndex == -1){
				D3SceneManager.getInstance().displayList.selectedOutlineNode = file
				//target.afterHide(this);
				sendAppNotification(D3Event.select3DComp_event,null);
				dispatchSelect();
				selectedCell = this;
				get_D3OutlinePopViewMediator().infoTxt.text = "选中节点: " + file.path
				return;
			}
			
			if(e!=null){
				if(e.isDoubleClick)return ;
				if(e.isRightClick){
					D3OutlineMenu.getInstance().openRightMenu(e.addData as D3TreeNode,true);
					//return ;
				}
			}
			
			var f:D3TreeNode = contTile.selectedItem as D3TreeNode;
			
			if(f.isBranch){
				var c:D3OutlinePopListCell = target.createCell(this);
				c.setDataProvider(f);
			}else{
				target.afterHide(this);
			}
						
			selectedCell = this;
			D3SceneManager.getInstance().displayList.selectedOutlineNode = f;
			get_D3OutlinePopViewMediator().infoTxt.text = "选中节点: " + f.path
			
			if(!StringTWLUtil.isWhitespace(D3OutlinePopHBox.seachPath)){
				if(f.object.node.path == D3OutlinePopHBox.seachPath){
					D3ProjectCache.dataChange = true;
					sendAppNotification(D3Event.select3DComp_event,f.object);
					D3ProjectCache.dataChange = false;		
				}
			}else{
				D3ProjectCache.dataChange = true;
				sendAppNotification(D3Event.select3DComp_event,f.object);
				D3ProjectCache.dataChange = false;
			}
			
			AppMainModel.getInstance().applicationStorageFile.putKey_3dOutlineUID(D3SceneManager.getInstance().displayList.selectedOutlineNode.path);
			
			dispatchSelect();
		}
		
		public function selectContTileByName(n:String):Boolean
		{
			visible = true;
			includeInLayout = true;
			var a:Array = contTile.dataProvider as Array;
			for(var i:int=0;i<a.length;i++){
				var f:D3TreeNode = a[i] as D3TreeNode;
				if(f.name == n){
					contTile.setSelectIndex(i,true,true);
					return true;
				}
			}
			return false;
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
		
		
	}
}