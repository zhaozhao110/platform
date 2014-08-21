package com.editor.module_skill.timeline.vo
{
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.PlayerRole;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.proxy.EditSkillProxy;
	import com.editor.module_skill.vo.skillSeq.SkillSeqGroupVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqItemVO;
	import com.sandy.manager.data.SandyData;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.StringTWLUtil;

	public class TimelineDataList
	{
		public function TimelineDataList()
		{
		}
		
		public function reset():void
		{
			list = null;
			list = [];
		}
		
		public var list:Array = [];
		
		public function put(d:ITimelineDataBase):void
		{
			if(list[d.row.toString()] == null){
				list[d.row.toString()] = [];
			}
			(list[d.row.toString()] as Array)[d.frame.toString()] = d;
			d.reflash();
			reflashText();
		}
		
		public function put2(d:ITimelineDataBase):void
		{
			if(list[d.row.toString()] == null){
				list[d.row.toString()] = [];
			}
			(list[d.row.toString()] as Array)[d.frame.toString()] = d;
		}
		
		public function remove(d:ITimelineDataBase):void
		{
			if(d!=null){
				d.remove();	
			}
		}
		
		public function removeRowFrame(row:int,frame:int):void
		{
			if(list[row.toString()] == null){
				list[row.toString()] = [];
			}
			(list[row.toString()] as Array)[frame.toString()] = null;
		}
		
		public function remove2(d:ITimelineDataBase):void
		{
			if(d!=null){
				(list[d.row.toString()] as Array)[d.frame.toString()] = null
			}
		}
		
		public function dispose(row:int,frame:int):void
		{
			if(list[row.toString()] == null){
				list[row.toString()] = [];
			}
			(list[row.toString()] as Array)[frame.toString()] = null;
		}
		
		public function getRow(row:int,iskey:Boolean=false):Array
		{
			var out:Array = [];
			var a:Array = list[row.toString()]
			for each(var d:ITimelineDataBase in a){
				if(d!=null){
					if(iskey){
						if(d.isKey){
							out.push(d);
						}
					}else{
						out.push(d);
					}
				}
			}
			return out.sortOn("frame",Array.NUMERIC);
		}
		
		/**
		 * 帧格子上是否有数据
		 */ 
		public function checkHaveData(row:int,frame:int):Boolean
		{
			if(list[row.toString()] == null){
				list[row.toString()] = [];
			}
			return (list[row.toString()] as Array)[frame.toString()] != null;
		}
		
		public function getDataBase(row:int,frame:int):ITimelineDataBase
		{
			if(list[row.toString()] == null){
				list[row.toString()] = [];
			}
			return (list[row.toString()] as Array)[frame.toString()] as ITimelineDataBase
		}
		
		public function getSelectedDataBase():ITimelineDataBase
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			return getDataBase(row,frame);
		}
		
		public function getData(row:int,frame:int):String
		{
			if(checkHaveData(row,frame)){
				return getDataBase(row,frame).getData();
			}
			return "";
		}
		
		public function reflashText():void
		{
			if(EditSkillManager.timelineBottomTxt!=null){
				
				if(EditSkillManager.selectRect == null) return ;
				var row:int = EditSkillManager.selectRect.getRow();
				var frame:int = EditSkillManager.selectRect.getFrame();
				
				//trace(EditSkillManager.selectRect.getRow(),EditSkillManager.selectRect.getFrame());
				if(checkHaveData(row,frame)){
					EditSkillManager.timelineBottomTxt.text = getDataBase(row,frame).getLabel();
				}else{
					EditSkillManager.timelineBottomTxt.text = "";
				}
			}
		}
		
		/**
		 * 播放时间轴
		 * frame:当前的帧
		 */ 
		public function play(frame:int):void
		{
			var a:Array = EditSkillManager.row_ls;
			for(var i:int=0;i<a.length;i++)
			{
				var d:SandyData = a[i] as SandyData;
				var rect:ITimelineDataBase = getDataBase(int(d.getKey()),frame);
				if(rect!=null){
					rect.play();
				}
			}
		}
		
		public var currSkillSeqG:SkillSeqGroupVO;
		
		/**
		 * 解析xml
		 */ 
		public function parser():void
		{
			if(EditSkillManager.currSkill.voc == 5){
				currSkillSeqG = get_EditSkillProxy().skillSeq_ls.getGroupBySkillIdAndAttackId(EditSkillManager.currSkill.id,EditSkillManager.currSkill.attackId);
			}else{
				currSkillSeqG = get_EditSkillProxy().skillSeq_ls.getGroupBySkillId(EditSkillManager.currSkill.id);
			}
			if(currSkillSeqG!=null){
				
				//addPlayer
				var attackInfo:AppResInfoItemVO = get_EditSkillProxy().resInfo_ls.getCloneResInfoItemById(currSkillSeqG.attackId);
				if(attackInfo.type == RoleEditManager.resType_monster){
					BattleContainer.instace.battleItemContainer.addMonster(attackInfo,true)
				}else{
					BattleContainer.instace.battleItemContainer.addPlayer(attackInfo,true)
					BattleContainer.instace.battleItemContainer.addArm(get_EditSkillProxy().resInfo_ls.getCloneResInfoItemById(currSkillSeqG.attackArmId),true)
				}
				var defendInfo:AppResInfoItemVO = get_EditSkillProxy().resInfo_ls.getCloneResInfoItemById(currSkillSeqG.defendId);
				if(defendInfo.type == RoleEditManager.resType_monster){
					BattleContainer.instace.battleItemContainer.addMonster(defendInfo,false)
				}else{
					BattleContainer.instace.battleItemContainer.addPlayer(defendInfo,false)
					BattleContainer.instace.battleItemContainer.addArm(get_EditSkillProxy().resInfo_ls.getCloneResInfoItemById(currSkillSeqG.defendArmId),false)
				}
					
				var attackPoint:SandyPoint;
				var defendPoint:SandyPoint;
					
				var n:int = EditSkillManager.row_ls.length;
				for(var i:int=0;i<n;i++)
				{
					var d:SandyData = EditSkillManager.row_ls[i] as SandyData;
					var row:int = int(d.getKey());
					var item:SkillSeqItemVO = currSkillSeqG.getItemByRow(row);
					if(item!=null){
						var b:Array = item.frame_ls;
						for(var j:int=0;j<b.length;j++)
						{
							var dd:ITimelineDataBase;
							if(row == EditSkillManager.row1 || row == EditSkillManager.row4){
								dd = new TimelineActionData();
							}else if(row == EditSkillManager.row2 || row == EditSkillManager.row5){
								dd = new TimelineMoveData();
								dd.isKey = true;
							}else if(row == EditSkillManager.row3 || row == EditSkillManager.row6){
								dd = new TimelineEffectData();
							}else if(row == EditSkillManager.row7){
								dd = new TimelineResData();
							}else if(row == EditSkillManager.row8){
								dd = new TimelineShakeData();
							}
							dd.row = row;
							dd.frame = String(b[j]).split("$")[0];
							dd.parser(String(b[j]).split("$")[1]);
							put(dd);
							
							if(row == EditSkillManager.row2){
								attackPoint = new SandyPoint(TimelineMoveData(dd).x,TimelineMoveData(dd).y);
							}else if(row == EditSkillManager.row5){
								defendPoint = new SandyPoint(TimelineMoveData(dd).x,TimelineMoveData(dd).y);
							}
						}
					}
				}
				
				BattleContainer.instace.battleItemContainer.attackPlayer.pixelLoc = attackPoint;
				BattleContainer.instace.battleItemContainer.defendPlayer.pixelLoc = defendPoint;
			}
		}
		
		/**
		 * 获取最后一帧
		 */ 
		public function getLastFrame(frame2:int=-1,row2:int=-1):int
		{
			var lastFrame:int;
			var n:int ;
			if(frame2 == -1){
				n = EditSkillManager.total_frames;
			}else{
				n = frame2;
			}
			for(var i:int=0;i<n;i++){
				var frame:int = i+1;
				var n2:int = EditSkillManager.row_ls.length;;
				for(var j:int=0;j<n2;j++)
				{
					var d:SandyData = EditSkillManager.row_ls[j] as SandyData;
					var row:int = int(d.getKey());
					if(row2 == -1){
						var rect:ITimelineDataBase = getDataBase(row,frame)
						if(rect != null && rect.isKey){
							lastFrame = frame;
						}
					}else if(row == row2){
						rect = getDataBase(row,frame)
						if(rect != null && rect.isKey){
							lastFrame = frame;
						}
					}
				}
			}
			
			return lastFrame;
		}
		
		public function save(endFrame:String):XML
		{
			if(EditSkillManager.currSkill == null) return null;
			//var x:XML = XML('<?xml version="1.0" encoding="UTF-8"?><l />');
			
			//技能队列
			var x1:XML = <i />
			//技能ID
			x1.@sid = EditSkillManager.currSkill.getSaveId()
			//攻击方
			//套装
			x1.@aid = BattleContainer.instace.battleItemContainer.attackPlayer.getResInfoItem().id;
			//武器
			if(BattleContainer.instace.battleItemContainer.attackPlayer is PlayerRole){
				x1.@amid = (BattleContainer.instace.battleItemContainer.attackPlayer as PlayerRole).arm.getResInfoItem().id;
			}
			//防御方
			x1.@did = BattleContainer.instace.battleItemContainer.defendPlayer.getResInfoItem().id;
			//武器
			if(BattleContainer.instace.battleItemContainer.defendPlayer is PlayerRole){
				x1.@dmid = (BattleContainer.instace.battleItemContainer.defendPlayer as PlayerRole).arm.getResInfoItem().id;
			}
			x1.@end = endFrame;
			//x.appendChild(x1);
			
			var n:int = EditSkillManager.row_ls.length;
			for(var i:int=0;i<n;i++)
			{
				var d:SandyData = EditSkillManager.row_ls[i] as SandyData;
				var a:Array = getRow(int(d.getKey()),true);
				var aa:Array = [];
				for(var j:int=0;j<a.length;j++)
				{
					var dd:ITimelineDataBase = a[j] as ITimelineDataBase;
					aa.push(dd.save());
				}
				if(!StringTWLUtil.isWhitespace(aa.join(","))){
					var x2:XML = <r />
					x2.@i = i+1;
					x2.@v = aa.join(",");
					x1.appendChild(x2);
				}
			}
			return x1;
		}
		
		private function get_EditSkillProxy():EditSkillProxy
		{
			return BattleContainer.instace.mediator.retrieveProxy(EditSkillProxy.NAME) as EditSkillProxy;
		}
	}
}