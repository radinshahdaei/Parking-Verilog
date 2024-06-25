# Parking Management System

This Verilog project simulates a parking management system that handles university and non-university cars. The module manages the number of parked cars, available spaces, and adjusts the space allocation based on the hour of the day.

## Table of Contents
- [Overview](#overview)
- [Module Parameters](#module-parameters)
- [Module Ports](#module-ports)

## Overview
The `parking` module is designed to manage parking spaces for a university. It dynamically adjusts the number of spaces allocated to university and non-university cars based on the current hour. The parameters allow customization of initial and final university spaces, total parking spaces, and the increment value used to adjust spaces.

## Module Parameters
- `init_uni_space`: Initial number of spaces allocated to university cars.
- `final_uni_space`: Final number of spaces allocated to university cars.
- `total_space`: Total number of parking spaces.
- `increment`: The number of spaces to decrement per hour during transition hours.

## Module Ports
### Inputs
- `car_entered`: Signal indicating a car has entered.
- `is_uni_car_entered`: Signal indicating if the entering car is a university car.
- `car_exited`: Signal indicating a car has exited.
- `is_uni_car_exited`: Signal indicating if the exiting car is a university car.
- `hour`: The current hour (6-bit wide).

### Outputs
- `uni_parked_car`: Number of university cars currently parked.
- `parked_car`: Number of non-university cars currently parked.
- `uni_vacated_space`: Number of vacant spaces for university cars.
- `vacated_space`: Number of vacant spaces for non-university cars.
- `uni_is_vacated_space`: Signal indicating if there are vacant university spaces.
- `is_vacated_space`: Signal indicating if there are vacant non-university spaces.
