PGM
             STRSEU     SRCFILE(QTEMP/QFTPSRC) SRCMBR(SAVF) +
                          TYPE(SQL) OPTION(2)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             SNDUSRMSG  MSG('Pas de scripte SNDXX pour cette +
                          session') MSGTYPE(*INFO)
             ENDDO
ENDPGM
