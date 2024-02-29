             CMD        PROMPT('Envoi lib en savf')
             PARM       KWD(LIB) TYPE(*NAME) LEN(10) PROMPT('Bibliothèque') +
             MIN(1)
             PARM       KWD(EMAIL) TYPE(*CHAR) LEN(50) PROMPT('Email')
             PARM       KWD(ZIP) TYPE(*CHAR) LEN(4) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*YES) VALUES(*YES *NO) +
                          PMTCTL(*PMTRQS) PROMPT('Fichier Zippé')
             PARM       KWD(VERSION) TYPE(*CHAR) LEN(8) RTNVAL(*NO) +
                          RSTD(*YES) DFT(*CURRENT) VALUES(*CURRENT +
                          *PRV) PMTCTL(*PMTRQS) PROMPT('Version')
