PGM PARM(&SYS &USR &PWD &LIB &VER &LOG &CLR &LIBF &ACT &RST &PUB)
DCL &PUB *CHAR  4
DCL &SYS *CHAR 80
DCL &USR *CHAR 10
DCL &PWD *CHAR 50
DCL &LIB *CHAR 10
DCL &VER  *CHAR 10
DCL &LOG  *CHAR 4
DCL &CLR  *CHAR 4
DCL &LIBF *CHAR 10
DCL &ERR  *CHAR 1
DCL &ACT  *CHAR 5
DCL &RST  *CHAR 10
DCL &SAV  *CHAR 10 'X'
DCL &TIM  *CHAR 6
DCL VAR(&MSG) TYPE(*CHAR) LEN(132)
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR))
/*-----------------------------------------------------------------*/
/* CREATION DU FICHIER DE SAUVEGARDE   ET SAUVEGARDE               */
/*-----------------------------------------------------------------*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
CHGVAR %SST(&SAV 2 6) &TIM
CRTSAVF &LIBF/&SAV
MONMSG CPF7302
/*-----------------------------------------------------------------*/
/* MODIFICATION DES DROITS PUBLICS                                */
/*-----------------------------------------------------------------*/
IF COND(&PUB = '*YES') THEN(DO)
             GRTOBJAUT  OBJ(&LIB/*ALL) OBJTYPE(*ALL) USER(*PUBLIC) +
                          AUT(*ALL)
                          MONMSG CPF2200
             GRTOBJAUT  OBJ(*LIBL/&LIB) OBJTYPE(*LIB) USER(*PUBLIC) +
                          AUT(*ALL)
                          MONMSG CPF2200
ENDDO
             SAVLIB     LIB(&LIB) DEV(*SAVF) SAVF(&LIBF/&SAV) +
                          TGTRLS(&VER) CLEAR(*ALL) SAVACT(&ACT) +
                          PVTAUT(*YES) DTACPR(*HIGH)
                          MONMSG CPF0000 EXEC(DO)
 CALL SNDOBJR1   PARM( +
                 'SNDLIB'  +
                 &SYS      +
                 &USR      +
                 '*ALL'    +
                 &LIB      +
                 '*ALL'    +
                 &LIB      +
                 'KO'      +
                 'SAVLIB'  )
                 GOTO FIN
                 ENDDO
 /*------------------------------------------------------------------*/
 /* TEST DE DISPO MACHINE                                            */
 /*------------------------------------------------------------------*/
             PING  &SYS
             MONMSG TCP3200 EXEC(DO)
 CALL SNDOBJR1   PARM( +
                 'SNDLIB'  +
                 &SYS      +
                 &USR      +
                 '*ALL'    +
                 &LIB      +
                 '*ALL'    +
                 &LIB      +
                 'KO'      +
                 'PING '   )
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Machine' *BCAT &SYS *BCAT +
                          'injoignable') MSGTYPE(*ESCAPE)
             ENDDO
/**/
  CRTSRCPF   FILE(QTEMP/QFTPSRC) RCDLEN(192) MBR(SAVF)
MONMSG CPF7302  EXEC(DO)
           CLRPFM     FILE(QTEMP/QFTPSRC) MBR(SAVF  )
             ENDDO
/**/
  CRTSRCPF   FILE(QTEMP/QFTPLOG) RCDLEN(192) MBR(SAVFLG)
MONMSG CPF7302  EXEC(DO)
             CLRPFM   FILE(QTEMP/QFTPLOG) MBR(SAVFLG)
             GOTO SUITE
             ENDDO
             ADDPFTRG   FILE(QTEMP/QFTPLOG) TRGTIME(*AFTER) +
                          TRGEVENT(*INSERT) PGM(FTPLOGC)
SUITE:
/*-----------------------------------------------------------------*/
/* CREATION DU FICHIER DE SAUVEGARDE   ET SAUVEGARDE               */
/*-----------------------------------------------------------------*/
           OVRDBF     FILE(QFTPSRC) TOFILE(QTEMP/QFTPSRC) MBR(SAVF)
           OVRDBF     FILE(INPUT) TOFILE(QTEMP/QFTPSRC) MBR(SAVF)
           CALL SNDLIBR  (&USR &PWD &LIB &SAV &LIBF &RST &PUB)
/*-----------------------------------------------------------------*/
/* EXECUTION DU SCRIPTE FTP                                        */
/*-----------------------------------------------------------------*/
           CLRPFM     FILE(QTEMP/QFTPLOG) MBR(SAVFLG)
           IF COND(&LOG = '*NO ') THEN(DO)
           OVRDBF     FILE(OUTPUT) TOFILE(QTEMP/QFTPLOG) MBR(SAVFLG)
           ENDDO
           FTP &SYS
           DLTOVR INPUT
           MONMSG CPF0000
           DLTOVR OUTPUT
           MONMSG CPF0000
           DLTOVR QFTPSRC
           MONMSG CPF0000
CALL CTLFTPC (&ERR)
IF COND(&ERR = 'O') THEN(DO)
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) MSGDTA('Erreur +
                          sur envoi de la bibliothèque' *BCAT &LIB) +
                          MSGTYPE(*ESCAPE)
 CALL SNDOBJR1   PARM( +
                 'SNDLIB'  +
                 &SYS      +
                 &USR      +
                 '*ALL'    +
                 &LIB      +
                 '*ALL'    +
                 &LIB      +
                 'KO'      +
                 'LIB'     )
                          ENDDO
                          ELSE DO
 CALL SNDOBJR1   PARM( +
                 'SNDLIB'  +
                 &SYS      +
                 &USR      +
                 '*ALL'    +
                 &LIB      +
                 '*ALL'    +
                 &LIB      +
                 'OK'      +
                 'LIB'     )
ENDDO
           IF COND(&CLR = '*YES') THEN(DO)
           DLTF   FILE(QTEMP/QFTPSRC)
           ENDDO
 /*        DSPPFM     FILE(QTEMP/QFTPLOG) MBR(SAVFLG)    */
           GOTO FIN
ERREUR:
 CALL SNDOBJR1   PARM( +
                 'SNDLIB'  +
                 &SYS      +
                 &USR      +
                 '*ALL'    +
                 &LIB      +
                 '*ALL'    +
                 &LIB      +
                 'KO'      +
                 'LIB'     )
           RCVMSG MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
           SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
           MSGTYPE(*ESCAPE)
           FIN:
           DLTF    &LIBF/&SAV
           MONMSG CPF0000
ENDPGM
