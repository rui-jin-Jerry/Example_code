function Par = BRISC_oddball_bad_channels(Par, datasetNo, EEG)
%
% Names/Numbers of bad channels are entered into this function. This is
% called by the relevant BRISC EEG preprocessing scripts to get these lists
% of noisy channels.
%
% Written by Daniel Feuerriegel, 1/19

Par.badChannelLabels = {};

% Set bad channels based on visual inspection or tester notes
switch [Par.subjectCodesList{datasetNo} '_', Par.testingPhase]
    
% All Midline (399) 

case   '1F0298_M'
   Par.badChannelLabels = {};

case   '1F0309_M'
   Par.badChannelLabels = {};

case   '1F0313_M'
   Par.badChannelLabels = {};

case   '1F0327_M'
   Par.badChannelLabels = {'F8',};

case   '1F0330_M'
   Par.badChannelLabels = {'C3',};

case   '1F0337_M'
   Par.badChannelLabels = {};

case   '1F0339_M'
   Par.badChannelLabels = {'O1','Oz','P7',};

case   '1F0347_M'
   Par.badChannelLabels = {'F3','CP6',};

case   '1F0348_M'
   Par.badChannelLabels = {};

case   '1F0350_M'
   Par.badChannelLabels = {'F3',};

case   '1F0352_M'
   Par.badChannelLabels = {};

case   '1F0354_M'
   Par.badChannelLabels = {'CP1','F3','CP2',};

case   '1F0358_M'
   Par.badChannelLabels = {'O1','O2','Oz','CP2',};

case   '1F0364_M'
   Par.badChannelLabels = {'C3','T7',};

case   '1F0365_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '1F0367_M'
   Par.badChannelLabels = {};

case   '1F0369_M'
   Par.badChannelLabels = {'F3',};

case   '1F0370_M'
   Par.badChannelLabels = {};

case   '1F0371_M'
   Par.badChannelLabels = {'F3',};

case   '1F0373_M'
   Par.badChannelLabels = {'C3',};

case   '1F0374_M'
   Par.badChannelLabels = {};

case   '1F0378_M'
   Par.badChannelLabels = {'C3','T8',};

case   '1F0379_M'
   Par.badChannelLabels = {'P3','P7','F3',};

case   '1F0380_M'
   Par.badChannelLabels = {};

case   '1F0382_M'
   Par.badChannelLabels = {};

case   '1F0384_M'
   Par.badChannelLabels = {};

case   '1F0386_M'
   Par.badChannelLabels = {};

case   '1F0387_M'
   Par.badChannelLabels = {};

% case   '1F0389_M'
%    Par.badChannelLabels = {}; % BadRef,};
case   '1F0389_M'
   Par.badChannelLabels = {};
   
case   '1F0390_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '1F0391_M'
   Par.badChannelLabels = {'CP1',};

case   '1F0393_M'
   Par.badChannelLabels = {};

case   '1F0394_M'
   Par.badChannelLabels = {'T8',};

case   '1F0395_M'
   Par.badChannelLabels = {};

case   '1F0396_M'
   Par.badChannelLabels = {};

case   '1F0397_M'
   Par.badChannelLabels = {};

case   '1F0399_M'
   Par.badChannelLabels = {'Pz',};

case   '1F0413_M'
   Par.badChannelLabels = {'P7',};

case   '1F0415_M'
   Par.badChannelLabels = {};

case   '1F0417_M'
   Par.badChannelLabels = {'P7','P8',};

case   '1F0430_M'
   Par.badChannelLabels = {'Pz',};

case   '1F0433_M'
   Par.badChannelLabels = {'Pz','T8',};

% case   '1F0438_M'
%    Par.badChannelLabels = {}; % BadRef,};

case   '1F0438_M'
   Par.badChannelLabels = { };
   
case   '1F0442_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '1F0443_M'
   Par.badChannelLabels = {'O2','P7',};

case   '1F0447_M'
   Par.badChannelLabels = {'Fp1','T7','Pz',};

case   '1F0448_M'
   Par.badChannelLabels = {'T7',};

case   '1F0450_M'
   Par.badChannelLabels = {'Fp1','Fp2','Pz',};

case   '1F0452_M'
   Par.badChannelLabels = {'P8','Fp2',};

case   '1F0455_M'
   Par.badChannelLabels = {'Pz',};

case   '1F0457_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1F0459_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1F0463_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '1F0468_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1F0469_M'
   Par.badChannelLabels = {'F4','F8',};

case   '1F0470_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1F0476_M'
   Par.badChannelLabels = {'Fp1','F3','Pz',};

case   '1F0479_M'
   Par.badChannelLabels = {'Fp1',};

case   '1F0481_M'
   Par.badChannelLabels = {'Fp1',};

case   '1F0482_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1F0489_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '1F0491_M'
   Par.badChannelLabels = {'Fp1',};

case   '1F0497_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '1F0499_M'
   Par.badChannelLabels = {'P7',};

case   '1F0503_M'
   Par.badChannelLabels = {'P7',};

case   '1F0505_M'
   Par.badChannelLabels = {'Fp1','P7','P8',};

case   '1M0347_M'
   Par.badChannelLabels = {};

case   '1M0349_M'
   Par.badChannelLabels = {};

case   '1M0352_M'
   Par.badChannelLabels = {};

case   '1M0355_M'
   Par.badChannelLabels = {};

case   '1M0356_M'
   Par.badChannelLabels = {'Fp2',};

case   '1M0358_M'
   Par.badChannelLabels = {};

case   '1M0362_M'
   Par.badChannelLabels = {};

case   '1M0370_M'
   Par.badChannelLabels = {'FT9','P8',};

case   '1M0376_M'
   Par.badChannelLabels = {};

case   '1M0377_M'
   Par.badChannelLabels = {};

case   '1M0381_M'
   Par.badChannelLabels = {};

case   '1M0382_M'
   Par.badChannelLabels = {'CP6',};

case   '1M0383_M'
   Par.badChannelLabels = {'F3',};

case   '1M0387_M'
   Par.badChannelLabels = {'Fz','FC2',};

case   '1M0392_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '1M0393_M'
   Par.badChannelLabels = {};

case   '1M0394_M'
   Par.badChannelLabels = {'T8',};

case   '1M0398_M'
   Par.badChannelLabels = {'F3','T8',};

case   '1M0399_M'
   Par.badChannelLabels = {};

case   '1M0400_M'
   Par.badChannelLabels = {};

case   '1M0403_M'
   Par.badChannelLabels = {'T8',};

case   '1M0408_M'
   Par.badChannelLabels = {'F3',};

case   '1M0409_M'
   Par.badChannelLabels = {'F3',};

case   '1M0410_M'
   Par.badChannelLabels = {'F3','Cz',};

case   '1M0411_M'
   Par.badChannelLabels = {};

case   '1M0414_M'
   Par.badChannelLabels = {'FT9',};

case   '1M0416_M'
   Par.badChannelLabels = {'Fp1','T7',};

case   '1M0417_M'
   Par.badChannelLabels = {};

case   '1M0420_M'
   Par.badChannelLabels = {};

case   '1M0422_M'
   Par.badChannelLabels = {};

case   '1M0425_M'
   Par.badChannelLabels = {'P4',};

case   '1M0428_M'
   Par.badChannelLabels = {'T7','T8',};

case   '1M0429_M'
   Par.badChannelLabels = {};

case   '1M0432_M'
   Par.badChannelLabels = {};

case   '1M0433_M'
   Par.badChannelLabels = {'F8',};

case   '1M0436_M'
   Par.badChannelLabels = {};

case   '1M0443_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '1M0452_M'
   Par.badChannelLabels = {};

case   '1M0463_M'
   Par.badChannelLabels = {};

case   '1M0465_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '1M0466_M'
   Par.badChannelLabels = {};

case   '1M0467_M'
   Par.badChannelLabels = {};

case   '1M0468_M'
   Par.badChannelLabels = {};

case   '1M0471_M'
   Par.badChannelLabels = {'P7',};

case   '1M0472_M'
   Par.badChannelLabels = {'Fp2',};

case   '1M0475_M'
   Par.badChannelLabels = {'Pz','Fp2',};

case   '1M0478_M'
   Par.badChannelLabels = {'Pz','Fp2',};

case   '1M0501_M'
   Par.badChannelLabels = {'T8','P7',};

case   '1M0503_M'
   Par.badChannelLabels = {};

case   '1M0504_M'
   Par.badChannelLabels = {'T7',};

case   '1M0505_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1M0511_M'
   Par.badChannelLabels = {'CP5',};

case   '1M0517_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '1M0521_M'
   Par.badChannelLabels = {'Fp1',};

case   '1M0529_M'
   Par.badChannelLabels = {'CP6',};

case   '1M0532_M'
   Par.badChannelLabels = {'Fp1',};

case   '1M0535_M'
   Par.badChannelLabels = {'Fp1',};

case   '1M0536_M'
   Par.badChannelLabels = {'Fp1',};

case   '1M0542_M'
   Par.badChannelLabels = {'P7',};

case   '1M0543_M'
   Par.badChannelLabels = {'Fp1','P8',};

case   '1M0544_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '1M0545_M'
   Par.badChannelLabels = {'P7','Pz',};

case   '1M0547_M'
   Par.badChannelLabels = {};

case   '1M0548_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '1M0549_M'
   Par.badChannelLabels = {'Fp2','P4','P7','CP5',};

case   '2F0373_M'
   Par.badChannelLabels = {};

case   '2F0375_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0377_M'
   Par.badChannelLabels = {};

case   '2F0383_M'
   Par.badChannelLabels = {};

case   '2F0391_M'
   Par.badChannelLabels = {};

case   '2F0399_M'
   Par.badChannelLabels = {'Fp1','Fp2','O1','O2','Oz',};

case   '2F0400_M'
   Par.badChannelLabels = {};

case   '2F0401_M'
   Par.badChannelLabels = {'T7',};

case   '2F0402_M'
   Par.badChannelLabels = {};

case   '2F0403_M'
   Par.badChannelLabels = {};

case   '2F0404_M'
   Par.badChannelLabels = {'P7',};

case   '2F0409_M'
   Par.badChannelLabels = {'P4','F8',};

case   '2F0410_M'
   Par.badChannelLabels = {};

case   '2F0411_M'
   Par.badChannelLabels = {};

case   '2F0412_M'
   Par.badChannelLabels = {};

case   '2F0415_M'
   Par.badChannelLabels = {};

case   '2F0416_M'
   Par.badChannelLabels = {};

case   '2F0418_M'
   Par.badChannelLabels = {'P7',};

case   '2F0419_M'
   Par.badChannelLabels = {};

case   '2F0420_M'
   Par.badChannelLabels = {'FT9',};

case   '2F0421_M'
   Par.badChannelLabels = {};

case   '2F0423_M'
   Par.badChannelLabels = {};

case   '2F0425_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '2F0427_M'
   Par.badChannelLabels = {};

case   '2F0432_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0435_M'
   Par.badChannelLabels = {};

case   '2F0436_M'
   Par.badChannelLabels = {'F4',};

case   '2F0437_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0438_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0439_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0440_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0441_M'
   Par.badChannelLabels = {'T7',};

case   '2F0442_M'
   Par.badChannelLabels = {'FT9',};

case   '2F0443_M'
   Par.badChannelLabels = {'T8',};

case   '2F0446_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0451_M'
   Par.badChannelLabels = {};

case   '2F0453_M'
   Par.badChannelLabels = {'Fp2',};

case   '2F0472_M'
   Par.badChannelLabels = {};

case   '2F0475_M'
   Par.badChannelLabels = {'P3','Pz',};

case   '2F0479_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '2F0482_M'
   Par.badChannelLabels = {'Fp1','FT10','Pz',};

case   '2F0483_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '2F0489_M'
   Par.badChannelLabels = {'Pz',};

case   '2F0492_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0494_M'
   Par.badChannelLabels = {'Fp1','T8',};

case   '2F0496_M'
   Par.badChannelLabels = {};

case   '2F0497_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0498_M'
   Par.badChannelLabels = {'Pz',};

case   '2F0499_M'
   Par.badChannelLabels = {'Pz',};

case   '2F0500_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0502_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0503_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0508_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0513_M'
   Par.badChannelLabels = {'Pz',};

case   '2F0516_M'
   Par.badChannelLabels = {};

case   '2F0533_M'
   Par.badChannelLabels = {'Fp1','P4','CP2',};

case   '2F0537_M'
   Par.badChannelLabels = {'Fp1',};

case   '2F0538_M'
   Par.badChannelLabels = {};

case   '2F0539_M'
   Par.badChannelLabels = {'Fp1','F4',};

case   '2F0541_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '2F0542_M'
   Par.badChannelLabels = {'Fp1','P4','P7',};

case   '2F0544_M'
   Par.badChannelLabels = {'F3','P7',};

case   '2F0546_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '2F0548_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '2M0334_M'
   Par.badChannelLabels = {};

case   '2M0341_M'
   Par.badChannelLabels = {};

case   '2M0342_M'
   Par.badChannelLabels = {'O1','Oz','O2','P7','P4',};

case   '2M0343_M'
   Par.badChannelLabels = {};

case   '2M0344_M'
   Par.badChannelLabels = {};

case   '2M0348_M'
   Par.badChannelLabels = {};

case   '2M0349_M'
   Par.badChannelLabels = {};

case   '2M0351_M'
   Par.badChannelLabels = {'CP2',};

case   '2M0353_M'
   Par.badChannelLabels = {};

case   '2M0354_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0356_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0360_M'
   Par.badChannelLabels = {};

case   '2M0365_M'
   Par.badChannelLabels = {};

case   '2M0368_M'
   Par.badChannelLabels = {};

case   '2M0371_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '2M0374_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '2M0381_M'
   Par.badChannelLabels = {};

case   '2M0384_M'
   Par.badChannelLabels = {'F3',};

case   '2M0385_M'
   Par.badChannelLabels = {'F3',};

case   '2M0386_M'
   Par.badChannelLabels = {'P7',};

case   '2M0387_M'
   Par.badChannelLabels = {};

case   '2M0390_M'
   Par.badChannelLabels = {'T7','C3',};

case   '2M0391_M'
   Par.badChannelLabels = {};

case   '2M0392_M'
   Par.badChannelLabels = {};

case   '2M0394_M'
   Par.badChannelLabels = {};

case   '2M0395_M'
   Par.badChannelLabels = {};

case   '2M0397_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '2M0398_M'
   Par.badChannelLabels = {};

case   '2M0400_M'
   Par.badChannelLabels = {};

case   '2M0402_M'
   Par.badChannelLabels = {'P7',};

case   '2M0403_M'
   Par.badChannelLabels = {};

case   '2M0404_M'
   Par.badChannelLabels = {};

case   '2M0405_M'
   Par.badChannelLabels = {'Pz','P7',};

case   '2M0408_M'
   Par.badChannelLabels = {};

case   '2M0420_M'
   Par.badChannelLabels = {'Fp2',};

case   '2M0421_M'
   Par.badChannelLabels = {};

case   '2M0422_M'
   Par.badChannelLabels = {'CP5','P7',};

case   '2M0423_M'
   Par.badChannelLabels = {};

case   '2M0424_M'
   Par.badChannelLabels = {'T7','T8',};

case   '2M0427_M'
   Par.badChannelLabels = {};

case   '2M0431_M'
   Par.badChannelLabels = {};

case   '2M0432_M'
   Par.badChannelLabels = {'F7','P8','CP6',};

case   '2M0433_M'
   Par.badChannelLabels = {'P7',};

case   '2M0434_M'
   Par.badChannelLabels = {};

case   '2M0435_M'
   Par.badChannelLabels = {'T8',};

case   '2M0436_M'
   Par.badChannelLabels = {};

case   '2M0437_M'
   Par.badChannelLabels = {};

case   '2M0438_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0441_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0443_M'
   Par.badChannelLabels = {'P7',};

case   '2M0445_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '2M0454_M'
   Par.badChannelLabels = {'P8',};

case   '2M0460_M'
   Par.badChannelLabels = {};

case   '2M0461_M'
   Par.badChannelLabels = {'P7',};

case   '2M0462_M'
   Par.badChannelLabels = {'P7','FT10',};

case   '2M0465_M'
   Par.badChannelLabels = {'P4','CP2',};

case   '2M0467_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0472_M'
   Par.badChannelLabels = {};

case   '2M0479_M'
   Par.badChannelLabels = {'Pz',};

case   '2M0484_M'
   Par.badChannelLabels = {'T8','FT10',};

case   '2M0488_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '2M0518_M'
   Par.badChannelLabels = {'T8',};

case   '2M0522_M'
   Par.badChannelLabels = {'Fp1','P7','FT9',};

case   '2M0523_M'
   Par.badChannelLabels = {'P4','P7',};

case   '2M0526_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '2M0529_M'
   Par.badChannelLabels = {'P7','CP5','FT10','Fp1',};

case   '3F0379_M'
   Par.badChannelLabels = {};

case   '3F0383_M'
   Par.badChannelLabels = {'FC5','FC6','P7','Fp1',};

case   '3F0386_M'
   Par.badChannelLabels = {};

case   '3F0388_M'
   Par.badChannelLabels = {};

case   '3F0400_M'
   Par.badChannelLabels = {};

case   '3F0408_M'
   Par.badChannelLabels = {};

case   '3F0409_M'
   Par.badChannelLabels = {};

case   '3F0411_M'
   Par.badChannelLabels = {};

case   '3F0420_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0421_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '3F0422_M'
   Par.badChannelLabels = {'Fz','FC1','FC2',};

case   '3F0423_M'
   Par.badChannelLabels = {'P3','P4','P7','P8',};

case   '3F0425_M'
   Par.badChannelLabels = {'Fz','F3','Cz','FC2',};

case   '3F0430_M'
   Par.badChannelLabels = {};

case   '3F0431_M'
   Par.badChannelLabels = {};

case   '3F0435_M'
   Par.badChannelLabels = {'F3',};

case   '3F0442_M'
   Par.badChannelLabels = {'F3','Pz',};

case   '3F0443_M'
   Par.badChannelLabels = {'Cp5',};

case   '3F0455_M'
   Par.badChannelLabels = {'C3','T7',};

case   '3F0456_M'
   Par.badChannelLabels = {};

case   '3F0458_M'
   Par.badChannelLabels = {'C3',};

case   '3F0459_M'
   Par.badChannelLabels = {};

case   '3F0462_M'
   Par.badChannelLabels = {};

case   '3F0469_M'
   Par.badChannelLabels = {'F3',};

case   '3F0470_M'
   Par.badChannelLabels = {};

case   '3F0471_M'
   Par.badChannelLabels = {'P7',};

case   '3F0472_M'
   Par.badChannelLabels = {};

case   '3F0473_M'
   Par.badChannelLabels = {};

case   '3F0474_M'
   Par.badChannelLabels = {};

case   '3F0477_M'
   Par.badChannelLabels = {'T7',};

case   '3F0478_M'
   Par.badChannelLabels = {'T7',};

case   '3F0479_M'
   Par.badChannelLabels = {};

case   '3F0480_M'
   Par.badChannelLabels = {'T7',};

case   '3F0482_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0483_M'
   Par.badChannelLabels = {};

case   '3F0485_M'
   Par.badChannelLabels = {'Fp1','T8','Fp2','FC6',};

case   '3F0488_M'
   Par.badChannelLabels = {};

case   '3F0489_M'
   Par.badChannelLabels = {'P8',};

case   '3F0492_M'
   Par.badChannelLabels = {};

case   '3F0501_M'
   Par.badChannelLabels = {};

case   '3F0503_M'
   Par.badChannelLabels = {};

case   '3F0505_M'
   Par.badChannelLabels = {'Fp2',};

case   '3F0506_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0507_M'
   Par.badChannelLabels = {};

case   '3F0511_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0513_M'
   Par.badChannelLabels = {};

case   '3F0519_M'
   Par.badChannelLabels = {'P8',};

case   '3F0522_M'
   Par.badChannelLabels = {'Oz',};

case   '3F0524_M'
   Par.badChannelLabels = {};

case   '3F0530_M'
   Par.badChannelLabels = {'Pz',};

case   '3F0543_M'
   Par.badChannelLabels = {'M','i','s','s','i','n','g',};

case   '3F0550_M'
   Par.badChannelLabels = {'Fp1','Pz','CP5',};

case   '3F0551_M'
   Par.badChannelLabels = {'Pz',};

case   '3F0552_M'
   Par.badChannelLabels = {'Fp1',};

case   '3F0553_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0556_M'
   Par.badChannelLabels = {'P7','FT9',};

case   '3F0557_M'
   Par.badChannelLabels = {'Fp1',};

case   '3F0558_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0559_M'
   Par.badChannelLabels = {'F8','P7','Pz',};

case   '3F0561_M'
   Par.badChannelLabels = {'Fp1',};

case   '3F0562_M'
   Par.badChannelLabels = {};

case   '3F0563_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0564_M'
   Par.badChannelLabels = {};

case   '3F0566_M'
   Par.badChannelLabels = {};

case   '3F0568_M'
   Par.badChannelLabels = {'T8',};

case   '3F0573_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '3F0575_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3F0577_M'
   Par.badChannelLabels = {'Fp1',};

case   '3F0578_M'
   Par.badChannelLabels = {'CP6','P7',};

case   '3M0372_M'
   Par.badChannelLabels = {};

case   '3M0373_M'
   Par.badChannelLabels = {};

case   '3M0374_M'
   Par.badChannelLabels = {};

case   '3M0377_M'
   Par.badChannelLabels = {'C4',};

case   '3M0387_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3M0389_M'
   Par.badChannelLabels = {'O2',};

case   '3M0390_M'
   Par.badChannelLabels = {};

case   '3M0403_M'
   Par.badChannelLabels = {'F3',};

case   '3M0404_M'
   Par.badChannelLabels = {'F3','Fp1','Fp2',};

case   '3M0408_M'
   Par.badChannelLabels = {'Fp2',};

case   '3M0409_M'
   Par.badChannelLabels = {'F3',};

case   '3M0413_M'
   Par.badChannelLabels = {'Pz',};

case   '3M0419_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3M0428_M'
   Par.badChannelLabels = {};

case   '3M0431_M'
   Par.badChannelLabels = {'P7',};

case   '3M0433_M'
   Par.badChannelLabels = {'F3',};

case   '3M0434_M'
   Par.badChannelLabels = {'C3',};

case   '3M0438_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '3M0439_M'
   Par.badChannelLabels = {};

case   '3M0441_M'
   Par.badChannelLabels = {'C3',};

case   '3M0443_M'
   Par.badChannelLabels = {};

case   '3M0444_M'
   Par.badChannelLabels = {'T7',};

case   '3M0451_M'
   Par.badChannelLabels = {};

case   '3M0453_M'
   Par.badChannelLabels = {};

case   '3M0455_M'
   Par.badChannelLabels = {};

case   '3M0457_M'
   Par.badChannelLabels = {};

case   '3M0460_M'
   Par.badChannelLabels = {'Fp1','T8',};

case   '3M0463_M'
   Par.badChannelLabels = {};

case   '3M0467_M'
   Par.badChannelLabels = {};

case   '3M0468_M'
   Par.badChannelLabels = {'Fp2',};

case   '3M0469_M'
   Par.badChannelLabels = {};

case   '3M0472_M'
   Par.badChannelLabels = {};

case   '3M0475_M'
   Par.badChannelLabels = {};

case   '3M0478_M'
   Par.badChannelLabels = {};

case   '3M0484_M'
   Par.badChannelLabels = {'Fp1','Fp2',};

case   '3M0486_M'
   Par.badChannelLabels = {'P7',};

case   '3M0487_M'
   Par.badChannelLabels = {};

case   '3M0488_M'
   Par.badChannelLabels = {};

case   '3M0492_M'
   Par.badChannelLabels = {};

case   '3M0494_M'
   Par.badChannelLabels = {'Fp2',};

case   '3M0495_M'
   Par.badChannelLabels = {'T8',};

case   '3M0496_M'
   Par.badChannelLabels = {}; % BadRef,};

case   '3M0497_M'
   Par.badChannelLabels = {'P7','CP6',};

case   '3M0501_M'
   Par.badChannelLabels = {};

case   '3M0506_M'
   Par.badChannelLabels = {'Cz','FT10',};

case   '3M0528_M'
   Par.badChannelLabels = {'Pz',};

case   '3M0530_M'
   Par.badChannelLabels = {'Oz',};

case   '3M0532_M'
   Par.badChannelLabels = {'T7','FT9','Pz',};

case   '3M0533_M'
   Par.badChannelLabels = {};

case   '3M0534_M'
   Par.badChannelLabels = {};

case   '3M0535_M'
   Par.badChannelLabels = {'Fp1','T8',};

case   '3M0537_M'
   Par.badChannelLabels = {'T7','Pz',};

case   '3M0539_M'
   Par.badChannelLabels = {'Fp1',};

case   '3M0541_M'
   Par.badChannelLabels = {'Fp1','F7',};

case   '3M0542_M'
   Par.badChannelLabels = {'Fp1','Fp2','F7','T8','P7',};

% Special: Missing Oddball EEG file 
% case   '3M0543_M'
%    Par.badChannelLabels = {};

case   '3M0547_M'
   Par.badChannelLabels = {'Fp1','Pz',};

case   '3M0550_M'
   Par.badChannelLabels = {'Fp1','P8',};

case   '3M0552_M'
   Par.badChannelLabels = {'Fp1',};

case   '3M0553_M'
   Par.badChannelLabels = {'Fp1'}; % BadRef,};

case   '3M0555_M'
   Par.badChannelLabels = {};

case   '3M0556_M'
   Par.badChannelLabels = {'Fp1',};

case   '3M0559_M'
   Par.badChannelLabels = {'Fp1',};

case   '3M0561_M'
   Par.badChannelLabels = {'Fp1','FC5',};

case   '3M0563_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '3M0564_M'
   Par.badChannelLabels = {'Fp1','P7',};

case   '3M0565_M'
   Par.badChannelLabels = {'Fp1','F3','P7',};

case   '3M0568_M'
   Par.badChannelLabels = {'FC5','P7','T8',};

case   '3M0571_M'
   Par.badChannelLabels = {'Fp1','T7','T8','P7',};
   
% Above all midline    

% All Endline (334)
case   '1F0294_E'
   Par.badChannelLabels = {  };

case   '1F0298_E'
   Par.badChannelLabels = {'TP9','Fp2','T7' };

case   '1F0300_E'
   Par.badChannelLabels = {'F3','TP9','C4','Fp2' };

case   '1F0309_E'
   Par.badChannelLabels = {'TP9' };

case   '1F0311_E'
   Par.badChannelLabels = {  };

case   '1F0312_E'
   Par.badChannelLabels = {'T8','T7' };

case   '1F0313_E'
   Par.badChannelLabels = {'TP9','Cz','CP2','Fp2' };

case   '1F0315_E'
   Par.badChannelLabels = {  };

case   '1F0327_E'
   Par.badChannelLabels = { 'TP9','CP2'};

case   '1F0330_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1F0337_E'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1F0339_E'
   Par.badChannelLabels = { 'P7','TP9','CP2','Cz','Fp2'};

case   '1F0347_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' };

case   '1F0348_E'
   Par.badChannelLabels = {'CP2' };

case   '1F0350_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1F0352_E'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1F0354_E'
   Par.badChannelLabels = {'TP9','Oz','Cz' };

case   '1F0358_E'
   Par.badChannelLabels = {'TP9','O1','CP2' };

case   '1F0364_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '1F0365_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','T8','Fp2','Pz' };

case   '1F0367_E'
   Par.badChannelLabels = {'TP9','Pz','Oz','O1','CP2','Cz','Fp2' };

case   '1F0369_E'
   Par.badChannelLabels = {'T7','TP9','Pz','Oz','CP2','Fp2' };

case   '1F0370_E'
   Par.badChannelLabels = { };%'BadRef'

case   '1F0371_E'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Cz','F4','Fp2' };

case   '1F0373_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','C4','Fp2' };

case   '1F0374_E'
   Par.badChannelLabels = { 'T7','TP9','P7','CP2','Fp2'};

case   '1F0378_E'
   Par.badChannelLabels = {'C3','TP9','Oz','O2','CP2','Cz','Fp2' };

case   '1F0379_E'
   Par.badChannelLabels = { 'CP2'};

case   '1F0382_E'
   Par.badChannelLabels = {'Fp1','C3','TP9','Pz','P7','O1','CP2','Cz','Fp2' };

case   '1F0384_E'
   Par.badChannelLabels = {'Fp1','C3','TP9','Pz','P7','O1','CP2','Cz','Fp2' };

case   '1F0386_E'
   Par.badChannelLabels = {'C3','TP9','Pz','P7','O1','CP2','Cz','Fp2'  };

case   '1F0387_E'
   Par.badChannelLabels = {'Fp1','C3','TP9','Pz','Oz','O1','CP2','Cz','Fp2' };

% case   '1F0389_E'
%    Par.badChannelLabels = {  };

case   '1F0390_E'
   Par.badChannelLabels = {'TP9','Pz','P7','CP6','CP2','Cz','Fp2' };

case   '1F0391_E'
   Par.badChannelLabels = { };%'BadRef'

case   '1F0393_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '1F0394_E'
   Par.badChannelLabels = {'FT9','TP9','Pz','O1' };

case   '1F0395_E'
   Par.badChannelLabels = { 'C3','TP9','Pz','P7','O1','CP2','Cz','Fp2'  };

case   '1F0396_E'
   Par.badChannelLabels = {'TP9','Pz','Oz','CP2','Cz','Fp2' };

case   '1F0397_E'
   Par.badChannelLabels = {'TP9','T7','O1','Oz','CP2','Cz','Fp2' };

case   '1F0399_E'
   Par.badChannelLabels = {'TP9','T7','Pz','O1','CP2','Cz','Fp2' };

% case   '1F0413_E'
%    Par.badChannelLabels = { };

case   '1F0415_E'
   Par.badChannelLabels = {'F7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '1F0417_E'
   Par.badChannelLabels = {'Fp1','TP9' };

case   '1F0428_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '1F0429_E'
   Par.badChannelLabels = {'TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1F0430_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','Fp2' };

case   '1F0431_E'
   Par.badChannelLabels = { 'TP9','Pz','O1','CP2','Cz','Fp2'};

case   '1F0433_E'
   Par.badChannelLabels = {'TP9','CP2','Cz' };

case   '1F0438_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','Fp2' };

case   '1F0442_E'
   Par.badChannelLabels = {'TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1F0443_E'
   Par.badChannelLabels = {'FT9','C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '1F0447_E'
   Par.badChannelLabels = {'T7','TP9','Pz','Oz','O2','Fp2' };

case   '1F0448_E'
   Par.badChannelLabels = {'F3','TP9','O1','Oz','CP2','Cz','F8','Fp2' };

case   '1F0450_E'
   Par.badChannelLabels = { };%'BadRef'

case   '1F0452_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','Oz','CP2','Cz','F4','Fp2' };

case   '1F0455_E'
   Par.badChannelLabels = {'TP9','Oz','CP2','Cz','Fp2' };

case   '1F0457_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','P7','O1','Oz','CP2','Cz','Fp2' };

case   '1F0459_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Fp2' };

case   '1F0463_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','Oz','O2','CP2','Cz','F8','Fp2' };

case   '1F0468_E'
   Par.badChannelLabels = {'T7','TP9','Pz','Cz','CP2','Fp2','Oz','O2' };

case   '1F0469_E'
   Par.badChannelLabels = {'T7','TP9','Pz','Cz','CP2','Fp2','Oz','O2'  };

case   '1F0470_E'
   Par.badChannelLabels = { 'Fp1','T7','TP9','Pz','Cz','CP2','Fp2','Oz','O2'};

case   '1M0343_E'
   Par.badChannelLabels = {'F3','FC5','TP9' };

case   '1M0347_E'
   Par.badChannelLabels = {'TP9','P8' };

case   '1M0348_E'
   Par.badChannelLabels = {'P7','O1','CP6','CP2','Cz' };

case   '1M0349_E'
   Par.badChannelLabels = {'Fp1','Fp2','P4','CP6' };

case   '1M0352_E'
   Par.badChannelLabels = {  };

case   '1M0355_E'
   Par.badChannelLabels = {'TP9' };

case   '1M0356_E'
   Par.badChannelLabels = {  };

case   '1M0358_E'
   Par.badChannelLabels = { 'Pz'};

case   '1M0362_E'
   Par.badChannelLabels = {'TP9' };

case   '1M0370_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1M0376_E'
   Par.badChannelLabels = {'T7','TP9','O1','Oz','CP2','Fp2' };

case   '1M0377_E'
   Par.badChannelLabels = {'P8' };

case   '1M0381_E'
   Par.badChannelLabels = {'FC5','CP2' };

case   '1M0382_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' };

case   '1M0383_E'
   Par.badChannelLabels = {'TP9','CP2','Pz','Cz','Fp2'  };

case   '1M0387_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1M0392_E'
   Par.badChannelLabels = { 'TP9','CP2','Cz','Fp2'};

case   '1M0393_E'
   Par.badChannelLabels = {'TP9','P7','CP2','Fp2' };

case   '1M0394_E'
   Par.badChannelLabels = {'TP9','O1','CP2','Cz','C4','FC2','Fp2' };

case   '1M0398_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '1M0400_E'
   Par.badChannelLabels = {'TP9' };

case   '1M0403_E'
   Par.badChannelLabels = {'TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1M0408_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '1M0409_E'
   Par.badChannelLabels = {'T7','TP9','CP2','Cz','Fp2' };

case   '1M0410_E'
   Par.badChannelLabels = {'O1','Oz','CP2' };

case   '1M0411_E'
   Par.badChannelLabels = {'T7','CP2' };

case   '1M0414_E'
   Par.badChannelLabels = {'TP9','CP5','CP2','Cz','Fp2' };

case   '1M0416_E'
   Par.badChannelLabels = {'F3','C3','Oz','CP2','Cz','T8','Fp2' };

case   '1M0417_E'
   Par.badChannelLabels = {'O1','CP2' };

case   '1M0420_E'
   Par.badChannelLabels = { 'TP9','Pz','Oz','CP2','Cz','F4','Fp2'};

case   '1M0422_E'
   Par.badChannelLabels = {'O1','CP2','Fp2' };

case   '1M0425_E'
   Par.badChannelLabels = {'TP9','O1','CP2' };

case   '1M0428_E'
   Par.badChannelLabels = {'O1','CP2' };

% case   '1M0429_E'
%    Par.badChannelLabels = { };
% 
% case   '1M0432_E'
%    Par.badChannelLabels = { };

case   '1M0436_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','C4','Fp2' };

case   '1M0442_E'
   Par.badChannelLabels = {'TP9','P7','O1','CP2','Cz','Fp2','Oz','O2' };

case   '1M0443_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Fp2' };

case   '1M0463_E'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Fp2' };

case   '1M0465_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','FT10','Fp2' };

case   '1M0466_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2'  };

case   '1M0467_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1M0468_E'
   Par.badChannelLabels = {'TP9','Pz' };

case   '1M0471_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','Fp2' };

case   '1M0472_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','Fp2', 'Pz' };

case   '1M0475_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz' };

case   '1M0478_E'
   Par.badChannelLabels = {'FT9','TP9','Pz','CP2','Cz','Fp2' };

case   '1M0496_E'
   Par.badChannelLabels = { 'C3','TP9','O1','Oz','CP2','Cz','Fp2'};

case   '1M0501_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1M0503_E'
   Par.badChannelLabels = {'T7','TP9','O1','Oz','CP2','Cz','Fp2' };

case   '1M0504_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '1M0511_E'
   Par.badChannelLabels = {'T7','TP9','Oz','CP2','Cz','T8','Fp2' };

case   '2F0372_E'
   Par.badChannelLabels = {'P3' ,'TP9','P8','F8'};

case   '2F0373_E'
   Par.badChannelLabels = {'TP9' };

case   '2F0377_E'
   Par.badChannelLabels = {   };

case   '2F0383_E'
   Par.badChannelLabels = {'F3','CP2','TP9' };

case   '2F0391_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2','Fp1' };

case   '2F0399_E'
   Par.badChannelLabels = {'TP9','FT10','Fp2' };

case   '2F0400_E'
   Par.badChannelLabels = {'TP9','CP2' };

case   '2F0402_E'
   Par.badChannelLabels = {   };

case   '2F0403_E'
   Par.badChannelLabels = {'FC1','TP9','Oz','CP2','Cz','FC2' };

case   '2F0404_E'
   Par.badChannelLabels = {'TP9','O1' };

case   '2F0409_E'
   Par.badChannelLabels = {'TP9','Oz','CP2','Fp2','Fp1' };

case   '2F0410_E'
   Par.badChannelLabels = {'CP2','Cz','TP9' };

case   '2F0411_E'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Cz','Fp2' };

case   '2F0412_E'
   Par.badChannelLabels = {'T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2F0415_E'
   Par.badChannelLabels = { 'TP9','Oz','CP2','Cz','Fp2','C3'};

case   '2F0416_E'
   Par.badChannelLabels = {'TP9','T7','CP2','Cz','Fp2','O1' };

case   '2F0418_E'
   Par.badChannelLabels = {'TP9','O1','CP2' };

% case   '2F0419_E'
%    Par.badChannelLabels = { };

case   '2F0420_E'
   Par.badChannelLabels = {'C3','TP9','O1','CP2','Cz','Fp2' };

case   '2F0421_E'
   Par.badChannelLabels = {'O1','Cz','T8' };

case   '2F0423_E'
   Par.badChannelLabels = {'TP9','O1','Oz','C4' };

case   '2F0425_E'
   Par.badChannelLabels = {'TP9','O1','CP2' };

case   '2F0427_E'
   Par.badChannelLabels = { 'TP9','O1','CP2'};

case   '2F0432_E'
   Par.badChannelLabels = {'TP9' };

case   '2F0435_E'
   Par.badChannelLabels = {'Fp1','TP9','O1','Oz','CP2','Cz','Fp2' };

case   '2F0436_E'
   Par.badChannelLabels = {'TP9','O1' };

case   '2F0437_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2F0438_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '2F0439_E'
   Par.badChannelLabels = {'Fp1','Fp2','TP9','Pz','O1','CP2','Cz' };

case   '2F0440_E'
   Par.badChannelLabels = {'Fp1','C3','T7','TP9','Pz','P7','CP2','Cz','Fp2' };

case   '2F0441_E'
   Par.badChannelLabels = {'Pz','O1','Oz','O2','CP2','Cz' };

case   '2F0442_E'
   Par.badChannelLabels = {'Fp1','C3','T7','TP9','CP2','Cz','Fp2' };

%case   '2F0443_E'
%   Par.badChannelLabels = { };

case   '2F0445_E'
   Par.badChannelLabels = {'Fp1','TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '2F0446_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2' };

case   '2F0454_E'
   Par.badChannelLabels = {'T7','TP9','O1','CP2','Cz','Fp2' };

case   '2F0456_E'
   Par.badChannelLabels = {'C3','TP9' };

case   '2F0459_E'
   Par.badChannelLabels = {'TP9','P4','CP2','Cz' };

case   '2F0464_E'
   Par.badChannelLabels = {'T7','TP9','O1','CP2','Cz','Fp2' };

case   '2F0467_E'
   Par.badChannelLabels = {'TP9' };

case   '2F0470_E'
   Par.badChannelLabels = {'T7','TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '2F0471_E'
   Par.badChannelLabels = {'T7','TP9','O1', 'Fp2' };

case   '2F0472_E'
   Par.badChannelLabels = {'TP9' };

case   '2F0475_E'
   Par.badChannelLabels = {'TP9','P7','O1','CP2','Cz','Fp2' };

case   '2F0476_E'
   Par.badChannelLabels = {'TP9','O1','Oz','O2','CP2','Cz','Fp2' };

case   '2F0479_E'
   Par.badChannelLabels = {'BadRef' };

case   '2F0482_E'
   Par.badChannelLabels = {'TP9','O1','Oz','O2','CP2','Cz','Fp2'  };

case   '2F0483_E'
   Par.badChannelLabels = {'T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2F0489_E'
   Par.badChannelLabels = {'TP9','O1','CP2' };

case   '2F0492_E'
   Par.badChannelLabels = {'TP9','P3','O1','Oz','CP2','Cz','Fp2' };

case   '2F0494_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','O2','P4','CP2','Cz','Fp2' };

case   '2F0496_E'
   Par.badChannelLabels = {'BadRef' };

case   '2F0497_E'
   Par.badChannelLabels = {'T7','TP9' };

case   '2F0498_E'
   Par.badChannelLabels = {'Fp1','C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2F0499_E'
   Par.badChannelLabels = {'FT9','TP9','O1','Oz','CP2','Cz','Fp2' };

case   '2F0500_E'
   Par.badChannelLabels = {'Fp1', 'TP9','O1','Oz','CP2','Cz','Fp2' };

case   '2F0503_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2','O1' };

case   '2F0508_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0334_E'
   Par.badChannelLabels = {'TP9' };

case   '2M0338_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0341_E'
   Par.badChannelLabels = {'CP2' };

case   '2M0342_E'
   Par.badChannelLabels = {'T8' };

case   '2M0343_E'
   Par.badChannelLabels = { 'BadRef'};

case   '2M0344_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0348_E'
   Par.badChannelLabels = {'FC2' };

case   '2M0349_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0351_E'
   Par.badChannelLabels = {'TP9' };

case   '2M0353_E'
   Par.badChannelLabels = {'TP9' };

case   '2M0354_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2','Fp1'};

case   '2M0356_E'
   Par.badChannelLabels = {'TP9','P8' };

case   '2M0360_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' };

case   '2M0365_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '2M0368_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2'  };

case   '2M0374_E'
   Par.badChannelLabels = {'CP2' };

case   '2M0381_E'
   Par.badChannelLabels = {'TP9','CP2' };

case   '2M0382_E'
   Par.badChannelLabels = {'FC6','Oz' };

case   '2M0384_E'
   Par.badChannelLabels = {'Fp1','TP9','Pz','O1','Oz','CP2','Fp2' };

case   '2M0385_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0386_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','CP2','Cz','Fp2' };

case   '2M0387_E'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Cz','Fp2' };

case   '2M0390_E'
   Par.badChannelLabels = {'C3','TP9','CP2','Cz','Fp2' };

case   '2M0391_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0392_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' };

case   '2M0394_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' ,'O1','Oz' };

case   '2M0395_E'
   Par.badChannelLabels = {'TP9' };

% case   '2M0397_E'
%    Par.badChannelLabels = { };

case   '2M0398_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2M0400_E'
   Par.badChannelLabels = {'Oz','C4','TP9','Fp2' };

case   '2M0402_E'
   Par.badChannelLabels = {'TP9'};

case   '2M0403_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','CP2','Cz','Fp2' };

case   '2M0404_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '2M0405_E'
   Par.badChannelLabels = { 'TP9','O1','CP2','Cz','Fp2','Pz'};

case   '2M0408_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0420_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0421_E'
   Par.badChannelLabels = {'Fp1','TP9','CP1','Pz','P3','O1','Oz','CP2','Cz','Fp2' };

case   '2M0422_E'
   Par.badChannelLabels = {'TP9','Pz','O2','Oz','CP2','Cz','Fp2' };

case   '2M0423_E'
   Par.badChannelLabels = {'TP9','Pz','O2','Oz','CP2','Cz','Fp2' };

case   '2M0424_E'
   Par.badChannelLabels = {'TP9','Pz','O2','Oz','CP2','Cz','Fp2' };

case   '2M0427_E'
   Par.badChannelLabels = {'TP9','Pz','Fp1' };

case   '2M0431_E'
   Par.badChannelLabels = {'TP9','Pz','O2','Oz','CP2','Cz','Fp2'  };

case   '2M0432_E'
   Par.badChannelLabels = {'TP9','Oz','O1','CP2','Cz','Fp2' };

case   '2M0433_E'
   Par.badChannelLabels = {'TP9','Pz','O2','Oz','CP2','Cz','Fp2' ,'Fp1' };

case   '2M0434_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2'};

case   '2M0435_E'
   Par.badChannelLabels = {'CP2','TP9','Cz' };

case   '2M0436_E'
   Par.badChannelLabels = {'TP9' };

case   '2M0437_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0444_E'
   Par.badChannelLabels = {'TP9','Oz','Fp2' };

case   '2M0445_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','F4','Fp2' };

case   '2M0452_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0454_E'
   Par.badChannelLabels = {'FC1','T7','TP9','Oz','CP2','Cz' };

case   '2M0455_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','F4','Fp2' };

case   '2M0461_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0462_E'
   Par.badChannelLabels = {'C3','TP9','CP1','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2M0465_E'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','F4','Fp2' };

case   '2M0467_E'
   Par.badChannelLabels = {'TP9','CP5','O1','CP2','Cz' };

case   '2M0472_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '2M0479_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '2M0484_E'
   Par.badChannelLabels = {'BadRef' };

case   '2M0488_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0379_E'
   Par.badChannelLabels = {'O1','Oz','O2' };

case   '3F0386_E'
   Par.badChannelLabels = {'TP9','CP2','Cz','Fp2' };

case   '3F0388_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0390_E'
   Par.badChannelLabels = {'P7','O1' };

case   '3F0392_E'
   Par.badChannelLabels = { 'TP9'};

case   '3F0400_E'
   Par.badChannelLabels = {'TP9' };

case   '3F0408_E'
   Par.badChannelLabels = {'Fp1','TP9','CP2','Fp2' };

case   '3F0409_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0411_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0414_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0420_E'
   Par.badChannelLabels = {'TP9','CP2' };

case   '3F0421_E'
   Par.badChannelLabels = {'TP9','P7','CP2','Cz','Fp2' };

case   '3F0422_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0423_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' ,'Cz' };

case   '3F0425_E'
   Par.badChannelLabels = {'T7','T8','Fp2' };

case   '3F0430_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0431_E'
   Par.badChannelLabels = {'CP2','TP9','Fp2','Pz','C3'};

case   '3F0435_E'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '3F0442_E'
   Par.badChannelLabels = {'TP9','P7','CP2','Cz','Fp2' };

case   '3F0443_E'
   Par.badChannelLabels = {'TP9','P7','CP2','FT10','Fp2' };

case   '3F0446_E'
   Par.badChannelLabels = {'T8','F8' };

case   '3F0455_E'
   Par.badChannelLabels = { 'O2','CP2','Cz','Fp2'};

case   '3F0456_E'
   Par.badChannelLabels = {'T7','TP9','Pz','Oz','CP2','Cz','Fp2' };

case   '3F0462_E'
   Par.badChannelLabels = {'O1','Oz','CP2' };

case   '3F0469_E'
   Par.badChannelLabels = {'TP9','CP2','Pz','Cz','Fp2' };

case   '3F0470_E'
   Par.badChannelLabels = {'CP2','Fp2' };

case   '3F0471_E'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0472_E'
   Par.badChannelLabels = {'Fp1','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0473_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0474_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0477_E'
   Par.badChannelLabels = {'O1','Oz','O2' };

case   '3F0478_E'
   Par.badChannelLabels = {'CP2','F4','Fp2','F8' };

case   '3F0479_E'
   Par.badChannelLabels = {'T7','TP9','O1','CP2','Fp2' };

case   '3F0482_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0485_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0488_E'
   Par.badChannelLabels = {'FC5','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0489_E'
   Par.badChannelLabels = {'FC5','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0492_E'
   Par.badChannelLabels = {'FC1','TP9','P7','CP2','Cz','Fp2' };

case   '3F0501_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0503_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','C4','FC6','Fp2' };

case   '3F0505_E'
   Par.badChannelLabels = {'TP9','O1','CP2','Cz' };

case   '3F0506_E'
   Par.badChannelLabels = {'Fp1','TP9','Pz','Oz','CP6','CP2','Cz','Fp2' };

case   '3F0507_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0511_E'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Cz','Fp2','O2' };

case   '3F0513_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0519_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0522_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0524_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0527_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '3F0530_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0533_E'
   Par.badChannelLabels = { 'C3','T7','TP9','O1','Oz','O2','CP2','Cz','Fp2'};

case   '3F0537_E'
   Par.badChannelLabels = {'BadRef' };

case   '3F0543_E'
   Par.badChannelLabels = { 'F7','C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2'};

case   '3F0550_E'
   Par.badChannelLabels = {'F7','C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2','Fp1' };

case   '3F0551_E'
   Par.badChannelLabels = {'Fz','C3','TP9','Oz','O1','CP2','Cz','Fp2' };

case   '3F0552_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0350_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0372_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0373_E'
   Par.badChannelLabels = {'P7' };

case   '3M0374_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0380_E'
   Par.badChannelLabels = {'TP9' };

case   '3M0389_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0390_E'
   Par.badChannelLabels = {'TP9','CP2','O1','Oz','O2','FC2' };

case   '3M0400_E'
   Par.badChannelLabels = {'TP9','Oz','O2','CP2','T8','Fp2' };

case   '3M0403_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0404_E'
   Par.badChannelLabels = { 'P4'};

case   '3M0409_E'
   Par.badChannelLabels = { 'Fp1','P4','P8','CP6','Cz','C4','Fp2'};

case   '3M0413_E'
   Par.badChannelLabels = {'Fp1','TP9','P8','CP2','Cz','Fp2' };

case   '3M0428_E'
   Par.badChannelLabels = {'TP9','Oz','CP2','FC6' };

case   '3M0431_E'
   Par.badChannelLabels = {'TP9','CP2','F4' };

case   '3M0433_E'
   Par.badChannelLabels = {'Oz','CP2','Fp2' };

case   '3M0441_E'
   Par.badChannelLabels = {'TP9','O1','CP2','Cz','Fp2' };

case   '3M0443_E'
   Par.badChannelLabels = { 'CP2','O1'};

case   '3M0444_E'
   Par.badChannelLabels = {'T8' };

case   '3M0451_E'
   Par.badChannelLabels = {'T7','TP9','Oz','CP2','Cz','Fp2' };

% case   '3M0455_E'
%    Par.badChannelLabels = { };

case   '3M0457_E'
   Par.badChannelLabels = { 'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2'};

case   '3M0460_E'
   Par.badChannelLabels = {'Fp1','F3','TP9','Pz','P7','O1','CP2','Cz','Fp2' };

case   '3M0463_E'
   Par.badChannelLabels = {'TP9','CP2','O1','Oz','O2','Cz' };

% case   '3M0468_E'
%    Par.badChannelLabels = { };

case   '3M0469_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz' };

case   '3M0472_E'
   Par.badChannelLabels = {'TP9','Pz','O1','P8','CP2','Cz','Fp2' };

case   '3M0475_E'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '3M0478_E'
   Par.badChannelLabels = {'F3','TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '3M0484_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0486_E'
   Par.badChannelLabels = { 'TP9','CP5','Pz','O1','CP2','Cz','Fp2'};

case   '3M0492_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0495_E'
   Par.badChannelLabels = { 'T7','TP9','Pz','P7','O1','O2','CP2','Cz','T8'};

case   '3M0496_E'
   Par.badChannelLabels = { 'Fp1','TP9','Pz','CP2','Cz','Fp2'};

case   '3M0497_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0501_E'
   Par.badChannelLabels = {'C3','TP9','Pz','P7','O1','Oz','CP2','Cz','Fp2' };

case   '3M0503_E'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0506_E'
   Par.badChannelLabels = { 'Fp1','TP9','P7','O1','CP2','Cz','Fp2','CP1'};

case   '3M0528_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0530_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0532_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0533_E'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0534_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0535_E'
   Par.badChannelLabels = {'BadRef' };

case   '3M0541_E'
   Par.badChannelLabels = {'Fp1','C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };
   
% Below Extra

case   '1F0248_EX'
   Par.badChannelLabels = {        };

case   '1F0249_EX'
   Par.badChannelLabels = {'F3','C3' };

case   '1F0254_EX'
   Par.badChannelLabels = {'C4' };

case   '1F0262_EX'
   Par.badChannelLabels = {'Fp1','Fp2' };

case   '1F0266_EX'
   Par.badChannelLabels = {      };

case   '1F0267_EX'
   Par.badChannelLabels = {       };

case   '1F0270_EX'
   Par.badChannelLabels = {'O1' };

case   '1F0273_EX'
   Par.badChannelLabels = {'TP9','O1','Oz','O2' };

case   '1F0275_EX'
   Par.badChannelLabels = {'T7','P7' };

case   '1F0276_EX'
   Par.badChannelLabels = {'Fp1' };

case   '1F0278_EX'
   Par.badChannelLabels = {'CP2' };

case   '1F0280_EX'
   Par.badChannelLabels = { 'P8'};

case   '1F0288_EX'
   Par.badChannelLabels = {'TP9','Oz','O2','O1' };

case   '1F0295_EX'
   Par.badChannelLabels = {'T7'};

case   '1F0302_EX'
   Par.badChannelLabels = {'TP9'};

case   '1F0304_EX'
   Par.badChannelLabels = {'TP9','Fp2' };

case   '1F0307_EX'
   Par.badChannelLabels = {'P3' };

case   '1F0316_EX'
   Par.badChannelLabels = {        };

case   '1F0318_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1F0319_EX'
   Par.badChannelLabels = {'Cz','Pz'};

case   '1F0321_EX'
   Par.badChannelLabels = {'CP6','T8' };

% case   '1F0323_EX'
%    Par.badChannelLabels = { };

case   '1F0351_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1F0357_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1F0426_EX'
   Par.badChannelLabels = {'Fp1','T7','TP9','CP5','O1' };

case   '1M0270_EX'
   Par.badChannelLabels = {'Fp1','F3' };

case   '1M0276_EX'
   Par.badChannelLabels = {'Fp1' };

case   '1M0278_EX'
   Par.badChannelLabels = {'O1','O2','Oz' };

case   '1M0279_EX'
   Par.badChannelLabels = {        };

case   '1M0282_EX'
   Par.badChannelLabels = {'P8','P7' };

case   '1M0286_EX'
   Par.badChannelLabels = {'Fp1','TP9','CP2' };

case   '1M0292_EX'
   Par.badChannelLabels = {'TP9','T8','Fp2' };

case   '1M0293_EX'
   Par.badChannelLabels = { 'F3'};

case   '1M0300_EX'
   Par.badChannelLabels = { 'CP2','Fp2'};

case   '1M0302_EX'
   Par.badChannelLabels = {'T8' };

case   '1M0303_EX'
   Par.badChannelLabels = { 'Fp1','F3','P7'};

case   '1M0305_EX'
   Par.badChannelLabels = {'P8' };

case   '1M0307_EX'
   Par.badChannelLabels = {             };

case   '1M0309_EX'
   Par.badChannelLabels = {'TP9' };

case   '1M0312_EX'
   Par.badChannelLabels = {'T8','T7','P7' };

case   '1M0313_EX'
   Par.badChannelLabels = {'T7' };

case   '1M0317_EX'
   Par.badChannelLabels = {        };

% case   '1M0319_EX'
%    Par.badChannelLabels = { };

case   '1M0321_EX'
   Par.badChannelLabels = {'TP9' };

case   '1M0322_EX'
   Par.badChannelLabels = {           };

case   '1M0324_EX'
   Par.badChannelLabels = {'Fp1','Fp2','TP9' };

case   '1M0325_EX'
   Par.badChannelLabels = {'BadRef' };

case   '1M0333_EX'
   Par.badChannelLabels = { 'Cz'};

case   '1M0334_EX'
   Par.badChannelLabels = {'Pz','O1','Oz','O2' };

case   '1M0336_EX'
   Par.badChannelLabels = {'Cz'};

case   '1M0338_EX'
   Par.badChannelLabels = {         };

case   '1M0354_EX'
   Par.badChannelLabels = {            };

case   '1M0359_EX'
   Par.badChannelLabels = { 'F8'};

case   '1M0365_EX'
   Par.badChannelLabels = {'TP9','P8' };

case   '1M0368_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '1M0369_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1M0374_EX'
   Par.badChannelLabels = { 'TP9','CP2','Fp2' ,'P8'};

case   '1M0386_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '1M0389_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2'  };

% case   '1M0405_EX'
%    Par.badChannelLabels = { };

case   '1M0407_EX'
   Par.badChannelLabels = {'TP9','O1','Oz','CP2','Cz','Fp2' };

case   '1M0484_EX'
   Par.badChannelLabels = {'TP9','CP2','Cz' };

case   '2F0279_EX'
   Par.badChannelLabels = {'TP9','F3' };

case   '2F0283_EX'
   Par.badChannelLabels = { 'Fp1','F3'};

case   '2F0286_EX'
   Par.badChannelLabels = { 'P8'};

case   '2F0288_EX'
   Par.badChannelLabels = {'CP5' };

case   '2F0289_EX'
   Par.badChannelLabels = {'P8' };

case   '2F0290_EX'
   Par.badChannelLabels = {'T8','P8','Fz' };

case   '2F0291_EX'
   Par.badChannelLabels = {'O2','Oz','P8' };

case   '2F0292_EX'
   Par.badChannelLabels = { 'T8','FC2'};

case   '2F0295_EX'
   Par.badChannelLabels = {         };

case   '2F0301_EX'
   Par.badChannelLabels = {          };

% case   '2F0310_EX'
%    Par.badChannelLabels = { };

case   '2F0315_EX'
   Par.badChannelLabels = {'CP5' };

case   '2F0316_EX'
   Par.badChannelLabels = {          };

case   '2F0317_EX'
   Par.badChannelLabels = {'F3','T7' };

case   '2F0320_EX'
   Par.badChannelLabels = {'F3','T8' };

case   '2F0323_EX'
   Par.badChannelLabels = {'F3','FC6' };

case   '2F0328_EX'
   Par.badChannelLabels = {'P8' };

case   '2F0329_EX'
   Par.badChannelLabels = {'TP9','FT9' };

case   '2F0335_EX'
   Par.badChannelLabels = {          };

case   '2F0336_EX'
   Par.badChannelLabels = {          };

case   '2F0340_EX'
   Par.badChannelLabels = {          };

case   '2F0343_EX'
   Par.badChannelLabels = { 'O1','Oz','O2','P4','P8','CP6'};

case   '2F0344_EX'
   Par.badChannelLabels = {'Fp1','Fp2' };

case   '2F0346_EX'
   Par.badChannelLabels = {'P8' };

case   '2F0350_EX'
   Par.badChannelLabels = {'BadRef' };

case   '2F0351_EX'
   Par.badChannelLabels = {         };

case   '2F0352_EX'
   Par.badChannelLabels = {         };

case   '2F0354_EX'
   Par.badChannelLabels = {'FC1','CP2','T8' };

% case   '2F0359_EX'
%    Par.badChannelLabels = { };

case   '2F0360_EX'
   Par.badChannelLabels = {'Fp1','CP2' };

case   '2F0363_EX'
   Par.badChannelLabels = {            };

case   '2F0364_EX'
   Par.badChannelLabels = {               };

case   '2F0367_EX'
   Par.badChannelLabels = {              };

case   '2F0371_EX'
   Par.badChannelLabels = {'TP9','Fp2' };

case   '2F0381_EX'
   Par.badChannelLabels = {'BadRef' };

case   '2F0382_EX'
   Par.badChannelLabels = {'TP9' };

case   '2F0386_EX'
   Par.badChannelLabels = { 'TP9','CP2','Fp2'};

case   '2F0389_EX'
   Par.badChannelLabels = {'TP9' };

case   '2F0392_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '2F0395_EX'
   Par.badChannelLabels = {'FT10' };

case   '2F0430_EX'
   Par.badChannelLabels = {'FC1','TP9','Oz','O2','CP2','Cz','Fp2' };

case   '2F0434_EX'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };
% 
% case   '2F0448_EX'
%    Par.badChannelLabels = { };

case   '2F0458_EX'
   Par.badChannelLabels = {'FC1','TP9','C3','CP2','Cz','Fp2' };

case   '2F0473_EX'
   Par.badChannelLabels = {'C3','T7','TP9','Pz','O1','CP2','Cz','Fp2' };

case   '2M0273_EX'
   Par.badChannelLabels = {'Fp1','T7','FC5' };

case   '2M0277_EX'
   Par.badChannelLabels = {'BadRef' };

case   '2M0278_EX'
   Par.badChannelLabels = {'Fz' };

case   '2M0282_EX'
   Par.badChannelLabels = { 'FC1','Fp1'};

case   '2M0284_EX'
   Par.badChannelLabels = {        };

case   '2M0291_EX'
   Par.badChannelLabels = {'P8','Fp1','F3' };

case   '2M0293_EX'
   Par.badChannelLabels = {'Fp1','T8' };

case   '2M0294_EX'
   Par.badChannelLabels = {'TP9' };

case   '2M0298_EX'
   Par.badChannelLabels = {'P8' };

case   '2M0301_EX'
   Par.badChannelLabels = {'T8' };

case   '2M0303_EX'
   Par.badChannelLabels = { 'P8'};

case   '2M0305_EX'
   Par.badChannelLabels = {'FT9','FC5','C3','CP1','O1','Fp2' };

case   '2M0307_EX'
   Par.badChannelLabels = {          };

case   '2M0308_EX'
   Par.badChannelLabels = {           };

case   '2M0309_EX'
   Par.badChannelLabels = {               };

case   '2M0311_EX'
   Par.badChannelLabels = { 'Fp1','Fp2'};

case   '2M0312_EX'
   Par.badChannelLabels = {             };

case   '2M0313_EX'
   Par.badChannelLabels = {            };

case   '2M0316_EX'
   Par.badChannelLabels = {           };

% case   '2M0320_EX'
%    Par.badChannelLabels = { };

% case   '2M0324_EX'
%    Par.badChannelLabels = { };

case   '2M0325_EX'
   Par.badChannelLabels = {           };

case   '2M0327_EX'
   Par.badChannelLabels = {            };

case   '2M0328_EX'
   Par.badChannelLabels = {          };

case   '2M0329_EX'
   Par.badChannelLabels = {'TP9','Fp2' };

case   '2M0330_EX'
   Par.badChannelLabels = { 'P4'};

case   '2M0332_EX'
   Par.badChannelLabels = {         };

case   '2M0340_EX'
   Par.badChannelLabels = {'CP5','C4' };

case   '2M0346_EX'
   Par.badChannelLabels = {'TP9','T7','O1','Oz' };

case   '2M0355_EX'
   Par.badChannelLabels = {'TP9','Cz' };

case   '2M0359_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '2M0363_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '2M0366_EX'
   Par.badChannelLabels = {'BadRef' };

case   '2M0367_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2','P8' };

case   '2M0372_EX'
   Par.badChannelLabels = {         };

case   '2M0378_EX'
   Par.badChannelLabels = {'TP9','P3','Oz','CP2','Cz','Fp2' };

case   '2M0379_EX'
   Par.badChannelLabels = {'F7','O1','Fp1','Fz','F4' };

case   '2M0380_EX'
   Par.badChannelLabels = {'TP9','Pz','CP2','Cz','Fp2' };

case   '2M0453_EX'
   Par.badChannelLabels = {'TP9','O1','CP2','Cz','Fp2' };

case   '3F0303_EX'
   Par.badChannelLabels = {'Fp1','F3','P3','Pz' };

case   '3F0308_EX'
   Par.badChannelLabels = {'P8' };

case   '3F0309_EX'
   Par.badChannelLabels = {'Fp1' };

case   '3F0313_EX'
   Par.badChannelLabels = {'T8' };

case   '3F0314_EX'
   Par.badChannelLabels = {          };

case   '3F0318_EX'
   Par.badChannelLabels = {'BadRef' };

case   '3F0322_EX'
   Par.badChannelLabels = {'T8' };

case   '3F0324_EX'
   Par.badChannelLabels = {'Fp1','P7' };

case   '3F0325_EX'
   Par.badChannelLabels = { 'P8'};

case   '3F0327_EX'
   Par.badChannelLabels = { 'FT10','TP9'};

case   '3F0332_EX'
   Par.badChannelLabels = {'TP9' };

case   '3F0334_EX'
   Par.badChannelLabels = {'TP9' };

case   '3F0344_EX'
   Par.badChannelLabels = {'Fp1','F3','TP9','P7' };

case   '3F0346_EX'
   Par.badChannelLabels = {         };

case   '3F0348_EX'
   Par.badChannelLabels = {'FT9','T7','FT10','P8' };

case   '3F0350_EX'
   Par.badChannelLabels = {'Cz' };

case   '3F0351_EX'
   Par.badChannelLabels = {              };

case   '3F0356_EX'
   Par.badChannelLabels = {'Cz' };

case   '3F0360_EX'
   Par.badChannelLabels = {'Fp1','TP9','P8','Fp2' };

case   '3F0361_EX'
   Par.badChannelLabels = {'P7' };
% 
% case   '3F0365_EX'
%    Par.badChannelLabels = { };

case   '3F0369_EX'
   Par.badChannelLabels = {'T8' };

case   '3F0373_EX'
   Par.badChannelLabels = {'Oz','O1','O2' };

case   '3F0374_EX'
   Par.badChannelLabels = {'O1','Oz','O2' };

case   '3F0376_EX'
   Par.badChannelLabels = {'C4' };

case   '3F0377_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2','Fp1' };

case   '3F0378_EX'
   Par.badChannelLabels = {'TP9','Fp2' };

case   '3F0384_EX'
   Par.badChannelLabels = {'TP9','Fp2' };

case   '3F0403_EX'
   Par.badChannelLabels = {'P8' };

case   '3F0413_EX'
   Par.badChannelLabels = {'TP9','CP2' };

case   '3F0415_EX'
   Par.badChannelLabels = {      };

case   '3F0418_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0426_EX'
   Par.badChannelLabels = { 'TP9','CP2','Fp2'};

case   '3F0429_EX'
   Par.badChannelLabels = {'Fp1','TP9','CP2','Fp2' };

case   '3F0432_EX'
   Par.badChannelLabels = {'TP9','CP2','Fp2' };

case   '3F0441_EX'
   Par.badChannelLabels = {'BadRef' };

case   '3F0453_EX'
   Par.badChannelLabels = {'BadRef' };

case   '3F0460_EX'
   Par.badChannelLabels = { 'TP9','Pz','CP2','Cz','Fp2'};

case   '3F0463_EX'
   Par.badChannelLabels = {'CP2' };

case   '3F0504_EX'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Cz','Fp2' };

case   '3F0508_EX'
   Par.badChannelLabels = {'TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3F0528_EX'
   Par.badChannelLabels = {'BadRef' };

case   '3F0529_EX'
   Par.badChannelLabels = {'BadRef' };

case   '3F0534_EX'
   Par.badChannelLabels = {'C3','TP9','CP6','CP2','Cz','Fp2' };

case   '3M0287_EX'
   Par.badChannelLabels = {'F3' };

case   '3M0288_EX'
   Par.badChannelLabels = {'F3','FT10','FT9','FC2' };

case   '3M0310_EX'
   Par.badChannelLabels = { 'F3','Fp1'};

case   '3M0312_EX'
   Par.badChannelLabels = {'F3','P8' };

case   '3M0313_EX'
   Par.badChannelLabels = {'F3','T8' };

% case   '3M0316_EX'
%    Par.badChannelLabels = { };

case   '3M0318_EX'
   Par.badChannelLabels = {'Fp1','Fp2' };

case   '3M0319_EX'
   Par.badChannelLabels = {'P8' };

case   '3M0327_EX'
   Par.badChannelLabels = {'T7' };
% 
% case   '3M0328_EX'
%    Par.badChannelLabels = { };

case   '3M0330_EX'
   Par.badChannelLabels = {        };

case   '3M0332_EX'
   Par.badChannelLabels = {'T7','P8' };

case   '3M0336_EX'
   Par.badChannelLabels = {           };

case   '3M0337_EX'
   Par.badChannelLabels = {'CP2','Cz','T8' };

case   '3M0338_EX'
   Par.badChannelLabels = { 'FT9'};

case   '3M0339_EX'
   Par.badChannelLabels = { 'BadRef'};

case   '3M0343_EX'
   Par.badChannelLabels = {'Fp1','TP9','Fp2' };

case   '3M0344_EX'
   Par.badChannelLabels = {       };

case   '3M0346_EX'
   Par.badChannelLabels = {'Cz' };

case   '3M0354_EX'
   Par.badChannelLabels = {'Fp2' };

case   '3M0364_EX'
   Par.badChannelLabels = {'Fp1','Pz','Fp2' };

case   '3M0365_EX'
   Par.badChannelLabels = {'TP9','FC6' };

case   '3M0369_EX'
   Par.badChannelLabels = {'TP9','P8','CP2' };

case   '3M0376_EX'
   Par.badChannelLabels = { 'TP9'};

case   '3M0384_EX'
   Par.badChannelLabels = {'TP9' };

case   '3M0386_EX'
   Par.badChannelLabels = {          };

case   '3M0392_EX'
   Par.badChannelLabels = { 'C3','TP9','Pz','Oz','CP2','Cz','Fp2'};

case   '3M0397_EX'
   Par.badChannelLabels = {'CP2','TP9','Fp2' };

case   '3M0399_EX'
   Par.badChannelLabels = {'TP9' };

case   '3M0405_EX'
   Par.badChannelLabels = {'T7' };

case   '3M0407_EX'
   Par.badChannelLabels = {        };

case   '3M0420_EX'
   Par.badChannelLabels = {'O1','Oz','O2','CP2','CP6' };

case   '3M0422_EX'
   Par.badChannelLabels = {'Fp1','T7','TP9','Pz','O1','Oz','O2','CP2','Cz','Fp2' };

case   '3M0437_EX'
   Par.badChannelLabels = {'Fp1','TP9','Pz','CP2','Cz','Fp2' };

case   '3M0485_EX'
   Par.badChannelLabels = {'TP9','Pz','O1','CP2','Fp2','T8' };

case   '3M0512_EX'
   Par.badChannelLabels = {'C3','TP9','Pz','O1','Oz','CP2','Cz','Fp2' };

case   '3M0513_EX'
   Par.badChannelLabels = {'BadRef' };
   
   
end % of Par.subjectCodesList



% Get array of channel labels (for finding indices of bad channels)
for chanNo = 1:EEG.nbchan
    
    channelLabels{chanNo} = EEG.chanlocs(chanNo).labels;
    
end % of for chanNo

% Check if each entered bad channel is entered correctly (match with
% EEG.chanlocs entries)
if isempty(Par.badChannelLabels) == 0

    for badChanNo = 1:length(Par.badChannelLabels)
    
    if ismember(Par.badChannelLabels{badChanNo}, channelLabels);
        
 %   elseif strcmpi(Par.badChannelLabels{badChanNo},'BadRef')
            
    else
        
        error('Bad channel labels do not match labels in EEG dataset - entered incorrectly?');
        
    end % of if ismember
        
    end % of for badChanNo
        
end % of if isempty


% Reset bad channel indices vector
Par.badChannelIndices = [];


% Find indices of each bad channel (identified by the channel labels above)
if isempty(Par.badChannelLabels) == 0

    for badChanNo = 1:length(Par.badChannelLabels)
        
        Par.badChannelIndices(badChanNo) = find(strcmp(channelLabels, Par.badChannelLabels{badChanNo}));
        
    end % of for badChanNo

end % of if isempty








