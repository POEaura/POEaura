ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}
;F5開始
;F6暫停

pepex := 960	;角色不移動的座標 X
pepey := 486	;角色不移動的座標 Y

F7::
send {t}
mouseclick,left
YdownA := 1
return

F6::Pause

F9::
;開啟所有光環 
send {x}
sleep 200
send {6}{7}{8}
sleep 100
send {9}{0}{q}
sleep 100
send {w}{e}
sleep 100
send {r}{t}
sleep 100
send {x}
sleep 200
send {6}{7}{8}
sleep 100
send {9}{0}
return

F5::
SetTimer, flask1, 2150
SetTimer, flask2, 2250
SetTimer, flask3, 2300
SetTimer, flask4, 2400
SetTimer, flask5, 2550
SetTimer, skillR, 2050 ;瓦爾迅捷 {R}
SetTimer, skillw, 250 ;雷鳴重擊 {w}

SetTimer, invite, 1100 ;邀請
SetTimer, skillup, 2100 ;技能升級
SetTimer, death,1200 ;死亡回歸
SetTimer, party,2000 ; 邀請入組
SetTimer, dash,500 ; 幻步 {E}
SetTimer, sendt,2000 ; 距離過遠 按T
SetTimer, move,500 ;移動腳腳 {T}

;SetTimer,filter,300 ;
aurabot:

mousemove,pepex,pepey 

loop
{
	sleep 12
	PixelSearch, Pxx, Pyy, 1642, 7, 1912, 277, 0x885050, 0, Fast ;跟隨隊長
	if (Pxx>0 or Pyy>0)
	{
  		Mx := (Pxx-1777)*7+pepex-60
		My := (Pyy-142)*7+pepey+90
		if (Mx < 420)  Mx := Max(Mx,420)
		if (Mx > 1500) Mx := Min(Mx,1500)
		if (My < 100) My := Max(My,100)
		if (My > 900) My := Min(My,900)
		Mousemove,Mx,My,0
} else {
	sleep 40
		Gosub, orange
	}
}
return

move:
if (Pxx>0)
{
	if (YdownA = 1)
	{
		YdownA := 0
		send {t down}
	}
} else {
	if (YdownA = 0)
	{
		send {t}
		YdownA := 1
	}
}
return


death:
PixelSearch, deathAX, deathAY, 899, 222, 961, 240, 0x124A77, 0, Fast ; 死亡回歸
if (deathAX>0)
{
	PixelSearch, deathx, deathy, 846, 307, 1070, 330, 0x76C0FE, 0, Fast ; 死亡回歸
	if (deathx>0)
	{
		Mouseclick, left, deathx, deathy
		sleep 2000
	} else { 
		PixelSearch, deathx, deathy, 837, 260, 1097, 352, 0x76C0FE, 0, Fast ; 死亡回歸
		if (deathx>0)
		{
			Mouseclick, left, deathx, deathy
			sleep 2000
		}
	}	
}
return

party:
PixelSearch, leaderX,leaderY, 100, 100, 240, 588, 0x165587, 0, Fast ;隊長 id 是不是褐色 是的話還在地圖內跳離
if (leaderY < 0)
{

	PixelSearch, partyx, partyy, 1, 215, 30, 584, 0x69321A, 3, Fast 
	if(partyx > 0)
	{
		MouseClick, left, partyx, partyy
		sleep 50
		MouseMove,pepex,pepey
	}

	PixelSearch, spawnx, spawny, 974, 463, 1191, 614, 0x76C0FE, 3, Fast ;搜尋確認 
	if(spawnx > 0)
	{
		sleep 50
		Mouseclick, left, spawnx, spawny
	}

}
return


leader:
PixelSearch, leaderX,leaderY, 100, 100, 240, 588, 0x165587, 0, Fast ;隊長 id 是不是褐色 是的話還在地圖內跳離
if (leaderY < 0)
{
	Gosub, party
	SetTimer,leader,Off
}
return


invite:
PixelSearch, invx, invy, 1550, 753, 1750, 823, 0x76C0FE, 3, Fast ;邀請入組
if (invx > 0) 
{
	if (Pxx<0)
	{
		Mouseclick, left, invx, invy
	}
}
return

skillup:
PixelSearch, skillupx, skillupy, 1800, 283, 1879, 351, 0x053576, 3,Fast ;自動升級技能
if (skillupx >0)
{
	mouseclick , left, skillupx, skillupy
}
return

filter: ;自動撿物品 篩選器盡量嚴格一點
loop
{
	PixelSearch, filterX, filterY, 1642, 7, 1912, 277, 0x867DFF, 3, Fast ;小地圖搜索通貨
	if (filterX>0) 
	{
		SetTimer,aurabot,Off
		{
			filterMx := (filterX-1777)*4*2+pepex
  			filterMy := (filterY-142)*4*2+pepey
			Mousemove, filterMx, filterMy
			send {t}
			sleep 50
		}
	PixelSearch, filterPx, filterPy, filterMx-100, filterMy-100, filterMx+100,filterMy+100, 0x9F00FF, 3, Fast ;螢幕上小範圍通貨
	if (filterPx>0) 
		{
			Mouseclick, left, filterPx, filterPy
		}
	} else {
	SetTimer,aurabot,On
	return
	}	
}
return

;PixelSearch, questX, questY, 447, 117, 1670, 910, 0x35E647, 1, Fast ;;搜尋任務
;if (questX>0)
;	{
;		Gosub, quest
;	}


quest:
PixelSearch, questX, questY, 447, 117, 1670, 910, 0x35E647, 1, Fast ;;搜尋任務
if (questX>0)
{ 
	loop
	{
		PixelSearch, questX, questY, 447, 117, 1670, 910, 0x35E647, 1, Fast ;;搜尋任務
		if (questX>0) 
	{
		Mouseclick, Left, questX, questY
	} else {
		return
		}
	}
}
return

orange:
loop {
PixelSearch, Pxx, Pyy, 1642, 7, 1912, 277, 0x885050, 3, Fast
if (Pxx>0)
{
	return
}
	
	PixelSearch, D9X, D9Y, 1672, 37, 1882, 247, 0x2877D9, 3, Fast ;小地圖橘色門位置
	if (D9X>0)
	{
		PixelSearch, D9conX, D9conY, 1777-50, 142-50, 1777+50, 142+50, 0x2877D9, 3, Fast 
		if (D9conX > 0)
		{
		D9X := D9conX
		D9Y := D9conY
		 PixelSearch, D9conAX, D9conAY, 1777-30, 142-30, 1777+30, 142+30, 0x2877D9, 3, Fast 
			if (D9conAX > 0)
			{
			D9X := D9conAX
			D9Y := D9conAY
			 PixelSearch, D9conBX, D9conBY, 1777-20, 142-18, 1777+20, 142+20, 0x2877D9, 3, Fast 
				if (D9conBX > 0)
				{
				D9X := D9conBX
				D9Y := D9conBY
				PixelSearch, D9conCX, D9conCY, 1777-10, 142-8, 1777+10, 142+10, 0x2877D9, 3, Fast 
					if (D9conCX > 0)
					{
					D9X := D9conCX
					D9Y := D9conCY	
					}
				}
			}
		
	}
	D9MVX := (D9X-1777)*4*2+pepex
	D9MVY := (D9Y-142)*4*2+pepey+10
	if (D9MVX < 420) D9MVX := Max(D9MVX,420)
	if (D9MVX > 1500) D9MVX := Min(D9MVX,1500)
	if (D9MVY < 100) D9MVY := Max(D9MVY,100)
	if (D9MVY > 900) D9MVY := Min(D9MVY,900)
	MouseMove, D9MVX, D9MVY
	send {t}
	PixelSearch, Pxx, Pyy, 1642, 7, 1912, 277, 0x885050, 3, Fast
	if (Pxx>0) 
	{
		return
	}	
	if(D9MVX>pepex-100 and D9MVX<pepex+100 and D9MVY>pepey-100 and D9MVY<pepey+100)
	{
		Mouseclick,left,D9MVX,D9MVY
	}
} else {
	Gosub, delvept
	return
	}
}
return

delvept:
loop
{
	PixelSearch, Pxx, Pyy, 1642, 7, 1912, 277, 0x885050, 3, Fast
	if (Pxx>0)
	{
		return
	}

	PixelSearch, delveX, delveY, 1675, 40, 1880,240, 0x0020FC, 5, Fast ;挖礦門
	if(delveX>0)
	{
		Dx := (delveX-1777)*4*2+pepex
		Dy := (delveY-142)*4*2+pepey
		if (Dx < 420)  Dx := Max(Dx,420)
		if (Dx > 1500) Dx := Min(Dx,1500)
		if (Dy < 100) Dy := Max(Dy,100)
		if (Dy > 900) Dy := Min(Dy,900)
		MouseMove,Dx,Dy
		send {t}	
		if(Dx>pepex-100 and Dx<pepex+100 and Dy>pepey-100 and Dy<pepey+100)
		{
			Mouseclick,left,Dx,Dy
		}
	} else {

	PixelSearch, Pxx, Pyy, 1642, 7, 1912, 277, 0x885050, 3, Fast
	if (Pxx>0)
	{
		return
	}

	PixelSearch, PortalX, PortalY,1640, 7, 1910,277, 0xF9F2E9, 3, Fast
	if(PortalX>0)
	{
		PortalX := (PortalX-1777)*4*2+pepex
		PortalY := (PortalY-142)*4*2+pepey
		if (PortalX < 420)  PortalX := Max(PortalX,420)
		if (PortalX > 1500) PortalX := Min(PortalX,1500)
		if (PortalY < 100) PortalY := Max(PortalY,100)
		if (PortalY > 900) PortalY := Min(PortalY,900)
		mousemove, PortalX,  PortalY
		send {t}
		if(PortalX>pepex-100 and PortalX<pepex+100 and PortalY>pepey-100 and PortalY<pepey+100)
		{
			mouseclick, left, PortalX,  PortalY
		}
	} else {
	return
	}

	}
}
return



flask1:
if (Pxx>0)
{
	send {1}
}
return

flask2:
if (Pxx>0)
{
	send {2}
}
return

flask3:
if (Pxx>0)
{
	send {3}
}
return

flask4:
if (Pxx>0)
{
	send {4}
}
return

flask5:
if (Pxx>0)
{
	send {5}
}
return

skillR:
if (Pxx>0)
{
	send {r}
}
return


skillw:
if (Pxx>0)
{
	MouseGetPos, xposA, yposA
	if (xposA>900 and xposA<1020 and yposA>446 and yposA<506) ;雷鳴重擊
	{
		send {w}
	}
}
return


dash:
MouseGetPos, xpos, ypos 
if (xpos<760 or xpos>1160 or ypos<286 or ypos>686) ;移動距離過遠施放位移
{
	send {e}
}

return



sendt:
MouseGetPos, xpos, ypos
if (Pxx>0)
{
	if (xpos<760 or xpos>1160 or ypos<286 or ypos>686) ;t 移動
	{
		YdownA := 1
		send {t}
	}
}
return
