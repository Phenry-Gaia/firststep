             CMD        PROMPT('Envoi savf par mail') PRDLIB(GSEND)
             PARM       KWD(LIB) TYPE(*NAME) LEN(10) MIN(1) MAX(1) +
                          PROMPT('Bibliothèque')
             PARM       KWD(MAIL) TYPE(*CHAR) LEN(100) MIN(1) MAX(1) +
                          PROMPT('Email')
             PARM       KWD(TGTRLS) TYPE(*CHAR) LEN(8) DFT(*CURRENT) +
                          MIN(0) MAX(1) CHOICE(VXRXMX) +
                          PROMPT('Version')
             PARM       KWD(LIBSAF) TYPE(*NAME) LEN(10) DFT(LIBSAVF) +
                          MIN(0) MAX(1) PMTCTL(*PMTRQS) +
                          PROMPT('Bibliothèque SAVF')
