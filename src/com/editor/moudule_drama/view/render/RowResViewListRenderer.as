package com.editor.moudule_drama.view.render
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class RowResViewListRenderer extends SandyBoxItemRenderer
	{
		private var vo:Drama_LayoutViewBaseVO;
		
		public function RowResViewListRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var typeTxt:UILabel;
		private var editorBtn:UIButton;
		private var deleteBtn:UIButton;
		private function create_init():void
		{
			mouseEnabled = true;
			
			width = 160; height = 24;
			borderColor = 0xB3B3B3;
			borderThickness = 1;
			borderStyle = "solid";
			backgroundColor = 0xE0E0E0;
			
			nameTxt = new UILabel();
			nameTxt.x = 5; nameTxt.y = 2;
			nameTxt.width = 50;
			nameTxt.height = 20;
			addChild(nameTxt);
			
			typeTxt = new UILabel();
			typeTxt.top = 2; typeTxt.right = 60;
			typeTxt.width = 50;
			typeTxt.height = 20;
			addChild(typeTxt);
			
			editorBtn = new UIButton();
			editorBtn.top = 3; editorBtn.right = 36;
			editorBtn.width = 30; editorBtn.height = 20;
			editorBtn.label = "显示";
			addChild(editorBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.top = 3; deleteBtn.right = 3;
			deleteBtn.width = 30; deleteBtn.height = 20;
			deleteBtn.label = "删除";
			addChild(deleteBtn);
			
			addEventListener(MouseEvent.CLICK, onItemClick);
			editorBtn.addEventListener(MouseEvent.CLICK, onEditorBtnClickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClickHandle);
		}
		
		override public function poolChange(dat:*):void
		{
			super.poolChange(dat);
			if(dat == null){
				return;
			}
			vo = dat as Drama_LayoutViewBaseVO;
			
			if(vo)
			{
				nameTxt.text = vo.sourceName;
				typeTxt.text = vo.sourceType + "";
			}
						
		}
		
		
		override public function poolDispose():void
		{
			super.poolDispose();
		}
		
		override public function select():void
		{
			super.select();
			backgroundColor = 0xFFFFFF;
		}
		override public function noSelect():void
		{
			super.noSelect();
			backgroundColor = 0xE0E0E0;		
		}
		override public function checkSelect():Boolean
		{
			super.checkSelect();
			return false;
		}
		
		private function onItemClick(e:MouseEvent):void{
			dispatchSelect(true);
		}
		
		override public function getSelectValue():Object
		{	
			return vo;
		}
		
		/**显示**/	
		private function onEditorBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentPlaceKeyframe() as Drama_FrameResRecordVO;
				if(keyfVO)
				{
					var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(vo.sourceId);
					if(resInfoItem)
					{
						var sprite:DLayoutSprite = DramaManager.getInstance().get_DramaLayoutContainerMediator().getLayoutViewByVO(vo);
						if(sprite)
						{
							var propVO:ITimelineViewProperties_BaseVO = DramaManager.createNewPropertiesVO(resInfoItem);
							propVO.x = 100;
							propVO.y = 100;
							propVO.targetId = sprite.ident;
							(propVO as Drama_PropertiesBaseVO).placeFrameVO = keyfVO;
							keyfVO.addProperty(propVO as Drama_PropertiesBaseVO);
							
							DramaManager.getInstance().get_DramaAttributeEditor_RowMediator().updataResListVbox();
							iManager.getAppFacade().sendNotification(DramaEvent.drama_updataLayoutViewList_event);
						}
					}
					
				}else
				{
					DramaManager.getInstance().get_DramaModuleMediator().showMessage("请先选择关键帧再选择层进行操作！");
				}
			}
		}
		/**删除**/	
		private function onDeleteBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentPlaceKeyframe() as Drama_FrameResRecordVO;
				if(keyfVO)
				{
					
					var processA:Array = [];
					var processStr:String = "";
					
					var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(vo.sourceId);
					if(resInfoItem)
					{
						var sprite:DLayoutSprite = DramaManager.getInstance().get_DramaLayoutContainerMediator().getLayoutViewByVO(vo);
						if(sprite)
						{
							
							var a:Array = DramaDataManager.getInstance().getKeyframelistByRowId(keyfVO.rowId);
							var len:int = a.length;
							for(var i:int=0;i<len;i++)
							{
								var curKeyf:Drama_FrameResRecordVO = a[i] as Drama_FrameResRecordVO;
								if(curKeyf)
								{
									var aP:Array = curKeyf.getPropertiesListArr();
									var lenP:int = aP.length;
									for(var j:int=0;j<lenP;j++)
									{
										var prop:Drama_PropertiesBaseVO = aP[j] as Drama_PropertiesBaseVO;
										if(prop)
										{
											if(prop.targetId == sprite.ident)
											{
												if(i == 0)
												{
													var getRowVO:Drama_RowVO = DramaDataManager.getInstance().getRowById(curKeyf.rowId);
													processStr += "\"" + getRowVO.name + "\"层第 ";
												}
												processStr += curKeyf.frame + "";
												if(i < len-1)
												{
													processStr += "、";
												}
												processA.push(prop);
											}
										}
									}
								}
							}
																					
							
						}
					}
					
					processDeleteList(vo, processStr, processA);
				}else
				{
					DramaManager.getInstance().get_DramaModuleMediator().showMessage("请先选择关键帧再选择层进行操作！");
				}
			}
			
		}
		
		/**处理删除**/
		private function processDeleteList(pvo:Drama_LayoutViewBaseVO, str:String, list:Array):void
		{
			var confirmData:OpenMessageData = new OpenMessageData();
			confirmData.info = "该对象在：" + str + " 帧中均有引用<br>是否确定删除？";
			confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			confirmData.okFunction = okFunction;
			DramaManager.getInstance().get_DramaModuleMediator().showConfirm(confirmData);
			
			function okFunction():Boolean
			{				
				DramaDataManager.getInstance().removeLayoutView(pvo.id);
				
				var len:int = list.length;
				for(var i:int=0;i<len;i++)
				{
					var prop:Drama_PropertiesBaseVO = list[i] as Drama_PropertiesBaseVO;
					if(prop)
					{						
						if(prop.placeFrameVO)
						{
							prop.placeFrameVO.removePropertyVO(prop);
							if(prop.placeFrameVO.getPropertiesListArr().length <= 0)
							{
								DramaDataManager.getInstance().removeKeyframe(prop.placeFrameVO.id);
								DramaManager.getInstance().get_DramaLayoutContainerMediator().removeLayoutViewByVO(DramaManager.getInstance().getLayoutViewById(prop.targetId).vo as Drama_LayoutViewBaseVO);
								iManager.getAppFacade().sendNotification(DramaEvent.drama_removeKeyframe_event, {vo:prop.placeFrameVO});
								
							}
						}
						
					}
				}
				
				var rowVO:Drama_RowVO = DramaDataManager.getInstance().getRowById(pvo.rowId);
				DramaManager.getInstance().get_DramaAttributeEditor_RowMediator().setData(rowVO);
				
				return true;
			}
		}
		
		
		
	}
}