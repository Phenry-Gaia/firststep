             CMD        PROMPT('Génération CLP/LST*')
             PARM       KWD(NOMPGM) TYPE(*NAME) MIN(1) PROMPT('Nom +
                          du programme')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT('O') VALUES('O' 'U' 'L' 'M' 'I') MIN(0) +
                          PROMPT('Type d''objets')
             PARM       KWD(BIBLIO) TYPE(*NAME) SPCVAL((*CURLIB *N)) +
                          MIN(1) PROMPT('Nom de Bibliothèque')
