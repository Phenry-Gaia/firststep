pgm  /*---------------------------------------------------------------------*/
  /*                                                                        */
  /* SAUVEGARDE INFOS SYSTEMES  AVANT V5R4                                  */
  /*                RTVSYSINF / UPDSYSINF                                   */
  /*          LISTE DE RÉPONSE SYSTÈME                                      */
  /*          ATTRIBUTS DE MAINTENANCE                                      */
  /*          VARIABLES D'ENVIRONNEMENT                                     */
  /*          CERTAINES VALEURS SYSTÈME                                     */
  /*          ATTRIBUT DE RÉSEAU SNA                                        */
  /*                                                                        */
  /*          + SCHEDULER                                                   */
  /*                *JOBSCD  DE QUSRSYS                                     */
  /*------------------------------------------------------------------------*/
DCL &SYS *CHAR 8
             RTVNETA    SYSNAME(&SYS)
             CRTLIB     LIB(LIBSYS) TEXT('Infos systèmes' *BCAT &SYS)
             MONMSG CPF2111
  /*------------------------------------------------------------------------*/
  /* SAUVEGARDE INFO SYSTÉME   VERSION AVANT 5.4                            */
  /*------------------------------------------------------------------------*/
             RTVSYSINF  LIB(LIBSYS)
             MONMSG     MSGID(CPA0701 CPF222E) EXEC(DO)
             SNDUSRMSG  MSG('Le droit spécial *SAVSYS obligatoire') +
                          MSGTYPE(*INFO)
             GOTO FIN
             ENDDO
             CRTSAVF    FILE(LIBSYS/SCHEDUL) TEXT('Sauvegarde +
                          scheduler'  *bcat &sys)
             MONMSG     MSGID(CPF5813 CPA0701 CPF7302)
  /*------------------------------------------------------------------------*/
  /* SAUVEGARDE SCHEDULER                                                   */
  /*------------------------------------------------------------------------*/
             SAVOBJ     OBJ(QDFTJOBSCD) LIB(QUSRSYS) DEV(*SAVF) +
                          OBJTYPE(*JOBSCD) SAVF(LIBSYS/SCHEDUL) +
                          CLEAR(*ALL)
FIN:
ENDPGM
