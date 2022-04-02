/* ============================================================================
  A Verilog main() program that calls a local serial port co-simulator.
  =============================================================================*/
#include <string.h>
#include <strings.h>
#include <stdio.h>

#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vsoc.h"
#include "Vsoc__Dpi.h"   //auto created by the verilator from the rtl that support dpi

#include "uartsim.h"
#include "remote_bitbang.h"

/*
  =========================================================================
    // DPI EXPORTS
    // DPI export at /var/cpu_testbench/t_head/simpoint_openc910/sim_verilator/rtl/../../openc910/smart_run/logical/mem/f_spsram_large.v:404:10
    extern void simutil_load_data(const char* file);
    // DPI export at /var/cpu_testbench/t_head/simpoint_openc910/sim_verilator/rtl/../../openc910/smart_run/logical/mem/f_spsram_large.v:372:10
    extern void simutil_load_inst(const char* file);
    // DPI export at /var/cpu_testbench/t_head/simpoint_openc910/sim_verilator/rtl/../../openc910/smart_run/logical/mem/f_spsram_large.v:309:10
    extern void simutil_load_inst_data(const char* file1, const char* file2);
    // DPI export at /var/cpu_testbench/t_head/simpoint_openc910/sim_verilator/rtl/../../openc910/smart_run/logical/mem/f_spsram_large.v:524:18
    extern int simutil_read_memory(int mem_index, int addr_index, char* val);
    // DPI export at /var/cpu_testbench/t_head/simpoint_openc910/sim_verilator/rtl/../../openc910/smart_run/logical/mem/f_spsram_large.v:440:18
    extern int simutil_write_memory(int mem_index, int addr_index, char val);

  ============================================================================
*/

#define APB_FREQ			100000000L   /* MHz */

int main(int argc,  char ** argv)
{
    printf("Built with %s %s.\n", Verilated::productName(),
    Verilated::productVersion());
    printf("Recommended: Verilator 4.0 or later.\n");

    if(argc < 2 || argv[1] == "?")
    {
        printf("usage: %s --vmem vmem_file \r\n", argv[0]);
        printf("\tExample: %s --vmem hello_world.vmem \r\n", argv[0]);
        printf("usage: %s --bin bin_file \r\n", argv[0]);
        printf("\tExample: %s --bin hello_world.bin \r\n", argv[0]);
        printf("usage: %s --segment inst_mem_part data_mem_part  [Assume: data segement started from 0x00040000]\r\n", argv[0]);
        printf("\tExample: %s --segment inst.pat data.pat \r\n", argv[0]);
        return -1;
    }

    unsigned char ucLoadType = 0;
    if(strncasecmp(argv[1],"--bin",strlen("--bin")) == 0)
    {
        ucLoadType = 1;  //filename = argv[2]
    }
    else if(strncasecmp(argv[1],"--vmem",strlen("--vmem")) == 0)
    {
        ucLoadType = 2;  //filename = argv[2]
    }
    else if(strncasecmp(argv[1],"--segment",strlen("--segment")) == 0)
    {
        ucLoadType = 3; //filename1 = argv[2]   filename2 = argv[3]
    }
    else
    {
        printf("usage: %s --vmem vmem_file \r\n", argv[0]);
        printf("usage: %s --bin bin_file \r\n", argv[0]);
        printf("usage: %s --segment inst_mem_part data_mem_part \r\n", argv[0]);
        return -1;
    }

    // call commandArgs first!
    VerilatedContext* contextp = new VerilatedContext;
    Verilated::commandArgs(argc, argv);

    // Set debug level, 0 is off, 9 is highest presently used
    Verilated::debug(0);
    // Randomization reset policy
    Verilated::randReset(2);
    Verilated::mkdir("./log");

    // Instantiate our design
    Vsoc * ptTB = new Vsoc;

    // Tracing (vcd)
    VerilatedVcdC * m_trace = NULL;
    const char* flag_vcd = Verilated::commandArgsPlusMatch("vcd");
    if (flag_vcd && 0==strcmp(flag_vcd, "+vcd"))
    {
        Verilated::traceEverOn(true); // Verilator must compute traced signals
        m_trace = new VerilatedVcdC;
        ptTB->trace(m_trace, 1); // Trace 99 levels of hierarchy
        m_trace->open("./log/tb.vcd");
    }

    FILE * trace_fd = NULL;
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    const char* flag_trace = Verilated::commandArgsPlusMatch("trace");
    if (flag_trace && 0==strcmp(flag_trace, "+trace"))
    {
        trace_fd = fopen("./log/tb.trace", "w");
    }

    int m_cpu_tickcount = 0;
    int m_jtag_tickcount = 0;

    //jtag
#ifdef  JTAG_SUPPORTED
    remote_bitbang_t * jtag = NULL;
    jtag = new remote_bitbang_t(9823);
#endif

    //uart
#ifdef  UART_SUPPORTED
    UARTSIM  * uart = NULL;
    uart = new(UARTSIM);
    unsigned int  baud_rate = 19200;
    unsigned int baud_div;
    baud_div = (uint32_t)((APB_FREQ/baud_rate) >> 4);
    uart->setup(baud_div);
#endif

    // Note that if the DPI task or function accesses any register or net within the RTL,
    // it will require a scope to be set. This can be done using the standard functions within svdpi.h,
    // after the module is instantiated, but before the task(s) and/or function(s) are called.
    // For example, if the top level module is instantiated with the name “dut”
    // and the name references within tasks are all hierarchical (dotted) names with respect to that top level module,
    // then the scope could be set with
    // svSetScope(svGetScopeFromName("TOP.dut"));


    while(!contextp->gotFinish())
    {
        //cpu reset
        if(m_cpu_tickcount<10)
        {
            ptTB->i_pad_rst_b = 1;
        }
        else if( (m_cpu_tickcount>=10) && (m_cpu_tickcount<20))
        {
            ptTB->i_pad_rst_b = 0;   // reset the cpu
        }
        else
        {
            if(ptTB->i_pad_rst_b == 0)
                printf("reset the cpu,done \n");
            ptTB->i_pad_rst_b = 1;
        }

        //jtag reset
        if(m_cpu_tickcount%4 == 0)
        {
            m_jtag_tickcount += 1;
        }

        if(m_jtag_tickcount<10)
        {
            ptTB->i_pad_jtg_trst_b = 1;
        }
        else if( (m_jtag_tickcount>=10) && (m_jtag_tickcount<20))
        {
            ptTB->i_pad_jtg_trst_b = 0;   // reset the jtag
        }
        else
        {
            if(ptTB->i_pad_jtg_trst_b == 0)
            {
                printf("reset the jtag,done \n");
                //it is time to load the memory
                // tb.x_soc.x_axi_slave128.x_f_spsram_large
                svSetScope(svGetScopeFromName("TOP.soc.x_axi_slave128.x_f_spsram_large"));

                switch (ucLoadType)
                {
                    case 1:  //load bin, argv2
                    {
                        unsigned int  mem_index=0, addr_index=0;
                        unsigned char buffer[16] = {0};
                        size_t iread_bytes = 0;
                        // open the bin file to read
                        // you can read the bin file in liuux with: xxd ./work/hello_world.bin
                        FILE * fp;
                        fp = fopen(argv[2], "rb");  // r for read, b for binary
                        if(fp == NULL)
                        {
                            printf("open file (%s) failed, please check it \r\n", argv[2]);
                            exit(-1);
                        }
                        printf("start to load file (%s) into memory \r\n", argv[2]);
                        fseek(fp, 0, SEEK_SET);
                        iread_bytes = fread(buffer, sizeof(unsigned char), 16, fp); // read 16 bytes to our buffer
                        // write the byte to the memory
                        while(iread_bytes == 16)
                        {
                            for(mem_index=0; mem_index < iread_bytes; mem_index++)
                            {
                                simutil_write_memory(mem_index, addr_index, buffer[mem_index]);
                            }
                            addr_index ++;
                            iread_bytes = fread(buffer, sizeof(unsigned char), 16, fp); // read another 16 bytes to our buffer
                        }
                        printf("loaded file (%s) into memory successfully\r\n", argv[2]);
                    }
                    break;

                    case 2:  //load vmem, argv2
                    {
                        simutil_load_inst(argv[2]);
                    }
                    break;

                    case 3:  //load segment, inst, argv2 & argv3
                    {
                        simutil_load_inst_data(argv[2], argv[3]);
                    }
                    break;

                    default:
                    {
                        return -1;
                    }
                    break;
                }
            }
            ptTB->i_pad_jtg_trst_b = 1;
        }

        ptTB->i_pad_clk = 1;

#ifdef  JTAG_SUPPORTED
        if(m_cpu_tickcount%2 == 0 && m_jtag_tickcount>20)
        {
            jtag->tick(&(ptTB->i_pad_jtg_tclk), &(ptTB->i_pad_jtg_tms), &(ptTB->i_pad_jtg_tdi), &(ptTB->i_pad_jtg_trst_b), /*&(ptTB->sysrstn), */ ptTB->o_pad_jtg_tdo);
        }
#endif
        ptTB->eval();
        if(m_trace)
        {
	        m_trace->dump(m_cpu_tickcount*10);   //  Tick every 10 ns
	    }

#ifdef  UART_SUPPORTED
        if(m_cpu_tickcount>80)   //skip the reset process
        {
            ptTB->i_pad_uart0_sin = (*uart)(ptTB->o_pad_uart0_sout);  //get the uart_tx and sent the char via rx_pin to riscv cpu
        }
#endif

        ptTB->i_pad_clk = 0;
        ptTB->eval();
        if(m_trace)
        {
            m_trace->dump(m_cpu_tickcount*10+5);   // Trailing edge dump
            m_trace->flush();
        }

        m_cpu_tickcount++;
    }

    if(m_trace)
    {
        m_trace->flush();
        m_trace->close();
    }

    if(trace_fd)
    {
        fflush(trace_fd);
        fclose(trace_fd);
    }

#if VM_COVERAGE
    VerilatedCov::write("log/coverage.dat");
#endif // VM_COVERAGE

    delete ptTB;

#ifdef  JTAG_SUPPORTED
    delete jtag;
#endif

#ifdef  UART_SUPPORTED
    delete jtag;
#endif
    exit(0);
}


