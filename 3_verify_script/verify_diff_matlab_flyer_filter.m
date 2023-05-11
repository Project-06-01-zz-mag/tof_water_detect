subplot(3,1,1);
plot(fly_filte,'r')
hold on
subplot(3,1,2);
plot(r,'k')
 hold on
 
 size_data = size(fly_filte)
 for i = 1:size_data
     diff(i) = fly_filte(i) - r(i) 
 end
 subplot(3,1,3);
plot(diff,'k')