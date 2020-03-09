try
    port='COM3';
    s = serial(port);
    set(s,'DataBits',8);
    set(s,'StopBits',1);
    set(s,'BaudRate',9600);
    set(s,'Parity','even');
    s.Timeout = 5;
    fopen(s);
catch ME
    er = 'MATLAB:serial:fopen:opfailed';
    switch ME.identifier
        case er
            warning(['Nie je moûne sa pripojiù na port ' port]);
    end
end