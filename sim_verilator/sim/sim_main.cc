/* ============================================================================
  A Verilog main() program that calls a local serial port co-simulator.
  =============================================================================*/

#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vsoc.h"
#include "Vsoc__Dpi.h"   //auto created by the verilator from the rtl that support dpi

#include "uartsim.h"
#include "remote_bitbang.h"


int main(int argc,  char ** argv)
{
    printf("Built with %s %s.\n", Verilated::productName(),
    Verilated::productVersion());
    printf("Recommended: Verilator 4.0 or later.\n");

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
    remote_bitbang_t * jtag = NULL;
    jtag = new remote_bitbang_t(9823);

    //uart
    UARTSIM  * uart = NULL;
    uart = new(UARTSIM);
    unsigned   baudclocks = 0x1B8;
    uart->setup(baudclocks);

    // Note that if the DPI task or function accesses any register or net within the RTL,
    // it will require a scope to be set. This can be done using the standard functions within svdpi.h,
    // after the module is instantiated, but before the task(s) and/or function(s) are called.
    // For example, if the top level module is instantiated with the name “dut”
    // and the name references within tasks are all hierarchical (dotted) names with respect to that top level module,
    // then the scope could be set with
    // svSetScope(svGetScopeFromName("TOP.dut"));

    printf("load vmem file (%s) into ram \n", argv[1]);
    // svSetScope(svGetScopeFromName("TOP.soc.x_mem_ctrl.ram0"));
    // simutil_romload(argv[1]);

    svSetScope(svGetScopeFromName("TOP.soc.x_mem_ctrl"));
    simutil_ram_ctrl_load(argv[1]);

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
                printf("reset the jtag,done \n");
            ptTB->i_pad_jtg_trst_b = 1;
        }

        ptTB->i_pad_clk = 1;
        if(m_cpu_tickcount%2 == 0 && m_jtag_tickcount>20)
        {
            jtag->tick(&(ptTB->i_pad_jtg_tclk), &(ptTB->i_pad_jtg_tms), &(ptTB->i_pad_jtg_tdi), &(ptTB->i_pad_jtg_trst_b), /*&(ptTB->sysrstn), */ ptTB->o_pad_jtg_tdo);
        }
        ptTB->eval();
        if(m_trace)
        {
	        m_trace->dump(m_cpu_tickcount*10);   //  Tick every 10 ns
	    }

        ptTB->i_pad_uart0_sin = (*uart)(ptTB->o_pad_uart0_sout);  //get the uart_tx and sent the char via rx_pin to riscv cpu

        ptTB->i_pad_clk = 0;
        ptTB->eval();
        if(m_trace)
        {
            m_trace->dump(m_cpu_tickcount*10+5);   // Trailing edge dump
            m_trace->flush();
        }

        if(m_cpu_tickcount>80)   //skip the reset process
        {
            ptTB->i_pad_uart0_sin = (*uart)(ptTB->o_pad_uart0_sout);  //get the uart_tx and sent the char via rx_pin to riscv cpu
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
    exit(0);
}


