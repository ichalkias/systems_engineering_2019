0x0(~1): 0x24080258: addiu $t0,$zero,600   // the instructions @ 0x0 to 0x44
0x4(~1): 0x251C0000: addiu $gp,$t0,0       // initialize the global pointer
0x8(~1): 0x24080FFF: addiu $t0,$zero,4095  // $gp and the stack pointer $sp,
0xC(~1): 0x24094000: addiu $t1,$zero,16384 // and invoke the main procedure:
0x10(~1): 0x01090019: multu $t0,$t1        // $gp=600[0x258] which represents
0x14(~1): 0x00004012: mflo $t0             // the program break, that is,
0x18(~1): 0x00000000: nop                  // the first address after code,
0x1C(~1): 0x00000000: nop                  // strings, and global variables;
0x20(~1): 0x25083FFC: addiu $t0,$t0,16380  // $sp=mem[2^26-4] which is where
0x24(~1): 0x8D1D0000: lw $sp,0($t0)        // the loader stores the address
........: nop instructions removed         // of the top of the stack; and,
0x40(~1): 0x0C00005F: jal 0x5F[0x17C]      // finally, a jump to 0x17C which
0x44(~1): 0x00000000: nop                  // is where the code for main is.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x48(~1): 0x27BDFFFC: addiu $sp,$sp,-4 // push the result of main stored in $v0
0x4C(~1): 0xAFA20000: sw $v0,0($sp)    // onto the stack as argument for exit.
-------------------------------------------------------------------------------
0x50(~1): 0x8FA40000: lw $a0,0($sp)        // the exit procedure:
0x54(~1): 0x27BD0004: addiu $sp,$sp,4      // pop argument from the stack into
0x58(~1): 0x24020FA1: addiu $v0,$zero,4001 // $a0 as argument for exit system
0x5C(~1): 0x0000000C: syscall              // call identified by 4001.
-------------------------------------------------------------------------------
0x60(~1)-0x178(~1): unused library code removed
-------------------------------------------------------------------------------
0x17C(~4): 0x27BDFFFC: addiu $sp,$sp,-4 // the prologue of the main procedure:
0x180(~4): 0xAFBF0000: sw $ra,0($sp)    // save the link register containing
0x184(~4): 0x27BDFFFC: addiu $sp,$sp,-4 // the return address on the stack;
0x188(~4): 0xAFBE0000: sw $fp,0($sp)    // save the frame pointer on the stack;
0x18C(~4): 0x27BE0000: addiu $fp,$sp,0  // set frame pointer to new frame.
-------------------------------------------------------------------------------
0x190(~4): 0x24080000: addiu $t0,$zero,0 // the x = 0 assignment:
0x194(~4): 0xAF88FFFC: sw $t0,-4($gp)    // store 0 where x is in memory.
-------------------------------------------------------------------------------
0x198(~6): 0x8F88FFFC: lw $t0,-4($gp)    // the x = x + 1 assignment:
0x19C(~6): 0x24090001: addiu $t1,$zero,1 // load the value of x from memory,
0x1A0(~6): 0x01094021: addu $t0,$t0,$t1  // add 1 to it, and store the result
0x1A4(~6): 0xAF88FFFC: sw $t0,-4($gp)    // in memory where the value of x is.
-------------------------------------------------------------------------------
0x1A8(~8): 0x8F88FFFC: lw $t0,-4($gp)         // the if statement:
0x1AC(~8): 0x24090001: addiu $t1,$zero,1      // check if x == 1 by subtracting
0x1B0(~8): 0x01094023: subu $t0,$t0,$t1       // 1 from the value of x;
0x1B4(~8): 0x10080004: beq $zero,$t0,4[0x1C8] // after nop, if true, branch to
0x1B8(~8): 0x00000000: nop                    // true case, or else, continue
0x1BC(~8): 0x24080000: addiu $t0,$zero,0      // and load 0 into register $t0
0x1C0(~8): 0x10080002: beq $zero,$t0,2[0x1CC] // and then, after nop, branch to
0x1C4(~8): 0x00000000: nop                    // avoid true case; finally,
0x1C8(~8): 0x24080001: addiu $t0,$zero,1      // if true, load 1 into $t0.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x1CC(~8): 0x10080007: beq $zero,$t0,7[0x1EC] // after nop continue if true,
0x1D0(~8): 0x00000000: nop                    // or else, branch to false case.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x1D4(~9): 0x8F88FFFC: lw $t0,-4($gp)    // the true case of the if statement
0x1D8(~9): 0x24090001: addiu $t1,$zero,1 // implements x = x + 1 which is
0x1DC(~9): 0x01094021: addu $t0,$t0,$t1  // executed here because the if
0x1E0(~9): 0xAF88FFFC: sw $t0,-4($gp)    // condition evaluated to true.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x1E4(~11): 0x10000005: beq $zero,$zero,5[0x1FC] // after nop branch to the
0x1E8(~11): 0x00000000: nop          // while statement to avoid false case.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x1EC(~11): 0x8F88FFFC: lw $t0,-4($gp)   // the false case of the if statement:
0x1F0(~11): 0x24090001: addiu $t1,$zero,1 // implements x = x - 1 which is not
0x1F4(~11): 0x01094023: subu $t0,$t0,$t1  // executed here because the if
0x1F8(~11): 0xAF88FFFC: sw $t0,-4($gp)    // condition evaluated to true.
-------------------------------------------------------------------------------
0x1FC(~13): 0x8F88FFFC: lw $t0,-4($gp)         // the while statement:
0x200(~13): 0x24090000: addiu $t1,$zero,0      // check if x > 0; if true,
0x204(~13): 0x0128402A: slt $t0,$t1,$t0        // after nop execute the true
0x208(~13): 0x10080007: beq $zero,$t0,7[0x228] // case; if false, after nop
0x20C(~13): 0x00000000: nop                 // branch to the return statement.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x210(~14): 0x8F88FFFC: lw $t0,-4($gp)             // the true case of the
0x214(~14): 0x24090001: addiu $t1,$zero,1          // while statement:
0x218(~14): 0x01094023: subu $t0,$t0,$t1           // implements x = x - 1
0x21C(~14): 0xAF88FFFC: sw $t0,-4($gp)             // and then branches back
0x220(~16): 0x1000FFF6: beq $zero,$zero,-10[0x1FC] // to the while statement
0x224(~16): 0x00000000: nop                        // after executing the nop.
-------------------------------------------------------------------------------
0x228(~16): 0x8F88FFFC: lw $t0,-4($gp)     // the return statement:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
0x22C(~16): 0x00081021: addu $v0,$zero,$t0 // copy x from memory into the
0x230(~16): 0x0800008E: j 0x8E[0x238]      // the return register $v0 and
0x234(~16): 0x00000000: nop                // jump to epilogue after nop.
-------------------------------------------------------------------------------
0x238(~17): 0x27DD0000: addiu $sp,$fp,0 // the epilogue of the main procedure:
0x23C(~17): 0x8FBE0000: lw $fp,0($sp)   // deallocate local variables;
0x240(~17): 0x27BD0004: addiu $sp,$sp,4 // restore frame pointer from stack;
0x244(~17): 0x8FBF0000: lw $ra,0($sp)   // restore link register from stack;
0x248(~17): 0x27BD0004: addiu $sp,$sp,4 // and, finally, return to caller
0x24C(~17): 0x03E00008: jr $ra          // after executing the nop instruction
0x250(~17): 0x00000000: nop             // (here the program jumps to 0x48).