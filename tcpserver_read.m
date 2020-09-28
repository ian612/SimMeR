function [cmd] = tcpserver_read(s_cmd)
%TCPSERVER_READ reads a command string from the algorithm
%   Detailed explanation goes here

tcp_data = 0;
while ~tcp_data
    if s_cmd.BytesAvailable > 0
        cmd = char(fread(s_cmd, s_cmd.BytesAvailable, 'uint8'))';
        tcp_data = 1;
        disp(cmd)
    end
end

end