             CMD        PROMPT('Envoyer un spool par Mail')

             PARM       KWD(FROMFILE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Nom du spool')

             PARM       KWD(EMAIL) TYPE(*CHAR) LEN(128) MIN(1) +
                          PROMPT('Email destinataire')


             PARM       KWD(JOB) TYPE(JOB) DFT(*) SNGVAL((*)) +
                          PROMPT('Travail')
 JOB:        QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Utilisateur')
             QUAL       TYPE(*CHAR) LEN(6) RANGE(000000 999999) +
                          MIN(1) PROMPT('Numéro')

             PARM       KWD(SPLNBR) TYPE(*DEC) LEN(4) DFT(*ONLY) +
                          RANGE(1 9999) SPCVAL((*LAST -2) (*ONLY +
                          -3)) PROMPT('Numéro de spool')

             PARM       KWD(TOFMT) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*TEXT) VALUES(*TEXT *HTML *PDF) +
                          PROMPT('Format du fichier')

             PARM       KWD(STOPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*NONE) VALUES(*NONE *ADD *REPLACE) +
                          PROMPT('Option fichier')

             PARM       KWD(SUJET) TYPE(*CHAR) LEN(60) RSTD(*NO) +
                          DFT(*NONE) SPCVAL((*NONE)) PMTCTL(*PMTRQS) +
                          PROMPT('Sujet du Mail')
             PARM       KWD(NOTE) TYPE(*CHAR) LEN(300) RSTD(*NO) +
                          DFT(*NONE) SPCVAL((*NONE)) +
                          PMTCTL(*PMTRQS) PROMPT('Note du Mail')

