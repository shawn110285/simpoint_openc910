/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
#include "stdio.h"
#include "uart.h"

/*
static t_ck_uart_device uart0 = {0xFFFF};

void uart_putc(uint8_t ch)
{
  ck_uart_putc(&uart0, ch);
}

*/

int main (void)
{
/*
  //--------------------------------------------------------
  // setup uart
  //--------------------------------------------------------
  t_ck_uart_cfig   uart_cfig;


  uart_cfig.baudrate = BAUD;       // any integer value is allowed
  uart_cfig.parity = PARITY_NONE;     // PARITY_NONE / PARITY_ODD / PARITY_EVEN
  uart_cfig.stopbit = STOPBIT_1;      // STOPBIT_1 / STOPBIT_2
  uart_cfig.wordsize = WORDSIZE_8;    // from WORDSIZE_5 to WORDSIZE_8
  uart_cfig.txmode = ENABLE;          // ENABLE or DISABLE

  // open UART device with id = 0 (UART0)
  ck_uart_open(&uart0, 0);

  // initialize uart using uart_cfig structure
  ck_uart_init(&uart0, &uart_cfig);
  //--------------------------------------------------------
*/

//Section 1: Hello World!
  printf("\nHello Friend!\n");
  printf("Welcome to T-HEAD World!\n");

//Section 2: Embeded ASM in C
  int a;
  int b;
  int c;
  a=1;
  b=2;
  c=0;
  printf("\na is %d!\n",a);
  printf("b is %d!\n",b);
  printf("c is %d!\n",c);

asm(
    "mv  x5,%[a]\n"
    "mv  x6,%[b]\n"
    "label_add:"
    "add  %[c],x5,x6\n"
    :[c]"=r"(c)
    :[a]"r"(a),[b]"r"(b)
    :"x5","x6"
    );

if(c == 3)
  printf("!!! PASS !!!");
else
  printf("!!! FAIL !!!");
  printf("after ASM c is changed to %d!\n",c);

  return 0;
}

