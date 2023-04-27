
length = size(time,1);

now_time = 1
j=1

for i=1:length
    r = isequal(time(i), now_time)
    if(r==0)
        new_fpds(j) = dpfs(i)
        j=j+1
        now_time = time(i)
    end
end