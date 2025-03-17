clear
clc

Count = [1,0,0,0,1,0,0,0,0,406,1669,0,1,0,1,0,0,0,0,130,0,0,0,0,1,0,0,0,1,131,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,5,152];
WW = [0 1 0];

Cat = [Count, WW];

figure(1)
findpeaks(findpeaks(Cat));
[c,d] = findpeaks(findpeaks(Cat));

for i = 1:size(c,2)
    x(i) = find(Count == c(i));
end


Count(x)