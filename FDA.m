%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Using Fisher idea to transform the original dataset to a one-dimensional dataset

load gamma;

N1 = size(trainLabels(trainLabels(:,1)==1),1);
N2 = size(trainLabels(trainLabels(:,1)==0),1);

train_1 = train(trainLabels(:,1)==1,:);
train_2 = train(trainLabels(:,1)==0,:);

%%%% mean
mean_class1 = mean(train_1);
mean_class2 = mean(train_2);


%%%% S_W
%class1
s1 = train_1;
for i=1:size(train_1,1)
    s1(i,:) = train_1(i,:) - mean_class1;
end
s1 =  s1'*s1;

%class2
s2 = train_2;
for i=1:size(train_2,1)
    s2(i,:) = train_2(i,:) - mean_class2;
end
s2 =  s2'*s2;

S_W = s1 + s2 ;

%%%% S_B
overal_mean = mean(train);
sb_1 = (mean_class1 - overal_mean)'*(mean_class1 - overal_mean);
sb_2 = (mean_class2 - overal_mean)'*(mean_class2 - overal_mean);

S_B = N1*sb_1 + N2*sb_2;
              
%%%% eigenvalue problem 
[u, v] = eig(inv(S_W)*S_B);

W = [u(:, 1), u(:, 2)];
Data_Fda = train*W;
Data_Fda = [Data_Fda, trainLabels];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% desgin a classifier based on Fisher idea 1

alpha = (mean_class1*W + mean_class2*W)/2;

num=0;
for i=1:size(test,1)
    class =1;
   if(test(i,:)*W)> alpha
       class =0;
   end
   if(testLabels(i)==class)
       num = num +1;
   end
end

correctness_precision = (num/size(test,1))*100


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% desgin a classifier based on Fisher idea 2
mean1 = mean_class1*W;
mean2 = mean_class2*W;

pi_1 = N1/size(trainLabels,1);
pi_2 = N2/size(trainLabels,1);

alpha = ((mean1.*pi_1)+(mean2.*pi_2));

num=0;
for i=1:size(test,1)
    class =1;
   if(test(i,:)*W)> alpha
       class =0;
   end
   if(testLabels(i)==class)
       num = num +1;
   end
end

correctness_precision = (num/size(test,1))*100
