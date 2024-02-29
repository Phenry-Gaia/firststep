PGM  (&DATDEB &TIMDEB &DATFIN &TIMFIN &SORTIE)
DCL &DATDEB *CHAR 6
DCL &TIMDEB *CHAR 6
DCL &DATFIN *CHAR 6
DCL &TIMFIN *CHAR 6
DCL &SORTIE *CHAR 5
IF COND(&DATDEB = '*CUR') THEN(DO)
RTVSYSVAL QDATE &DATDEB
             CVTDAT     DATE(&DATDEB) TOVAR(&DATDEB) +
                          FROMFMT(*SYSVAL) TOFMT(*DMY) TOSEP(*NONE)
ENDDO
IF COND(&DATFIN = '*CUR') THEN(DO)
RTVSYSVAL QDATE &DATFIN
             CVTDAT     DATE(&DATFIN) TOVAR(&DATFIN) +
                          FROMFMT(*SYSVAL) TOFMT(*DMY) TOSEP(*NONE)
ENDDO
/* SANS DATE     */
IF COND(&DATDEB = ' ' *AND &DATFIN = ' ') THEN(DO)
             DSPJRN     JRN(QZMF) RCVRNG(*CURCHAIN) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/LOGMAIL) ENTDTALEN(*CALC)
                          MONMSG CPF7062
GOTO SUITE
ENDDO
/* DATE DE DEBUT */
IF COND(&DATFIN = ' ') THEN(DO)
             DSPJRN     JRN(QZMF) RCVRNG(*CURCHAIN) FROMTIME(&DATDEB +
                          &TIMDEB)                         +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LOGMAIL) +
                          ENTDTALEN(*CALC)
                          MONMSG CPF7062
GOTO SUITE
ENDDO
/* DATE DE FIN   */
IF COND(&DATDEB = ' ') THEN(DO)
             DSPJRN     JRN(QZMF) RCVRNG(*CURCHAIN)                  +
                                   TOTIME(&DATFIN &TIMFIN) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LOGMAIL) +
                          ENTDTALEN(*CALC)
                          MONMSG CPF7062
GOTO SUITE
ENDDO
/* DATE DE DEBUT ET DATE DE FIN */
             IF         COND(&DATDEB *NE ' ' *AND &DATFIN *NE ' ') +
                          THEN(DO)
             DSPJRN     JRN(QZMF) RCVRNG(*CURCHAIN) FROMTIME(&DATDEB +
                          &TIMDEB) TOTIME(&DATFIN &TIMFIN) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LOGMAIL) +
                          ENTDTALEN(*CALC)
                          MONMSG CPF7062
GOTO SUITE
ENDDO
SUITE:
CALL DSPSMTPR PARM(&SORTIE  +
                   &DATDEB  +
                   &TIMDEB  +
                   &DATFIN  +
                   &TIMFIN)
ENDPGM
