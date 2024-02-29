/* pgm de traitement SNDFTPLIBC */
             CMD        PROMPT('Envoi d''un objet') PRDLIB(GSEND)
             PARM       KWD(SERvEuR) TYPE(*CHAR) LEN(80) MIN(1) +
                          PROMPT('Serveur ou IP @')
             PARM       KWD(USER) TYPE(*CHAR) LEN(30) MIN(1) +
                          PROMPT('Utilisateur Distant')
             PARM       KWD(PWD) TYPE(*CHAR) LEN(50) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Mot de passe')
             PARM       KWD(fichier) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Fichier')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Bibliothèque')
           PARM       KWD(Membre) TYPE(*CHAR) LEN(10)  MIN(1) +
                          DSPINPUT(*YES) PROMPT('Membre')
             PARM       KWD(LIBSAVF) TYPE(*CHAR) LEN(10) DFT(QGPL) +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Bibliothèque du SAVF')
             PARM       KWD(REPERT) TYPE(*CHAR) LEN(50) DFT(' ') +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Répertoire')
             PARM       KWD(PORT) TYPE(*DEC) LEN(5) DFT(00021) +
                          MIN(0) DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Port')
             PARM       KWD(RSTOBJ ) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT( *YES ) VALUES( *YES   *NO ) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Restaurer le membre')
             PARM       KWD(DLTSAVF) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT( *YES ) VALUES( *YES   *NO ) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Supprimer SAVF')
             PARM       KWD(CLRLOG) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT( *YES ) VALUES( *YES   *NO ) MIN(0) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Effacer LOG')
             PARM       KWD(VERSION) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*CURRENT) VALUES(V7R1M0 V7R2M0 +
                          V7R3M0 *CURRENT) MIN(0) DSPINPUT(*YES) +
                          PMTCTL(*PMTRQS) PROMPT('Version')
