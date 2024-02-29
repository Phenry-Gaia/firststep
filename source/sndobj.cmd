             CMD        PROMPT('Envoi d''un objet')
             PARM       KWD(SYS) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Système ou IP @')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Utilisateur Distant')
             PARM       KWD(PWD) TYPE(*CHAR) LEN(50) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Mot de passe')
             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Objet')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Bibliothèque')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Type')
             PARM       KWD(RSTLIB) TYPE(*CHAR) LEN(10) DFT(*SAVLIB) +
                          MIN(0) DSPINPUT(*YES) +
                          PROMPT('Bibliothèque Destination')
             PARM       KWD(VERSION) TYPE(*CHAR) LEN(10) +
                          DFT(*CURRENT) MIN(0) DSPINPUT(*YES) +
                          PROMPT('Version')
             PARM       KWD(LOG) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES('*YES' '*NO') MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Affichage de la log')
             PARM       KWD(DLTF) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES('*YES' '*NO') MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Suprimer le fichier scripte')
             PARM       KWD(LIBSAVF) TYPE(*CHAR) LEN(10) DFT(QGPL) +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Bibliothèque')
             PARM       KWD(SAVACT) TYPE(*CHAR) LEN(08) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *SYNCLIB) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Sauvegarde en mise à jour')
             PARM       KWD(AUTPUB) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Droit Public')
