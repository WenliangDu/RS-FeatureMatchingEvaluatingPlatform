function [PDistriF,PercentageArray] = Simulation_GaussianDistribution_alpha1
%{
2017/05/07
Simulation_GaussianDistribution_alpha1
1. probability distribution function
%}
fun = @(x) (1/sqrt(2*pi))*exp((-x.^2)/2); %u=0;theta=1;
PercentageArray = [0,5;5,15;15,25;25,35;35,45;45,55;55,65;65,75;75,85;85,95;95,100];

SelectNumberL = size(PercentageArray,1); 

%Space = 6/SelectNumberL; % 6 = 3 - (-3)
StartP = -3;
PDistriF = zeros(1,SelectNumberL);
for j = 1:SelectNumberL,
    
    PDistriF(j) = integral(fun,StartP+(PercentageArray(j,1)*6)/100,StartP+(PercentageArray(j,2)*6)/100); %% 6 = 3 - (-3)
    %PDistriF(j) = integral(fun,StartP+(j-1)*Space,StartP+j*Space);
end
PDistriF(6) = PDistriF(6) + (1-sum(PDistriF));

%PercentageArray = [0,5;5,15;15,25;25,35;35,45;45,55;55,65;65,75;75,85;85,95;95,100];
