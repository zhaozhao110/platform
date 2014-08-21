package com.editor.d3.pop.curveEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.manager.DataManager;
	import com.sandy.math.ArrayCollection;
	import com.sandy.math.QueueNode;
	import com.sandy.utils.FilterTool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CurveEditor extends UICanvas
	{
		public function CurveEditor()
		{
			super();
			if(instance == null){
				instance = this;
			}
			create_init();
			
		}
		
		public static var instance:CurveEditor;
		private var leftVBox:UIVBox;
		private var botHBox:UIHBox;
		private var closeBtn:UIButton;
		private var saveBtn:UIButton;
		
		private function create_init():void
		{
			width = 900;
			height = 700;
			backgroundColor = DataManager.def_col;
			styleName = "uicanvas"
			this.filters = [FilterTool.getDropShadowFilter()]
			
			var h:UIHBox = new UIHBox();
			h.height = 40;
			h.percentWidth = 100;
			h.styleName = "uicanvas"
			h.paddingLeft = 10;
			h.horizontalGap = 30
			h.verticalAlignMiddle = true;
			h.mouseEnabled = true;
			h.addEventListener(MouseEvent.MOUSE_UP , onTileUp);
			h.addEventListener(MouseEvent.MOUSE_DOWN , onTileDown);
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "Curve Editor"
			lb.bold = true;
			lb.fontSize = 16;
			h.addChild(lb);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存"
			saveBtn.addEventListener(MouseEvent.CLICK , onSave);
			h.addChild(saveBtn);
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭"
			closeBtn.addEventListener(MouseEvent.CLICK , onClose);
			h.addChild(closeBtn);
			
			lb = new UILabel();
			lb.width = 380;
			lb.text = "右键添加关节点，右键删除关节点 , 滚轮变化左边的数值"
			h.addChild(lb);
			
			locLB = new UILabel();
			h.addChild(locLB);
			
			leftVBox = new UIVBox();
			leftVBox.width = 35;
			leftVBox.verticalGap = 45;
			addChild(leftVBox);
			leftVBox.x = 15;
			leftVBox.y = 53
			
			botHBox = new UIHBox();
			botHBox.y = 660;
			botHBox.horizontalGap = 50;
			addChild(botHBox);
			botHBox.x = 30;
			
			createLeftLabel()
			createBottomLabel();
			createGrid()
			createDraw()
			
			mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_WHEEL , onWheel);
			
			drawCont.createMousePoint();
			addListener()
		}
		
		public var locLB:UILabel;
		
		private function _createDefaultPoints():void
		{
			var d:CurveEditorPointData = new CurveEditorPointData();
			d.xn = 0;
			d.yn = 0;
			CurveEditorData.addPoint(d);
			
			d = new CurveEditorPointData();
			d.xn = 1;
			d.yn = 1;
			CurveEditorData.addPoint(d);
			
			reflashLine()
		}
		
		private function onTileUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		private function onTileDown(e:MouseEvent):void
		{
			this.startDrag();	
		}
		
		private function onClose(e:MouseEvent):void
		{
			get_App3DMainUIContainerMediator().hideCurveEditor();
		}
		
		public static const gridWidth:int = 800;
		public static const gridHeight:int = 600
		public static const tileWidth:int = 80;
		public static const tileHeight:int = 60;
		public static const stepSize_ls:Array = [1,2,5,10,20,50,100,200,500,1000,2000,5000];
		private var stepSize_i:int = -1;
		
		public static function getYN(_y:Number):Number
		{
			if(_y < gridHeight/2){
				return (gridHeight/2 - _y)/(gridHeight/2)*CurveEditor.instance.maximum
			}else if(_y > gridHeight/2){
				return -(_y-gridHeight/2)/(gridHeight/2)*CurveEditor.instance.maximum
			}
			return 0
		}
		
		private var _maximum:int=1;
		public function get maximum():int
		{
			return _maximum;
		}
		public function set maximum(value:int):void
		{
			_maximum = value;
		}
		
		private var _minimum:int=0;
		public function get minimum():int
		{
			return _minimum;
		}
		public function set minimum(value:int):void
		{
			_minimum = value;
		}
		
		private function createLeftLabel():void
		{
			var st:Number = maximum/5;
			for(var i:int=0;i<11;i++){
				var lb:CurveEditorLabel = new CurveEditorLabel();
				var n:Number = st*100*i/100;
				lb.text = String( (maximum*100-n*100)/100 );
				leftVBox.addChild(lb);
			}
		}
		
		private function reflashLeftNum():void
		{
			reflashLeftNum2()
			drawCont.reflashPoint();
			grid.reflashLine();
		}
		
		private function reflashLeftNum2():void
		{
			var st:Number = maximum/5;
			for(var i:int=0;i<11;i++){
				var lb:CurveEditorLabel = leftVBox.getChildAt(i) as CurveEditorLabel;
				var n:Number = st*100*i/100;
				lb.text = String( (maximum*100-n*100)/100 );
			}
		}
		
		private function createBottomLabel():void
		{
			var st:Number = 1/10;
			for(var i:int=10;i>=0;i--){
				var lb:CurveEditorLabel = new CurveEditorLabel();
				var n:Number = st*100*i/100;
				lb.text = String( (maximum*100-n*100)/100 );
				botHBox.addChild(lb);
			}
		}
		
		public var grid:CurveEditorGrid;
		private function createGrid():void
		{
			if(grid == null){
				grid = new CurveEditorGrid();
				addChild(grid);
			}
			grid.x = 50;
			grid.y = 60;
		}
		
		public var drawCont:CurveEditorDrawCont;
		private function createDraw():void
		{
			if(drawCont == null){
				drawCont = new CurveEditorDrawCont();
				addChild(drawCont);
			}
			drawCont.x = grid.x;
			drawCont.y = grid.y;
		}
		
		private function onWheel(e:MouseEvent):void
		{
			if(e.delta > 0){
				if(stepSize_i >= stepSize_ls.length-1) return ;
				stepSize_i += 1
				maximum = stepSize_ls[stepSize_i]
				reflashLeftNum()
			}else{
				if(stepSize_i <= 0) return ;
				if(!drawCont.testPoint(stepSize_ls[stepSize_i-1])) return ;
				stepSize_i -= 1;
				maximum = stepSize_ls[stepSize_i]
				reflashLeftNum()
			}
		}
				
		public function reflashLine():void
		{
			drawCont.reflashLine();
			grid.reflashLine();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "OneDCurveValueSubParser"
			obj.data = {};
			obj.data.anchorDatas = {};
			
			var b:Array = [];
			var a:ArrayCollection = CurveEditorData.queue.getList()
			var n:int = a.length;
			for(var i:int=0;i<n;i++){
				var qn:QueueNode = a.getItemAt(i) as QueueNode;
				var ob:Object = CurveEditorPointData(qn.data).getObject()
				b.push(ob);
			}
			b = b.sortOn("y",Array.NUMERIC);
			obj.info = "min:"+Object(b[0]).y + ",max:" + Object(b[b.length-1]).y;
			obj.data.anchorDatas = b;
			
			return obj;
		}
		
		public var save_f:Function;
		
		public function changeAnim(obj:Object):void
		{
			maximum = 1;
			if(obj == null){
				_createDefaultPoints();
				return ;
			}
			var a:Array = obj.data.anchorDatas;
			if(a!=null){
				a = a.sortOn("y",Array.NUMERIC|Array.DESCENDING);
				var max_y:Number = Object(a[i]).y;
				for(var i:int=0;i<stepSize_ls.length;i++){
					if(stepSize_ls[i-1]!=null){
						if(stepSize_ls[i-1] < max_y){
							if(max_y<stepSize_ls[i]){
								maximum = stepSize_ls[i];
								reflashLeftNum2();
								break;
							}
						}
					}
				}
				for(i=0;i<a.length;i++){
					var o:Object = a[i]
					var d:CurveEditorPointData = new CurveEditorPointData();
					d.xn = o.x;
					d.yn = o.y
					CurveEditorData.addPoint(d);
				}
			}else{
				_createDefaultPoints();
			}
			
			reflashLine();
		}
		
		override protected function uiShow():void
		{
			addListener()
		}
		
		override protected function uiHide():void
		{
			removeListener();
			CurveEditorDrawCont.dragPoint = null;
			CurveEditorData.queue.clear();
			drawCont.removeAllPoint();
		}
		
		private function onSave(e:MouseEvent):void
		{
			if(save_f!=null)save_f(getObject());
			save_f = null;
			get_App3DMainUIContainerMediator().hideCurveEditor();
		}
		
		private function addListener():void
		{
			removeListener()
			this.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function removeListener():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			drawCont.onRender();
		}
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
	}
}