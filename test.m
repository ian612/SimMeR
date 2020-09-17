clear
close all
clc

% Initialize tcp server to read and respond to algorithm commands
[s_cmd, s_rply] = tcp_setup();
fopen(s_cmd);
fopen(s_rply);

while 1
    data = tcpclient_write(input('Enter a string: ', 's'), s_cmd, s_rply);
    disp('Returned data:')
    disp(data)
end