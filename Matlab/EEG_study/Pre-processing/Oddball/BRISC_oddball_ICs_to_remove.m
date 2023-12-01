function Par = BRISC_oddball_ICs_to_remove(Par, datasetNo)
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

case   '1F0350_M'
  Par.ICsToRemove = [5 7];

case   '1F0352_M'
  Par.ICsToRemove = [3 ];

case   '1F0364_M'
  Par.ICsToRemove = [1 ];

case   '1F0365_M'
  Par.ICsToRemove = [ ];

case   '1F0367_M'
  Par.ICsToRemove = [6 ];

case   '1F0369_M'
  Par.ICsToRemove = [3 ];

case   '1F0370_M'
  Par.ICsToRemove = [6 ];

case   '1F0371_M'
  Par.ICsToRemove = [3];

case   '1F0373_M'
  Par.ICsToRemove = [ ];

case   '1F0374_M'
  Par.ICsToRemove = [4];

case   '1F0378_M'
  Par.ICsToRemove = [ ];

case   '1F0382_M'
  Par.ICsToRemove = [ 2 ];

case   '1F0391_M'
  Par.ICsToRemove = [10 ];

case   '1F0393_M'
  Par.ICsToRemove = [6];

case   '1F0394_M'
  Par.ICsToRemove = [10];

case   '1F0395_M'
  Par.ICsToRemove = [4];

case   '1F0396_M'
  Par.ICsToRemove = [2];

case   '1F0397_M'
  Par.ICsToRemove = [14];

case   '1F0399_M'
  Par.ICsToRemove = [8];

case   '1F0413_M'
  Par.ICsToRemove = [ ];

case   '1F0415_M'
  Par.ICsToRemove = [5];

case   '1F0417_M'
  Par.ICsToRemove = [8];

case   '1F0430_M'
  Par.ICsToRemove = [3 ];

case   '1F0433_M'
  Par.ICsToRemove = [2];

case   '1F0438_M'
  Par.ICsToRemove = [  ];

case   '1F0447_M'
  Par.ICsToRemove = [  ];

case   '1F0448_M'
  Par.ICsToRemove = [8];

case   '1F0450_M'
  Par.ICsToRemove = [  ];

case   '1F0452_M'
  Par.ICsToRemove = [2];

case   '1F0455_M'
  Par.ICsToRemove = [5];

case   '1F0457_M'
  Par.ICsToRemove = [10];

case   '1F0459_M'
  Par.ICsToRemove = [10];

case   '1F0463_M'
  Par.ICsToRemove = [  ];

case   '1F0468_M'
  Par.ICsToRemove = [6];

case   '1F0469_M'
  Par.ICsToRemove = [5];

case   '1F0470_M'
  Par.ICsToRemove = [6];

case   '1F0476_M'
  Par.ICsToRemove = [3];

case   '1F0479_M'
  Par.ICsToRemove = [3];

case   '1F0489_M'
  Par.ICsToRemove = [11];

case   '1F0491_M'
  Par.ICsToRemove = [6];

case   '1F0497_M'
  Par.ICsToRemove = [16];

case   '1F0499_M'
  Par.ICsToRemove = [3];

case   '1F0503_M'
  Par.ICsToRemove = [ ];

case   '1F0505_M'
  Par.ICsToRemove = [2];

case   '1M0347_M'
  Par.ICsToRemove = [2];

case   '1M0381_M'
  Par.ICsToRemove = [3];

case   '1M0400_M'
  Par.ICsToRemove = [5];

case   '1M0411_M'
  Par.ICsToRemove = [7];

case   '1M0417_M'
  Par.ICsToRemove = [  ];

case   '1M0422_M'
  Par.ICsToRemove = [3];

case   '1M0429_M'
  Par.ICsToRemove = [4];

case   '1M0432_M'
  Par.ICsToRemove = [11];

case   '1M0433_M'
  Par.ICsToRemove = [  ];

case   '1M0436_M'
  Par.ICsToRemove = [19];

case   '1M0443_M'
  Par.ICsToRemove = [5 6];

case   '1M0452_M'
  Par.ICsToRemove = [  ];

case   '1M0463_M'
  Par.ICsToRemove = [14];

case   '1M0465_M'
  Par.ICsToRemove = [ ];

case   '1M0466_M'
  Par.ICsToRemove = [2];

case   '1M0467_M'
  Par.ICsToRemove = [ ];

case   '1M0468_M'
  Par.ICsToRemove = [2];

case   '1M0471_M'
  Par.ICsToRemove = [11];

case   '1M0475_M'
  Par.ICsToRemove = [2];

case   '1M0501_M'
  Par.ICsToRemove = [2];

case   '1M0503_M'
  Par.ICsToRemove = [5 6];

case   '1M0504_M'
  Par.ICsToRemove = [10];

case   '1M0511_M'
  Par.ICsToRemove = [ ];

case   '1M0517_M'
  Par.ICsToRemove = [12 ];

case   '1M0521_M'
  Par.ICsToRemove = [ ];

case   '1M0529_M'
  Par.ICsToRemove = [ ];

case   '1M0532_M'
  Par.ICsToRemove = [ ];

case   '1M0535_M'
  Par.ICsToRemove = [9];

case   '1M0536_M'
  Par.ICsToRemove = [2];

case   '1M0542_M'
  Par.ICsToRemove = [2];

case   '1M0543_M'
  Par.ICsToRemove = [10];

case   '1M0544_M'
  Par.ICsToRemove = [ ];

case   '1M0545_M'
  Par.ICsToRemove = [ ];

case   '1M0547_M'
  Par.ICsToRemove = [1];

case   '1M0548_M'
  Par.ICsToRemove = [6];

case   '1M0549_M'
  Par.ICsToRemove = [6];

case   '2F0403_M'
  Par.ICsToRemove = [6];

case   '2F0409_M'
  Par.ICsToRemove = [6];

case   '2F0411_M'
  Par.ICsToRemove = [4];

case   '2F0412_M'
  Par.ICsToRemove = [12];

case   '2F0415_M'
  Par.ICsToRemove = [2];

case   '2F0416_M'
  Par.ICsToRemove = [5];

case   '2F0419_M'
  Par.ICsToRemove = [5 24];

case   '2F0423_M'
  Par.ICsToRemove = [4];

case   '2F0427_M'
  Par.ICsToRemove = [2];

case   '2F0432_M'
  Par.ICsToRemove = [9];

case   '2F0435_M'
  Par.ICsToRemove = [3];

case   '2F0436_M'
  Par.ICsToRemove = [2];

case   '2F0437_M'
  Par.ICsToRemove = [3];

case   '2F0438_M'
  Par.ICsToRemove = [4];

case   '2F0439_M'
  Par.ICsToRemove = [4];

case   '2F0440_M'
  Par.ICsToRemove = [5];

case   '2F0441_M'
  Par.ICsToRemove = [1];

case   '2F0442_M'
  Par.ICsToRemove = [2];

case   '2F0443_M'
  Par.ICsToRemove = [ ];

case   '2F0446_M'
  Par.ICsToRemove = [3];

case   '2F0451_M'
  Par.ICsToRemove = [2];

case   '2F0453_M'
  Par.ICsToRemove = [24];

case   '2F0472_M'
  Par.ICsToRemove = [ ];

case   '2F0475_M'
  Par.ICsToRemove = [12];

case   '2F0482_M'
  Par.ICsToRemove = [12];

case   '2F0483_M'
  Par.ICsToRemove = [ ];

case   '2F0489_M'
  Par.ICsToRemove = [];

case   '2F0496_M'
  Par.ICsToRemove = [17];

case   '2F0498_M'
  Par.ICsToRemove = [7];

case   '2F0499_M'
  Par.ICsToRemove = [4];

case   '2F0500_M'
  Par.ICsToRemove = [13];

case   '2F0502_M'
  Par.ICsToRemove = [7];

case   '2F0503_M'
  Par.ICsToRemove = [12];

case   '2F0508_M'
  Par.ICsToRemove = [3];

case   '2F0513_M'
  Par.ICsToRemove = [ ];

case   '2F0516_M'
  Par.ICsToRemove = [5];

case   '2F0537_M'
  Par.ICsToRemove = [14];

case   '2F0539_M'
  Par.ICsToRemove = [7];

case   '2F0541_M'
  Par.ICsToRemove = [ ];

case   '2F0542_M'
  Par.ICsToRemove = [8];

case   '2F0544_M'
  Par.ICsToRemove = [4];

case   '2F0548_M'
  Par.ICsToRemove = [2 9 12];

case   '2M0381_M'
  Par.ICsToRemove = [7];

case   '2M0384_M'
  Par.ICsToRemove = [4];

case   '2M0385_M'
  Par.ICsToRemove = [4];

case   '2M0386_M'
  Par.ICsToRemove = [1];

case   '2M0387_M'
  Par.ICsToRemove = [8 13];

case   '2M0390_M'
  Par.ICsToRemove = [2];

case   '2M0392_M'
  Par.ICsToRemove = [5];

case   '2M0394_M'
  Par.ICsToRemove = [7];

case   '2M0398_M'
  Par.ICsToRemove = [3];

case   '2M0403_M'
  Par.ICsToRemove = [3];

case   '2M0408_M'
  Par.ICsToRemove = [5];

case   '2M0420_M'
  Par.ICsToRemove = [5];

case   '2M0421_M'
  Par.ICsToRemove = [5];

case   '2M0422_M'
  Par.ICsToRemove = [13];

case   '2M0423_M'
  Par.ICsToRemove = [ ];

case   '2M0424_M'
  Par.ICsToRemove = [3];

case   '2M0427_M'
  Par.ICsToRemove = [5];

case   '2M0431_M'
  Par.ICsToRemove = [1];

case   '2M0434_M'
  Par.ICsToRemove = [9];

case   '2M0436_M'
  Par.ICsToRemove = [3];

case   '2M0437_M'
  Par.ICsToRemove = [4];

case   '2M0438_M'
  Par.ICsToRemove = [5];

case   '2M0443_M'
  Par.ICsToRemove = [ ];

case   '2M0445_M'
  Par.ICsToRemove = [4];

case   '2M0454_M'
  Par.ICsToRemove = [3 16];

case   '2M0460_M'
  Par.ICsToRemove = [14];

case   '2M0461_M'
  Par.ICsToRemove = [3];

case   '2M0462_M'
  Par.ICsToRemove = [6 9];

case   '2M0472_M'
  Par.ICsToRemove = [3];

case   '2M0479_M'
  Par.ICsToRemove = [7];

case   '2M0484_M'
  Par.ICsToRemove = [ ];

case   '2M0488_M'
  Par.ICsToRemove = [ ];

case   '2M0518_M'
  Par.ICsToRemove = [ ];

case   '2M0522_M'
  Par.ICsToRemove = [3];

case   '2M0523_M'
  Par.ICsToRemove = [7];

case   '2M0526_M'
  Par.ICsToRemove = [ ];

case   '2M0529_M'
  Par.ICsToRemove = [11];

case   '3F0383_M'
  Par.ICsToRemove = [5];

case   '3F0455_M'
  Par.ICsToRemove = [2 13 14];

case   '3F0456_M'
  Par.ICsToRemove = [3];

case   '3F0459_M'
  Par.ICsToRemove = [1];

case   '3F0462_M'
  Par.ICsToRemove = [8];

case   '3F0472_M'
  Par.ICsToRemove = [7];

case   '3F0473_M'
  Par.ICsToRemove = [2];

case   '3F0483_M'
  Par.ICsToRemove = [5];

case   '3F0488_M'
  Par.ICsToRemove = [3];

case   '3F0489_M'
  Par.ICsToRemove = [2];

case   '3F0492_M'
  Par.ICsToRemove = [2];

case   '3F0501_M'
  Par.ICsToRemove = [ ];

case   '3F0503_M'
  Par.ICsToRemove = [3 7];

case   '3F0505_M'
  Par.ICsToRemove = [6];

case   '3F0506_M'
  Par.ICsToRemove = [5];

case   '3F0507_M'
  Par.ICsToRemove = [ ];

case   '3F0511_M'
  Par.ICsToRemove = [3];

case   '3F0513_M'
  Par.ICsToRemove = [15];

case   '3F0519_M'
  Par.ICsToRemove = [2];

case   '3F0522_M'
  Par.ICsToRemove = [10];

case   '3F0524_M'
  Par.ICsToRemove = [4];

case   '3F0530_M'
  Par.ICsToRemove = [5];

case   '3F0551_M'
  Par.ICsToRemove = [8];

case   '3F0552_M'
  Par.ICsToRemove = [6];

case   '3F0553_M'
  Par.ICsToRemove = [2];

case   '3F0556_M'
  Par.ICsToRemove = [19];

case   '3F0558_M'
  Par.ICsToRemove = [ ];

case   '3F0559_M'
  Par.ICsToRemove = [7];

case   '3F0561_M'
  Par.ICsToRemove = [4];

case   '3F0562_M'
  Par.ICsToRemove = [13];

case   '3F0563_M'
  Par.ICsToRemove = [8];

case   '3F0564_M'
  Par.ICsToRemove = [8];

case   '3F0568_M'
  Par.ICsToRemove = [9];

case   '3F0575_M'
  Par.ICsToRemove = [ ];

case   '3F0577_M'
  Par.ICsToRemove = [ ];

case   '3F0578_M'
  Par.ICsToRemove = [3];

case   '3M0419_M'
  Par.ICsToRemove = [3];

case   '3M0428_M'
  Par.ICsToRemove = [9];

case   '3M0431_M'
  Par.ICsToRemove = [3];

case   '3M0433_M'
  Par.ICsToRemove = [3];

case   '3M0434_M'
  Par.ICsToRemove = [2];

case   '3M0438_M'
  Par.ICsToRemove = [ ];

case   '3M0439_M'
  Par.ICsToRemove = [1];

case   '3M0441_M'
  Par.ICsToRemove = [1];

case   '3M0443_M'
  Par.ICsToRemove = [5];

case   '3M0444_M'
  Par.ICsToRemove = [7];

case   '3M0451_M'
  Par.ICsToRemove = [11];

case   '3M0455_M'
  Par.ICsToRemove = [4];

case   '3M0457_M'
  Par.ICsToRemove = [2];

case   '3M0460_M'
  Par.ICsToRemove = [8];

case   '3M0467_M'
  Par.ICsToRemove = [7];

case   '3M0468_M'
  Par.ICsToRemove = [12];

case   '3M0469_M'
  Par.ICsToRemove = [1];

case   '3M0472_M'
  Par.ICsToRemove = [2];

case   '3M0475_M'
  Par.ICsToRemove = [2];

case   '3M0478_M'
  Par.ICsToRemove = [];

case   '3M0484_M'
  Par.ICsToRemove = [ ];

case   '3M0486_M'
  Par.ICsToRemove = [2];

case   '3M0487_M'
  Par.ICsToRemove = [3];

case   '3M0488_M'
  Par.ICsToRemove = [3];

case   '3M0492_M'
  Par.ICsToRemove = [ ];

case   '3M0494_M'
  Par.ICsToRemove = [6];

case   '3M0495_M'
  Par.ICsToRemove = [5];

case   '3M0497_M'
  Par.ICsToRemove = [2];

case   '3M0501_M'
  Par.ICsToRemove = [5];

case   '3M0506_M'
  Par.ICsToRemove = [4];

case   '3M0528_M'
  Par.ICsToRemove = [5];

case   '3M0530_M'
  Par.ICsToRemove = [4];

case   '3M0532_M'
  Par.ICsToRemove = [2];

case   '3M0533_M'
  Par.ICsToRemove = [2];

case   '3M0534_M'
  Par.ICsToRemove = [ ];

case   '3M0539_M'
  Par.ICsToRemove = [20];

case   '3M0541_M'
  Par.ICsToRemove = [ ];

case   '3M0542_M'
  Par.ICsToRemove = [ ];

case   '3M0543_M'
  Par.ICsToRemove = [ ];

case   '3M0547_M'
  Par.ICsToRemove = [ ];

case   '3M0550_M'
  Par.ICsToRemove = [5];

case   '3M0552_M'
  Par.ICsToRemove = [ ];

case   '3M0553_M'
  Par.ICsToRemove = [];

case   '3M0555_M'
  Par.ICsToRemove = [6];

case   '3M0556_M'
  Par.ICsToRemove = [3];

case   '3M0563_M'
  Par.ICsToRemove = [3];

case   '3M0564_M'
  Par.ICsToRemove = [ ];

case   '3M0565_M'
  Par.ICsToRemove = [11];

case   '3M0568_M'
  Par.ICsToRemove = [ ];

case   '3M0571_M'
  Par.ICsToRemove = [];
  
% Oddnum 

case   '1F0298_M'
  Par.ICsToRemove = [2];

case   '1F0309_M'
  Par.ICsToRemove = [7];

case   '1F0313_M'
  Par.ICsToRemove = [3];

case   '1F0327_M'
  Par.ICsToRemove = [];

case   '1F0330_M'
  Par.ICsToRemove = [4];

case   '1F0337_M'
  Par.ICsToRemove = [1 21];

case   '1F0339_M'
  Par.ICsToRemove = [5];

case   '1F0347_M'
  Par.ICsToRemove = [3];

case   '1F0348_M'
  Par.ICsToRemove = [3];

case   '1F0354_M'
  Par.ICsToRemove = [ ];

case   '1F0358_M'
  Par.ICsToRemove = [ ];

case   '1F0386_M'
  Par.ICsToRemove = [4];

case   '1F0443_M'
  Par.ICsToRemove = [ ];

case   '1M0349_M'
  Par.ICsToRemove = [ ];

case   '1M0352_M'
  Par.ICsToRemove = [5];

case   '1M0355_M'
  Par.ICsToRemove = [8];

case   '1M0356_M'
  Par.ICsToRemove = [9];

case   '1M0358_M'
  Par.ICsToRemove = [5];

case   '1M0362_M'
  Par.ICsToRemove = [3];

case   '1M0370_M'
  Par.ICsToRemove = [3];

case   '1M0376_M'
  Par.ICsToRemove = [8 25];

case   '1M0377_M'
  Par.ICsToRemove = [8];

case   '1M0382_M'
  Par.ICsToRemove = [2];

case   '1M0383_M'
  Par.ICsToRemove = [2];

case   '1M0387_M'
  Par.ICsToRemove = [ ];

case   '1M0392_M'
  Par.ICsToRemove = [ ];

case   '1M0393_M'
  Par.ICsToRemove = [3];

case   '1M0394_M'
  Par.ICsToRemove = [4];

case   '1M0398_M'
  Par.ICsToRemove = [3];

case   '1M0399_M'
  Par.ICsToRemove = [4];

case   '1M0403_M'
  Par.ICsToRemove = [1 3];

case   '1M0408_M'
  Par.ICsToRemove = [ ];

case   '1M0409_M'
  Par.ICsToRemove = [18];

case   '1M0410_M'
  Par.ICsToRemove = [5 14];

case   '1M0425_M'
  Par.ICsToRemove = [2 14];

case   '1M0472_M'
  Par.ICsToRemove = [4];

case   '2F0373_M'
  Par.ICsToRemove = [1];

case   '2F0375_M'
  Par.ICsToRemove = [3];

case   '2F0377_M'
  Par.ICsToRemove = [12 19];

case   '2F0383_M'
  Par.ICsToRemove = [10];

case   '2F0391_M'
  Par.ICsToRemove = [2 9];

case   '2F0399_M'
  Par.ICsToRemove = [ ];

case   '2F0400_M'
  Par.ICsToRemove = [6];

case   '2F0401_M'
  Par.ICsToRemove = [3];

case   '2F0402_M'
  Par.ICsToRemove = [2];

case   '2F0404_M'
  Par.ICsToRemove = [3 5];

case   '2F0421_M'
  Par.ICsToRemove = [5];

case   '2F0479_M'
  Par.ICsToRemove = [3];

case   '2M0334_M'
  Par.ICsToRemove = [1];

case   '2M0341_M'
  Par.ICsToRemove = [ ];

case   '2M0342_M'
  Par.ICsToRemove = [4];

case   '2M0343_M'
  Par.ICsToRemove = [12];

case   '2M0344_M'
  Par.ICsToRemove = [7];

case   '2M0348_M'
  Par.ICsToRemove = [10];

case   '2M0349_M'
  Par.ICsToRemove = [2];

case   '2M0351_M'
  Par.ICsToRemove = [6];

case   '2M0353_M'
  Par.ICsToRemove = [5];

case   '2M0354_M'
  Par.ICsToRemove = [6];

case   '2M0356_M'
  Par.ICsToRemove = [3];

case   '2M0360_M'
  Par.ICsToRemove = [6];

case   '2M0365_M'
  Par.ICsToRemove = [8];

case   '2M0368_M'
  Par.ICsToRemove = [1];

case   '2M0371_M'
  Par.ICsToRemove = [ ];

case   '2M0374_M'
  Par.ICsToRemove = [ ];

case   '2M0391_M'
  Par.ICsToRemove = [3];

case   '2M0405_M'
  Par.ICsToRemove = [13];

case   '2M0433_M'
  Par.ICsToRemove = [3];

case   '2M0435_M'
  Par.ICsToRemove = [25];

case   '2M0441_M'
  Par.ICsToRemove = [7];

case   '3F0379_M'
  Par.ICsToRemove = [4];

case   '3F0386_M'
  Par.ICsToRemove = [7];

case   '3F0388_M'
  Par.ICsToRemove = [ ];

case   '3F0400_M'
  Par.ICsToRemove = [13];

case   '3F0408_M'
  Par.ICsToRemove = [5];

case   '3F0409_M'
  Par.ICsToRemove = [9 12];

case   '3F0411_M'
  Par.ICsToRemove = [1];

case   '3F0420_M'
  Par.ICsToRemove = [2];

case   '3F0421_M'
  Par.ICsToRemove = [ ];

case   '3F0422_M'
  Par.ICsToRemove = [13];

case   '3F0423_M'
  Par.ICsToRemove = [11];

case   '3F0425_M'
  Par.ICsToRemove = [6];

case   '3F0430_M'
  Par.ICsToRemove = [4];

case   '3F0431_M'
  Par.ICsToRemove = [7 13];

case   '3F0435_M'
  Par.ICsToRemove = [ ];

case   '3F0442_M'
  Par.ICsToRemove = [ ];

case   '3F0443_M'
  Par.ICsToRemove = [];

case   '3F0458_M'
  Par.ICsToRemove = [ 3 ];

case   '3F0482_M'
  Par.ICsToRemove = [ ];

case   '3F0485_M'
  Par.ICsToRemove = [ ];

case   '3F0543_M'
  Par.ICsToRemove = [];

case   '3F0550_M'
  Par.ICsToRemove = [11];

case   '3M0372_M'
  Par.ICsToRemove = [2];

case   '3M0373_M'
  Par.ICsToRemove = [3];

case   '3M0374_M'
  Par.ICsToRemove = [6];

case   '3M0377_M'
  Par.ICsToRemove = [3];

case   '3M0387_M'
  Par.ICsToRemove = [3];

case   '3M0389_M'
  Par.ICsToRemove = [5];

case   '3M0390_M'
  Par.ICsToRemove = [];

case   '3M0403_M'
  Par.ICsToRemove = [3];

case   '3M0404_M'
  Par.ICsToRemove = [ ];

case   '3M0408_M'
  Par.ICsToRemove = [9];

case   '3M0409_M'
  Par.ICsToRemove = [2 16];

case   '3M0413_M'
  Par.ICsToRemove = [8];

case   '3M0496_M'
  Par.ICsToRemove = [2];

case   '3M0535_M'
  Par.ICsToRemove = [7];
  
 % Endline (334)
 
case   '1F0294_E'
  Par.ICsToRemove = [2];

case   '1F0298_E'
  Par.ICsToRemove = [ ];

case   '1F0300_E'
  Par.ICsToRemove = [17];

case   '1F0309_E'
  Par.ICsToRemove = [8];

case   '1F0311_E'
  Par.ICsToRemove = [5];

case   '1F0312_E'
  Par.ICsToRemove = [11 14];

case   '1F0313_E'
  Par.ICsToRemove = [5];

case   '1F0315_E'
  Par.ICsToRemove = [2];

case   '1F0327_E'
  Par.ICsToRemove = [7 23];

%case   '1F0330_E'
%  Par.ICsToRemove = [];

case   '1F0337_E'
  Par.ICsToRemove = [2];

case   '1F0339_E'
  Par.ICsToRemove = [2];

case   '1F0347_E'
  Par.ICsToRemove = [];

case   '1F0348_E'
  Par.ICsToRemove = [4];

case   '1F0350_E'
  Par.ICsToRemove = [2];

case   '1F0352_E'
  Par.ICsToRemove = [2];

case   '1F0354_E'
  Par.ICsToRemove = [12];

case   '1F0358_E'
  Par.ICsToRemove = [2];

case   '1F0364_E'
  Par.ICsToRemove = [11];

case   '1F0365_E'
  Par.ICsToRemove = [3];

case   '1F0367_E'
  Par.ICsToRemove = [9];

case   '1F0369_E'
  Par.ICsToRemove = [4];

case   '1F0370_E'
  Par.ICsToRemove = [];

case   '1F0371_E'
  Par.ICsToRemove = [ ];

case   '1F0373_E'
  Par.ICsToRemove = [2];

case   '1F0374_E'
  Par.ICsToRemove = [6];

case   '1F0378_E'
  Par.ICsToRemove = [5];

case   '1F0379_E'
  Par.ICsToRemove = [7];

case   '1F0382_E'
  Par.ICsToRemove = [ ];

case   '1F0384_E'
  Par.ICsToRemove =  [ ];

case   '1F0386_E'
  Par.ICsToRemove = [5];

case   '1F0387_E'
  Par.ICsToRemove = [ ];

case   '1F0389_E'
  Par.ICsToRemove = [ ];

case   '1F0390_E'
  Par.ICsToRemove = [ ];

case   '1F0391_E'
  Par.ICsToRemove = [ ];

case   '1F0393_E'
  Par.ICsToRemove = [ ];

case   '1F0394_E'
  Par.ICsToRemove = [ ];

case   '1F0395_E'
  Par.ICsToRemove = [18];

case   '1F0396_E'
  Par.ICsToRemove = [3];

case   '1F0397_E'
  Par.ICsToRemove = [ ];

case   '1F0399_E'
  Par.ICsToRemove = [ ];

case   '1F0413_E'
  Par.ICsToRemove = [ ];

case   '1F0415_E'
  Par.ICsToRemove = [ ];

case   '1F0417_E'
  Par.ICsToRemove = [ ];

case   '1F0428_E'
  Par.ICsToRemove = [ ];

case   '1F0429_E'
  Par.ICsToRemove = [ ];

case   '1F0430_E'
  Par.ICsToRemove = [5];

case   '1F0431_E'
  Par.ICsToRemove = [16];

case   '1F0433_E'
  Par.ICsToRemove = [20];

case   '1F0438_E'
  Par.ICsToRemove = [ ];

case   '1F0442_E'
  Par.ICsToRemove = [15];

case   '1F0443_E'
  Par.ICsToRemove = [ ];

case   '1F0447_E'
  Par.ICsToRemove = [ ];

case   '1F0448_E'
  Par.ICsToRemove = [ ];

case   '1F0450_E'
  Par.ICsToRemove = [];

case   '1F0452_E'
  Par.ICsToRemove = [4];

case   '1F0455_E'
  Par.ICsToRemove = [4];

case   '1F0457_E'
  Par.ICsToRemove = [ ];

case   '1F0459_E'
  Par.ICsToRemove = [ ];

case   '1F0463_E'
  Par.ICsToRemove = [ ];

case   '1F0468_E'
  Par.ICsToRemove = [16];

case   '1F0469_E'
  Par.ICsToRemove = [7];

case   '1F0470_E'
  Par.ICsToRemove = [ ];

case   '1M0343_E'
  Par.ICsToRemove = [6];

case   '1M0347_E'
  Par.ICsToRemove = [8];

case   '1M0348_E'
  Par.ICsToRemove = [ ];

case   '1M0349_E'
  Par.ICsToRemove = [21];

case   '1M0352_E'
  Par.ICsToRemove = [14];

case   '1M0355_E'
  Par.ICsToRemove = [ ];

case   '1M0356_E'
  Par.ICsToRemove = [20];

case   '1M0358_E'
  Par.ICsToRemove = [7];

case   '1M0362_E'
  Par.ICsToRemove = [7];

case   '1M0370_E'
  Par.ICsToRemove = [ ];

case   '1M0376_E'
  Par.ICsToRemove = [ ];

case   '1M0377_E'
  Par.ICsToRemove = [4];

case   '1M0381_E'
  Par.ICsToRemove = [9];

%case   '1M0382_E'
%  Par.ICsToRemove = [];

%case   '1M0383_E'
%  Par.ICsToRemove = [];

case   '1M0387_E'
  Par.ICsToRemove = [7];

case   '1M0392_E'
  Par.ICsToRemove = [6];

case   '1M0393_E'
  Par.ICsToRemove = [10];

case   '1M0394_E'
  Par.ICsToRemove = [ ];

case   '1M0398_E'
  Par.ICsToRemove = [ ];

case   '1M0400_E'
  Par.ICsToRemove = [ ];

case   '1M0403_E'
  Par.ICsToRemove = [11];

case   '1M0408_E'
  Par.ICsToRemove = [4];

case   '1M0409_E'
  Par.ICsToRemove = [14];

case   '1M0410_E'
  Par.ICsToRemove = [16];

case   '1M0411_E'
  Par.ICsToRemove = [4];

case   '1M0414_E'
  Par.ICsToRemove = [ ];

case   '1M0416_E'
  Par.ICsToRemove = [];

case   '1M0417_E'
  Par.ICsToRemove = [];

case   '1M0420_E'
  Par.ICsToRemove = [ ];

case   '1M0422_E'
  Par.ICsToRemove = [];

case   '1M0425_E'
  Par.ICsToRemove = [3];

case   '1M0428_E'
  Par.ICsToRemove = [];

case   '1M0429_E'
  Par.ICsToRemove = [];

case   '1M0432_E'
  Par.ICsToRemove = [];

case   '1M0436_E'
  Par.ICsToRemove = [19];

case   '1M0442_E'
  Par.ICsToRemove = [11];

case   '1M0443_E'
  Par.ICsToRemove = [16];

case   '1M0463_E'
  Par.ICsToRemove = [15];

case   '1M0465_E'
  Par.ICsToRemove = [6];

case   '1M0466_E'
  Par.ICsToRemove = [3];

case   '1M0467_E'
  Par.ICsToRemove = [ ];

case   '1M0468_E'
  Par.ICsToRemove = [ ];

case   '1M0471_E'
  Par.ICsToRemove = [ ];

case   '1M0472_E'
  Par.ICsToRemove = [14];

case   '1M0475_E'
  Par.ICsToRemove = [10];

case   '1M0478_E'
  Par.ICsToRemove = [3];

case   '1M0496_E'
  Par.ICsToRemove = [1];

case   '1M0501_E'
  Par.ICsToRemove = [];

case   '1M0503_E'
  Par.ICsToRemove = [10];

case   '1M0504_E'
  Par.ICsToRemove = [ ];

case   '1M0511_E'
  Par.ICsToRemove = [9];

case   '2F0372_E'
  Par.ICsToRemove = [];

case   '2F0373_E'
  Par.ICsToRemove = [3];

%case   '2F0377_E'
%  Par.ICsToRemove = [];

%case   '2F0383_E'
%  Par.ICsToRemove = [];

case   '2F0391_E'
  Par.ICsToRemove = [ ];

case   '2F0399_E'
  Par.ICsToRemove = [8];

case   '2F0400_E'
  Par.ICsToRemove = [16];

case   '2F0402_E'
  Par.ICsToRemove = [3];

case   '2F0403_E'
  Par.ICsToRemove = [16];

case   '2F0404_E'
  Par.ICsToRemove = [17];

case   '2F0409_E'
  Par.ICsToRemove = [ ];

case   '2F0410_E'
  Par.ICsToRemove = [6];

case   '2F0411_E'
  Par.ICsToRemove = [14];

case   '2F0412_E'
  Par.ICsToRemove = [7];

%case   '2F0415_E'
%  Par.ICsToRemove = [];

case   '2F0416_E'
  Par.ICsToRemove = [6];

case   '2F0418_E'
  Par.ICsToRemove = [4];

% case   '2F0419_E'
%   Par.ICsToRemove = [];

case   '2F0420_E'
  Par.ICsToRemove = [ ];

case   '2F0421_E'
  Par.ICsToRemove = [ ];

case   '2F0423_E'
  Par.ICsToRemove = [15  ];

case   '2F0425_E'
  Par.ICsToRemove = [17];

case   '2F0427_E'
  Par.ICsToRemove = [5];

case   '2F0432_E'
  Par.ICsToRemove = [ ];

case   '2F0435_E'
  Par.ICsToRemove = [ ];

case   '2F0436_E'
  Par.ICsToRemove = [11];

case   '2F0437_E'
  Par.ICsToRemove = [12];

case   '2F0438_E'
  Par.ICsToRemove = [14];

case   '2F0439_E'
  Par.ICsToRemove = [ ];

case   '2F0440_E'
  Par.ICsToRemove = [ ];

case   '2F0441_E'
  Par.ICsToRemove = [22];

case   '2F0442_E'
  Par.ICsToRemove = [ ];

case   '2F0443_E'
  Par.ICsToRemove = [];

case   '2F0445_E'
  Par.ICsToRemove = [ ];

case   '2F0446_E'
  Par.ICsToRemove = [ ];

case   '2F0454_E'
  Par.ICsToRemove = [15];

case   '2F0456_E'
  Par.ICsToRemove = [6];

case   '2F0459_E'
  Par.ICsToRemove = [6];

case   '2F0464_E'
  Par.ICsToRemove = [16];

case   '2F0467_E'
  Par.ICsToRemove = [12];

case   '2F0470_E'
  Par.ICsToRemove = [3];

case   '2F0471_E'
  Par.ICsToRemove = [11];

%case   '2F0472_E'
%  Par.ICsToRemove = [];

case   '2F0475_E'
  Par.ICsToRemove = [14];

case   '2F0476_E'
  Par.ICsToRemove = [4];

case   '2F0479_E'
  Par.ICsToRemove = [];

case   '2F0482_E'
  Par.ICsToRemove = [];

case   '2F0483_E'
  Par.ICsToRemove = [7];

case   '2F0489_E'
  Par.ICsToRemove = [3];

case   '2F0492_E'
  Par.ICsToRemove = [15];

case   '2F0494_E'
  Par.ICsToRemove = [10];

case   '2F0496_E'
  Par.ICsToRemove = [];

case   '2F0497_E'
  Par.ICsToRemove = [  ];

case   '2F0498_E'
  Par.ICsToRemove = [3];

case   '2F0499_E'
  Par.ICsToRemove = [23];

case   '2F0500_E'
  Par.ICsToRemove = [ ];

case   '2F0503_E'
  Par.ICsToRemove = [18];

case   '2F0508_E'
  Par.ICsToRemove = [];

case   '2M0334_E'
  Par.ICsToRemove = [16];

case   '2M0338_E'
  Par.ICsToRemove = [];

case   '2M0341_E'
  Par.ICsToRemove = [3];

case   '2M0342_E'
  Par.ICsToRemove = [];

case   '2M0343_E'
  Par.ICsToRemove = [];

case   '2M0344_E'
  Par.ICsToRemove = [];

case   '2M0348_E'
  Par.ICsToRemove = [];

case   '2M0349_E'
  Par.ICsToRemove = [];

case   '2M0351_E'
  Par.ICsToRemove = [14];

case   '2M0353_E'
  Par.ICsToRemove = [3];

case   '2M0354_E'
  Par.ICsToRemove = [];

case   '2M0356_E'
  Par.ICsToRemove = [6];

case   '2M0360_E'
  Par.ICsToRemove = [8];

case   '2M0365_E'
  Par.ICsToRemove = [];

case   '2M0368_E'
  Par.ICsToRemove = [2];

case   '2M0374_E'
  Par.ICsToRemove = [8];

case   '2M0381_E'
  Par.ICsToRemove = [12];

case   '2M0382_E'
  Par.ICsToRemove = [9];

case   '2M0384_E'
  Par.ICsToRemove = [   ];

case   '2M0385_E'
  Par.ICsToRemove = [ ];

case   '2M0386_E'
  Par.ICsToRemove = [ ];

case   '2M0387_E'
  Par.ICsToRemove = [6];

case   '2M0390_E'
  Par.ICsToRemove = [   ];

case   '2M0391_E'
  Par.ICsToRemove = [  ];

case   '2M0392_E'
  Par.ICsToRemove = [8];

case   '2M0394_E'
  Par.ICsToRemove = [15];

case   '2M0395_E'
  Par.ICsToRemove = [9];

case   '2M0397_E'
  Par.ICsToRemove = [];

case   '2M0398_E'
  Par.ICsToRemove = [7];

case   '2M0400_E'
  Par.ICsToRemove = [10];

case   '2M0402_E'
  Par.ICsToRemove = [5];

case   '2M0403_E'
  Par.ICsToRemove = [];

case   '2M0404_E'
  Par.ICsToRemove = [5 27];

case   '2M0405_E'
  Par.ICsToRemove = [5];

case   '2M0408_E'
  Par.ICsToRemove = [];

case   '2M0420_E'
  Par.ICsToRemove = [];

case   '2M0421_E'
  Par.ICsToRemove = [];

case   '2M0422_E'
  Par.ICsToRemove = [14];

case   '2M0423_E'
  Par.ICsToRemove = [4];

case   '2M0424_E'
  Par.ICsToRemove = [13];

case   '2M0427_E'
  Par.ICsToRemove = [16];

case   '2M0431_E'
  Par.ICsToRemove = [4];

case   '2M0432_E'
  Par.ICsToRemove = [15];

case   '2M0433_E'
  Par.ICsToRemove = [13];

case   '2M0434_E'
  Par.ICsToRemove = [8];

case   '2M0435_E'
  Par.ICsToRemove = [2 17 ];

case   '2M0436_E'
  Par.ICsToRemove = [18];

case   '2M0437_E'
  Par.ICsToRemove = [];

case   '2M0444_E'
  Par.ICsToRemove = [14];

case   '2M0445_E'
  Par.ICsToRemove = [12];

case   '2M0452_E'
  Par.ICsToRemove = [];

case   '2M0454_E'
  Par.ICsToRemove = [6];

case   '2M0455_E'
  Par.ICsToRemove = [3];

case   '2M0461_E'
  Par.ICsToRemove = [];

case   '2M0462_E'
  Par.ICsToRemove = [10];

case   '2M0465_E'
  Par.ICsToRemove = [18];

case   '2M0467_E'
  Par.ICsToRemove = [4];

case   '2M0472_E'
  Par.ICsToRemove = [4];

case   '2M0479_E'
  Par.ICsToRemove = [13];

case   '2M0484_E'
  Par.ICsToRemove = [9];

case   '2M0488_E'
  Par.ICsToRemove = [   ];

case   '3F0379_E'
  Par.ICsToRemove = [];

case   '3F0386_E'
  Par.ICsToRemove = [];

case   '3F0388_E'
  Par.ICsToRemove = [];

case   '3F0390_E'
  Par.ICsToRemove = [ 2];

case   '3F0392_E'
  Par.ICsToRemove = [5 28];

case   '3F0400_E'
  Par.ICsToRemove = [4];

case   '3F0408_E'
  Par.ICsToRemove = [];

case   '3F0409_E'
  Par.ICsToRemove = [];

case   '3F0411_E'
  Par.ICsToRemove = [];

case   '3F0414_E'
  Par.ICsToRemove = [4];

case   '3F0420_E'
  Par.ICsToRemove = [2 22];

case   '3F0421_E'
  Par.ICsToRemove = [4];

case   '3F0422_E'
  Par.ICsToRemove = [3];

case   '3F0423_E'
  Par.ICsToRemove = [21];

case   '3F0425_E'
  Par.ICsToRemove = [8];

case   '3F0430_E'
  Par.ICsToRemove = [23];

case   '3F0431_E'
  Par.ICsToRemove = [1];

case   '3F0435_E'
  Par.ICsToRemove = [5];

case   '3F0442_E'
  Par.ICsToRemove = [7];

case   '3F0443_E'
  Par.ICsToRemove = [2 10];

case   '3F0446_E'
  Par.ICsToRemove = [8];

case   '3F0455_E'
  Par.ICsToRemove = [6];

case   '3F0456_E'
  Par.ICsToRemove = [2];

case   '3F0462_E'
  Par.ICsToRemove = [2];

case   '3F0469_E'
  Par.ICsToRemove = [7];

case   '3F0470_E'
  Par.ICsToRemove = [14];

case   '3F0471_E'
  Par.ICsToRemove = [8];

case   '3F0472_E'
  Par.ICsToRemove = [      ];

case   '3F0473_E'
  Par.ICsToRemove = [2   ];

case   '3F0474_E'
  Par.ICsToRemove = [];

case   '3F0477_E'
  Par.ICsToRemove = [1];

case   '3F0478_E'
  Par.ICsToRemove = [4];

case   '3F0479_E'
  Par.ICsToRemove = [9];

case   '3F0482_E'
  Par.ICsToRemove = [9];

case   '3F0485_E'
  Par.ICsToRemove = [  ];

case   '3F0488_E'
  Par.ICsToRemove = [14];

case   '3F0489_E'
  Par.ICsToRemove = [4];

case   '3F0492_E'
  Par.ICsToRemove = [9];

case   '3F0501_E'
  Par.ICsToRemove = [];

case   '3F0503_E'
  Par.ICsToRemove = [3];

case   '3F0505_E'
  Par.ICsToRemove = [7];

case   '3F0506_E'
  Par.ICsToRemove = [  ];

case   '3F0507_E'
  Par.ICsToRemove = [];

case   '3F0511_E'
  Par.ICsToRemove = [8];

case   '3F0513_E'
  Par.ICsToRemove = [];

case   '3F0519_E'
  Par.ICsToRemove = [];

case   '3F0522_E'
  Par.ICsToRemove = [5];

case   '3F0524_E'
  Par.ICsToRemove = [6];

case   '3F0527_E'
  Par.ICsToRemove = [5];

case   '3F0530_E'
  Par.ICsToRemove = [];

case   '3F0533_E'
  Par.ICsToRemove = [5];

case   '3F0537_E'
  Par.ICsToRemove = [];

case   '3F0543_E'
  Par.ICsToRemove = [8];

case   '3F0550_E'
  Par.ICsToRemove = [14];

case   '3F0551_E'
  Par.ICsToRemove = [18];

case   '3F0552_E'
  Par.ICsToRemove = [1];

case   '3M0350_E'
  Par.ICsToRemove = [];

case   '3M0372_E'
  Par.ICsToRemove = [];

case   '3M0373_E'
  Par.ICsToRemove = [3 26];

case   '3M0374_E'
  Par.ICsToRemove = [];

case   '3M0380_E'
  Par.ICsToRemove = [2 25];

case   '3M0389_E'
  Par.ICsToRemove = [];

case   '3M0390_E'
  Par.ICsToRemove = [6];

case   '3M0400_E'
  Par.ICsToRemove = [2 ];

case   '3M0403_E'
  Par.ICsToRemove = [];

case   '3M0404_E'
  Par.ICsToRemove = [];

case   '3M0409_E'
  Par.ICsToRemove = [14];

case   '3M0413_E'
  Par.ICsToRemove = [1];

case   '3M0428_E'
  Par.ICsToRemove = [2 21];

case   '3M0431_E'
  Par.ICsToRemove = [2];

case   '3M0433_E'
  Par.ICsToRemove = [1];

case   '3M0441_E'
  Par.ICsToRemove = [4];

case   '3M0443_E'
  Par.ICsToRemove = [7];

case   '3M0444_E'
  Par.ICsToRemove = [4];

case   '3M0451_E'
  Par.ICsToRemove = [3];

case   '3M0455_E'
  Par.ICsToRemove = [];

case   '3M0457_E'
  Par.ICsToRemove = [3];

case   '3M0460_E'
  Par.ICsToRemove = [8];

case   '3M0463_E'
  Par.ICsToRemove = [16];

case   '3M0468_E'
  Par.ICsToRemove = [];

case   '3M0469_E'
  Par.ICsToRemove = [2 8];

case   '3M0472_E'
  Par.ICsToRemove = [1];

case   '3M0475_E'
  Par.ICsToRemove = [5];

case   '3M0478_E'
  Par.ICsToRemove = [9];

case   '3M0484_E'
  Par.ICsToRemove = [];

case   '3M0486_E'
  Par.ICsToRemove = [6];

case   '3M0492_E'
  Par.ICsToRemove = [4];

case   '3M0495_E'
  Par.ICsToRemove = [12];

case   '3M0496_E'
  Par.ICsToRemove = [7];

case   '3M0497_E'
  Par.ICsToRemove = [];

case   '3M0501_E'
  Par.ICsToRemove = [5];

case   '3M0503_E'
  Par.ICsToRemove = [2];

case   '3M0506_E'
  Par.ICsToRemove = [];

case   '3M0528_E'
  Par.ICsToRemove = [10];

case   '3M0530_E'
  Par.ICsToRemove = [9];

case   '3M0532_E'
  Par.ICsToRemove = [6];

case   '3M0533_E'
  Par.ICsToRemove = [4];

case   '3M0534_E'
  Par.ICsToRemove = [];

case   '3M0535_E'
  Par.ICsToRemove = [];

case   '3M0541_E'
  Par.ICsToRemove = []; 
  
  % below Ex
  
  
case   '1F0248_EX'
  Par.ICsToRemove = [];

case   '1F0249_EX'
  Par.ICsToRemove = [1];

case   '1F0254_EX'
  Par.ICsToRemove = [3];

case   '1F0262_EX'
  Par.ICsToRemove = [16];

case   '1F0266_EX'
  Par.ICsToRemove = [1 28];

case   '1F0267_EX'
  Par.ICsToRemove = [11];

case   '1F0270_EX'
  Par.ICsToRemove = [2];

case   '1F0273_EX'
  Par.ICsToRemove = [4];

case   '1F0275_EX'
  Par.ICsToRemove = [3];

case   '1F0276_EX'
  Par.ICsToRemove = [13];

case   '1F0278_EX'
  Par.ICsToRemove = [2];

case   '1F0280_EX'
  Par.ICsToRemove = [3];

case   '1F0288_EX'
  Par.ICsToRemove = [4];

case   '1F0295_EX'
  Par.ICsToRemove = [4];

case   '1F0302_EX'
  Par.ICsToRemove = [2 16];

case   '1F0304_EX'
  Par.ICsToRemove = [4];

case   '1F0307_EX'
  Par.ICsToRemove = [3];

case   '1F0316_EX'
  Par.ICsToRemove = [1];

case   '1F0318_EX'
  Par.ICsToRemove = [3];

case   '1F0319_EX'
  Par.ICsToRemove = [5];

case   '1F0321_EX'
  Par.ICsToRemove = [];

case   '1F0323_EX'
  Par.ICsToRemove = [];

case   '1F0351_EX'
  Par.ICsToRemove = [5];

case   '1F0357_EX'
  Par.ICsToRemove = [2 24];

case   '1F0426_EX'
  Par.ICsToRemove = [6];

case   '1M0270_EX'
  Par.ICsToRemove = [8];

case   '1M0276_EX'
  Par.ICsToRemove = [3];

case   '1M0278_EX'
  Par.ICsToRemove = [25];

case   '1M0279_EX'
  Par.ICsToRemove = [3];

case   '1M0282_EX'
  Par.ICsToRemove = [5];

case   '1M0286_EX'
  Par.ICsToRemove = [12];

case   '1M0292_EX'
  Par.ICsToRemove = [3];

case   '1M0293_EX'
  Par.ICsToRemove = [2];

case   '1M0300_EX'
  Par.ICsToRemove = [2];

case   '1M0302_EX'
  Par.ICsToRemove = [1 28];

case   '1M0303_EX'
  Par.ICsToRemove = [20];

case   '1M0305_EX'
  Par.ICsToRemove = [6 28];

case   '1M0307_EX'
  Par.ICsToRemove = [3 9];

case   '1M0309_EX'
  Par.ICsToRemove = [11];

case   '1M0312_EX'
  Par.ICsToRemove = [2 25];

case   '1M0313_EX'
  Par.ICsToRemove = [2];

case   '1M0317_EX'
  Par.ICsToRemove = [5 27];

case   '1M0319_EX'
  Par.ICsToRemove = [];

case   '1M0321_EX'
  Par.ICsToRemove = [3];

case   '1M0322_EX'
  Par.ICsToRemove = [3];

case   '1M0324_EX'
  Par.ICsToRemove = [];

case   '1M0325_EX'
  Par.ICsToRemove = [];

case   '1M0333_EX'
  Par.ICsToRemove = [4 ];

case   '1M0334_EX'
  Par.ICsToRemove = [4];

case   '1M0336_EX'
  Par.ICsToRemove = [2];

case   '1M0338_EX'
  Par.ICsToRemove = [3 30];

case   '1M0354_EX'
  Par.ICsToRemove = [3 28];

case   '1M0359_EX'
  Par.ICsToRemove = [];

case   '1M0365_EX'
  Par.ICsToRemove = [4];

case   '1M0368_EX'
  Par.ICsToRemove = [ ];

case   '1M0369_EX'
  Par.ICsToRemove = [2];

case   '1M0374_EX'
  Par.ICsToRemove = [15];

case   '1M0386_EX'
  Par.ICsToRemove = [11];

case   '1M0389_EX'
  Par.ICsToRemove = [7];

case   '1M0405_EX'
  Par.ICsToRemove = [];

case   '1M0407_EX'
  Par.ICsToRemove = [6];

case   '1M0484_EX'
  Par.ICsToRemove = [14];

case   '2F0279_EX'
  Par.ICsToRemove = [];

case   '2F0283_EX'
  Par.ICsToRemove = [11];

case   '2F0286_EX'
  Par.ICsToRemove = [6];

case   '2F0288_EX'
  Par.ICsToRemove = [11];

case   '2F0289_EX'
  Par.ICsToRemove = [1 11];

case   '2F0290_EX'
  Par.ICsToRemove = [3];

case   '2F0291_EX'
  Par.ICsToRemove = [9];

case   '2F0292_EX'
  Par.ICsToRemove = [];

case   '2F0295_EX'
  Par.ICsToRemove = [2];

case   '2F0301_EX'
  Par.ICsToRemove = [2];

case   '2F0310_EX'
  Par.ICsToRemove = [];

case   '2F0315_EX'
  Par.ICsToRemove = [ 3 27];

case   '2F0316_EX'
  Par.ICsToRemove = [4];

case   '2F0317_EX'
  Par.ICsToRemove = [3];

case   '2F0320_EX'
  Par.ICsToRemove = [4];

case   '2F0323_EX'
  Par.ICsToRemove = [];

case   '2F0328_EX'
  Par.ICsToRemove = [2];

case   '2F0329_EX'
  Par.ICsToRemove = [3 24];

case   '2F0335_EX'
  Par.ICsToRemove = [3 25];

case   '2F0336_EX'
  Par.ICsToRemove = [17];

case   '2F0340_EX'
  Par.ICsToRemove = [4 25];

case   '2F0343_EX'
  Par.ICsToRemove = [1];

case   '2F0344_EX'
  Par.ICsToRemove = [  ];

case   '2F0346_EX'
  Par.ICsToRemove = [14 15];

case   '2F0350_EX'
  Par.ICsToRemove = [];

case   '2F0351_EX'
  Par.ICsToRemove = [5 29];

case   '2F0352_EX'
  Par.ICsToRemove = [3 22];

case   '2F0354_EX'
  Par.ICsToRemove = [17];

case   '2F0359_EX'
  Par.ICsToRemove = [];

case   '2F0360_EX'
  Par.ICsToRemove = [1];

case   '2F0363_EX'
  Par.ICsToRemove = [6];

case   '2F0364_EX'
  Par.ICsToRemove = [26];

case   '2F0367_EX'
  Par.ICsToRemove = [2 30];

case   '2F0371_EX'
  Par.ICsToRemove = [16];

case   '2F0381_EX'
  Par.ICsToRemove = [];

case   '2F0382_EX'
  Par.ICsToRemove = [8];

case   '2F0386_EX'
  Par.ICsToRemove = [];

case   '2F0389_EX'
  Par.ICsToRemove = [1];

case   '2F0392_EX'
  Par.ICsToRemove = [5];

case   '2F0395_EX'
  Par.ICsToRemove = [4];

case   '2F0430_EX'
  Par.ICsToRemove = [];

case   '2F0434_EX'
  Par.ICsToRemove = [3];

case   '2F0448_EX'
  Par.ICsToRemove = [];

case   '2F0458_EX'
  Par.ICsToRemove = [17];

case   '2F0473_EX'
  Par.ICsToRemove = [11];

case   '2M0273_EX'
  Par.ICsToRemove = [8];

case   '2M0277_EX'
  Par.ICsToRemove = [];

case   '2M0278_EX'
  Par.ICsToRemove = [3];

case   '2M0282_EX'
  Par.ICsToRemove = [4];

case   '2M0284_EX'
  Par.ICsToRemove = [2];

case   '2M0291_EX'
  Par.ICsToRemove = [3];

case   '2M0293_EX'
  Par.ICsToRemove = [];

case   '2M0294_EX'
  Par.ICsToRemove = [4];

case   '2M0298_EX'
  Par.ICsToRemove = [3];

case   '2M0301_EX'
  Par.ICsToRemove = [5];

case   '2M0303_EX'
  Par.ICsToRemove = [1];

case   '2M0305_EX'
  Par.ICsToRemove = [8];

case   '2M0307_EX'
  Par.ICsToRemove = [2];

case   '2M0308_EX'
  Par.ICsToRemove = [5];

case   '2M0309_EX'
  Par.ICsToRemove = [2];

case   '2M0311_EX'
  Par.ICsToRemove = [ ];

case   '2M0312_EX'
  Par.ICsToRemove = [4];

case   '2M0313_EX'
  Par.ICsToRemove = [10];

case   '2M0316_EX'
  Par.ICsToRemove = [4 11];

case   '2M0320_EX'
  Par.ICsToRemove = [];

case   '2M0324_EX'
  Par.ICsToRemove = [];

case   '2M0325_EX'
  Par.ICsToRemove = [7];

case   '2M0327_EX'
  Par.ICsToRemove = [13];

case   '2M0328_EX'
  Par.ICsToRemove = [3];

case   '2M0329_EX'
  Par.ICsToRemove = [3];

case   '2M0330_EX'
  Par.ICsToRemove = [2];

case   '2M0332_EX'
  Par.ICsToRemove = [7];

case   '2M0340_EX'
  Par.ICsToRemove = [5 17];

case   '2M0346_EX'
  Par.ICsToRemove = [27];

case   '2M0355_EX'
  Par.ICsToRemove = [2];

case   '2M0359_EX'
  Par.ICsToRemove = [13];

case   '2M0363_EX'
  Par.ICsToRemove = [   ];

case   '2M0366_EX'
  Par.ICsToRemove = [   ];

case   '2M0367_EX'
  Par.ICsToRemove = [17];

case   '2M0372_EX'
  Par.ICsToRemove = [2];

case   '2M0378_EX'
  Par.ICsToRemove = [7];

case   '2M0379_EX'
  Par.ICsToRemove = [5];

case   '2M0380_EX'
  Par.ICsToRemove = [8];

case   '2M0453_EX'
  Par.ICsToRemove = [ ];

case   '3F0303_EX'
  Par.ICsToRemove = [3];

case   '3F0308_EX'
  Par.ICsToRemove = [7];

case   '3F0309_EX'
  Par.ICsToRemove = [14];

case   '3F0313_EX'
  Par.ICsToRemove = [5];

case   '3F0314_EX'
  Par.ICsToRemove = [29];

case   '3F0318_EX'
  Par.ICsToRemove = [];

case   '3F0322_EX'
  Par.ICsToRemove = [2];

case   '3F0324_EX'
  Par.ICsToRemove = [];

case   '3F0325_EX'
  Par.ICsToRemove = [1];

case   '3F0327_EX'
  Par.ICsToRemove = [2];

case   '3F0332_EX'
  Par.ICsToRemove = [3];

case   '3F0334_EX'
  Par.ICsToRemove = [1];

case   '3F0344_EX'
  Par.ICsToRemove = [3];

case   '3F0346_EX'
  Par.ICsToRemove = [8];

case   '3F0348_EX'
  Par.ICsToRemove = [3];

case   '3F0350_EX'
  Par.ICsToRemove = [9 24];

case   '3F0351_EX'
  Par.ICsToRemove = [4];

case   '3F0356_EX'
  Par.ICsToRemove = [2];

case   '3F0360_EX'
  Par.ICsToRemove = [2];

case   '3F0361_EX'
  Par.ICsToRemove = [3];

case   '3F0365_EX'
  Par.ICsToRemove = [];

case   '3F0369_EX'
  Par.ICsToRemove = [1];

case   '3F0373_EX'
  Par.ICsToRemove = [14];

case   '3F0374_EX'
  Par.ICsToRemove = [2];

case   '3F0376_EX'
  Par.ICsToRemove = [2];

case   '3F0377_EX'
  Par.ICsToRemove = [2];

case   '3F0378_EX'
  Par.ICsToRemove = [4];

case   '3F0384_EX'
  Par.ICsToRemove = [3];

case   '3F0403_EX'
  Par.ICsToRemove = [11];

case   '3F0413_EX'
  Par.ICsToRemove = [];

case   '3F0415_EX'
  Par.ICsToRemove = [16];

case   '3F0418_EX'
  Par.ICsToRemove = [2];

case   '3F0426_EX'
  Par.ICsToRemove = [3];

case   '3F0429_EX'
  Par.ICsToRemove = [];

case   '3F0432_EX'
  Par.ICsToRemove = [6];

case   '3F0441_EX'
  Par.ICsToRemove = [];

case   '3F0453_EX'
  Par.ICsToRemove = [];

case   '3F0460_EX'
  Par.ICsToRemove = [14];

case   '3F0463_EX'
  Par.ICsToRemove = [23];

case   '3F0504_EX'
  Par.ICsToRemove = [9];

case   '3F0508_EX'
  Par.ICsToRemove = [8];

case   '3F0528_EX'
  Par.ICsToRemove = [];

case   '3F0529_EX'
  Par.ICsToRemove = [];

case   '3F0534_EX'
  Par.ICsToRemove = [5];

case   '3M0287_EX'
  Par.ICsToRemove = [];

case   '3M0288_EX'
  Par.ICsToRemove = [11];

case   '3M0310_EX'
  Par.ICsToRemove = [8];

case   '3M0312_EX'
  Par.ICsToRemove = [2];

case   '3M0313_EX'
  Par.ICsToRemove = [3 28];

case   '3M0316_EX'
  Par.ICsToRemove = [];

case   '3M0318_EX'
  Par.ICsToRemove = [12];

case   '3M0319_EX'
  Par.ICsToRemove = [2];

case   '3M0327_EX'
  Par.ICsToRemove = [2 30];

case   '3M0328_EX'
  Par.ICsToRemove = [5 16];

case   '3M0330_EX'
  Par.ICsToRemove = [];

case   '3M0332_EX'
  Par.ICsToRemove = [2];

case   '3M0336_EX'
  Par.ICsToRemove = [1 ];

case   '3M0337_EX'
  Par.ICsToRemove = [2];

case   '3M0338_EX'
  Par.ICsToRemove = [3];

case   '3M0339_EX'
  Par.ICsToRemove = [];

case   '3M0343_EX'
  Par.ICsToRemove = [12];

case   '3M0344_EX'
  Par.ICsToRemove = [3];

case   '3M0346_EX'
  Par.ICsToRemove = [9];

case   '3M0354_EX'
  Par.ICsToRemove = [2];

case   '3M0364_EX'
  Par.ICsToRemove = [];

case   '3M0365_EX'
  Par.ICsToRemove = [12];

case   '3M0369_EX'
  Par.ICsToRemove = [3];

case   '3M0376_EX'
  Par.ICsToRemove = [4];

case   '3M0384_EX'
  Par.ICsToRemove = [2 26];

case   '3M0386_EX'
  Par.ICsToRemove = [22];

case   '3M0392_EX'
  Par.ICsToRemove = [3];

case   '3M0397_EX'
  Par.ICsToRemove = [7];

case   '3M0399_EX'
  Par.ICsToRemove = [5];

case   '3M0405_EX'
  Par.ICsToRemove = [20];

case   '3M0407_EX'
  Par.ICsToRemove = [18];

case   '3M0420_EX'
  Par.ICsToRemove = [5];

case   '3M0422_EX'
  Par.ICsToRemove = [];

case   '3M0437_EX'
  Par.ICsToRemove = [];

case   '3M0485_EX'
  Par.ICsToRemove = [11];

case   '3M0512_EX'
  Par.ICsToRemove = [4];

case   '3M0513_EX'
  Par.ICsToRemove = [];  
  
end % of Par.subjectCodesList