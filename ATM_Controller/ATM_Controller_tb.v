module ATM_Controller_TB;
  reg clk;
  reg reset;
  reg [3:0] key_in;
  reg card_inserted;
  reg barcode_scanned;
  reg face_recognition_passed;
  reg otp_passed;
  reg [3:0] withdraw_amount;
  reg deposit_flag;
  
  wire [7:0] display_data;
  wire dispense_cash;
  wire deposit_cash;
  wire face_recognition_required;
  wire otp_required;
  wire invalid_pin_attempts_exceeded;
  wire [7:0] old_balance;
  wire [7:0] new_balance;
  wire mini_statement;
  
  // Instantiate the ATM_Controller module
  ATM_Controller dut (
    .clk(clk),
    .reset(reset),
    .key_in(key_in),
    .card_inserted(card_inserted),
    .barcode_scanned(barcode_scanned),
    .face_recognition_passed(face_recognition_passed),
    .otp_passed(otp_passed),
    .withdraw_amount(withdraw_amount),
    .deposit_flag(deposit_flag),
    .display_data(display_data),
    .dispense_cash(dispense_cash),
    .deposit_cash(deposit_cash),
    .face_recognition_required(face_recognition_required),
    .otp_required(otp_required),
    .invalid_pin_attempts_exceeded(invalid_pin_attempts_exceeded),
    .old_balance(old_balance),
    .new_balance(new_balance),
    .mini_statement(mini_statement)
  );
  
  // Define simulation parameters
  reg dumpfile_enabled = 1;
  
  // Dump waveform to VCD file
  initial begin
    if (dumpfile_enabled) begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  end
  
  // Initialize inputs
  initial begin
    clk = 0;
    reset = 1;
    key_in = 0;
    card_inserted = 0;
    barcode_scanned = 0;
    face_recognition_passed = 0;
    otp_passed = 0;
    withdraw_amount = 0;
    deposit_flag = 0;
    
    // Toggle the clock
    forever #5 clk = ~clk;
    
    // Simulate ATM behavior
    #10 reset = 0;
    #20 card_inserted = 1;
    #10 barcode_scanned = 1;
    #10 face_recognition_passed = 1;
    #10 otp_passed = 1;
    #10 withdraw_amount = 5;
    #10 deposit_flag = 1;
    #10 key_in = 4'b0100;
    #100 $finish;
  end

endmodule