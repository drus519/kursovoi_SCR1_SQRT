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
        
#define TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_1  nop; TEST_INSERT_NOPS_0
#define TEST_INSERT_NOPS_2  nop; TEST_INSERT_NOPS_1



#define TEST_SQRT_DEST_BYPASS( testnum, nop_cycles, inst, result, val1 ) \
    TEST_CASE( testnum, x3, result, \
      li  x6, 0; \
1:    li  x1, MASK_XLEN(val1); \
      inst;\
      TEST_INSERT_NOPS_ ## nop_cycles \
      addi  x28, x3, 0; \
      addi  x6, x6, 1; \
      li  x7, 2; \
      bne x6, x7, 1b \
    )

    
#define TEST_SQRT_SCR1_BYPASS( testnum, nop_cycles, inst, result, val1 ) \
    TEST_CASE( testnum, x3, result, \
      li  x6, 0; \
1:    li  x1, MASK_XLEN(val1); \
      TEST_INSERT_NOPS_ ## nop_cycles \
      inst ;            \
      addi  x6, x6, 1; \
      li  x7, 2; \
      bne x6, x7, 1b \
    )

    

RVTEST_RV32U
RVTEST_CODE_BEGIN

#-------------------------------------------------------------
# Arithmetic tests begin
#-------------------------------------------------------------

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

#-------------------------------------------------------------
# Arithmetic tests end
#-------------------------------------------------------------

#-------------------------------------------------------------
# Bypassing tests begin 
#-------------------------------------------------------------
  
  li x4, 0xFFFFFFFF;
  
  TEST_SQRT_DEST_BYPASS( 10, 0, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );
  TEST_SQRT_DEST_BYPASS( 11, 1, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );
  TEST_SQRT_DEST_BYPASS( 12, 2, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );

  TEST_SQRT_SCR1_BYPASS( 13, 0, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );
  TEST_SQRT_SCR1_BYPASS( 14, 1, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );
  TEST_SQRT_SCR1_BYPASS( 15, 2, INST_SQRT(3, 4), 0xFFFF, 0xFFFFFFFF );

#-------------------------------------------------------------
# Bypassing tests end
#-------------------------------------------------------------

TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

TEST_DATA

RVTEST_DATA_END
