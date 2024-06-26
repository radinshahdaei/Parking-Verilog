module parking #(
    // Define the parameters for initial and final university parking spaces, 
    // total parking spaces, and increment value.
    parameter init_uni_space = 500,
    parameter final_uni_space = 200,
    parameter total_space = 700,
    parameter increment = 50
)(
    // Define the inputs for car entered/exited events and whether it is a university car.
    input car_entered,
    input is_uni_car_entered,
    input car_exited,
    input is_uni_car_exited,
    input [5:0] hour,  // Define the input for the current hour.

    // Define the outputs for the count of parked cars and available spaces.
    output reg [9:0] uni_parked_car = 0,
    output reg [9:0] parked_car = 0,
    output reg [9:0] uni_vacated_space = init_uni_space,
    output reg [9:0] vacated_space = total_space - init_uni_space,
    output reg uni_is_vacated_space = 1,
    output reg is_vacated_space = 1
);

reg [9:0] uni_total_space;  // Internal register to hold the total university space at a given hour.

// Calculate the total university space based on the hour of the day.
always @(*) begin
    case (hour)
        8, 9, 10, 11, 12: uni_total_space = init_uni_space;
        13: uni_total_space = init_uni_space - increment;
        14: uni_total_space = init_uni_space - 2 * increment;
        15: uni_total_space = init_uni_space - 3 * increment;
        default: uni_total_space = final_uni_space;
    endcase

    // Adjust parked cars if the university parked cars exceed the total university space.
    if (uni_parked_car >= uni_total_space) begin
        parked_car = parked_car + (uni_parked_car - uni_total_space);
        uni_parked_car = uni_total_space;
        vacated_space = total_space - (uni_parked_car + parked_car);
        uni_vacated_space = 0;
    end

    // Update the vacated space status flags.
    uni_is_vacated_space = (uni_parked_car < uni_total_space);
    is_vacated_space = (parked_car < total_space - uni_total_space);
end

// Handle car entered and exited events.
always @(posedge car_entered or posedge car_exited) begin
    if (hour >= 8) begin
        if (car_entered) begin
            handle_car_entered(is_uni_car_entered);
        end
        
        if (car_exited) begin
            handle_car_exited(is_uni_car_exited);
        end

        // Update the vacated space status flags.
        uni_is_vacated_space = (uni_parked_car < uni_total_space);
        is_vacated_space = (parked_car < total_space - uni_total_space);
    end
end

// Task to handle a car entering the parking lot.
task handle_car_entered(input is_uni_car);
    if (is_uni_car) begin
        if (uni_is_vacated_space) begin
            uni_parked_car = uni_parked_car + 1;
            uni_vacated_space = uni_vacated_space - 1;
        end else if (is_vacated_space) begin
            parked_car = parked_car + 1;
            vacated_space = vacated_space - 1;
        end
    end else begin
        if (is_vacated_space) begin
            parked_car = parked_car + 1;
            vacated_space = vacated_space - 1;
        end
    end
endtask

// Task to handle a car exiting the parking lot.
task handle_car_exited(input is_uni_car);
    if (is_uni_car && (uni_parked_car > 0)) begin
        uni_parked_car = uni_parked_car - 1;
        uni_vacated_space = uni_vacated_space + 1;
        uni_is_vacated_space = 1;
    end else if (!is_uni_car && (parked_car > 0)) begin
        parked_car = parked_car - 1;
        vacated_space = vacated_space + 1;
        is_vacated_space = 1;
    end
endtask

endmodule
