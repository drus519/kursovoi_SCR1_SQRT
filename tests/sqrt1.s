#include "riscv_macros.h"
#include "test_macros.h"

#define SQRT_OPCODE 0xFE001013
#define RD_SHIFT 7
#define RD_MASK (0xF << RD_SHIFT)
#define RS1_SHIFT 15
#define RS1_MASK (0xF << RS1_SHIFT)

#define INST_SQRT(rd, rs1, imm) \
.word (SQRT_OPCODE | ((rd) << RD_SHIFT & RD_MASK) | ((rs1) << RS1_SHIFT & RS1_MASK))

_start:
	li x1, 0xFFFFFFFF;
	#li x2, 0xFE009113; # sqrt x2,x1,0
	#TEST_IMM_OP( 2,  addi, 0x00000000, 0x00000000, 0x000 );
	
	TEST_IMM_OP(1, 0xFE009113, 0xFFFF, 1, 0x0); #sqrt x2,x1,0, op1=0xFFFFFFFF, sqrt(0xFFFFFFFF) = 0xFFFF
  