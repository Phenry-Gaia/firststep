PGM PARM(       &PARM)
   DCL &PARM  *CHAR 78
   DCL &POS   *DEC  2     (2)   /* DEBUT         */
   DCL &LEN   *DEC  10    (10)  /* LONGUEUR      */
   DCL &INS   *CHAR 10
   DCL &INSO  *CHAR 11
   MONMSG CPF0000 EXEC GOTO ERREUR
   CHGVAR &INS   (%SST(&PARM &POS &LEN))
   /*  TRAITEMENT DES OPTIONS                    */
   IF COND(%SST(&PARM 1 1) = '4') THEN(DO)
   CHGVAR &INSO   ('4' *TCAT &INS)
   CALL SUB001R (&INSO)
   ENDDO
   IF COND(%SST(&PARM 1 1) = '2') THEN(DO)
   CHGVAR &INSO   ('2' *TCAT &INS)
   CALL SUB001R (&INSO)
   ENDDO
   IF COND(%SST(&PARM 1 1) = '1') THEN(DO)
   SUB   &INS
   ENDDO
   CHGVAR %SST(&PARM &POS 68)    ('** TRAITEMENT EFFECTUE **')
   GOTO FIN
   ERREUR:
             CHGVAR %SST(&PARM &POS 68)    ('** TRAITEMENT NON OK  **')
             SNDUSRMSG  MSG('Opération impossible') MSGTYPE(*INFO)
   FIN:
   ENDPGM
ENDPGM
