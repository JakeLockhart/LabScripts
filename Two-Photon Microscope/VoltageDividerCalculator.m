clear; clc;
format short g; format compact;

AllVoltages = [];
R = [1000, 2000, 10000, 100, 10e6, 100000, 10, 5000, 330, 220];
Vin = [3.3, 5];

for i = 1:length(Vin)
    for j = 1:length(R)
        for k = 1:length(R)

            Vout = Vin(i)*((R(j))/(R(j)+R(k)));
            AllVoltages = [AllVoltages; Vout, Vin(i), R(k), R(j)];

        end
    end
end

MinVoltage = 0.6;
MaxVoltage = 3;

MinFiltered = AllVoltages(AllVoltages(:,1) > MinVoltage, :);
MaxFiltered = MinFiltered(MinFiltered(:,1) < MaxVoltage, :);
SortedVoltages = sortrows(MaxFiltered, 1);

Data_3_3V = SortedVoltages(SortedVoltages(:,2) == 3.3, :);
Data_5V = SortedVoltages(SortedVoltages(:,2) == 5, :);