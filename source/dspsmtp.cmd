/* PROGRAMME ASSOCIE  ASMTPC */
             CMD        PROMPT('Affichage historique Mail')
             PARM       KWD(DATDEB) TYPE(*CHAR) LEN(6) DFT(*CUR) +
                          PROMPT('Date début jjmmaa')
             PARM       KWD(TIMDEB) TYPE(*CHAR) LEN(6) PROMPT('Heure +
                          début ')     DFT(000001)
             PARM       KWD(DATFIN) TYPE(*CHAR) LEN(6) DFT(*CUR) +
                          PROMPT('Date fin jjmmaa')
             PARM       KWD(TIMFIN) TYPE(*CHAR) LEN(6) PROMPT('Heure +
                          de fin')   DFT(235959)
             PARM       KWD(SORTIE) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*DSP) VALUES(*DSP *FILE) +
                          PMTCTL(*PMTRQS) PROMPT('SORTIE fichier +
                          (DSPSMTPP)')
