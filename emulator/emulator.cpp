#include <iostream>
#include <fstream>
#include <bitset>
#include <iomanip>
using namespace std;
#define ADD 1
#define SUB 2
#define ADDI 3
#define AND 4
#define OR 5
#define XOR 6
#define BLT 7
#define BEQ 8
#define JAL 9
#define SLL 10
#define SRL 11
#define LW 12
#define SW 13
#define OP 0
#define RD 1
#define RS1 2
#define RS2 3
#define IMME 4
void RISC_V_parser(signed int*, int**);
void RISC_V_arithmetic_parser(signed int* instruction, int** descriptor);
void RISC_V_imme_arithmetic_parser(signed int* instruction, int** descriptor);
void RISC_V_conditional_jmp_parser(signed int* instruction, int** descriptor);
void RISC_V_unconditional_jmp_parser(signed int* instruction, int** descriptor);
void RISC_V_load_parser(signed int* instruction, int** descriptor);
void RISC_V_store_parser(signed int* instruction, int** descriptor);
void RISC_V_add(signed int*, signed int*, signed int*);
void RISC_V_sub(signed int*, signed int*, signed int*);
void RISC_V_addi(signed int*, signed int*, signed int);
void RISC_V_and(signed int*, signed int*, signed int*);
void RISC_V_or(signed int*, signed int*, signed int*);
void RISC_V_xor(signed int*, signed int*, signed int*);
void RISC_V_blt(unsigned int*, signed int*, signed int*, signed int);
void RISC_V_beq(unsigned int*, signed int*, signed int*, signed int);
void RISC_V_jal(unsigned int*, signed int);
void RISC_V_sll(signed int*, signed int*, signed int*);
void RISC_V_srl(signed int*, signed int*, signed int*);
void RISC_V_lw(signed int*, signed int, signed int*);
void RISC_V_sw(signed int*, signed int, signed int*);
signed int IO_inst_ram_read(unsigned int);
signed int IO_data_ram_read(signed int);
void IO_data_ram_write(signed int, signed int);
void DEBUG_print_all(signed int ** RF, unsigned int * pc, signed int * instruction, signed int ** descriptor){
  cout<<"Register files are:\n";
  for(int m = 0; m <= 7; ++m){
    for (int i = 0; i <= 3; ++i) {
      cout << "x" << setw(2) << left << i + m*4 << " = " << setw(10) << *RF[i+m*4] << " | ";
    }
    cout<<"\n";
  }
  cout<<"PC is: "<<hex<<(*pc)<<dec<<"\n";
  cout<<"Previous instruction is: "<<bitset<32>(*instruction)<<"\n";
  cout<<"Instruction type is: ";
  switch (*descriptor[OP]){
  case ADD: cout<<"ADD"<<"\n"; break;
  case SUB: cout<<"SUB"<<"\n"; break;
  case ADDI: cout<<"ADDI"<<"\n"; break;
  case AND: cout<<"AND"<<"\n"; break;
  case OR: cout<<"OR"<<"\n"; break;
  case XOR: cout<<"XOR"<<"\n"; break;
  case BLT: cout<<"BLT"<<"\n"; break;
  case BEQ: cout<<"BEQ"<<"\n"; break;
  case JAL: cout<<"JAL"<<"\n"; break;
  case SLL: cout<<"SLL"<<"\n"; break;
  case SRL: cout<<"SRL"<<"\n"; break;
  case LW: cout<<"LW"<<"\n"; break;
  case SW: cout<<"SW"<<"\n"; break;
  default : cout<<"Undetermined" << '\n';
  }
  cout<<"RS1 is: x"<<*descriptor[RS1]<<" = "<<bitset<32>(*RF[*descriptor[RS1]])<<" ("<<dec<<*RF[*descriptor[RS1]]<<")"<<"\n";
  cout<<"RS2 is: x"<<*descriptor[RS2]<<" = "<<bitset<32>(*RF[*descriptor[RS2]])<<" ("<<dec<<*RF[*descriptor[RS2]]<<")"<<"\n";
  cout<<"RD is: x"<<*descriptor[RD]<<" = "<<bitset<32>(*RF[*descriptor[RD]])<<" ("<<dec<<*RF[*descriptor[RD]]<<")"<<"\n";
  cout<<"IMME is: "<<bitset<32>(*descriptor[IMME])<<" ("<<*descriptor[IMME]<<")"<<"\n";
}
FILE* IO_inst_ram_normalize(FILE*);
FILE* inst_ram;
FILE* data_ram;
int main(){
  signed int * Register_File[32];
  cout << "Allocating register file, PC and instruction , the size of each register is "<<sizeof(signed int)<<" bytes\n";
  for (int i = 0; i <= 31 ; ++ i){
    Register_File[i] = (signed int*) malloc(sizeof(signed int));
    *Register_File[i] = 0;
  }
  unsigned int * pc;
  pc = (unsigned int *) malloc(sizeof(unsigned int));
  *(pc) = 0;

  signed int * instruction;
  instruction = (signed int *) malloc(sizeof(signed int));

  int * descriptor[5];
  for(int i = 0; i <= 4; ++i) descriptor[i] = (int*) malloc(sizeof(int));

  cout << "Connecting instruction RAM file and data RAM file\n";
  inst_ram = fopen("machinecode.txt", "r");
  inst_ram = IO_inst_ram_normalize(inst_ram);
  data_ram = fopen("data_mem.txt","r+");

  char command;
  int print_flag = 0;
  cout << "Emulator is kicked up\n";
  while(true){
    while(true){
      cout<<"Type instruction (n, next) (p, print) (t, toggle print on each step):\n";
      cin>>command;
      if(command == 'n') break;
      else
        switch (command) {
        case 'p':
          DEBUG_print_all(Register_File, pc, instruction, descriptor);
          break;
        case 't':
          print_flag = (print_flag == 0);
          if (print_flag) cout << "Turn on printing in each step\n";
          else cout << "Turn off printing in each step\n";
          break;
        default:
          cout << "This is not a command " << command <<'\n';
        }
    }
    *instruction = IO_inst_ram_read(*pc);
    RISC_V_parser(instruction, descriptor);
    switch (*descriptor[OP]) {
    case ADD:
      RISC_V_add(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case SUB:
      RISC_V_sub(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case ADDI:
      RISC_V_addi(Register_File[*descriptor[RD]],
                  Register_File[*descriptor[RS1]],
                  *descriptor[IMME]);
      break;
    case AND:
      RISC_V_and(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case OR:
      RISC_V_or(Register_File[*descriptor[RD]],
                Register_File[*descriptor[RS1]],
                Register_File[*descriptor[RS2]]);
      break;
    case XOR:
      RISC_V_xor(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case BLT:
      RISC_V_blt(pc,
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]],
                 *descriptor[IMME]);
      break;
    case BEQ:
      RISC_V_beq(pc,
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]],
                 *descriptor[IMME]);
      break;
    case JAL:
      RISC_V_jal(pc, *descriptor[IMME]);
      break;
    case SLL:
      RISC_V_sll(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case SRL:
      RISC_V_srl(Register_File[*descriptor[RD]],
                 Register_File[*descriptor[RS1]],
                 Register_File[*descriptor[RS2]]);
      break;
    case LW:
      RISC_V_lw(Register_File[*descriptor[RD]],
                *descriptor[IMME],
                Register_File[*descriptor[RS1]]);
      break;
    case SW:
      RISC_V_sw(Register_File[*descriptor[RS2]],
                *descriptor[IMME],
                Register_File[*descriptor[RS1]]);
      break;
    }
    if(*descriptor[OP] != BEQ &&
       *descriptor[OP] != BLT &&
       *descriptor[OP] != JAL) *(pc) = *(pc) + 4;
    if(print_flag) DEBUG_print_all(Register_File, pc, instruction, descriptor);
  }
}

void RISC_V_parser(signed int* instruction, int** descriptor){
  switch (*instruction & 0b1111111) {
  case 0b0110011: RISC_V_arithmetic_parser(instruction, descriptor); break;
  case 0b0010011: RISC_V_imme_arithmetic_parser(instruction, descriptor); break;
  case 0b1100011: RISC_V_conditional_jmp_parser(instruction, descriptor); break;
  case 0b1101111: RISC_V_unconditional_jmp_parser(instruction, descriptor); break;
  case 0b0000011: RISC_V_load_parser(instruction, descriptor); break;
  case 0b0100011: RISC_V_store_parser(instruction, descriptor); break;
  default: exit(1);
  }
}
void RISC_V_arithmetic_parser(signed int *instruction, int **descriptor) {
  *descriptor[RS1] = (*instruction >> 15) & 0b11111;
  *descriptor[RS2] = (*instruction >> 20) & 0b11111;
  *descriptor[RD] = (*instruction >> 7) & 0b11111;
  switch ((*instruction >> 12) & 0b111) {
  case 0b000: {
    if ((*instruction & 0xF0000000) == 0) {
      *descriptor[OP] = ADD;
      break;
    } else {
      *descriptor[OP] = SUB;
      break;
    }
  }
  case 0b001: {
    *descriptor[OP] = SLL;
    break;
  }
  case 0b101: {
    *descriptor[OP] = SRL;
    break;
  }
  case 0b100: {
    *descriptor[OP] = XOR;
    break;
  }
  case 0b110: {
    *descriptor[OP] = OR;
    break;
  }
  case 0b111: {
    *descriptor[OP] = AND;
    break;
  }
  default: exit(1);
  }
}
void RISC_V_imme_arithmetic_parser(signed int *instruction, int** descriptor){
  if (((*instruction >> 12) & 0b111) == 0b000){
    *descriptor[OP] = ADDI;
    *descriptor[RD] = (*instruction >> 7)&0b11111;
    *descriptor[RS1] = (*instruction >> 15)&0b11111;
    *descriptor[IMME] = (*instruction >> 20);
  }
}

void RISC_V_conditional_jmp_parser(signed int* instruction, int** descriptor){
  *descriptor[RS1] = (*instruction >> 15) & 0b11111;
  *descriptor[RS2] = (*instruction >> 20) & 0b11111;
  *descriptor[IMME] = ((*instruction >> 7) & 0b11110) |
    ((*instruction >> 20) & 0b11111100000) |
    ((*instruction << 4) & 0b100000000000) |
    ((*instruction >> 19) & 0xfffff000);
  switch ((*instruction >> 12) & 0b111) {
  case 0b100 : *descriptor[OP] = BLT; break;
  case 0b000 : *descriptor[OP] = BEQ; break;
  }
}
void RISC_V_unconditional_jmp_parser(signed int* instruction, int** descriptor){
  *descriptor[OP] = JAL;
  *descriptor[RD] = 0; // JAL's rd is always x0
  *descriptor[IMME] = ((*instruction >> 20) & 0b11111111110) |
    ((*instruction >> 9) & 0b100000000000) |
    ((*instruction) & 0xff000) |
    ((*instruction >> 11) & 0x100000);
}
void RISC_V_load_parser(signed int* instruction, int** descriptor){
  *descriptor[OP] = LW;
  *descriptor[RD] = ((*instruction) >> 7) & 0b11111;
  *descriptor[RS1] = ((*instruction) >> 15) & 0b11111;
  *descriptor[IMME] = ((*instruction) >> 20) & 0xfff;
}
void RISC_V_store_parser(signed int* instruction, int** descriptor){
  *descriptor[OP] = SW;
  *descriptor[RS1] = ((*instruction) >> 15) & 0b11111;
  *descriptor[RS2] = ((*instruction) >> 20) & 0b11111;
  *descriptor[IMME] = ((*instruction >> 7) & 0b11111) |
    ((*instruction >> 20) & 0b111111100000);
}
void RISC_V_add(signed int *rd, signed int *rs1, signed int *rs2) {
  *(rd) = *(rs1) + *(rs2);
}
void RISC_V_sub(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = *(rs1) - *(rs2);
}
void RISC_V_addi(signed int* rd, signed int* rs1, signed int imme){
  *(rd) = *(rs1) + imme;
}
void RISC_V_and(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = *(rs1) & *(rs2);
}
void RISC_V_or(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = *(rs1) | *(rs2);
}
void RISC_V_xor(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = *(rs1) ^ *(rs2);
}
void RISC_V_blt(unsigned int* pc, signed int* rs1, signed int* rs2, signed int imme){
  if (*(rs1) < *(rs2)) *(pc) = *(pc) + (unsigned int) imme;
  else *(pc) = *(pc) + 4;
}
void RISC_V_beq(unsigned int* pc, signed int* rs1, signed int* rs2, signed int imme){
  if (*(rs1) == *(rs2)) *(pc) = *(pc) +(unsigned int) imme;
  else *(pc) = *(pc) + 4;
}
void RISC_V_jal(unsigned int* pc, signed int imme){
  *(pc) = *(pc) + (unsigned int) imme;
}

void RISC_V_sll(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = ((unsigned int) *(rs1)) << ((unsigned int) (*rs2 & 0b11111));
}

void RISC_V_srl(signed int* rd, signed int* rs1, signed int* rs2){
  *(rd) = ((unsigned int) *(rs1)) >> ((unsigned int) (*rs2 & 0b11111));
}

void RISC_V_lw(signed int* dest, signed int offset, signed int* base){
  *(dest) = IO_data_ram_read(*(base) + offset);
}

void RISC_V_sw(signed int* src, signed int offset, signed int* base){
  IO_data_ram_write(*src, *base + offset);
}

FILE* IO_inst_ram_normalize(FILE* prev){
  FILE* normal_inst_ram = fopen("machinecode_normal.txt", "w");
  int tmp;
  while((tmp = fgetc(prev)) != EOF){
    if(tmp == 0x20 || tmp == 0x2f || tmp == 0x0d){}
    else {
      fputc(tmp, normal_inst_ram);
    }
  }
  fclose(prev);
  fclose(normal_inst_ram);
  return fopen("machinecode_normal.txt", "r");
}

inline unsigned int IO_char_to_hex(char semibyte){
  if (semibyte >= '0' && semibyte <= '9') return semibyte - 48;
  if (semibyte >= 'a' && semibyte <= 'f') return semibyte + 10 - 97;
  else {
    cerr<<"fatal error in converting char to hex\n";
    cerr<<"converting "<<semibyte<<'\n';
    exit(1);
  }
}

inline char IO_hex_to_char(int semibyte){
  if (semibyte >= 0 && semibyte <= 9) return semibyte + 48;
  if (semibyte >= 10 && semibyte <= 15) return semibyte - 10 + 97;
  else {
    cerr<<"fatal error in converting hex to char\n";
    cerr<<"converting "<<semibyte<<'\n';
    exit(1);
  }
}
signed int IO_inst_ram_read(unsigned int pc){
  int instruction = 0;
  int semibyte;
  semibyte = fgetc(inst_ram);
  if(fseek(inst_ram, (pc/4)*9, SEEK_SET)) {
    cerr << "exiting in seeking instruction, PC is " << pc;
    exit(1);
  }
  for(int i = 0; i <= 7; ++ i){
    semibyte = fgetc(inst_ram);
    instruction = (instruction << 4)+ IO_char_to_hex(semibyte);
  }
  return instruction;
}
signed int IO_data_ram_read(signed int addr){
  signed int value = 0;
  signed int semibyte;
  int counter = 0;
  if(fseek(data_ram, addr*3, SEEK_SET)) {
    cerr<<"fatal error in seeking data position\n";
    exit(1);
  }
  for (int i = 0; i <= 3; ++ i){
    semibyte = fgetc(data_ram);
    value = value + (IO_char_to_hex(semibyte) << (counter * 4));
    counter ++;
    semibyte = fgetc(data_ram);
    value = value + (IO_char_to_hex(semibyte) << (counter * 4));
    semibyte = fgetc(data_ram);
  }
  return value;
}

void IO_data_ram_write(signed int src_value, signed int addr){
  if(fseek(data_ram, addr*3, SEEK_SET)) {
    cerr<<"fatal error in seeking data position\n";
    exit(1);
  }
  for (int i = 0; i <= 3; ++ i){
    fputc(IO_hex_to_char(src_value & 0xf), data_ram);
    src_value = src_value >> 4;
    fputc(IO_hex_to_char(src_value & 0xf), data_ram);
    src_value = src_value >> 4;
    fputc(0xa, data_ram);
  }
}
