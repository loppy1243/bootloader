;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Interfaces to BIOS interrupts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%ifndef _BIOS_IO_ASM
%define _BIOS_IO_ASM 1

;;;;----------------------------------------------------------------------------
;;;; Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Prints a character
;;;--------------------
;;;   AL <- character
;;;-------------------
print_char:
  ;; Save registers
  push ax
  push bx

  ;; BIOS call
  mov ah, 0x0e
  mov bx, 0x00 
  int 0x10

  ;; Restore registers
  pop bx
  pop ax

  ret

%endif ; _BIOS_IO_ASM defined
