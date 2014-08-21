package com.editor.module_api.view
{
	import com.asparser.Field;
	import com.editor.module_api.EditorApiFacade;
	import com.editor.module_api.itemRenderer.ApiCodeEditor;
	import com.editor.module_api.itemRenderer.ApiImplTileItemRenderer;
	import com.editor.module_api.itemRenderer.ApiTileItemRenderer;
	import com.editor.module_api.manager.ApiSqlConn;
	import com.editor.module_api.mediator.ApiModuleLeftContMediator;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyCanvas;
	import com.sandy.component.containers.SandyHBox;
	import com.sandy.component.containers.SandyTile;
	import com.sandy.component.containers.SandyVBox;
	import com.sandy.component.controls.SandyLinkButton;
	import com.sandy.component.controls.text.SandyLabel;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	public class ApiModuleRightCont extends SandyVBox
	{
		public function ApiModuleRightCont()
		{
			super();
			create_init();
		}
		
		public var nameTi:SandyLabel;
		public var extendsTi:SandyLinkButton;
		public var public_var_t:SandyTile;
		public var static_var_t:SandyTile;
		public var public_fun_t:SandyTile;
		public var protected_fun_t:SandyTile;
		public var static_fun_t:SandyTile;
		public var implements_t:SandyTile;
		public var signLb:SandyLabel;
		public var openBtn:SandyLinkButton;
		public var vbox2:SandyVBox;
		public var editor:ApiCodeEditor;
		public var cls_obj:Object;
		
		public function clear():void
		{
			nameTi.text = "";
			extendsTi.text = "";
			public_fun_t.dataProvider = null;
			public_var_t.dataProvider = null;
			static_fun_t.dataProvider = null;
			static_var_t.dataProvider = null;
			protected_fun_t.dataProvider = null
		}
				
		private function create_init():void
		{
			enabledPercentSize = true;
			verticalGap = 10;
			styleName = "uicanvas"
				
			var hb:SandyHBox = new SandyHBox();
			hb.paddingLeft = 20;
			hb.height = 30;
			hb.percentWidth = 100;
			hb.horizontalGap = 20;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			openBtn = new SandyLinkButton();
			openBtn.label = "源代码";
			openBtn.visible = false;
			openBtn.addEventListener(MouseEvent.CLICK , onOpenClick);
			hb.addChild(openBtn);
			
			var lb:SandyLabel = new SandyLabel();
			lb.text = "类名: " ;
			lb.height = 25;
			hb.addChild(lb);
			signLb = lb;
			
			nameTi = new SandyLabel();
			//nameTi.height = 25;
			nameTi.width = 250;
			nameTi.color = ColorUtils.blue;
			hb.addChild(nameTi);
			
			lb = new SandyLabel();
			lb.height = 25;
			lb.text = "extends";
			hb.addChild(lb);
			
			extendsTi = new SandyLinkButton();
			extendsTi.color = ColorUtils.green;
			extendsTi.height = 25;
			//extendsTi.width = 
			extendsTi.addEventListener(MouseEvent.CLICK,link_f);
			hb.addChild(extendsTi);
			
			var c:SandyCanvas = new SandyCanvas();
			c.enabledPercentSize = true;
			addChild(c);
			
			vbox2 = new SandyVBox();
			vbox2.enabledPercentSize = true;
			vbox2.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			c.addChild(vbox2);
						
			lb = createLabel()
			lb.text = "implements";
			implements_t = createTile()
			implements_t.itemRenderer = ApiImplTileItemRenderer;
			implements_t.height = 100;
			
			lb = createLabel()
			lb.text = "public变量";
			public_var_t = createTile()
				
			lb = createLabel()
			lb.text = "public函数";
			public_fun_t = createTile()
				
			lb = createLabel()
			lb.text = "protected函数";
			protected_fun_t = createTile()
				
			lb = createLabel()
			lb.text = "static变量";
			static_var_t = createTile()			
			static_var_t.height = 100;
				
			lb = createLabel()
			lb.text = "static函数";
			static_fun_t = createTile()
			static_fun_t.height = 100;
			
			editor = new ApiCodeEditor();
			editor.visible = false;
			editor.x = 5;
			c.addChild(editor);
		}
		
		private function createLabel():SandyLabel
		{
			var lb:SandyLabel = new SandyLabel();
			//lb.enabledFliter = true
			lb.color = 0x0077cc
			lb.fontSize = 16;
			vbox2.addChild(lb);
			return lb;
		}
		
		private function createTile():SandyTile
		{
			var tile:SandyTile = new SandyTile();
			tile.percentWidth = 96;
			tile.padding= 5;
			tile.styleName = "list"
			tile.height = 200;
			//tile.tileWidth = 200;
			tile.tileHeight = 25;
			tile.horizontalGap = 15;
			tile.verticalGap = 5;
			tile.itemRenderer = ApiTileItemRenderer;
			tile.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			vbox2.addChild(tile);
			return tile
		}
		
		public function reflashClassInfo(obj:Object):void
		{
			cls_obj = obj;
			if(editor.visible){
				reflashEditor();
			}
			var nam:String = obj.pack + "." + obj.name;
			
			nameTi.text = obj.name;
			if(obj.interfac){
				signLb.text = "接口名："
			}else{
				signLb.text = "类名："
			}
			nameTi.toolTip = nam + "<br>" + StringTWLUtil.replaceWhiteSpace(obj.info);
			extendsTi.text = obj.extend;
			
			//implements_t
			var impl:String = obj.implement;
			if(!StringTWLUtil.isWhitespace(impl)){
				var impl_a:Array = impl.split(",");
				var a6:Array = [];
				for(var i:int=0;i<impl_a.length;i++){
					var nam2:String = impl_a[i]
					var n:int=nam2.lastIndexOf(".");
					var c:String = nam2.substring(n+1,nam2.length);
					var c2:String = nam2.substring(0,n);
					var f:Field = new Field();
					f.name = c;
					f.packagePath = c2;
					a6.push(f);
				}
				implements_t.dataProvider = a6;
			}else{
				implements_t.dataProvider = null;
			}
			
			//protected fun
			var stat:String = "SELECT * FROM protected_fun where className='"+nam+"'"
			var a1:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a1!=null){
				protected_fun_t.dataProvider = a1.sortOn("name");
			}else{
				protected_fun_t.dataProvider = null;
			}
			
			//public fun
			if(obj.interfac){
				stat = "SELECT * FROM impl_fun where className='"+nam+"'"
			}else{
				stat = "SELECT * FROM public_fun where className='"+nam+"'"
			}
			var a2:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a2!=null){
				public_fun_t.dataProvider = a2.sortOn("name");
			}else{
				public_fun_t.dataProvider = null
			}
			
			//public var
			stat = "SELECT * FROM public_var where className='"+nam+"'"
			var a3:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a3!=null){
				public_var_t.dataProvider = a3.sortOn("name");
			}else{
				public_var_t.dataProvider = null
			}
			
			//static fun
			stat = "SELECT * FROM static_fun where className='"+nam+"'"
			var a4:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a4!=null){
				static_fun_t.dataProvider = a4.sortOn("name");
			}else{
				static_fun_t.dataProvider = null
			}
			
			//static var
			stat = "SELECT * FROM static_var where className='"+nam+"'"
			var a5:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a5!=null){
				static_var_t.dataProvider = a5.sortOn("name");
			}else{
				static_var_t.dataProvider = null
			}
		}
				
		private function link_f(e:MouseEvent=null):void
		{
			var nam:String = extendsTi.text;
			var n:int=nam.lastIndexOf(".");
			var c:String = nam.substring(n+1,nam.length);
			var c2:String = nam.substring(0,n);
			var stat:String = "SELECT * FROM class where name='"+c+"' and pack='"+c2+"';"
			var a1:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a1!=null){
				get_ApiModuleLeftContMediator().reflashClass(a1[0]);
			}
		}
		
		private function get_ApiModuleLeftContMediator():ApiModuleLeftContMediator
		{
			return EditorApiFacade.getInstance().moduleFacade.retrieveMediator(ApiModuleLeftContMediator.NAME) as ApiModuleLeftContMediator;
		}
		
		private function onOpenClick(e:MouseEvent=null):void
		{
			editor.visible = !editor.visible;
			reflashEditor()
		}
		
		private function reflashEditor():void
		{
			if(!editor.visible) return ;
			if(cls_obj == null) return ;
			var b:ByteArray = cls_obj.code;
			try{
				b.uncompress();
				var s:String = ByteArrayUtil.convertByteArrayToString(b);
				s = StringTWLUtil.removeNewline(s);
				editor.setText(s);
			}catch(e:Error){}
		}
		
	}
}