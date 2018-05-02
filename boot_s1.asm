;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Bootloader, Stage 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set the origin to 0x7c00
org 0x7c00

;; Setup the stack
mov sp, 0x7e0
mov ss, sp
mov sp, 0xfffe

;;;-----------------------------------------------------------------------------
;;; Begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Print the stage
;;;-----------------
  ;; Zero DS
  xor  ax, ax
  mov  ds, ax

  ;; Call print_str; DS:BX <- string address
  mov  bx, msg
  call print_str

;;; Reset the first disk
;;;----------------------
  mov  ah, 0x00
  mov  dl, 0x80  ; Drive number; bit 7 set for hard disk
  int  0x13

  ; Carry set on error
  jc  reset_failed

;;; Load the second sector of the disk into RAM at 0x7e00
;;;-------------------------------------------------------
  mov  ah, 0x02
  mov  al,    1  ; Sectors to read
  mov  cl, 0x02  ; High bits of cylinder number and sector number
  mov  ch, 0x00  ; Low bits of cylinder number
  mov  dh, 0x00  ; Head number
  mov  dl, 0x80  ; Drive number; bit 7 set for hard disk

;; Address is ES:BX; Zero out ES, set BX to 0x7e00
xor bx, bx
mov es, bx
mov bx, 0x7e00

; Try and Hope!
int 0x13

; Carry flag set on error
jc read_failed

; Worked, now Execute!
jmp 0x0000:0x7e00

reset_failed:
  ;; Call print_str; DS:BX -> string address
  ;; DS already zero
  mov  bx, reset_error_msg
  call print_str

  ; Hang
  jmp hang

read_failed:
  ;; Call print_str; DS:BX -> string address
  ;; DS already zero
  mov  bx, read_error_msg
  call print_str

  ; Hang
  jmp hang

hang:
  jmp hang

;;;-----------------------------------------------------------------------------
;;; Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

            msg:  db                     "Stage 1", 0x0d, 0x0a, 0x00
reset_error_msg:  db      "Unable to reset drive!", 0x00
 read_error_msg:  db  "Failed to read from drive!", 0x00

;;;-----------------------------------------------------------------------------
;;; Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "util/IO.asm"

;;;-----------------------------------------------------------------------------
;;; Align to 512 bytes and add boot signature
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

times (510-($-$$)) db 0x00
dw 0xaa55
