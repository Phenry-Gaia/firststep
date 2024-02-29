             CMD        PROMPT('Lancement instance d''un SFL') +
                          PRDLIB(BERTHOIN)
             PARM       KWD(INSTANCE) TYPE(*NAME) SPCVAL((*LISTE +
                          *N)) MIN(1) PROMPT('Nom de l''instance')
             PARM       KWD(PARM) TYPE(*CHAR) LEN(78) DFT('*NONE') +
                          MIN(0) MAX(1) PMTCTL(*PMTRQS) +
                          PROMPT('Paramétrage')
