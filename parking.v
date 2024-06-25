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

always @(*) begin
    // Determine the total university space based on the hour of the day.
    if (hour >= 8 && hour < 13) begin
        uni_total_space = init_uni_space; 
    end else if (hour >= 13 && hour < 16) begin
        uni_total_space = init_uni_space - (hour - 12) * increment;
    end else if (hour >= 16) begin
        uni_total_space = final_uni_space;
    end

    // Adjust parked cars if the university parked cars exceed the total university space.
    if(uni_parked_car >= uni_total_space) begin
        parked_car = parked_car + (uni_parked_car - uni_total_space);
        uni_parked_car = uni_total_space;
        vacated_space = total_space - (uni_parked_car + parked_car);
        uni_vacated_space = 0;
    end

    if(uni_parked_car == uni_total_space) 
        uni_is_vacated_space = 0;
    if(parked_car == total_space - uni_total_space)
        is_vacated_space = 0;
end

always @(posedge car_entered or posedge car_exited) begin
    if(car_entered) begin
        if(is_uni_car_entered & hour >= 8) begin
            // Handle university car entering
            if(uni_is_vacated_space) begin
                uni_parked_car = uni_parked_car + 1;
                uni_vacated_space = uni_vacated_space - 1;
            end else if(is_vacated_space) begin
                parked_car = parked_car + 1;
                vacated_space = vacated_space - 1;
            end
        end else if(!is_uni_car_entered & hour >= 8) begin
            // Handle non-university car entering
            if(is_vacated_space) begin
                parked_car = parked_car + 1;
                vacated_space = vacated_space - 1;
            end
        end
    end

    if (car_exited & hour >= 8) begin
        // Handle car exiting based on whether it's a university car or not.
        if (is_uni_car_exited & (uni_parked_car > 0)) begin
            uni_parked_car = uni_parked_car - 1;
            uni_vacated_space = uni_vacated_space + 1;
            uni_is_vacated_space = 1;
        end else if (!is_uni_car_exited & (parked_car > 0)) begin
            parked_car = parked_car - 1;
            vacated_space = vacated_space + 1;
            is_vacated_space = 1;
        end
    end

    // Update the vacated space status flags.
    if(uni_parked_car == uni_total_space) 
        uni_is_vacated_space = 0;
    if(parked_car == total_space - uni_total_space)
        is_vacated_space = 0;
end

endmodule
