             CMD        PROMPT('Envoi outq par SAVF') PRDLIB(GSEND)
             PARM       KWD(OUTQ) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Nom Outq')
             PARM       KWD(LIB) TYPE(*NAME) LEN(10) min(1) +
                          SPCVAL((*LIBL))        PROMPT('Library Outq')
             PARM       KWD(MAIL) TYPE(*CHAR) LEN(100) MIN(1) +
                          PROMPT('Mail ')
             PARM       KWD(ZIP) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Zipper ')
