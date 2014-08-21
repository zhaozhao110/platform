package com.editor.d3.view.project.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.view.project.D3ProjectMenu;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	public class D3ProjectPopListCell extends UICanvas
	{
		public function D3ProjectPopListCell()
		{
			super();
			
			width = 160;
			height = 285;
			
			borderStyle = ASComponentConst.borderStyle_solid;
			borderThickness = 1;
			borderColor = ColorUtils.black;
			
			contTile = new UIVlist();
			contTile.itemRenderer = D3ProjectPopViewItemRenderer
			contTile.enabeldSelect = true;
			//contTile.doubleClickEnabled = true;
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
				preNode = this.parent.getChildAt(n-1) as D3ProjectPopListCell;
				preNode.nextNode = this;
			}
		}
		
		override protected function uiHide():void
		{
			super.uiHide();
			contTile.selectedIndex = -1;
		}
		
		public var target:D3ProjectPopHBox;
		public var contTile:UIVlist;
		public var preNode:D3ProjectPopListCell;
		public var nextNode:D3ProjectPopListCell;
		public var file:File;
		public static var selectedCell:D3ProjectPopListCell;
		
		public function setDataProvider(f:File):void
		{
			if(f == null) return ;
			file = f;
			target.file_map.put(f.nativePath,this);
			contTile.dataProvider = f.getDirectoryListing();
		}
		
		override public function reflashDataProvider():void
		{
			setDataProvider(file);
		}
		
		private function contTileRightDown(e:MouseEvent):void
		{
			contTile.setSelectIndex(-1,true,true);
			D3ProjectMenu.getInstance().openRightMenu(file,false);
		}
		
		private function contTileDown(e:MouseEvent):void
		{
			contTile.setSelectIndex(-1,true,true);
		}
		
		private function tileChange(e:ASEvent=null):void
		{
			get_D3ProjectPopViewMediator().infoTxt.text = "";
			
			if(contTile.selectedIndex == -1){
				D3SceneManager.getInstance().displayList.selectedFolder = file
				//target.afterHide(this);
				sendAppNotification(D3Event.select3DComp_event,null);
				dispatchSelect();
				selectedCell = this;
				get_D3ProjectPopViewMediator().infoTxt.text = "选中文件: " + D3ProjectFilesCache.getInstance().getProjectResPath(file);
				return;
			}
			
			if(e!=null){
				if(e.isDoubleClick)return ;
				if(e.isRightClick){
					D3ProjectMenu.getInstance().openRightMenu(e.addData as File,true);
					//return ;
				}
			}
			
			var f:File = contTile.selectedItem as File;
			
			if(f.isDirectory){
				var c:D3ProjectPopListCell = target.createCell(this);
				c.setDataProvider(f);
			}else{
				target.afterHide(this);
			}
			
			if(f.name == D3ComponentConst.sign_2){
				//sendAppNotification(App3DEvent.select3DComp_event,f);
				return;
			}
					
			selectedCell = this;
			D3SceneManager.getInstance().displayList.selectedFolder = f;
			get_D3ProjectPopViewMediator().infoTxt.text = "选中文件: " + D3ProjectFilesCache.getInstance().getProjectResPath(f);
			
			D3ProjectCache.dataChange = true;
			sendAppNotification(D3Event.select3DComp_event,D3SceneManager.getInstance().displayList.convertObject(f));
			D3ProjectCache.dataChange = false;
			AppMainModel.getInstance().applicationStorageFile.putKey_3dprojectFold(D3SceneManager.getInstance().displayList.selectedFolder.nativePath);
			
			dispatchSelect();
		}
		
		public function selectContTileByName(n:String):Boolean
		{
			visible = true;
			includeInLayout = true;
			var a:Array = contTile.dataProvider as Array;
			for(var i:int=0;i<a.length;i++){
				var f:File = a[i] as File;
				if(f.name == n){
					contTile.setSelectIndex(i,true,true);
					return true;
				}
			}
			return false;
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
		
		
	}
}