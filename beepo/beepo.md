## Registers

| Name  | Width | Purpose           | Starts At |
| ---   | ---   | ---               | ---       |
| PC    | 12    | Program counter   | 0x000     |

## Opcode Structure

| Opcode    | Meaning                   |
| ---       | ---                       |
| zzz00000  | No arguments              |
| zzzzz100  | One immediate argument    |


## Opcodes

### nop

Does nothing

| Arguments | Opcode    | Bytes |
| ---       | ---       | ---   |
|           | 0x00      | 1     |

### jmp

Changes PC to a new value

| Arguments | Opcode    | Bytes |
| ---       | ---       | ---   |
| imm       | 0x14      | 2     |

### \[TEMP] wait

Sleeps for 300ms

| Arguments | Opcode    | Bytes |
| ---       | ---       | ---   |
|           | 0x20      | 1     |

### \[TEMP] showhi

Sets the high byte to be displayed

| Arguments | Opcode    | Bytes |
| ---       | ---       | ---   |
| imm       | 0xF4      | 2     |

### \[TEMP] showlo

Sets the low byte to be displayed

| Arguments | Opcode    | Bytes |
| ---       | ---       | ---   |
| imm       | 0xFB      | 2     |