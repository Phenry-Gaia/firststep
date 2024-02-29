             CMD        PROMPT('Envoi d''un fichier IFS')
             PARM       KWD(SYS) TYPE(*CHAR) LEN(40) MIN(1) +
                          PROMPT('Système ou IP @')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Utilisateur Distant')
             PARM       KWD(PWD) TYPE(*CHAR) LEN(50) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Mot de passe')
             PARM       KWD(IFS) TYPE(*CHAR) LEN(132) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Fichier IFS')
             PARM       KWD(URLSRC) TYPE(*CHAR) LEN(132) MIN(1) +
                          DSPINPUT(*YES) PROMPT('Répertoire IFS +
                          source')
             PARM       KWD(URLCIB) TYPE(*CHAR) LEN(132) DFT(*SAME) +
                          DSPINPUT(*YES) PMTCTL(*PMTRQS) +
                          PROMPT('Répertoire IFS cible')
