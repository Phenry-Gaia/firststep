             CMD        PROMPT('Génération CLP/DSPF')
             PARM       KWD(NOMPGM) TYPE(*NAME) MIN(1) PROMPT('Nom +
                          du programme')
             PARM       KWD(TITRE) TYPE(*CHAR) LEN(25) DFT('titre du +
                          programme') MIN(0) PROMPT('Titre du +
                          programme')
             PARM       KWD(TXTZONE) TYPE(*CHAR) LEN(20) DFT('texte +
                          de la zone') MIN(0) PROMPT('Texte de la +
                          zone')
             PARM       KWD(NOMZONE) TYPE(*NAME) LEN(10) +
                          DFT(ZONE1) MIN(0) PROMPT('Nom de la zone')
             PARM       KWD(LENZONE) TYPE(*DEC) LEN(2) DFT(10) +
                          MIN(0) PROMPT('Longueur de la zone')
             PARM       KWD(BIBLIO) TYPE(*NAME) SPCVAL((*CURLIB *N)) +
                          MIN(1) PROMPT('Nom de Bibliothèque')
