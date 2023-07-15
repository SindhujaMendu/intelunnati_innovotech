module ATM_Controller (
  input wire clk,
  input wire reset,
  input wire [3:0] key_in,
  input wire card_inserted,
  input wire barcode_scanned,
  input wire face_recognition_passed,
  input wire otp_passed,
  input wire [3:0] withdraw_amount,
  input wire deposit_flag,
  output reg [7:0] display_data,
  output reg dispense_cash,
  output reg deposit_cash,
  output reg face_recognition_required,
  output reg otp_required,
  output reg invalid_pin_attempts_exceeded,
  output reg [7:0] old_balance,
  output reg [7:0] new_balance,
  output reg mini_statement
);

  // Define ATM controller states
  localparam [1:0] IDLE = 2'b00;
  localparam [1:0] CARD_INSERTED = 2'b01;
  localparam [1:0] BARCODE_SCANNED = 2'b10;
  localparam [1:0] FACE_RECOGNITION = 2'b11;
  localparam [2:0] OTP_VERIFICATION = 3'b100;
  localparam [2:0] WITHDRAW = 3'b101;
  localparam [2:0] DEPOSIT = 3'b110;
  
  // Define local variables
  reg [1:0] state;
  reg [2:0] invalid_pin_attempts;
  
  // Initialize outputs
  reg dispense_cash_reg;
  reg deposit_cash_reg;
  reg face_recognition_required_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      invalid_pin_attempts <= 0;
      display_data <= 8'b00000000;
      old_balance <= 8'b00000000;
      new_balance <= 8'b00000000;
      mini_statement <= 0;
      dispense_cash_reg <= 0;
      deposit_cash_reg <= 0;
      face_recognition_required_reg <= 0;
    end
    else begin
      case (state)
        IDLE:
          if (card_inserted) begin
            state <= CARD_INSERTED;
            invalid_pin_attempts <= 0;
          end
        CARD_INSERTED:
          if (key_in == 4'b0) begin
            state <= BARCODE_SCANNED;
          end
          else if (key_in == 4'b1) begin
            state <= WITHDRAW;
          end
          else if (key_in == 4'b10) begin
            state <= DEPOSIT;
          end
          else if (key_in == 4'b11) begin
            state <= IDLE;
          end
        BARCODE_SCANNED:
          if (face_recognition_passed) begin
            state <= OTP_VERIFICATION;
          end
          else begin
            state <= FACE_RECOGNITION;
          end
        FACE_RECOGNITION:
          if (face_recognition_passed) begin
            state <= OTP_VERIFICATION;
          end
        OTP_VERIFICATION:
          if (otp_passed) begin
            state <= WITHDRAW;
          end
        WITHDRAW:
          if (withdraw_amount > 4'b0) begin
            state <= WITHDRAW;
            face_recognition_required_reg <= 1;
          end
          else begin
            state <= IDLE;
            dispense_cash_reg <= 1;
          end
        DEPOSIT:
          if (deposit_flag) begin
            state <= DEPOSIT;
            deposit_cash_reg <= 1;
          end
          else begin
            state <= IDLE;
          end
      endcase
    end
  end
  
  always @(state) begin
    case (state)
      IDLE:
        display_data <= 8'b00000000;
      CARD_INSERTED:
        display_data <= 8'b00000001;
      BARCODE_SCANNED:
        display_data <= 8'b00000010;
      FACE_RECOGNITION:
        display_data <= 8'b00000011;
      OTP_VERIFICATION:
        display_data <= 8'b00000100;
      WITHDRAW:
        display_data <= 8'b00000101;
      DEPOSIT:
        display_data <= 8'b00000110;
      default:
        display_data <= 8'b00000000;
    endcase
  end
  
  always @(posedge clk) begin
    if (reset) begin
      mini_statement <= 0;
    end
    else begin
      if (state == IDLE && key_in == 4'b0100) begin
        mini_statement <= 1;
      end
      else begin
        mini_statement <= 0;
      end
    end
  end
  
  always @(posedge clk) begin
    if (reset) begin
      dispense_cash <= 0;
      deposit_cash <= 0;
      face_recognition_required <= 0;
    end
    else begin
      dispense_cash <= dispense_cash_reg;
      deposit_cash <= deposit_cash_reg;
      face_recognition_required <= face_recognition_required_reg;
    end
  end
  
  always @(posedge clk) begin
    if (reset) begin
      invalid_pin_attempts_exceeded <= 0;
    end
    else begin
      if (state == FACE_RECOGNITION && !face_recognition_passed && invalid_pin_attempts >= 3) begin
        invalid_pin_attempts_exceeded <= 1;
      end
      else begin
        invalid_pin_attempts_exceeded <= 0;
      end
    end
  end
  
endmodule