PGM  PARM(&PWD) /*------------------------------------------------*/
/* EXECUTE TOUTES LES DEMANDES D'UN FICHIER  WSNDOBJP             */
/*----------------------------------------------------------------*/
DCL &PWD *CHAR 10   /* MOT DE PASSE */
DCLF WSNDOBJP
BOUCLE:
RCVF
MONMSG CPF0864  EXEC(GOTO FIN)
IF COND(&SNDCOM='SNDLIB') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Envoi +
                          Bibliothéque' *BCAT &SNDOBJ *BCAT 'En +
                          cours vers' *BCAT &SNDSYS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             SNDLIB     SYS(&SNDSYS) USER(&SNDUSR) PWD(&PWD) +
                          LIB(&SNDLIB)
MONMSG CPF0000

ENDDO
ELSE DO
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Envoi +
                          Objet' *BCAT &SNDLIB *BCAT 'En cours +
                          vers' *BCAT &SNDSYS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             SNDOBJ     SYS(&SNDSYS) USER(&SNDUSR) PWD(&PWD) +
                          OBJ(&SNDOBJ) LIB(&SNDLIB) TYPE(&SNDTYP) +
                          RSTLIB(&SNDLIBR)
MONMSG CPF0000
ENDDO
GOTO BOUCLE
FIN:
ENDPGM
