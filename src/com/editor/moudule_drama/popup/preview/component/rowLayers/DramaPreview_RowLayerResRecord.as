package com.editor.moudule_drama.popup.preview.component.rowLayers
{
	import com.editor.component.controls.UIText;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_RowLayer;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Sprite;
	import com.editor.moudule_drama.popup.preview.manager.DramaPreviewDataManager;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;
	import com.sandy.asComponent.effect.tween.ASTween;
	
	import flash.events.MouseEvent;
	

	/**
	 * 资源层
	 * @author sun
	 * 
	 */	
	public class DramaPreview_RowLayerResRecord extends DramaPreview_RowLayer
	{
		public function DramaPreview_RowLayerResRecord()
		{
			create_init();
		}
		
		private var actionTxt:UIText;
		private function create_init():void
		{
			actionTxt = new UIText();
			actionTxt.width = 300;
			actionTxt.textAlign = "center";
			actionTxt.fontSize = 14;
			actionTxt.color = 0xff0000;
			addChild(actionTxt);
			actionTxt.visible = false;
		}
		
		override public function processKeyFrameVO(vo:ITimelineKeyframe_BaseVO):void
		{
			if(vo is Drama_FrameResRecordVO)
			{
				/**处理脚本**/
				var scriptStr:String = (vo as Drama_FrameResRecordVO).script;
				if(scriptStr && scriptStr != "undefined" && scriptStr != "")
				{
					if(scriptStr == "stop")
					{
						DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.pause();
					}
				}
				
				/**处理属性列表**/
				var a1:Array = layoutList;
				var len1:int = a1.length;
				for(var i:int=0;i<len1;i++)
				{
					var s:DramaPreview_Sprite = a1[i] as DramaPreview_Sprite;
					if(s)
					{
						//trace("s:" + s.ident)
						/**显示对象是否含有属性	in current frame**/
						var sVisiBool:Boolean = false;
						var pro:ITimelineViewProperties_BaseVO = null;
						
						var a2:Array = (vo as Drama_FrameResRecordVO).getPropertiesListArr();
						var len2:int = a2.length;
						for(var j:int=0;j<len2;j++)
						{
							pro = a2[j] as ITimelineViewProperties_BaseVO;
							
							if(pro)
							{
								//trace("pro::" + pro.targetId + ":" + pro.x + "_" + pro.y);
							}
							
							if(pro && pro.targetId == s.ident)
							{
								sVisiBool = true;
								break;
							}
						}
						
						/**process**/
						if(sVisiBool)
						{
							/**prototype**/
							s.x = pro.x;
							s.y = pro.y;
							
							//trace("s set xy:" + s.ident + ":" + pro.x + "_" + pro.y);
							
							s.scaleX = pro.scaleX;
							s.scaleY = pro.scaleY;
							s.rotation = pro.rotation;
							s.playRes();
							addChild(s);
							if(pro.index < numChildren)
							{
								setChildIndex(s, pro.index);
							}
							/**base**/
							if(pro is Drama_PropertiesBaseVO)
							{
								var baseVO:Drama_PropertiesBaseVO = pro as Drama_PropertiesBaseVO;
								if(baseVO.transition > 0)
								{
									var lastFrame:int = DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.lastFrame;
									var afterProVO:Drama_PropertiesBaseVO = DramaPreviewDataManager.getInstance().getSpriteProperties_InAfterFrame(baseVO, lastFrame);
									if(afterProVO)
									{
										var frameLen:int = afterProVO.placeFrameVO.frame - baseVO.placeFrameVO.frame;
										var time:Number = frameLen/DramaConst.frameRate;
										var tween:ASTween = ASTween.to(s, time , {x:afterProVO.x, y:afterProVO.y, 
											onComplete: function():void{ if(tween) tween.kill() }});
									}
								}
								if(baseVO.mouseClickPara)
								{
									var clickParaStr:String = baseVO.mouseClickPara;
									if(clickParaStr != "undefined" && clickParaStr != "")
									{
										s.mouseEnabled = true;
										s.mouseChildren = false;
										s.buttonMode = true;
										s.removeEventListener(MouseEvent.CLICK, onSpriteClickHandle);
										s.data = clickParaStr;
										s.addEventListener(MouseEvent.CLICK, onSpriteClickHandle);
									}
								}
								
							}
							
							/**角色类型**/
							if(pro is Drama_PropertiesRoleVO)
							{
								var roleVO:Drama_PropertiesRoleVO = pro as Drama_PropertiesRoleVO;
								s.hConversionBool = roleVO.direction;
								if(roleVO.action && roleVO.action != "")
								{
									playAction(s, roleVO);
								}
								
							}			
							
						}else
						{
							if(contains(s)) removeChild(s);
						}
						
					}
				}
								
								
			}
		}
		
		/**播放动作**/
		private function playAction(s:DramaPreview_Sprite, vo:Drama_PropertiesRoleVO):void
		{
			var actionTypeStr:String;
			switch(vo.actionType)
			{
				case 0:
					actionTypeStr = "普通动作：";
					break;
				case 1:
					actionTypeStr = "混合动作：";
					break;
				case 2:
					actionTypeStr = "技能动作：";
					break;
					
			}
			if(vo.action != "undefined")
			{
				actionTxt.htmlText = "<b>" + "<font color='#00ff00'>" + actionTypeStr + "</font>" + vo.actionName + "</b>";
				actionTxt.x = s.x - (actionTxt.width/2);
				actionTxt.y = s.y - s.resContainer.height;
				actionTxt.alpha = 1;
				actionTxt.visible = true;
				
				ASTween.to(actionTxt, 3, {y:actionTxt.y - 100, alpha:0});
			}
			
		}
		
		/**鼠标参数**/
		private function onSpriteClickHandle(e:MouseEvent):void
		{
			var s:DramaPreview_Sprite = e.target as DramaPreview_Sprite;
			if(s)
			{
				s.removeEventListener(MouseEvent.CLICK, onSpriteClickHandle);
				s.mouseEnabled = false;
				s.buttonMode = false;
				if(s.data)
				{
					var paraStr:String = s.data.toString();
					if(paraStr == "play")
					{
						DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.dePause();
					}
				}
			}
			
		}
		
		
		
		
		
	}
}