;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; IO utilities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%ifndef _IO_ASM
%define _IO_ASM 1

;;;;----------------------------------------------------------------------------
;;;; Includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "util/BIOS.asm"

;;;;----------------------------------------------------------------------------
;;;; Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Prints a null-terminated string
;;;---------------------------------
;;;   DS:BX <- string address
;;;---------------------------
print_str:
  ;; Save registers
  push ax
  push bx

  ;; Print the string
  .loop:
    mov ah, BYTE [ds:bx]  ; For efficiency
    cmp ah, 0x00          ; Check if we've finished
    jz .end               ; Yep, done
    
    ;; Call print_char
    mov al, ah
    call print_char

    ;; Advance to next character
    inc bx 
    jmp .loop
  .end:

  ;; Restore registers
  pop bx
  pop ax

  ret

;;; Number of digits
;;;------------------
;;;   AX <- num
;;;   CX <- digits
;;;----------------
_num_digits:
  ;; If it's less than 10, then there can only be 1 digit.
  mov cx, 1
  cmp ax, 10
  jl .end

  ;; Similarly for 100
  inc cx
  cmp ax, 100
  jl .end

  ;; And therefore anything else must be 3
  inc cx

  .end:
    ret

;;; Print an unsigned integer
;;;---------------------------
;;;   AX <- num
;;;   DS:BX <- place with free 4 bytes
;;;
;;;   Mutilates BX
;;;------------------------------------
print_int:
  ;; Save registers
  push bp
  mov bp, sp
  push dx
  push ax
  push di

  ;; Get last digit
  mov di, 10
  div di

  mov BYTE [ds:bx+2], dl    ; Store in buffer
  mov di, ax                ; Save
  mov ax, WORD [bp+2]       ; Restore value

  ;; Call _num_digits
  call _num_digits          ; How many are there? (returns at most 3)
  mov BYTE [ds:bx+3], 0x00  ; Needs to go here eventually

  cmp cx, 1
  je .one

  cmp cx, 2
  je .two

  jmp .three

  .one:
    add bx, 2
    jmp .end

  .two:
    mov ax, di
    mov BYTE [ds:bx+1], al
    inc bx
    jmp .end

  .three:
    mov ax, di
    mov di, 10
    div di
    mov BYTE [ds:bx+1], dl
    mov BYTE [ds:bx], al
    jmp .end

  .end:
    call print_str

    pop di 
    pop ax
    pop dx
    pop bp

    ret

%endif ; _IO_ASM defined

