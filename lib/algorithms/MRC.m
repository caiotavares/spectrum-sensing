function MRC = MRC(w, test)

MRC.E = test.X*w./sum(w); % Energy level
MRC.P = MRC.E./max(MRC.E);
MRC.P = [MRC.P 1-MRC.P];
MRC.name = 'MRC';
