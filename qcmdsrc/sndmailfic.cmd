             CMD        PROMPT('Envoi fichier par Mail') +
                          PRDLIB(GSEND)
             PARM       KWD(MBR1) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Membre  ')
             PARM       KWD(FILE1) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Fichier  ')
             PARM       KWD(LIB1) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Bibliotèque  ')
             PARM       KWD(EMAIL) TYPE(*CHAR) LEN(60)  +
                          MIN(1) PROMPT('Adresse mail')
             PARM       KWD(ZIP) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Fichier Zipper')
