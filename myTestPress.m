function myTestPress

% 1263.xml
C1=-4.023025e+004;
C2=-4.466859e-001;
C3=1.240000e-002;
D1=3.511700e-002;
D2=0.000000e+000;
T1=3.023099e+001;
T2=-4.469710e-004;
T3=4.128850e-006;
T4=2.885040e-009;
Slope=1.00000000;
Offset=0.00000;
T5=0.000000e+000;
AD590M=1.279148e-002;
AD590B=-9.405686e+000;

% fr02701
F = 33096.289;
N = 2837;
P = 2.988; % db
Td = computeTemp(N);
p = compute(F, Td);
fprintf(1, 'Press= %8.3f db,  Expected: %8.3f db, Temp= %5.2f°C\n', p, P, Td);
%
F = 33684.457;
Td = 25.59;
P = 1000.016; % db
p = compute(F, Td);
fprintf(1, 'Press= %8.3f db,  Expected: %8.3f db, Temp= %5.2f°C\n', p, P, Td);
%
F = 34063.273;
N = 2622;
P = 1653.143; % db
Td = computeTemp(N);
p = compute(F, Td);
fprintf(1, 'Press= %8.3f db,  Expected: %8.3f db, Temp= %5.2f°C\n', p, P, Td);




  function P = compute(F, Td)
    % pressure temperature compensation Td = (M * N) + B
    %Td = AD590M * N + AD590B;
    
    % compute Pressure (psia)
    C = C1 + C2 * Td + C3 * Td^2;
    D = D1 + D2 * Td;
    % T = 1 / F * 10^6;
    F = F * 10^-6;
    To = T1 + T2 *Td + T3 * Td^2 + ...
      T4 * Td^3 + T5 * Td^4;
    
    % P = C * (1 - (To / T)^2) * (1 - D * (1 - (To / T)^2));
    P = C * (1 - To^2 * F^2) * (1 - D * (1 - To^2 * F^2));
    % Pressure (db) = [pressure (psia) – 14.7] * 0.689476
    %where 14.7 psia is the assumed atmospheric pressure (based on atmospheric pressure at sea level)
    %P = P / 1.450377 * Slope + Offset;
    P = (P - 14.7) * 0.689476;
    P = P * Slope + Offset;
  end

  function Td = computeTemp(N)
    % pressure temperature compensation Td = (M * N) + B
    Td = AD590M * N + AD590B;
  end
end

