%https://www.princeton.edu/~kung/ele571/Other-MatLab/speech/decision_boundary_sample.m

%This program demonstrates how to obtain the decision boundary of a
%GMM-based classifier. Note that it may take some time to obtain the
%boundary
%Suppose we have 2 classes of data and the data is 2-D

clear all
close all
%First, create the data

%Generate class 1 data. The data follows a  Gaussian pdf with mean mu1 and
%variance sigma1
N=50;

data1=zeros(N,2);

%Generate Class 2 data, mu2 is the mean of data and sigma2 is its variance
sigma1=9;
mu1=90;

for i=1:N
 
    data1(i,1)=randn*sigma1+mu1;
    data1(i,2)=randn*sigma1+mu1;
end

data2=zeros(N,2);

%Initialize variables for random data
sigma2=10;
mu2=120;

for i=1:N
 
    data2(i,1)=randn*sigma2+mu2;
    data2(i,2)=randn*sigma2+mu2;
end


%plot the data
figure(1),plot(data1(:,1),data1(:,2),'go',data2(:,1),data2(:,2),'bo')
title('The generated data')

%Then, create the GMMs for the 2 classes 

gmm1=gmm(2,2,'diag');
gmm2=gmm(2,2,'diag');


%Set the error value
options = foptions;
options(1)  = 1;		% Prints out error values.
options(14) = 100;		% Number of maximum iterations.


%After creating the models, we initialize it by using the training data

gmm1=gmminit(gmm1,data1,options);
gmm2=gmminit(gmm2,data1,options);

%Train the GMMs using the EM algorithm
gmm1=gmmem(gmm1,data1,options);
gmm2=gmmem(gmm2,data2,options);

%The model have now been created succesfully
figure(2),plot(data1(:,1),data1(:,2),'go',data2(:,1),data2(:,2),'bo',gmm1.centres(:,1),gmm1.centres(:,2),'kx',gmm2.centres(:,1),gmm2.centres(:,2),'rx','MarkerSize',10);
legend('Class 1 data','Class 2 data','Class 1 Centres','Class 2 Centres',-1);
title('The 2 GMMs after EM algorithm');

%Then, find the class 


%Initialize 2 empty arrays, they are 3-D in which the 1st and 2nd fields store the
%location of point in a 2-D plan and the 3rd field store the classes' likelihood
%eg. likelihood(1,1,1) store the likelihood of class 1 at location (1,1)

%The class of each point within the interval was stored in classified_result
%The array, classified_result is to store the classified class of location
%(i,j), for example, if the data point with index (5,5) was classified to
%class 10, the index (5,5) will be stored into classified_result(n1,n2,5) for some
%n1, n2.
%After that, the array classified_result will be search from (:,:,1) to
%(:,:,k) and find the location with different classes



likelihood=[];
classified_result=[];


%ind(i,j) store the class label of the data point indexd by (i,j) on the
%x-y plan
ind=[];



i=1;
j=0;
k=1;

%Determine the region on which the decision boundary is plotted
%The region should depend on sigma and mu
xmin=1;
xmax=200;
ymin=1;
ymax=200;
xinc=4;     %The interval in x-axis for performing classification
yinc=4;     %The interval in y-axis for performing classification

for x=xmin:xinc:xmax
    j=j+1;
    i=1;
    for y=ymin:yinc:ymax
        likelihood(i,j,1)=gmmprob(gmm1, [x, y]);
        likelihood(i,j,2)=gmmprob(gmm2, [x, y]);
        [val,ind(i,j)]=max(likelihood(i,j,:));
        %The class of this data point was store in ind(i,j)
        classified_result(k,:,ind(i,j))=[x,y];
        k=k+1;
        i=i+1;
        
    end
end


%plot the classification
figure(3), plot(classified_result(:,1,1), classified_result(:,2,1), 'ro' ,classified_result(:,1,2), classified_result(:,2,2), 'go' );                                        
legend('Class 1', 'Class 2' ,  -1)
title('The classification in the xy plan')


%Now, based on this classification, the boundary can be obtained by class difference
%Find the class difference

%Initial the variable ind_now as the class of the data point indexed (1,1)
ind_now=ind(1,1);

k=1;
boundary_row=[];        %2D array to store the position at which class changes occur in horizontal dimenstion
boundary_col=[];        %2D array to store the position at which class changes occur in vertical dimenstion
[num_row,num_col]=size(ind);

%Check in horizontal and vertical dimension that if there have class change
%in 2 adjance points

for i=1:num_row-1
    ind_now=ind(i,1);
    for j=1:num_col-1
        %Check if the 2 neighbour points belong to the same class
        ind_previous=ind_now;
        ind_now=ind(i,j);
        if ind_now~=ind_previous
            %record the area with class changes
            %boundary_row(k,:)=((([i,j]-[0,1]).*xinc+1)+([i,j]).*xinc+1)./2;
            boundary_row(k,:)=[(i-1)*xinc+1,((((j-1)*yinc+1))+((((j-1)*yinc+1))-yinc))./2];
            k=k+1;
        end
    end
end

k=1;
for j=1:num_col-1
    ind_now=ind(1,j);
    for i=1:num_row-1
    
        %Check if the 2 neighbour points belong to the same class
        ind_previous=ind_now;
        ind_now=ind(i,j);
        if ind_now~=ind_previous
            %record the area with class changes
            %boundary_col(k,:)=((([i,j]-[1,0]).*yinc+1)+([i,j]).*yinc+1)./2;
            boundary_col(k,:)=[((((i-1)*xinc+1))+((((i-1)*xinc+1))-xinc))./2,(j-1)*yinc+1];
            k=k+1;
        end
    end
end



%plot the boundary

%figure(4),plot(boundary_col(:,2)-1),boundary_col(:,1),'.b',boundary_row(:,2),boundary_row(:,1),'.k','MarkerSize',15,data1(:,1),data1(:,2),'go',data2(:,1),data2(:,2),'bo',gmm1.centres(:,1),gmm1.centres(:,2),'kx',gmm2.centres(:,1),gmm2.centres(:,2),'rx','MarkerSize',10);
figure(4),plot(boundary_col(:,2),(boundary_col(:,1)),'.b',boundary_row(:,2),boundary_row(:,1),'.k','MarkerSize',20);
hold on;
plot(data1(:,1),data1(:,2),'go',data2(:,1),data2(:,2),'bo',gmm1.centres(:,1),gmm1.centres(:,2),'kx',gmm2.centres(:,1),gmm2.centres(:,2),'rx','MarkerSize',10)
legend('Boundary','','Class 1 Data','Class 2 Data','Class 1 centres','Class 2 centres',-1)
title('The decision boundary and the data')
hold off

clear all;
