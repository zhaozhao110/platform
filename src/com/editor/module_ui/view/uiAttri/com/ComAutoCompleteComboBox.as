package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.manager.StackManager;
	import com.editor.module_ui.css.CreateCSSFileItemVO;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.text.SandyAutoCompleteComboBox;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class ComAutoCompleteComboBox extends ComBase
	{
		public function ComAutoCompleteComboBox()
		{
			super();
		}
		
		protected var input:SandyAutoCompleteComboBox;
				
		override protected function create_init():void
		{
			super.create_init();
			
			input = new SandyAutoCompleteComboBox();
			input.height = 22
			input.percentWidth = 100;
			input.dropDownWidth = 180
			input.enterKeyDown_proxy = enterKeyDown;
			input.filter_proxy = onInputChange;
			input.addEventListener(ASEvent.CHANGE,onSelectChange)
			addChild(input);
		}
				
		private function onSelectChange(e:ASEvent):void
		{
			if(CreateCSSFileItemVO.checkIsSkin(key) || item.value == "styleName"){
				var fl:File = e.data as File;
				data = fl;
				input.text = getStyleNameFromName(fl.name);
			}else if(key == "inventedGroup"){
				var g:InvertedGroupVO = e.data as InvertedGroupVO;
				data = g;
				input.text = g.id;
			}else if(key == "parent"){
				var gg:UITreeNode = e.data.data as UITreeNode;
				data = gg;
				input.text = UIShowCompProxy(gg.obj).target.id;
			}
		}
		
		private function getStyleNameFromName(nm:String):String
		{
			nm = nm.split(".")[0];
			if(StringTWLUtil.beginsWith(nm,"CSS_")){
				nm = nm.substring(4,nm.length);
			}
			return nm;
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			if(!StringTWLUtil.isWhitespace(input.text)){
				if(key == "inventedGroup"){
					data = UIEditManager.currEditShowContainer.cache.getInvertedGroup(input.text);
				}else if(key == "parent"){
					data = UIEditManager.currEditShowContainer.cache.findCompById(input.text);
				}else if(CreateCSSFileItemVO.checkIsSkin(key) || item.value == "styleName"){
					var fl:File = ProjectAllUserCache.getInstance().findFileByNameFromCSSXML(input.text);
					if(fl!=null){
						if(StackManager.checkIsEditCSS()){
							data = getStyleNameFromName(fl.name);
						}else{
							if(StackManager.checkIsEditUI()){
								data = fl;	
							}
						}
					}
				}
			}else{
				if(key == "parent"){
					input.text = "stage";
					data = UIEditManager.currEditShowContainer.cache.findCompById(input.text);
				}else if(key == "inventedGroup"){
					data = null;
				}
			}
			d.value = data; 
			return d;
		}
		
		private function onInputChange(t:String):Array
		{
			if(CreateCSSFileItemVO.checkIsSkin(key) || item.value == "styleName"){
				return ProjectAllUserCache.getInstance().findByNameFromCSSXML(t);
			}else if(key == "inventedGroup"){
				return UIEditManager.currEditShowContainer.cache.findGroupByName(t);
			}else if(key == "parent"){
				return UIEditManager.currEditShowContainer.cache.findCompArrayById(t);
			}
			return [];
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			if(item!=null){
				if(key == "inventedGroup"){
					input.labelField = "id"
				}else{
					input.labelField = "name"
				}
				if(!StringTWLUtil.isWhitespace(item.expand)){
					if(item.expand.split(",")[0]==0){
						input.editable = false;
					}
				}
			}
			
			input.text = "";
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			if(obj!=null){
				if(!StringTWLUtil.isWhitespace(obj.value)){
					if(key == "inventedGroup"){
						if(UIEditManager.currEditShowContainer.cache.getInvertedGroup(obj.value)!=null){
							input.text = UIEditManager.currEditShowContainer.cache.getInvertedGroup(obj.value).id;
						}else{
							input.text = ""
						}
						return ;
					}
					if(obj.value is File){
						input.text = File(obj.value).name.split(".")[0];
					}else{
						input.text = obj.value;
					}
				}
			}
		}
		
		override protected function resetCom():void
		{
			input.text = "";
		}
		
	}
}