function [ respond ] = simReg( command,data )
if (strcmp(command,'AT:'))
    respond=rand(1)+25;
end
end

