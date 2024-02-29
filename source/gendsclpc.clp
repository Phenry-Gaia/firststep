PGM  PARM(&NOMFIC &LIBF &NOMPGM  &LIBP)
DCL &NOMFIC *CHAR 10
DCL &LIBF   *CHAR 10
DCL &NOMPGM *CHAR 10
DCL &LIBP   *CHAR 10
             IF         COND(&LIBP = '*CURLIB') THEN(RTVJOBA +
                          CURLIB(&LIBP))
             ADDPFM     FILE(&LIBP/QCLSRC) MBR(&NOMPGM)
             MONMSG     MSGID(CPF5812 CPF7306)
             CLRPFM     FILE(&LIBP/QCLSRC) MBR(&NOMPGM)
             MONMSG     MSGID(CPF0000)
             /* */
             CHKOBJ   &LIBF/&NOMFIC
             MONMSG     MSGID(CPF9800) EXEC(SNDPGMMSG MSGID(CPF9897) +
                          MSGF(QCPFMSG) MSGDTA('Fichier' *BCAT &NOMFIC +
                          *TCAT ', non disponible dans la +
                          bibliothèque' *BCAT &LIBF) MSGTYPE(*ESCAPE))
             OVRDBF     FILE(QCLSRC) TOFILE(&LIBP/QCLSRC) MBR(&NOMPGM)
  CALL GENDSCLPR PARM(&NOMFIC &LIBF)
          DLTOVR        FILE(QCLSRC)
ENDPGM
