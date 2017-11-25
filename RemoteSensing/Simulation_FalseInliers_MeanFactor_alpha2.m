function NewPDistriF = Simulation_FalseInliers_MeanFactor_alpha2(PDistriF,MeanFactor)
%{
2017/11/24
Simulation_FalseInliers_MeanFactor_alpha1
1. Use MeanFactor to shift the most probability outliers distance

2017/11/25
Simulation_FalseInliers_MeanFactor_alpha2
1. Do not change the value in PDistriF;
%}
% NewPDistriF = PDistriF;
% if MeanFactor == 0,
%     return
% end
% NewPDistriF = [];
PDistriF_L = length(PDistriF);
PDistriF_Position = round(PDistriF.*10000)./10000; % For offering position info

NewPDistriF_Position = PDistriF_Position(1-MeanFactor:PDistriF_L);
NewPDistriF = PDistriF(1-MeanFactor:PDistriF_L);

RestPDistriF_Position = PDistriF_Position(1:-MeanFactor);
RestPDistriF = PDistriF(1:-MeanFactor);

while ~isempty(RestPDistriF_Position),
    InsertPosition = find(NewPDistriF_Position==RestPDistriF_Position(1));
    NewPDistriF_L = length(NewPDistriF_Position);
    NewPDistriF_Position = [NewPDistriF_Position(1:InsertPosition-1) RestPDistriF_Position(1) NewPDistriF_Position(InsertPosition:NewPDistriF_L)];
    NewPDistriF = [NewPDistriF(1:InsertPosition-1) RestPDistriF(1) NewPDistriF(InsertPosition:NewPDistriF_L)];
    
    RestPDistriF_Position(1) = [];
    RestPDistriF(1) = [];
end