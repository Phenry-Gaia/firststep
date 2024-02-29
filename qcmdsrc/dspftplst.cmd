/* pgm de traitement SNDFTPLIBC */
             CMD        PROMPT('Affichage répertoire') PRDLIB(GSEND)
             PARM       KWD(SERvEuR) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Serveur ou IP @')
             PARM       KWD(USER) TYPE(*CHAR) LEN(30) MIN(1) +
                          PROMPT('Utilisateur Distant')
             PARM       KWD(PWD) TYPE(*CHAR) LEN(50) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Mot de passe')
             PARM       KWD(REPERT) TYPE(*CHAR) LEN(50) DFT(' ') +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Répertoire')
             PARM       KWD(PORT) TYPE(*DEC) LEN(5) DFT(00021) +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Port')
