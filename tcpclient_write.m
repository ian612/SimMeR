function [reply] = tcpclient_write(cmd, s_cmd, s_rply)
%TCPCLIENT_WRITE writes a command string to the simulator and collects a
%response
%   Detailed explanation goes here

fwrite(s_cmd, cmd, 'uint8')
ct = 1;
while ct
    if s_rply.BytesAvailable > 0
        reply = fread(s_rply, s_rply.BytesAvailable/8, 'double');
        ct = 0;
    end
end

end