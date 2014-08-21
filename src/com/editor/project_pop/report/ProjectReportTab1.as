package com.editor.project_pop.report
{
	import com.asparser.Field;
	import com.asparser.TypeDBCache;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.timer.TimerManager;
	
	import flash.filesystem.File;

	public class ProjectReportTab1 extends UIVBox
	{
		public function ProjectReportTab1()
		{
			super();
			create_init();
			
		}
		
		public static const a:Array = [{label:"非法使用Array",info:"建议使用SandyArray",data:":Array"},
										{label:"非法使用Loader",info:"统一使用SandyLoader",data:":Loader"},
										{label:"乱用*类型",info:"尽量少用*类型",data:":*"},
										{label:"非法使用MovieClip",info:"尽量少用MovieClip",data:":MovieClip"},
										{label:"非法使用Timer",info:"使用TimerManager.getInstance().createSandyTimer(",data:":Timer"},
										{label:"非法使用setInterval",info:"",data:"setInterval("},
										{label:"非法使用setTimeout",info:"",data:"setTimeout("},
										{label:"非法使用TimeLite",info:"改用asTween",data:"TimeLite.to("},
										{label:"非法使用ENTER_FRAME",info:"",data:"Event.ENTER_FRAME"},
										{label:"非法使用GroupSelectOneTool",info:"改用group",data:":GroupSelectOneTool"},
										{label:"非法使用getDefinition",info:"改用ASAssetsSymbol",data:".getDefinition("}
		]
		
		private var cb:UICombobox;
		private var box:UIVlist;
		private var infoIT:UILabel;
		private var bottomTI:UILabel;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 50;
			hb.horizontalGap = 10;
			hb.percentWidth  =100;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "检测类型: ";
			hb.addChild(lb);
			
			cb = new UICombobox();
			cb.width = 250;
			cb.height = 25;
			cb.labelField = "label"
			hb.addChild(cb);
			
			infoIT = new UILabel();
			hb.addChild(infoIT);
			
			box = new UIVlist();
			box.doubleClickEnabled = true;
			box.itemRenderer = ProjectReportTab1ItemRenderer
			box.enabledPercentSize = true;
			box.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			box.styleName = "list";
			box.addEventListener(ASEvent.CHANGE,onBoxChange)
			addChild(box);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.horizontalGap = 10;
			hb.percentWidth  =100;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			bottomTI = new UILabel();
			hb.addChild(bottomTI)
			
			cb.dataProvider = a;
			cb.addEventListener(ASEvent.CHANGE,onChange)
			cb.setSelectIndex(0);
		}
		
		private function onChange(e:ASEvent):void
		{
			var a:Array = [];
			a = TypeDBCache.getArray(cb.selectedItem.data);
			box.dataProvider = a;
			if(a == null) return ;
			if(cb.selectedItem == null) return 
			infoIT.text = cb.selectedItem.info;
			bottomTI.text = "一共( " + a.length + " )数据"
		}
		
		private function onBoxChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:Field = e.addData as Field;
				var fl:File = new File(d.filePath); 
				if(fl.exists&&!fl.isDirectory){
					var dd:OpenFileData = new OpenFileData();
					dd.file = fl;
					dd.rowIndex = d.index;
					sendAppNotification(AppModulesEvent.openEditFile_event,dd);
				}
			}
		}
		
	}
}