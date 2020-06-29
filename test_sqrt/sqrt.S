#include "riscv_test.h"
#include "riscv_macros.h"
#include "test_macros.h"

#define SQRT_OPCODE 0xFE001013
#define RD_SHIFT 7
#define RD_MASK (0xF << RD_SHIFT)
#define RS1_SHIFT 15
#define RS1_MASK (0xF << RS1_SHIFT)

#define INST_SQRT(rd, rs1) \
.word (SQRT_OPCODE | ((rd) << RD_SHIFT & RD_MASK) | ((rs1) << RS1_SHIFT & RS1_MASK))

#define TEST_IMM_OP_SQRT( testnum, inst, result, val1) \
    TEST_CASE( testnum, x3, result, \
      li  x1, MASK_XLEN(val1); \
      inst ; \
    )

RVTEST_RV32U
RVTEST_CODE_BEGIN

li x4, 0xFFFFFFFF;
TEST_IMM_OP_SQRT( 1, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF); // max val

li x4, 0xFFFFFFFE
TEST_IMM_OP_SQRT( 2, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFE); // max val-1

li x4,0xFFFFFFFD
TEST_IMM_OP_SQRT( 3, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFD); // max val-2

li x4, 0x0
TEST_IMM_OP_SQRT( 4, INST_SQRT(3, 4), 0x0, 0x0); // val 0

li x4, 0x1
TEST_IMM_OP_SQRT( 5, INST_SQRT(3, 4), 0x1, 0x1); // val 1

li x4, 0x2
TEST_IMM_OP_SQRT( 6, INST_SQRT(3, 4), 0x1, 0x2); // val 2

li x4, 0x3
TEST_IMM_OP_SQRT( 7, INST_SQRT(3, 4), 0x1, 0x3); // val 3

li x4, 0x4
TEST_IMM_OP_SQRT( 8, INST_SQRT(3, 4), 0x2, 0x4); // val 4

li x4, 0xA9
TEST_IMM_OP_SQRT( 9, INST_SQRT(3, 4), 13, 0xA9); // val 169

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

TEST_DATA

RVTEST_DATA_END
