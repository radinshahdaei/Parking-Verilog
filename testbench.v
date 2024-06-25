`include "parking.v"

module testbench;

// Parameters for the testbench
parameter init_uni_space = 5;
parameter final_uni_space = 2;
parameter total_space = 10;
parameter increment = 1;

// Testbench signals
reg car_entered;
reg is_uni_car_entered;
reg car_exited;
reg is_uni_car_exited;
reg [5:0] hour;
reg [20*8:0] operation;  // Register to store the current operation message

wire [9:0] uni_parked_car;
wire [9:0] parked_car;
wire [9:0] uni_vacated_space;
wire [9:0] vacated_space;
wire uni_is_vacated_space;
wire is_vacated_space;

// Instantiate the parking module
parking #(
    .init_uni_space(init_uni_space),
    .final_uni_space(final_uni_space),
    .total_space(total_space),
    .increment(increment)
) uut (
    .car_entered(car_entered),
    .is_uni_car_entered(is_uni_car_entered),
    .car_exited(car_exited),
    .is_uni_car_exited(is_uni_car_exited),
    .hour(hour),
    .uni_parked_car(uni_parked_car),
    .parked_car(parked_car),
    .uni_vacated_space(uni_vacated_space),
    .vacated_space(vacated_space),
    .uni_is_vacated_space(uni_is_vacated_space),
    .is_vacated_space(is_vacated_space)
);

initial begin
    // Initialize inputs
    car_entered = 0;
    is_uni_car_entered = 0;
    car_exited = 0;
    is_uni_car_exited = 0;
    hour = 0;
    operation = "Initial state";

    // Display header for the output
    $display("Time | Hour | Uni Parked | Parked | Uni Vacated | Vacated | Uni Vacant | Vacant | Operation");
    $display("-----|------|------------|--------|-------------|---------|------------|--------|----------------------");

    // Monitor the outputs
    $monitor("%4t |  %2d  | %9d  | %6d | %10d  | %7d | %9b  | %5b  | %s", 
             $time, hour, uni_parked_car, parked_car, uni_vacated_space, vacated_space, uni_is_vacated_space, is_vacated_space, operation);

    // Simulate different scenarios using tasks
    // Initial state
    #5;

    change_time(9, "Time changed to 9");
    // Test entering and exiting cars in various scenarios
    test_enter_car(1, "Uni car entered");
    test_enter_car(1, "Uni car entered");
    test_enter_car(1, "Uni car entered");
    test_enter_car(0, "Non-Uni car entered");
    test_enter_car(0, "Non-Uni car entered");

    change_time(10, "Time changed to 10");
    test_exit_car(1, "Uni car exited");

    change_time(11, "Time changed to 11");
    test_exit_car(1, "Uni car exited");
    test_exit_car(0, "Non-Uni car exited");

    change_time(12, "Time changed to 12");
    test_enter_car(1, "Uni car entered");
    test_enter_car(1, "Uni car entered");
    test_enter_car(1, "Uni car entered");

    change_time(13, "Time changed to 13");
    test_enter_car(1, "Uni car entered");
    test_enter_car(1, "Uni car entered");
    test_enter_car(0, "Non-Uni car entered");

    change_time(14, "Time changed to 14");
    test_exit_car(1, "Uni car exited");
    test_exit_car(0, "Non-Uni car exited");
    test_exit_car(0, "Non-Uni car exited");

    change_time(17, "Time changed to 17");
    test_enter_car(0, "Non-Uni car entered");
    test_enter_car(0, "Non-Uni car entered");
    test_enter_car(0, "Non-Uni car entered");
    test_enter_car(0, "Non-Uni car entered");
    test_enter_car(0, "Non-Uni car entered");

    change_time(20, "Time changed to 20");
    test_exit_car(1, "Uni car exited");
    test_exit_car(0, "Non-Uni car exited");
    test_exit_car(0, "Non-Uni car exited");
    test_exit_car(0, "Non-Uni car exited");
    test_exit_car(0, "Non-Uni car exited");


    // End simulation
    $stop;
end

// Task to handle car entering
task test_enter_car(input is_uni, input [25*8:1] op);
begin
    car_entered = 1;
    is_uni_car_entered = is_uni;
    operation = op;
    #5 car_entered = 0;
    #5;
end
endtask

// Task to handle car exiting
task test_exit_car(input is_uni, input [25*8:1] op);
begin
    car_exited = 1;
    is_uni_car_exited = is_uni;
    operation = op;
    #5 car_exited = 0;
    #5;
end
endtask

// Task to handle change of time
task change_time(input [5:0] in_hour, input [25*8:1] op);
begin
    hour = in_hour;
    operation = op;
    #10;
end
endtask

endmodule
