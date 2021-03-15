ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"

if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A	_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}

pepex := 960		;PoeHeight/2 人物不動座標 螢幕寬 x*0.5 極限移動距離x (988-934)	螢幕寬/2
pepey := 486		


		;PixelSearch, tagX, tagY, 1642, 7, 1912, 277, 0x223452, 1, Fast
F5::
loop
{
sleep 50
Mousegetpos, x, y
	PixelSearch, px, py, 1642, 7, 1912, 277, 0B0A22, 0, Fast 
	ToolTip, x%x%`y%y%` `npx%px%`py%py%
}

return
F6::Pause

;1642, 7, 1912, 277, 0x885050 0xF99696


	;PixelSearch, px, py, 1640,7, 1910,277, 0xF3C410,3, Fast ;搜尋傳送門點擊
	;PixelSearch, px, py, 136, 117, 1670, 910, 0xD7E4E5, 3, Fast ;;搜尋任務
		;PixelSearch, px, py, 136, 117, 1670, 910, 0xC5DFE6, 3, Fast ;;搜尋任務