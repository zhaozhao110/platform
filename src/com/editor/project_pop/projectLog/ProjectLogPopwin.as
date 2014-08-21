package com.editor.project_pop.projectLog
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;

	public class ProjectLogPopwin extends AppPopupWithEmptyWin
	{
		public function ProjectLogPopwin()
		{
			super()
			create_init();
		}
		
		public var ti:UITextInput;
		public var cb:UICombobox;
		public var statusLB:UIText;
		public var connBtn:UIButton;
		public var atcb:UICombobox;
		private var can:UIVBox;
		public var logTxt:UITextArea;
		public var tipTxt:UIText;
		
		override protected function resizeHandle(e:Event=null):void
		{
			if(can!=null){
				can.width = width-10;
				can.height = height-10
			}
		}
		
		private function create_init():void
		{
			can = new UIVBox();
			can.y = 10;
			can.x = 10;
			can.width = width-10;
			can.height = height-30
			can.styleName = "uicanvas";
			addChild(can);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true;
			can.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "localName:"
			hb.addChild(lb);
			
			ti = new UITextInput();
			ti.width = 100;
			hb.addChild(ti);
			
			lb = new UILabel();
			lb.text = "cache localNames:"
			hb.addChild(lb);
			
			cb = new UICombobox();
			cb.width = 200;
			cb.height = 25;
			hb.addChild(cb);
			
			connBtn = new UIButton();
			connBtn.label = "连接"
			hb.addChild(connBtn);
			
			tipTxt = new UIText();
			hb.addChild(tipTxt);
			
			statusLB = new UIText();
			hb.addChild(statusLB);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			can.addChild(hb);
			
			lb = new UILabel();
			lb.text = "操作"
			hb.addChild(lb);
			
			atcb = new UICombobox();
			atcb.width = 200;
			atcb.height = 25;
			hb.addChild(atcb);
			
			var a:Array = [];
			a.push({label:"计时器",data:"当前正在运行的计时器，包括Timer,EnterFrame"})
			a.push({label:"服务器消息",data:"与服务器通讯的消息"});
			a.push({label:"删除服务器消息",data:"删除与服务器通讯的消息"});
			a.push({label:"缓存",data:"当前游戏的缓存"});
			a.push({label:"垃圾回收",data:"点击刷新可立即垃圾回收"});
			a.push({label:"性能监控",data:"打开性能监控"});
			a.push({label:"加载所有记录",data:"记录所有的加载记录"});
			a.push({label:"加载重复记录",data:"记录重复的加载记录"});
			a.push({label:"组件",data:"组件渲染"});
			atcb.labelField = "label";
			atcb.dataProvider = a;
			
			logTxt = new UITextArea();
			logTxt.enabledPercentSize = true;
			can.addChild(logTxt);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.maximizable = true;
			opts.minimizable = true;
			opts.width = 1000;
			opts.height = 650;
			opts.title = "项目log"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.ProjectLogPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectLogPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectLogPopwinMediator.NAME);
		}
		
	}
}