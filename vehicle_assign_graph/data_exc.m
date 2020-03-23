% data exchange
a = arrive_time';
b = a(:,2); 
a(:,2) = a(:,5);
a(:,5) = b;
arrive_time = a;
arrive_time = arrive_time'; 

% data exchange
a = arrive_time';
b = a(:,3); 
a(:,3) = a(:,4);
a(:,4) = b;
arrive_time = a;
arrive_time = arrive_time'; 

% data exchange
a = run_time';
b = a(:,4); 
a(:,4) = a(:,5);
a(:,5) = b;
run_time = a;
run_time = run_time'; 