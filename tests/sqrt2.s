#include "riscv_macros.h"
#include "riscv_test.h"
#include "test_macros.h"
//0xFE001013
#define SQRT_OPCODE 0xFE001013
#define RD_SHIFT 7
#define RD_MASK (0xF << RD_SHIFT)
#define RS1_SHIFT 15
#define RS1_MASK (0xF << RS1_SHIFT)

#define SEXT_IMM(x) ((x) | (-(((x) >> 11) & 1) << 11))

/* rd, rs1 - integer registers num 0-31, imm (alwZERO) */
#define INST_SQRT(rd, rs1, imm) \
.word (SQRT_OPCODE | ((rd) << RD_SHIFT & RD_MASK) | \
((rs1) << RS1_SHIFT & RS1_MASK))

/* TEST_IMM_OP( testnum, inst, result, val1, imm ) */

_start:

li x1, 0xFFFFFFFF
TEST_IMM_OP(1, INST_SQRT(2, 1, 0x0), 0xFFFF, 1, 0x0); // max val
li x1, 0xFFFFFFFE
TEST_IMM_OP(2, INST_SQRT(2, 1, 0x0), 0xFFFF, 1, 0x0); // max val-1
li x1,0xFFFFFFFD
TEST_IMM_OP(3, INST_SQRT(2, 1, 0x0), 0xFFFF, 1, 0x0); // max val-2
li x1, 0x0
TEST_IMM_OP(4, INST_SQRT(2, 1, 0x0), 0x0, 1, 0x0); // val 0

li x1, 0x1
TEST_IMM_OP(5, INST_SQRT(2, 1, 0x0), 1, 1, 0x0); // val 1
li x1, 0x2
TEST_IMM_OP(6, INST_SQRT(2, 1, 0x0), 1, 1, 0x0); // val 2
li x1, 0x3
TEST_IMM_OP(7, INST_SQRT(2, 1, 0x0), 1, 1, 0x0); // val 3
li x1, 0x4
TEST_IMM_OP(8, INST_SQRT(2, 1, 0x0), 2, 1, 0x0); // val 4

li x1, 0xA9
TEST_IMM_OP(9, INST_SQRT(2, 1, 0x0), 13, 1, 0x0); // val 169
