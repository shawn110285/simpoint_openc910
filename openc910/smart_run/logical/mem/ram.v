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
module ram #(parameter  DATAWIDTH = 2, parameter  ADDRWIDTH = 2)
(
    input wire                    PortAClk,
    input wire[(ADDRWIDTH-1):0]   PortAAddr,
    input wire[(DATAWIDTH-1):0]   PortADataIn,
    input wire                    PortAWriteEnable,
    output reg[(DATAWIDTH-1):0]   PortADataOut
);

    parameter  MEMDEPTH = 2**(ADDRWIDTH);

    reg [(DATAWIDTH-1):0] ram_mem [(MEMDEPTH-1):0];

    always @(posedge PortAClk) begin
        if(PortAWriteEnable)  begin
            ram_mem[PortAAddr]  <= PortADataIn;
        end else begin
            PortADataOut    <= ram_mem[PortAAddr];
        end
    end


    // Task for loading 'ram_mem' with SystemVerilog system task $readmemh()
    export "DPI-C" task simutil_ramload;

    task simutil_ramload;
        input string file;
        $readmemh(file, ram_mem);
    endtask

    // Function for setting a specific element in |ram_mem|
    // Returns 1 (true) for success, 0 (false) for errors.
    export "DPI-C" function simutil_set_ram;

    function int simutil_set_ram(input int index, input bit [7:0] val);
        if (index >= MEMDEPTH) begin
            return 0;
        end
        ram_mem[index] = val;
        return 1;
    endfunction

    // Function for getting a specific element in |ram_mem|
    export "DPI-C" function simutil_get_ram;

    function int simutil_get_ram(input int index, output bit [7:0] val);
        if (index >= MEMDEPTH) begin
          return 0;
        end

        val = 0;
        val = ram_mem[index];
        return 1;
    endfunction


endmodule
