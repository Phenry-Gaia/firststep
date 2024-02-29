             CMD        PROMPT('Envoi d''un objet')
             PARM       KWD(SYS) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Système ou IP @')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Utilisateur Distant')
             PARM       KWD(PWD) TYPE(*CHAR) LEN(50) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Mot de passe')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Bibliothèque')
             PARM       KWD(VERSION) TYPE(*CHAR) LEN(10) +
                          DFT(*CURRENT) MIN(0) DSPINPUT(*YES) +
                          PROMPT('Version')
             PARM       KWD(LOG) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES('*YES' '*NO') MIN(0) +
                          DSPINPUT(*YES) PROMPT('Affichage de la log')
             PARM       KWD(DLTF) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES('*YES' '*NO') MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Suprimmer le fichier scripte')
             PARM       KWD(LIBSAVF) TYPE(*CHAR) LEN(10) DFT(QGPL) +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Bibliothèque')
             PARM       KWD(SAVACT) TYPE(*CHAR) LEN(05) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES *SYNC) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Sauvegarde en mise à jour')
             PARM       KWD(RSTLIB) TYPE(*NAME) LEN(10) DFT(*SAVLIB) +
                          SPCVAL((*SAVLIB)) MIN(0) DSPINPUT(*YES) +
                          PMTCTL(*PMTRQS) PROMPT('Bibliothèque +
                          Restauration')
             PARM       KWD(AUTPUB) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          DSPINPUT(*PROMPT) PMTCTL(*PMTRQS) +
                          PROMPT('Droit Public')
