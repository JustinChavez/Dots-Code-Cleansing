correct = load('H_.1/correct.mat');
correct = correct.correct;

time_elapsed = load('H_.1/time_elapsed.mat');
time_elapsed = time_elapsed.time_elapsed;

%round up to closest 

time_elapsed_round = ceil(time_elapsed * 2) / 2;
X_1 = unique(time_elapsed_round);
Y = zeros(2,size(X_1,2));


for i=1:size(correct, 2)
    
    ind = find(X_1==time_elapsed_round(i));
    Y(1,ind) = Y(1,ind) + correct(i);
    Y(2,ind) = Y(2,ind) + 1;
    
end

for i=1:size(Y,2)
   Y_1(1,i) = Y(1,i) / Y(2,i);
    
end

correct = load('H_2/correct.mat');
correct = correct.correct;

time_elapsed = load('H_2/time_elapsed.mat');
time_elapsed = time_elapsed.time_elapsed;

%round up to closest 

time_elapsed_round = ceil(time_elapsed * 2) / 2;
X_2 = unique(time_elapsed_round);
Y = zeros(2,size(X_2,2));


for i=1:size(correct, 2)
    
    ind = find(X_2==time_elapsed_round(i));
    Y(1,ind) = Y(1,ind) + correct(i);
    Y(2,ind) = Y(2,ind) + 1;
    
end

for i=1:size(Y,2)
   Y_2(1,i) = Y(1,i) / Y(2,i);
    
end

%use the x-axis of the ones with the smallest unique values
%TODO: splitting of this needs to be more autominized. It relies on X_1
%being bigger than X_2. 
plot(X_2, Y_1(1,1:size(X_2,2)), X_2,Y_2(1,:))
