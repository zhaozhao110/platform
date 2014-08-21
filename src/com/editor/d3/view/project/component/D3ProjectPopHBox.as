package com.editor.d3.view.project.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	public class D3ProjectPopHBox extends UIHBox
	{
		public function D3ProjectPopHBox()
		{
			super();
			create_init();
		}
		
		public var firstCell:D3ProjectPopListCell;
		public var file_map:HashMap = new HashMap();
		
		private function create_init():void
		{
			name = "D3ProjectPopHBox"
			styleName = "uicanvas"
			paddingTop = 2;
			paddingLeft = 5;
			enabledPercentSize = true
			horizontalGap = 5;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			enabeldSelect = true;
			
			firstCell = new D3ProjectPopListCell();
			addChild(firstCell);
			firstCell.target = this;
		}
		
		public function setTopDataProvider(f:File):void
		{
			firstCell.setDataProvider(f);
		}
		
		public function getSelectedItem():File
		{
			return D3SceneManager.getInstance().displayList.selectedFolder;
		}
		
		public function getSelectedDirectory():File
		{
			var f:File = getSelectedItem();
			if(f.isDirectory){
				return f;
			}
			return f.parent;
		}
		
		//刷新当前选中的cell
		public function reflashCurrentDirectory():void
		{
			D3ProjectPopListCell.selectedCell.reflashDataProvider();
		}
				
		public function createCell(d:D3ProjectPopListCell):D3ProjectPopListCell
		{
			var n:int = this.getChildIndex(d);
			if((numChildren-1)>=(n+1)){
				var c:D3ProjectPopListCell = this.getChildAt(n+1) as D3ProjectPopListCell;
				if((numChildren-1)>=(n+1)){
					for(var i:int=(n+2);i<numChildren;i++){
						var cell:D3ProjectPopListCell = this.getChildAt(i) as D3ProjectPopListCell;
						cell.visible = false;
						cell.includeInLayout = false;
					}
				}
				c.visible = true;
				c.includeInLayout = true;
				callLater(hscrollToBottom);
				return c;
			}
			
			c = new D3ProjectPopListCell();
			addChild(c);
			c.target = this;
			callLater(hscrollToBottom);
			return c;
		}
		
		public function hideAllCells():void
		{
			for(var i:int=0;i<numChildren;i++){
				(this.getChildAt(i) as D3ProjectPopListCell).visible = false;
				(this.getChildAt(i) as D3ProjectPopListCell).includeInLayout = false;
			}
		}
		
		public function afterHide(d:D3ProjectPopListCell):void
		{
			var n:int = this.getChildIndex(d);
			if((numChildren-1)>=(n+1)){
				for(var i:int=(n+1);i<numChildren;i++){
					var cell:D3ProjectPopListCell = this.getChildAt(i) as D3ProjectPopListCell;
					cell.visible = false;
					cell.includeInLayout = false;
				}
			}
			//horticalScrollPosition = -d.x;
		}
		
		public function getCellByIndex(ind:int):D3ProjectPopListCell
		{
			return getChildAt(ind) as D3ProjectPopListCell;
		}
		
		public function getLastCell():D3ProjectPopListCell
		{
			return getCellByIndex(numChildren-1);
		}
		
		public function getCellByFile(f:File):D3ProjectPopListCell
		{
			return file_map[f.nativePath] as D3ProjectPopListCell;
		}
		
		
		/////////////////////// 遍历选中  ////////////////////////////
		
		private var tmp_fold_a:Array;
		private var autoSel_index:int;
		private var auto_startTime:Number;
		private var cell_index:int;
		//assets\temp1\1\2
		public function setSelectedItem(f:File):void
		{
			for(var i:int=0;i<numChildren;i++){
				getCellByIndex(i).visible = false;
				getCellByIndex(i).includeInLayout = false;
			}
			
			var p:String = D3ProjectFilesCache.getInstance().getProjectResPath(f);
			var a:Array = p.split("\\");
			auto_startTime = getTimer();
			tmp_fold_a = a;
			cell_index = 0;
			autoSel_index = 0;
			autoSelectedFold();
		}
		
		private function autoSelectedFold():void
		{
			if(tmp_fold_a.length <= autoSel_index){
				return ;
			}
			var n:String = tmp_fold_a[autoSel_index];
			if(StringTWLUtil.isWhitespace(n)){
				nextAutoSelectedFold(auto_startTime);
				return ;
			}
			if(getCellByIndex(cell_index).selectContTileByName(n)){
				cell_index += 1;
				nextAutoSelectedFold(auto_startTime);
			}
		}
		
		private function nextAutoSelectedFold(n:Number):void
		{
			if(auto_startTime != n) return ;
			autoSel_index += 1;
			autoSelectedFold();
		}
		
		
	}
}