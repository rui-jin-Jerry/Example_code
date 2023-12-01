function Par = BRISC_resting_ICs_to_remove(Par, datasetNo)
%
% This function lists the indices of independent components (ICs) to remove from
% the dataset, identified by visual inspection after running ICA on the
% datsets. Indices and manually entered, and relevant preprocessing scripts
% call this function to get the IC indices.
%
% Written by Daniel Feuerriegel, 1/19

% Reset vector to avoid inheriting from last processed dataset
Par.ICsToRemove = [];

% Set ICs to remove based on visual inspection
switch [Par.subjectCodesList{datasetNo} '_', Par.testingPhase]

    case '1M0001_M'

        Par.ICsToRemove = [];

    case '1M0002_M'

        Par.ICsToRemove = [];
        
    case 'Example_Code'
        
        Par.ICsToRemove = [];

end % of Par.subjectCodesList