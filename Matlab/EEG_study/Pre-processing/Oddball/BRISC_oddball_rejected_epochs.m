function [Par, EEG] = BRISC_oddball_rejected_epochs(Par, datasetNo, EEG)
%
% This function rejects epochs identified via visual inspection. The lists
% of bad epochs for each dataset are containing within this function.
%
% Written by Daniel Feuerriegel, 1/19

switch [Par.subjectCodesList{datasetNo} '_', Par.testingPhase]

    case '1M0387_M'

        EEG = pop_rejepoch( EEG, [77 78 104 105:107 117 118:120 157 186 196 197 200 206 212 214 215 216 222 243 244:247 251 318 359 439 441 448 449 450 469 470 475 476:477] , 0);
        
    case '3F0425_M'
        
        % No epochs to reject
        
    case 'EXAMPLE'
        
        
        
end % of switch