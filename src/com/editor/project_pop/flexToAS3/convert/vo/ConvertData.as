package com.editor.project_pop.flexToAS3.convert.vo
{
	import com.air.component.SandyFile;
	import com.sandy.common.reflect.Field;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	

	public class ConvertData
	{
		public function ConvertData()
		{
		}
		
		public var selectFile:SandyFile;
		public var xml:XML;
		
		public var implements_str:String;
		
		/**
		 * 变量
		 */ 
		public var variable:Array = [];
		/**
		 * import list
		 */ 
		public var custom_namespace:Array = [];
		
		public var init_str:String = "";
		
		
		private var _script:String = "";
		public function get script():String
		{
			return _script;
		}
		public function set script(value:String):void
		{
			if(_script != ""){
				throw new Error("scrip have data")
			}
			_script = value;
		}

		
		/**
		 * 原始的内容
		 */ 
		public var originalText:String;
		
		/**
		 * 原始目录
		 */ 
		public var originalDirectory:File;
		/**
		 * 目标目录
		 */ 
		public var targetDirectory:File;
				
		
		
		
		
			
			
		private static var uicomponentIndex:int;
			
		public static function createUIComponentIndex():int
		{
			return ++uicomponentIndex;
		}
		
		
		
		
		
		/**
		 * 排除的导入包
		 */ 
		public static const exclude_mxml_ls:Array = ["http://www.adobe.com/2006/mxml",
														"http://ns.adobe.com/textLayout/internal/2008",
														"com.rpg.component.container.default1.*",
														"com.rpg.modules.activity1.view.*",
														"flashx.textLayout.elements.*"]
		
			
		/**
		 * 要删除的字符串
		 */ 
		public static const delete_str_ls:Array = ["[Bindable]",
													"import mx.containers.TabNavigator;",
													"import mx.controls.Button;",
													"import mx.events.DragEvent;",
													"import mx.managers.DragManager;",
													"import mx.core.DragSource;",
													"import mx.events.ListEvent;",
													"import mx.events.IndexChangedEvent;",
													"import mx.utils.ColorUtil;"]
		
		/**
		 * 不能addChild的类
		 */ 
		public static const disabled_addChild_ls:Array = ["SandyRadioButtonGroup"]
			
		/**
		 * 一定是字符串
		 */ 
		public static const string_ls:Array = ["id",
													"label",
													"normal_tip",
													"select_tip",
													"text",
													"normalStyleName",
													"selectStyleName"]
		/**
		 * 一定是变量
		 */ 
		public static const variable_ls:Array = ["target"]
													
		/**
		 * 要导入类
		 */ 
		public static const importClass_ls:Array = ["itemRenderer",
														"branch_itemRenderer",
														"leaf_itemRenderer",
														"rendererClass"]
		
		/**
		 * 事件
		 */ 
		public static const event_ls:Array = ["initialize",
													"click",
													"mouseOver",
													"mouseOut",
													"mouseDown",
													"effectEnd",
													"effectStart",
													"creationComplete",
													"link",
													"mouseUp",
													"doubleClick",
													"rollOver",
													"rollOut",
													"dataChange",
													"change"]
		/**
		 * 排除的属性
		 */ 
		public static const exclude_attri_ls:Array = ["implements",
															"focusEnabled",
															"mouseFocusEnabled"]
		/**
		 * 可以包括的mx包
		 */ 
		public static const mxml_ls:Array = ["mx.core.Application",
												"mx.core.UIComponent"];
		
		
		
			
	}
}