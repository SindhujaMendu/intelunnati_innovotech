# intelunnati_innovotech
The provided code implements an ATM Controller module in SystemVerilog, which serves as the brain of an ATM machine. It handles various states and operations necessary for ATM functionality. Let's provide an overview of the code in 100 lines:

The code begins by defining the module, `ATM_Controller`, which takes input and output signals for communication with the ATM system.

The module includes an enumeration type, `atm_state`, which defines the different states of the ATM. These states include IDLE, CARD_INSERTED, FACE_RECOGNITION, OTP_VERIFICATION, AMOUNT_CONFIRMATION, WITHDRAWAL, DEPOSIT, DISPLAY_BALANCE, and MINI_STATEMENT.

Inside the module, there are input signals for clock (`clk`), reset (`reset`), card insertion (`card_inserted`), card data (`card_data`), mode selection (`mode_selection`), amount confirmation (`amount_confirmed`), face recognition result (`face_recognition_passed`), and OTP received (`otp_received`).

The module also includes output signals such as current balance (`current_balance`), new balance (`new_balance`), mini statement (`mini_statement`), and invalid PIN entry indication (`invalid_pin_entry`).

The module defines various registers, including the current state (`state`), the next state (`next_state`), PIN attempts (`pin_attempts`), and the amount to withdraw (`withdraw_amount`).

There are also parameters defined to set constants like the maximum number of PIN attempts (`MAX_PIN_ATTEMPTS`) and the maximum withdrawal amount (`MAX_WITHDRAW_AMOUNT`).

The code uses an `always` block to handle clock and reset events. It updates the current state based on the next state value, which is determined by the state transition logic in the following `always` block.

The state transition logic is implemented using a combinational `always` block, which detects changes in the input signals and determines the next state based on the current state and the input values. It covers various scenarios such as card insertion, face recognition, OTP verification, amount confirmation, and mode selection.

The `always` block also includes conditional statements to handle different states and perform actions accordingly. For example, it checks if the withdrawal amount exceeds the maximum allowed amount and prompts for face recognition in such cases.

Within the `always` block triggered by the positive edge of the clock, the code updates the current balance based on the state. It subtracts the withdrawal amount during withdrawal and adds the withdrawal amount during deposit. In other states, the balance remains unchanged.

The code provides a basic framework for an ATM controller, handling state transitions and balance updates. However, it does not include the complete implementation of ATM functionality, such as user input handling, validations, error conditions, or communication with other ATM components.

To create a fully functional ATM system, additional modules and components need to be integrated with the ATM Controller module. These modules may include a user interface module, a keypad module, a display module, a cash dispenser module, and various other modules to handle transactions, PIN verification, and communication with the bank's backend system.

In summary, the provided code serves as a starting point for an ATM Controller module. It defines states, handles state transitions, and updates the current balance. However, additional components and modules need to be developed and integrated to build a complete and functional ATM system.
