function [GroupByTrial, GroupByChannel ] = ...
    GenerateGroupVariables(Data, TrialNames, TrialLengths)

GroupByTrial = cell(length(Data), 1); 
[GroupByTrial{1:...
    (3 * TrialLengths(1) ) } ] = deal(TrialNames{1}); 
[GroupByTrial{(3 * TrialLengths(1) + 1 ) : ...
    (3 * TrialLengths(1) + 3 * TrialLengths(2) ) } ] = deal(TrialNames{2}); 
[GroupByTrial{ ( 3 * TrialLengths(1) + 3 * TrialLengths(2) + 1 ) : ...
        (3 * TrialLengths(1) + 3 * TrialLengths(2) + 3 * TrialLengths(3)) } ] = ...
        deal(TrialNames{3}); 

LengthTrialOne = TrialLengths(1); LengthTrialTwo = TrialLengths(2); 
LengthTrialThree = TrialLengths(3); 

[GroupByChannel{1:LengthTrialOne}] = deal('Roll'); 
[GroupByChannel{(LengthTrialOne+1):(2 * LengthTrialOne) }] = deal('Pitch'); 
[GroupByChannel{(LengthTrialOne * 2 + 1):(3 * LengthTrialOne) }] = deal('Yaw'); 
[GroupByChannel{(3 * LengthTrialOne + 1) : ...
    (3 * LengthTrialOne + LengthTrialTwo) } ] = deal('Roll'); 
[GroupByChannel{ (3 * LengthTrialOne + LengthTrialTwo + 1) : ...
    ( 3 * LengthTrialOne + 2 * LengthTrialTwo) }] = deal('Pitch'); 
[GroupByChannel{ ( 3 * LengthTrialOne + 2 * LengthTrialTwo + 1) : ...
    ( 3 * LengthTrialOne + 3 * LengthTrialTwo) }] = deal('Yaw'); 
[GroupByChannel{ ( 3 * LengthTrialOne + 3 * LengthTrialTwo + 1) : ...
    ( 3 * LengthTrialOne + 3 * LengthTrialTwo + LengthTrialThree ) } ] = ...
    deal('Roll'); 
[GroupByChannel{ (3*LengthTrialOne + ...
    3*LengthTrialTwo + LengthTrialThree + 1) : ...
    (3*LengthTrialOne + 3*LengthTrialTwo + 2*LengthTrialThree) } ] = ...
    deal('Pitch'); 
[GroupByChannel{ ( 3*LengthTrialOne + 3*LengthTrialTwo + ...
    2*LengthTrialThree + 1) : ...
    (3*LengthTrialOne + 3*LengthTrialTwo + 3*LengthTrialThree) } ] = ...
    deal('Yaw');


    