package com.editor.module_ui.ui
{
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.expandComp.ExpandCompItemVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;

	public class UIEditCache
	{
		
		/////////////// 组件大纲 ///////////
				
		//舞台的node
		public var tree:UITreeNode;
		
		public function addComp(p:UITreeNode,_reflash:Boolean=true):void
		{
			if(p.branch == null){
				tree.addItem(p);
				tree.sortOn("index",Array.NUMERIC);
			}else{
				if(p.branch.id == tree.id){
					tree.addItem(p);
					tree.sortOn("index",Array.NUMERIC);
				}else{
					p.branch.addItem(p);
					p.branch.sortOn("index",Array.NUMERIC);
				}
			}
			if(_reflash){
				reflashCompOutline();
			}
		}
		
		public function removeComp(p:UITreeNode,_reflash:Boolean=true):void
		{
			tree.removeItem(p);
			tree.sortOn("index",Array.NUMERIC);
			if(p.branch!=null){
				p.branch.removeItem(p);
			}
			if(_reflash){
				reflashCompOutline();
			}
		}
		
		public static var _enabled_reflashCompOutline:Boolean=true;
		public static function set enabled_reflashCompOutline(value:Boolean):void
		{
			_enabled_reflashCompOutline = value;
			if(value){
				reflashCompOutline()
			}
		}
		public static function get enabled_reflashCompOutline():Boolean
		{
			return _enabled_reflashCompOutline;
		}
		
		public static function reflashCompOutline():void
		{
			if(!enabled_reflashCompOutline) return ;
			SandyEngineGlobal.iManager.sendAppNotification(UIEvent.reflash_compOutline_event);
		}
		
		public function getAllComp():Array
		{
			return tree.getAllList();
		}
		
		public function allCompShowWhileBorder():void
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null){
					if(t.obj is UIShowCompProxy){
						if(UIShowCompProxy(t.obj).target!=null){
							UIShowCompProxy(t.obj).target.showBorderInUIEdit();
						}
					}
				}
			}
		}
		
		public function reflashTreeNodeInitAttri():void
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null){
					if(t.obj is UIShowCompProxy){
						if(UIShowCompProxy(t.obj).target!=null){
							t.name = UIShowCompProxy(t.obj).name;
							UIShowCompProxy(t.obj).reflashCompIndex();
						}
					}
					t.sortOn("index",Array.NUMERIC);
				}
			}
		}
		
		public function findCompArrayById(id:String):Array
		{
			var a:Array = getAllComp();
			var out:Array = [];
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).target.id.indexOf(id)!=-1){
							out.push({name:UIShowCompProxy(t.obj).target.id,data:t});
						}
					}
				}
			}
			return out;
		}
		
		public function findCompById(id:String):UITreeNode
		{
			if(id == "stage") return tree;
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).target.id == id){
							return t;
						}
					}
				}
			}
			return null;
		}
		
		public function findCompByName(nm:String):UITreeNode
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).target.name == nm){
							return t;
						}
					}
				}
			}
			return null;
		}
		
		public function checkIsSameId():Boolean
		{
			var id_ls:Array = [];
			var name_ls:Array = [];
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						var nm:String = UIShowCompProxy(t.obj).target.name;
						var _id:String = UIShowCompProxy(t.obj).target.id;
						if(name_ls[nm]!=null){
							SandyManagerBase.getInstance().showError("有相同的name:"+nm+"的组件");
							return true;
						}
						if(id_ls[_id]!=null){
							SandyManagerBase.getInstance().showError("有相同的name:"+_id+"的组件");
							return true;
						}
						name_ls[nm] = nm;
						id_ls[_id] = _id;
					}
				}
			}
			return false
		}
		
		public function addExpandCompAttri(d:ComAttriItemVO,type:String):void
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).data.item.name == type){
							UIShowCompProxy(t.obj).data.item.addAttri(d);
						}
					}
				}
			}
			if(ProjectAllUserCache.getInstance().expandComp!=null){
				var item:ExpandCompItemVO = ProjectAllUserCache.getInstance().expandComp.getItem(type);
				if(item!=null){
					item.addAttri(d.key,{value:d.value,dataType:d.dataType})
				}
			}
		}
		
		public function removeExpandCompAttri(key:String,type:String):void
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).data.item.name == type){
							UIShowCompProxy(t.obj).data.item.removeAttri(key);
						}
					}
				}
			}
			if(ProjectAllUserCache.getInstance().expandComp!=null){
				var item:ExpandCompItemVO = ProjectAllUserCache.getInstance().expandComp.getItem(type);
				if(item!=null){
					item.removeAttri(key)
				}
			}
		}
		
		public function getTreeNodeByType(type:String):UIShowCompProxy
		{
			var a:Array = getAllComp();
			for each(var t:UITreeNode in a){
				if(t!=null && (t.obj is UIShowCompProxy)){
					if(UIShowCompProxy(t.obj).target!=null){
						if(UIShowCompProxy(t.obj).data.item.name == type){
							return UIShowCompProxy(t.obj);
						}
					}
				}
			}
			return null;
		}
			
		
		/////////////////////// 虚拟面板 //////////////////////
		public var invertedGroup_ls:Array = []
		public function addInvertedGroup(g:InvertedGroupVO):void
		{
			if(StringTWLUtil.isWhitespace(g.id)) return ;
			invertedGroup_ls.push(g);
			iManager.sendAppNotification(UIEvent.reflash_invertedGroupList_event);
		}
		
		public function removeInvertedGroup(g:InvertedGroupVO):void
		{
			if(StringTWLUtil.isWhitespace(g.id)) return ;
			g.dispose();
			var n:int = invertedGroup_ls.indexOf(g);
			if(n>=0){
				invertedGroup_ls.splice(n,1);
				var a:Array = getAllComp();
				for each(var t:UITreeNode in a){
					if(t!=null && (t.obj is UIShowCompProxy)){
						if(UIShowCompProxy(t.obj).target!=null){
							if(UIShowCompProxy(t.obj).target.inventedGroup!=null){
								if(UIShowCompProxy(t.obj).target.inventedGroup.id == g.id){
									UIShowCompProxy(t.obj).reflashAttri("inventedGroup",null);
								}
							}
						}
					}
				}
				iManager.sendAppNotification(UIEvent.reflash_invertedGroupList_event);
			}
		}
		
		public function findGroupByName(nm:String):Array
		{
			if(nm.length < 2) return [];
			var out:Array = [];
			for(var i:int=0;i<invertedGroup_ls.length;i++){
				var g:InvertedGroupVO = invertedGroup_ls[i] as InvertedGroupVO;
				if(g.id.indexOf(nm)!=-1){
					out.push(g);
				}
			}
			return out;
		}
		
		public function getInvertedGroup(id:String):InvertedGroupVO
		{
			for(var i:int=0;i<invertedGroup_ls.length;i++){
				var g:InvertedGroupVO = invertedGroup_ls[i] as InvertedGroupVO;
				if(g.id == id){
					return g;
				}
			}
			return null;
		}
		
		public function getGroupId():String
		{
			return "group"+int(TimerUtils.getTime()/1000);
		}
		
		public function copyAllCompEventCode():String
		{
			var out:Array = [];
			var a:Array = tree.getAllList();
			for each(var t:UITreeNode in a){
				if(t!=null && t.obj is UIShowCompProxy){
					var evt:String = (t.obj as UIShowCompProxy).getAttri("event");
					if(!StringTWLUtil.isWhitespace(evt)){
						evt = (t.obj as UIShowCompProxy).createEventCode();
						if(!StringTWLUtil.isWhitespace(evt)){
							out.push(evt)
						}
					}
				}
			}
			return out.join(NEWLINE_SIGN);
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		public function showAllComp():void
		{
			var a:Array = tree.getAllList();
			for each(var t:UITreeNode in a){
				if(t!=null && t.obj is UIShowCompProxy){
					(t.obj as UIShowCompProxy).target.visible = true;
				}
			}
			UIEditManager.currEditShowContainer.setBackgroundVisible(true);
		}
		
		public function hideAllComp(p:UIShowCompProxy=null):void
		{
			var a:Array = tree.getAllList();
			for each(var t:UITreeNode in a){
				if(t!=null && t.obj is UIShowCompProxy){
					if(p!=null){
						if((t.obj as UIShowCompProxy) == p){
							(t.obj as UIShowCompProxy).target.visible = true;
						}else if(UIShowCompProxy(t.obj).parentComp == p.target){
							(t.obj as UIShowCompProxy).target.visible = true;	
						}else if(p.parentComp == UIShowCompProxy(t.obj).target){
							(t.obj as UIShowCompProxy).target.visible = true;
						}else{
							(t.obj as UIShowCompProxy).target.visible = false;
						}
					}else{
						(t.obj as UIShowCompProxy).target.visible = false
					}
				}
			}
		}
		
		
		/////////////// 组件全局缓存  ///////////
		
		public static var cacheUI_ls:Array = []
		
		public static function addCacheUI(ui:UIShowCompProxy):void
		{
			if(cacheUI_ls.indexOf(ui)==-1){
				cacheUI_ls.push(ui);
			}
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}	
}