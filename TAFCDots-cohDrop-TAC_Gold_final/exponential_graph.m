%% hist
size = 1000;
Y = exprnd(1,1,size);
hist(Y,size);

%% pdf
X = 0:.1:10;
Y = exppdf(X,1/.1);
plot(X,Y);

%% show accumulation
size = 1000;
H = .5;
Y = zeros(1,size);
minT = 4;
maxT = 9;
for i=1:size
    choice = min(minT + exprnd(1/H), maxT);
    while(choice == maxT)
        choice = min(minT + exprnd(1/H), maxT);
    end
    Y(i) = choice;
end
hist(Y,20);