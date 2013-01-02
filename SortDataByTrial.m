%% Sort data by trial
%{
Fourteen total tests:  
  Grossman: 
    Horizontal = shake head horizontally
    Vertical = shake head vertically
    RIP = run in place
    WIP = walk in place
    StandOpen  = standing still, eyes open
    StandClosed = standing still, eyes closed

  For the outdoor tests:    
    RGS = Run grass shoes
    WGS = walk grass shoes
    RCS = run concrete shoes
    WCS = walk concrete shoes
    RGB = run grass barefoot
    WGB = walk grass barefoot
    RCB = run concrete barefoot
    WCB = walk concrete barefoot  

This list is hand-made, and works only for our data.  
%}
HorizontalShake = cellfun(@isempty, strfind(Data.Filename, 'Horizontal') ) == 0; 
HorizontalShakeIndices = Indices(HorizontalShake > 0 ); 
HorizontalShakeLength = length( HorizontalShakeIndices ); 

VerticalShake = cellfun(@isempty, strfind(Data.Filename, 'Vertical') ) == 0; 
VerticalShakeIndices = Indices( VerticalShake > 0 ); 
VerticalShakeLength = length( VerticalShakeIndices ); 

RunInPlace = cellfun(@isempty, strfind(Data.Filename, 'RIP') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RunInPlace') ) == 0 ; 
RunInPlaceIndices = Indices(RunInPlace > 0 );
RunInPlaceLength = length(RunInPlaceIndices); 

WalkInPlace = cellfun(@isempty, strfind(Data.Filename, 'WIP') ) == 0 + ...
    cellfun(@ismpty, strfind(Data.Filename, 'WalkInPlace') ) == 0 ; 
WalkInPlaceIndices = Indices( WalkInPlace > 0 ) ; 
WalkInPlaceLength = length(WalkInPlaceIndices); 

StandOpen = cellfun(@isempty, strfind(Data.Filename, 'StandOpen' ) ) == 0; 
StandOpenIndices = Indices( StandOpen > 0 ) ; 
StandOpenLength = length(StandOpenIndices); 
    
StandClosed = cellfun(@isempty, strfind(Data.Filename, 'StandClosed' ) ) == 0; 
StandClosedIndices = Indices( StandClosed > 0 ) ; 
StandClosedLength = length(StandClosedIndices); 

RunGrassShoes = cellfun(@isempty, strfind(Data.Filename, 'RGS') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RunShoesGrass') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RUNSHOESGRASS') ) == 0; 
RunGrassShoesIndices = Indices(RunGrassShoes > 0 ); 
RunGrassShoesLength = length(RunGrassShoesIndices); 

WalkGrassShoes = cellfun(@isempty, strfind(Data.Filename, 'WGS') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WalkShoesGrass') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WALKSHOESGRASS') ) == 0; 
WalkShoesGrassIndices = Indices( WalkShoesGrass > 0 ) ; 
WalkShoesGrassLength = length(WalkShoesGrass); 

RunConcreteShoes = cellfun(@isempty, strfind(Data.Filename, 'RCS') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RunShoesConcrete') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RUNSHOESCONCRETE') ) == 0; 
RunConcreteShoesIndices = Indices(RunConcreteShoes > 0 );
RunConcreteShoesLength = length(RunConcreteShoesIndices); 

WalkConcreteShoes = cellfun(@isempty, strfind(Data.Filename, 'WCS') ) == 0 + ...
    cellfun(@isempty, strfind(Data.FileName, 'WalkShoesConcrete') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WALKSHOESCONCRETE') ) == 0; 
WalkConcreteShoesIndices = Indices(WalkConcreteShoes > 0 ) ; 
WalkConcreteShoesLength = length(WalkConcreteShoesIndices); 

RunGrassBarefoot = cellfun(@isempty, strfind(Data.Filename, 'RGB') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RunBareGrass') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RUNBAREGRASS') ) == 0; 
RunGrassBarefootIndices = Indices(RunGrassBarefoot > 0 ); 
RunGrassBarefootLength = length(RunGrassBarefootIndices); 

WalkGrassBarefoot = cellfun(@isempty, strfind(Data.Filename, 'WGB') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WalkBareGrass') ) == 0 + ...
    cellfun(@isempty, strfind('WALKBAREGRASS') ) == 0; 
WalkGrassBarefootIndices = Indices( WalkGrassBarefoot > 0 ) ; 
WalkGrassBarefootLength = length(WalkGrassBarefootIndices); 

RunConcreteBarefoot = cellfun(@isempty, strfind(Data.Filename, 'RCB')) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RunBareConcrete') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'RUNBARECONCRETE') ) == 0; 
RunConcreteBarefootIndices = Indices( RunConcreteBarefoot > 0 ) ; 
RunConcreteBarefootLength = length(RunConcreteBarefootIndices ) ; 

WalkConcreteBarefoot = cellfun(@isempty, strfind(Data.Filename, 'WCB'))== 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WalkConcreteBarefoot') ) == 0 + ...
    cellfun(@isempty, strfind(Data.Filename, 'WALKCONCRETEBAREFOOT') ) == 0; 
WalkConcreteBarefootIndices = Indices( WalkConcreteBarefoot ) ; 
WalkConcreteBarefootLength = length(WalkConcreteBarefootIndices); 