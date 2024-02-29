PGM  PARM(&NOMPGM &TYPE &LIB)
DCL &NOMPGM *CHAR 10
DCL &TYPE   *CHAR  1
DCL &LIB    *CHAR 10
             IF         COND(&LIB = '*CURLIB') THEN(RTVJOBA +
                          CURLIB(&LIB))
             ADDPFM     FILE(&LIB/QCLSRC) MBR(&NOMPGM)
             MONMSG     MSGID(CPF5812 CPF7306)
             CLRPFM     FILE(&LIB/QCLSRC) MBR(&NOMPGM)
             MONMSG     MSGID(CPF0000)
             /* */
             OVRDBF     FILE(QCLSRC) TOFILE(&LIB/QCLSRC) MBR(&NOMPGM)
  CALL GENCLDSPR PARM(&NOMPGM &TYPE)
          DLTOVR        FILE(QCLSRC)
ENDPGM
