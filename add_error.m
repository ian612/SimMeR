function [value_noisy] = add_error(value, pct_error)
%ADD_ERROR Adds normally distributed percent error to a measurement
%   As an input, this function takes a measurement value and an error
%   percentage (from 0 to 1). It uses randn to calculate a normally
%   distributed error and add it to the value and output it.

err = randn * pct_error * value;
value_noisy = value + err;
end

