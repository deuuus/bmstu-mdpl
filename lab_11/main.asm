.386
.model flat, stdcall
option casemap :none
 
include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32, user32, masm32, comctl32
 
WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD ;объявление функции
 
LAB_11 = 1000 ;некоторые переменные из .rc файла
BTN_0 = 1006
ENTRY_1 = 1001
ENTRY_2 = 1002
BTN_2 = 1015
BTN_3 = 1008
BTN_4 = 1009
BTN_5 = 1010
BTN_6 = 1011
BTN_7 = 1012
BTN_8 = 1013
BTN_1 = 1007
BTN_9 = 1014
BTN_CLC = 1003
RES = 1005


.data
  id dd 0
  edit_id dd 1001
 
.data?
  hInstance dd ?
  icce INITCOMMONCONTROLSEX <> 

 
.code
  start:
    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX
    mov icce.dwICC, ICC_DATE_CLASSES or \
                    ICC_INTERNET_CLASSES or \
                    ICC_PAGESCROLLER_CLASS or \
                    ICC_COOL_CLASSES
 
    invoke InitCommonControlsEx, offset icce
 
    invoke GetModuleHandle, NULL
    mov hInstance, eax
 
    invoke DialogBoxParam, hInstance, LAB_11, 0, offset WndProc, 0
 
    invoke ExitProcess, eax
 
WndProc proc hWin :DWORD, uMsg :DWORD, wParam :DWORD, lParam :DWORD
  switch uMsg
    case WM_COMMAND
      mov ebx, wParam 
      xor edx, edx
      mov dx, bx
      mov id, edx
      switch id

        case ENTRY_1
          mov edit_id, ENTRY_1
        case ENTRY_2
          mov edit_id, ENTRY_2

        case BTN_CLC
          invoke GetDlgItemInt, hWin, ENTRY_1, 0, FALSE
          .if eax < 0 || eax > 10 
            invoke MessageBox, hWin, chr$("Input a digit."), chr$("ERROR"), 0
            xor eax, eax
            ret
          .endif
          mov ebx, eax 

          invoke GetDlgItemInt, hWin, ENTRY_2, 0, FALSE
          .if eax < 0 || eax > 10 
            invoke MessageBox, hWin, chr$("Input a digit."), chr$("ERROR"), 0
            xor eax, eax
            ret
          .endif

          add eax, ebx

          invoke SetDlgItemInt, hWin, RES, eax, FALSE

      endsw

    case WM_CLOSE
      exit_program:
      invoke EndDialog, hWin, 0
  endsw
 
  xor eax, eax
ret
WndProc ENDP
 
end start