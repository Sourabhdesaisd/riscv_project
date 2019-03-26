module btb_file (
    input clk,
    input reset,                    

    input [2:0] read_index,
    input [2:0] update_index,
    input [2:0] write_index,
    input [127:0] write_set,
    input write_en,

    output [127:0] read_set,
    output [127:0] update_set
);

    reg [127:0] file [7:0];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                file[i] <= 128'h0;
        end 
        else if (write_en) begin
            file[write_index] <= write_set;
        end
    end

    // Normal update read
    assign update_set = file[update_index];

    // Read with forwarding
    assign read_set =(write_en && (read_index == write_index)) ?write_set : file[read_index];

endmodule

