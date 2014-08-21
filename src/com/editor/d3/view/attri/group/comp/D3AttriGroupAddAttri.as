package com.editor.d3.view.attri.group.comp
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.view.attri.group.D3AttriGroupCell;
	import com.editor.d3.view.attri.group.D3AttriGroupViewBase;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.controls.ASHRule;
	import com.sandy.asComponent.controls.ASPopupButton;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.gameTool.groupSelect.GroupSelectEvent;
	import com.sandy.utils.ColorUtils;

	public class D3AttriGroupAddAttri extends UIVBox
	{
		public function D3AttriGroupAddAttri()
		{
			super();
			
			
			height = 25;
			percentWidth = 100;
			horizontalAlign = "center";
			
			addAttriPopBtn = new ASPopupButton();
			addAttriPopBtn.height = 22;
			addAttriPopBtn.width = 200;
			addAttriPopBtn.prompt = "add Component"
			addAttriPopBtn.label = "add component"
			addChild(addAttriPopBtn);
			addAttriPopBtn.rowSelectChange_proxy = onAddHandle2;
			
			var sp:ASSpace = new ASSpace();
			sp.height = 5;
			sp.width = 100;
			addChild(sp);
			
			var hs:ASHRule = new ASHRule();
			hs.height = 1;
			hs.width = 260
			addChild(hs);
			hs.color = ColorUtils.gray;
			
			sp = new ASSpace();
			sp.height = 5;
			sp.width = 100;
			addChild(sp);
		}
		
		public function reflashInfo():void
		{
			if(target.comp.group == D3ComponentConst.comp_group11){
				addAttriPopBtn.dataProvider = [D3ComponentProxy.getInstance().group_ls.getItem(3),
												D3ComponentProxy.getInstance().group_ls.getItem(39)]
			}else if(target.comp.group == D3ComponentConst.comp_group14){
				addAttriPopBtn.dataProvider = [D3ComponentProxy.getInstance().group_ls.getItem(47)]
			}else{
				addAttriPopBtn.dataProvider = D3ComponentProxy.getInstance().group_ls.enAdd_ls;
			}
		}
		
		private function onAddHandle2(e:ASEvent):void
		{
			var d:D3GroupItemVO = (addAttriPopBtn.dataProvider as Array)[e.newIndex];
			if(d!=null){
				var c:D3AttriGroupCell = D3SceneManager.getInstance().displayList.selectedAttriView.curr_group_map.find(d.id.toString()) as D3AttriGroupCell
				if(c!=null&&c.visible){
					iManager.iPopupwin.showMessage("已经存在该属性");
					return ;
				}
			}

			D3SceneManager.getInstance().displayList.selectedAttriView.comp.configData.addCustomGroup(d)
			D3SceneManager.getInstance().displayList.selectedAttriView.createGroupView(d);
		}
		
		private var addAttriPopBtn:ASPopupButton;
		public var target:D3AttriGroupViewBase;
		
	}
}