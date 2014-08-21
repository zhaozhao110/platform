package com.editor.d3.view.outline.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.getTimer;

	public class D3OutlinePopHBox extends UIHBox
	{
		public function D3OutlinePopHBox()
		{
			super();
			create_init();
		}
		
		public var firstCell:D3OutlinePopListCell;
		public var file_map:HashMap = new HashMap();
		
		private function create_init():void
		{
			name = "D3OutlinePopHBox"
			styleName = "uicanvas"
			paddingTop = 2;
			paddingLeft = 5;
			enabledPercentSize = true
			horizontalGap = 5;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			enabeldSelect = true;
			
			firstCell = new D3OutlinePopListCell();
			addChild(firstCell);
			firstCell.target = this;
		}
		
		public function setTopDataProvider(f:D3TreeNode):void
		{
			firstCell.setDataProvider(f);
		}
		
		public function getSelectedItem():D3TreeNode
		{
			return D3SceneManager.getInstance().displayList.selectedOutlineNode
		}
		
		public function getSelectedDirectory():D3TreeNode
		{
			var f:D3TreeNode = getSelectedItem();
			if(f.isBranch){
				return f;
			}
			return f.branch as D3TreeNode;
		}
		
		//刷新当前选中的cell
		public function reflashCurrentDirectory():void
		{
			D3OutlinePopListCell.selectedCell.reflashDataProvider();
		}
		
		public function hideAfterCurrDirectory():void
		{
			var n:int = this.getChildIndex(D3OutlinePopListCell.selectedCell);
			if((numChildren-1)>=(n+1)){
				var c:D3OutlinePopListCell = this.getChildAt(n+1) as D3OutlinePopListCell;
				if((numChildren-1)>=(n+1)){
					for(var i:int=(n+2);i<numChildren;i++){
						var cell:D3OutlinePopListCell = this.getChildAt(i) as D3OutlinePopListCell;
						cell.visible = false;
						cell.includeInLayout = false;
					}
				}
				callLater(hscrollToBottom);
			}
		}
		
		public function hideAllCells():void
		{
			for(var i:int=0;i<numChildren;i++){
				(this.getChildAt(i) as D3OutlinePopListCell).visible = false;
				(this.getChildAt(i) as D3OutlinePopListCell).includeInLayout = false;
			}
		}
		
		public function createCell(d:D3OutlinePopListCell):D3OutlinePopListCell
		{
			var n:int = this.getChildIndex(d);
			if((numChildren-1)>=(n+1)){
				
				var c:D3OutlinePopListCell = this.getChildAt(n+1) as D3OutlinePopListCell;
				
				var _afterHide_b:Boolean=false;
				if(!StringTWLUtil.isWhitespace(seachPath)){
					if(seachPath.indexOf(c.file.path)!=-1){
						_afterHide_b = false
					}else{
						_afterHide_b = true
					}
				}else{
					_afterHide_b = true;
				}
				
				if((numChildren-1)>=(n+1)&&_afterHide_b){
					for(var i:int=(n+2);i<numChildren;i++){
						var cell:D3OutlinePopListCell = this.getChildAt(i) as D3OutlinePopListCell;
						cell.visible = false;
						cell.includeInLayout = false;
					}
				}
				
				c.visible = true;
				c.includeInLayout = true;
				callLater(hscrollToBottom);
				return c;
			}
			
			c = new D3OutlinePopListCell();
			addChild(c);
			c.target = this;
			callLater(hscrollToBottom);
			return c;
		}
		
		public function afterHide(d:D3OutlinePopListCell):void
		{
			var n:int = this.getChildIndex(d);
			if((numChildren-1)>=(n+1)){
				for(var i:int=(n+1);i<numChildren;i++){
					var cell:D3OutlinePopListCell = this.getChildAt(i) as D3OutlinePopListCell;
					cell.visible = false;
					cell.includeInLayout = false;
				}
			}
			//horticalScrollPosition = -d.x;
		}
		
		public function getCellByIndex(ind:int):D3OutlinePopListCell
		{
			return getChildAt(ind) as D3OutlinePopListCell;
		}
		
		public function getLastCell():D3OutlinePopListCell
		{
			return getCellByIndex(numChildren-1);
		}
		
		public function getCellByFile(f:File):D3OutlinePopListCell
		{
			return file_map[f.nativePath] as D3OutlinePopListCell;
		}
		
		
		/////////////////////// 遍历选中  ////////////////////////////
		
		private var tmp_fold_a:Array;
		private var autoSel_index:int;
		private var auto_startTime:Number;
		private var cell_index:int;
		public static var seachPath:String;
		//assets\temp1\1\2
		public function setSelectedItem(f:String):void
		{
			seachPath = f;
			var p:String = f;
			var a:Array = p.split(".");
			if(a[0] == "all") a.shift()
			auto_startTime = getTimer();
			tmp_fold_a = a;
			cell_index = 0;
			autoSel_index = 0;
			autoSelectedFold();
		}
		
		private function autoSelectedFold():void
		{
			if(tmp_fold_a.length <= autoSel_index){
				seachPath = "";
				return ;
			}
			var n:String = tmp_fold_a[autoSel_index];
			if(StringTWLUtil.isWhitespace(n)){
				nextAutoSelectedFold(auto_startTime);
				return ;
			}
			if(getCellByIndex(cell_index)!=null&&getCellByIndex(cell_index).selectContTileByName(n)){
				cell_index += 1;
				nextAutoSelectedFold(auto_startTime);
			}else{
				seachPath = "";
			}
		}
		
		private function nextAutoSelectedFold(n:Number):void
		{
			if(auto_startTime != n){
				seachPath = "";
				return ;
			}
			autoSel_index += 1;
			autoSelectedFold();
		}
		
		
	}
}