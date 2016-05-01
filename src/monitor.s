; ------------------------------------------------------------
;Secure Monitor
;
; Implement a basic monitor
; ------------------------------------------------------------

  PRESERVE8

  AREA  Monitor_Code, CODE, ALIGN=5, READONLY

  ; Defines used in the code
Mode_MON            EQU   0x16
Mode_SVP            EQU   0x13
NS_BIT              EQU   0x1

  ENTRY

; ------------------------------------------------------------
; Monitor mode vector table
; ------------------------------------------------------------

  EXPORT monitor
monitor

  ; Monitor's
  NOP     ; Reset      - not used by Monitor
  NOP     ; Undef      - not used by Monitor
  B       SMC_Handler
  NOP     ; Prefetch   - can by used by Monitor
  NOP     ; Data abort - can by used by Monitor
  NOP     ; RESERVED
  NOP     ; IRQ        - can by used by Monitor
  NOP     ; FIQ        - can by used by Monitor

; ------------------------------------------------------------
; SMC Handler
;
; - Detect which world executed SMC
; - Saves state to appropiate stack
; - Restores other worlds state
; - Switches world
; - Performs exception return
; ------------------------------------------------------------

  EXPORT SMC_Handler
SMC_Handler
  PUSH   {r0-r3}                       ; R0-r3 contain args to be passed between worlds
                                       ; Temporarily stack, so can be used as scratch regs

  ; Which world have we come from
  ; ------------------------------
  MRC     p15, 0, r0, c1, c1, 0        ; Read Secure Configuration Register data
  TST     r0, #NS_BIT                  ; Is the NS bit set?
  EOR     r0, r0, #NS_BIT              ; Toggle NS bit
  MCR     p15, 0, r0, c1, c1, 0        ; Write Secure Configuration Register data


  ; Load save to pointer
  ; ---------------------
  LDREQ   r0, =S_STACK_SP             ; If NS bit set, was in Normal world.  So restore Secure state
  LDRNE   r0, =NS_STACK_SP
  LDR     r2, [r0]

  ; Load restore from pointer
  ; --------------------------
  LDREQ   r1, =NS_STACK_SP
  LDRNE   r1, =S_STACK_SP
  LDR     r3, [r1]

  ; r2  <-- save to
  ; r3  <-- restore from

  ; Save general purpose registers, SPSR and LR
  ; --------------------------------------------
  STMFD   r2!, {r4-r12}               ; Save r4 to r12
  ; ADD SUPPORT FOR SPs
  MRS     r4, spsr                    ; Also get a copy of the SPSR
  STMFD   r2!, {r4, lr}               ; Save original SPSR and LR

  STR     r2, [r0]                    ; Save updated pointer back, r0 and r2 now free

  ; Restore other world's registers, SPSR and LR
  ; ---------------------------------------------
  LDMFD   r3!, {r0, lr}               ; Get SPSR and LR from
  ; ADD SUPPORT FOR SPs
  MSR     spsr_cxsf, r0               ; Restore SPSR
  LDMFD   r3!, {r4-r12}               ; Restore registers r4 to r12

  STR     r3, [r1]                    ; Save updated pointer back, r1 and r3 now free

  ; Clear local monitor
  ; --------------------
  CLREX                               ; Not strictly required in this example, as not using LDREX/STREX
                                      ; However, architecturally should execute CLREX on a context switch

  ; Now restore args (r0-r3)
  ; -------------------------
  POP     {r0-r3}


  ; Perform exception return
  ; -------------------------
  MOVS    pc, lr

; ------------------------------------------------------------
; Monitor Initialization
;
; This is called the first time the Secure world wishes to
; move to the Normal world.
; ------------------------------------------------------------

  EXPORT monitorInit
monitorInit
  ; Install Secure Monitor
  ; -----------------------
  LDR     r0, =monitor                 ; Get address of Monitor's vector table
  MCR     p15, 0, r0, c12, c0, 1       ; Write Monitor Vector Base Address Register

  ; Save Secure state
  ; ------------------
  LDR     r0, =S_STACK_LIMIT          ; Get address of Secure state stack
  STMFD   r0!, {r4-r12}               ; Save general purpose registers
  ; ADD support for SPs
  MRS     r1, cpsr                    ; Also get a copy of the CPSR
  STMFD   r0!, {r1, lr}               ; Save CPSR and LR


  ; Switch to Monitor mode
  ; -----------------------
  CPS     #Mode_MON                   ; Move to Monitor mode after saving Secure state


  ; Save Secure state stack pointer
  ; --------------------------------
  LDR     r1, =S_STACK_SP              ; Get address of global
  STR     r0, [r1]                     ; Save pointer
  

  ; Set up initial NS state stack pointer
  ; --------------------------------------
  LDR     r0, =NS_STACK_SP             ; Get address of global
  LDR     r1, =NS_STACK_LIMIT          ; Get top of Normal state stack (assuming FD model)
  STR     r1, [r0]                     ; Save pointer


  ; Set up execption return information
  ; ------------------------------------
  IMPORT  ns_image
  LDR     lr, =ns_image
  MSR     spsr_cxsf, #Mode_SVP         ; Set SPSR to be SVC mode


  ; Switch to Normal world
  ; -----------------------
  MRC     p15, 0, r4, c1, c1, 0        ; Read Secure Configuration Register data
  ORR     r4, #NS_BIT                  ; Set NS bit
  MCR     p15, 0, r4, c1, c1, 0        ; Write Secure Configuration Register data


  ; Clear general purpose registers
  ; --------------------------------
  MOV     r0,  #0
  MOV     r1,  #0
  MOV     r2,  #0
  MOV     r3,  #0
  MOV     r4,  #0
  MOV     r5,  #0
  MOV     r6,  #0
  MOV     r7,  #0
  MOV     r8,  #0
  MOV     r9,  #0
  MOV     r10, #0
  MOV     r11, #0
  MOV     r12, #0

  MOVS    pc, lr


; ------------------------------------------------------------
; Space reserved for stacks
; ------------------------------------------------------------

  AREA  Monitor_Data, DATA, ALIGN=8, READWRITE

NS_STACK_BASE
  DCD     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
NS_STACK_LIMIT

S_STACK_BASE
  DCD     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
S_STACK_LIMIT

NS_STACK_SP
  DCD     0

S_STACK_SP
  DCD     0


  END

; ------------------------------------------------------------
; End
; ------------------------------------------------------------
