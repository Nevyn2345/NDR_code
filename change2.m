function [ L0, bini ] = change2( trace )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

trace = trace(2:end);
N = sum(trace);

for k = 1:N-1
    bin = 0;
    rec = 0;
    bini = 1;
    while rec ~= 1
        if bin > k
            rec = 1;
            bini = bini-1;
        else
            bin = bin + trace(bini);
            bini = bini + 1;
        end
    end
    Vk = bini/length(trace);
    L0(k) = 2*k*log(k/Vk) + 2*(N-k)*log((N-k)/(1-Vk)) - 2*N *log(N);
end
L0(~isfinite(L0))=0;
L0 = L0(5:end);
[z, idx] = max(L0);

bin = 0;
rec = 0;
bini = 1;
while rec ~= 1
    if bin > idx
        rec = 1;
        bini = bini-1;
    else
        bin = bin + trace(bini);
        bini = bini + 1;
    end
end
end