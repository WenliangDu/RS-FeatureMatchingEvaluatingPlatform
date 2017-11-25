function [FeaturesCoordinatesA_NewReOrdered,FeaturesCoordinatesB_NewReOrdered,TrueInliers,TrueOutiers,indexPairs,SamplingOrder_R] = Simulation_FalseInliers_alpha1_4(FeaturesWorldPlaneCoordinates,FeaturesCoordinatesA,FeaturesCoordinatesB,Ratio,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,DistributionFactor,MeanFactor)
%{
2017/04/27
Simulation_FalseInliers_alpha1
1. Select false inliers from simulated features in image plane.

2017/05/01
Simulation_FalseInliers_alpha1_1
1. Use the coordinates of features in world plane to generate false inliers.

2017/05/04
Simulation_FalseInliers_alpha1_2
1. Use Simulation_FalseInliers_BreakOrder_alpha1
2. Output add SamplingOrder_R (2017/05/06)

2017/05/04
Simulation_FalseInliers_alpha1_3
1. Use Gaussian Distribution instead of bionomial distribution
Simulation_FalseInliers_Distribution_alpha1_1 => 1_2(Simulation_GaussianDistribution_alpha1)

2017/11/23
Simulation_FalseInliers_alpha1_4
1. Add MeanFactor
2. Simulation_FalseInliers_Distribution_alpha1_2=> Simulation_FalseInliers_Distribution_alpha1_3

%}
SamplingOrder_R = [];
if Ratio ~= 0,
    %% Project features in image B to features in image A.
    % MedianPointA = [median(FeaturesCoordinatesA(:,1)) median(FeaturesCoordinatesA(:,2))];
    % MedianPointB = [median(FeaturesCoordinatesB(:,1)) median(FeaturesCoordinatesB(:,2))];

%     TransMatrixB2A = Transformation_alpha1(FeaturesCoordinatesB,FeaturesCoordinatesA);
%     FeaturesCoordinatesB2A = Tranversal_KNN_CalculateProjection_alpha1(FeaturesCoordinatesB,TransMatrixB2A);


    % MedianPointA = [median(FeaturesCoordinatesA(:,1)) median(FeaturesCoordinatesA(:,2))];
    % MedianPointB = [median(FeaturesCoordinatesB(:,1)) median(FeaturesCoordinatesB(:,2))];
    % TransMatrixB2A = [1 0 (MedianPointA(:,1) - MedianPointB(:,1));0 1 (MedianPointA(:,2) - MedianPointB(:,2));0 0 1];
    % %TransMatrix_ALL = Transformation_alpha1(MatchedLocation1,MatchedLocation2);
    % FeaturesCoordinatesB2A = Tranversal_KNN_CalculateProjection_alpha1(FeaturesCoordinatesB,TransMatrixB2A);

    % figure,
    % plot(FeaturesCoordinatesA(:,1),FeaturesCoordinatesA(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB(:,1),FeaturesCoordinatesB(:,2),'g*');
    % figure,
    % plot(FeaturesCoordinatesA(:,1),FeaturesCoordinatesA(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB2A(:,1),FeaturesCoordinatesB2A(:,2),'g*');
    %% Select false inliers
    % IdealRatio = [0 10 20 30 40 50 60 70 80 90]; % (FalseLength/(TrueLength + FalseLength))*100;
    % BestRealRaito = [0 0.092 0.172 0.245 0.315 0.383 0.453 0.527 0.611 0.719]; %FeaturesNum = 5000;
    % ProcessedRatio = BestRealRaito(IdealRatio == Ratio);
    [SamplingNumbers,FalseInlierNumber] = Simulation_FalseInliers_Distribution_alpha1_3(Ratio,FeaturesWorldPlaneCoordinates,DistributionFactor,MeanFactor);
    %% Arrange the index of FeaturesCoordinatesA and FeaturesCoordinatesB in new mapping
    [FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex] = Simulation_FalseInliers_Index_alpha1(FeaturesCoordinatesA,FeaturesCoordinatesB,SamplingNumbers,FalseInlierNumber);
    % figure,
    % plot(FeaturesCoordinatesA_New(:,1),FeaturesCoordinatesA_New(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB_New(:,1),FeaturesCoordinatesB_New(:,2),'g*');
    % for i = 1:length(TrueInliersIndex),
    %     line([FeaturesCoordinatesA_New(TrueInliersIndex(i),1) FeaturesCoordinatesB_New(TrueInliersIndex(i),1)],[FeaturesCoordinatesA_New(TrueInliersIndex(i),2) FeaturesCoordinatesB_New(TrueInliersIndex(i),2)],'Color','y');
    % end
    % for i = 1:length(FalseInliersIndex),
    %     line([FeaturesCoordinatesA_New(FalseInliersIndex(i),1) FeaturesCoordinatesB_New(FalseInliersIndex(i),1)],[FeaturesCoordinatesA_New(FalseInliersIndex(i),2) FeaturesCoordinatesB_New(FalseInliersIndex(i),2)],'Color','r');
    % end
    %% Complement the number of FeaturesCoordinatesA_New to SamplingNum
    if (size(FeaturesCoordinatesA_New,1) < size(FeaturesCoordinatesA,1)) %&& nargin > 3,
        SamplingNum = size(FeaturesCoordinatesA,1);
        [FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex,SamplingOrder_R] = Simulation_FalseInliers_Set2SamplingNum(FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,SamplingNum);
    end
    % figure,
    % plot(FeaturesCoordinatesA_New(:,1),FeaturesCoordinatesA_New(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB_New(:,1),FeaturesCoordinatesB_New(:,2),'g*');
    % for i = 1:length(TrueInliersIndex),
    %     line([FeaturesCoordinatesA_New(TrueInliersIndex(i),1) FeaturesCoordinatesB_New(TrueInliersIndex(i),1)],[FeaturesCoordinatesA_New(TrueInliersIndex(i),2) FeaturesCoordinatesB_New(TrueInliersIndex(i),2)],'Color','y');
    % end
    % for i = 1:length(FalseInliersIndex),
    %     line([FeaturesCoordinatesA_New(FalseInliersIndex(i),1) FeaturesCoordinatesB_New(FalseInliersIndex(i),1)],[FeaturesCoordinatesA_New(FalseInliersIndex(i),2) FeaturesCoordinatesB_New(FalseInliersIndex(i),2)],'Color','r');
    % end
    %% break rank
    [FeaturesCoordinatesA_NewReOrdered,FeaturesCoordinatesB_NewReOrdered,TrueInliers,TrueOutiers,indexPairs] = Simulation_FalseInliers_BreakOrder_alpha1(FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex);

    %% The true ploting 2017/07/01
%     figure,
%     plot(FeaturesCoordinatesA_NewReOrdered(:,1),FeaturesCoordinatesA_NewReOrdered(:,2),'r*');hold on
%     plot(FeaturesCoordinatesB_NewReOrdered(:,1),FeaturesCoordinatesB_NewReOrdered(:,2),'b*');
%     for i = 1:length(TrueInliers),
%         line([FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueInliers(i),1),1) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueInliers(i),2),1)],[FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueInliers(i),1),2) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueInliers(i),2),2)],'Color','g');
%     end
%     for i = 1:length(TrueOutiers),
%         line([FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueOutiers(i),1),1) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueOutiers(i),2),1)],[FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueOutiers(i),1),2) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueOutiers(i),2),2)],'Color','m');
%     end
    
    
    % figure,
    % plot(FeaturesCoordinatesA_NewReOrdered(:,1),FeaturesCoordinatesA_NewReOrdered(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB_NewReOrdered(:,1),FeaturesCoordinatesB_NewReOrdered(:,2),'g*');
    % for i = 1:length(TrueInliers),
    %     line([FeaturesCoordinatesA_NewReOrdered(TrueInliers(i),1) FeaturesCoordinatesB_NewReOrdered(TrueInliers(i),1)],[FeaturesCoordinatesA_NewReOrdered(TrueInliers(i),2) FeaturesCoordinatesB_NewReOrdered(TrueInliers(i),2)],'Color','y');
    % end
    % for i = 1:length(TrueOutiers),
    %     line([FeaturesCoordinatesA_NewReOrdered(TrueOutiers(i),1) FeaturesCoordinatesB_NewReOrdered(TrueOutiers(i),1)],[FeaturesCoordinatesA_NewReOrdered(TrueOutiers(i),2) FeaturesCoordinatesB_NewReOrdered(TrueOutiers(i),2)],'Color','r');
    % end


    % figure,
    % plot(FeaturesCoordinatesA(:,1),FeaturesCoordinatesA(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB(:,1),FeaturesCoordinatesB(:,2),'g*');
    % figure,
    % plot(FeaturesCoordinatesA(:,1),FeaturesCoordinatesA(:,2),'m*');hold on
    % plot(FeaturesCoordinatesB2A(:,1),FeaturesCoordinatesB2A(:,2),'g*');
else
    FeaturesCoordinatesA_NewReOrdered = FeaturesCoordinatesA;
    FeaturesCoordinatesB_NewReOrdered = FeaturesCoordinatesB;
    TrueInliers = 1:1:size(FeaturesCoordinatesA_NewReOrdered,1);
    TrueOutiers = [];
    indexPairs = [TrueInliers' TrueInliers'];
end