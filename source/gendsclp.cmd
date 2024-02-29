             CMD        PROMPT('Génération CLP/DS')
             PARM       KWD(NOMFIC) TYPE(*NAME) MIN(1) PROMPT('Nom +
                          du fichier')
             PARM       KWD(BIBLIOF) TYPE(*NAME) SPCVAL((*CURLIB *N)) +
                          MIN(1) PROMPT('Nom de Bibliothèque')
             PARM       KWD(NOMPGM) TYPE(*NAME) MIN(1) PROMPT('Nom +
                          du programme')
             PARM       KWD(BIBLIOP) TYPE(*NAME) SPCVAL((*CURLIB *N)) +
                          MIN(1) PROMPT('Nom de Bibliothèque')
