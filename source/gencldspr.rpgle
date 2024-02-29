     h*-------------------------------------------------------------
     h*
     h* Génération d'un programme CLP de traitement d'un fichier
     h*
     h*-------------------------------------------------------------
     hDFTACTGRP(*NO)
     fqclsrc    o    e             disk    rename(qclsrc:qclsrcf)
     D GENCLDSPR       PR
     D                               10
     D                                1
     D GENCLDSPR       PI
     D  NOMPGM                       10
     D  TYPE                          1
      /free
       srcdat = udate ;
       //
       // generation clp
       //
       srcseq = 0 ;
       srcdta = '/*--------------------------------------------*/ '         ;
        exsr ecr_clp       ;
       srcdta = '/* Génération par GENCLDSP ' + %CHAR(udate) + ' */ '         ;
        exsr ecr_clp       ;
       srcdta = '/* VERSION 2.1                                */ '       ;
        exsr ecr_clp       ;
       srcdta = '/*--------------------------------------------*/ '         ;
        exsr ecr_clp       ;
        //------------------------------------------------------*
        // choix des valeurs de liste à générer
        // O liste d'objets
        // U liste de profils
        // M liste de membres
        // L liste de bibliothèque
        // I Index sur une table
        //------------------------------------------------------*
       select                    ;
       //
       when type =  'O'          ;   // listes d'objets
       //
       srcdta = ' PGM        PARM(&OBJ &LIB &TYP)     '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&TYP) TYPE(*CHAR) LEN(07) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&FIN) TYPE(*LGL)           '         ;
        exsr ecr_clp       ;
       srcdta = ' DCLF QSYS/QADSPOBJ /* FICHIER SYSTEME */  '         ;
        exsr ecr_clp       ;
        srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' DSPOBJD    OBJ(&LIB/&OBJ) OBJTYPE(&TYP) + '         ;
        exsr ecr_clp       ;
       srcdta = '              OUTPUT(*OUTFILE) OUTFILE(QTEMP/WADSPOBJ)'   ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/WADSPOBJ) +  '    ;
        exsr ecr_clp       ;
       srcdta = '            LVLCHK(*NO)                             '    ;
        exsr ecr_clp       ;
        //
       when type =  'I'          ;   // listes des indexs
       //
       srcdta = ' PGM        PARM(&OBJ &LIB)          '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&FIN) TYPE(*LGL)           '         ;
        exsr ecr_clp       ;
       srcdta = ' DCLF QSYS/QADSPDBR /* FICHIER SYSTEME */  '         ;
        exsr ecr_clp       ;
        srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' DSPDBR    FILE(&LIB/&OBJ)               + '         ;
        exsr ecr_clp       ;
       srcdta = '              OUTPUT(*OUTFILE) OUTFILE(QTEMP/WADSPDBR)'   ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' OVRDBF     FILE(QADSPDBR) TOFILE(QTEMP/WADSPDBR) +  '    ;
        exsr ecr_clp       ;
       srcdta = '            LVLCHK(*NO)                             '    ;
        exsr ecr_clp       ;
        //
       when type =  'L'          ;   // listes de bibliothèques
        //
       srcdta = ' PGM        PARM(&LIB)     '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&FIN) TYPE(*LGL)           '         ;
        exsr ecr_clp       ;
       srcdta = ' DCLF QSYS/QADSPOBJ /* FICHIER SYSTEME */  '         ;
        exsr ecr_clp       ;
        srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' DSPOBJD    OBJ(QSYS/&LIB) OBJTYPE(*LIB) + '         ;
        exsr ecr_clp       ;
       srcdta = '              OUTPUT(*OUTFILE) OUTFILE(QTEMP/WADSPOBJ)'   ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
       srcdta = ' OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/WADSPOBJ) +  '    ;
        exsr ecr_clp       ;
       srcdta = '            LVLCHK(*NO)                             '    ;
        exsr ecr_clp       ;
        //
       when type =  'M'          ;   // listes de membres
        //
       srcdta = ' PGM        PARM(&OBJ &LIB)     '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&FIN) TYPE(*LGL)           '         ;
        exsr ecr_clp       ;
       srcdta =  'DCLF QSYS/QAFDMBR  /* FICHIER SYSTEME */ '         ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
        srcdta = 'DSPFD      FILE(&LIB/&OBJ) TYPE(*MBR) OUTPUT(*OUTFILE) + ' ;
        exsr ecr_clp       ;
         srcdta = '       OUTFILE(QTEMP/WAFDMBR )                   ' ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
        srcdta = 'OVRDBF     FILE(QAFDMBR ) TOFILE(QTEMP/WAFDMBR ) +  ';
        exsr ecr_clp       ;
        srcdta = '        LVLCHK(*NO)                                   ';
        exsr ecr_clp       ;
        //
       when type =  'U'          ;   // listes de profils
       srcdta = ' PGM        PARM(&OBJ)     '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&OBJ) TYPE(*CHAR) LEN(10) '         ;
        exsr ecr_clp       ;
       srcdta = ' DCL        VAR(&FIN) TYPE(*LGL)           '         ;
        exsr ecr_clp       ;
        srcdta = 'DCLF QSYS/QADSPUPA /* FICHIER SYSTEME */    ';
        exsr ecr_clp       ;
       srcdta = ' MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERREUR)) '    ;
        exsr ecr_clp       ;
        srcdta = 'DSPUSRPRF  USRPRF(&OBJ) OUTPUT(*OUTFILE) +  '     ;
        exsr ecr_clp       ;
        srcdta = '        OUTFILE(QTEMP/WADSPUPA)               '     ;
        exsr ecr_clp       ;
         srcdta = 'OVRDBF     FILE(QADSPUPA) TOFILE(QTEMP/WADSPUPA) +  ' ;
        exsr ecr_clp       ;
         srcdta = '       LVLCHK(*NO)                                ' ;
        exsr ecr_clp       ;
        //
       endsl                     ;
        //
        // partie commune fin du programme
        //
       srcdta = ' /*---------------------*/     '         ;
        exsr ecr_clp       ;
       srcdta = ' /* BOUCLE DE LECTURE   */     '         ;
        exsr ecr_clp       ;
       srcdta = ' /*---------------------*/     '         ;
        exsr ecr_clp       ;
       srcdta = ' DOUNTIL    COND(&FIN)         '         ;
        exsr ecr_clp       ;
       srcdta = ' RCVF                          '         ;
        exsr ecr_clp       ;
       srcdta = ' MONMSG CPF0864 EXEC(LEAVE)    '         ;
        exsr ecr_clp       ;
       srcdta = ' /* ICI TRAITEMENT      */     '         ;
        exsr ecr_clp       ;
       select                    ;
       when type =  'O'          ;   // listes d'objets
       srcdta = ' SNDUSRMSG  MSG(''Objet'' *bcat &odobnm) + '    ;
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       when type =  'I'          ;   // listes des indexs
       srcdta = ' SNDUSRMSG  MSG(''Fichier'' *bcat &whrfi *bcat &whrli) + '    ;
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       when type =  'L'          ;   // listes de bibliothèques
       srcdta = ' SNDUSRMSG  MSG(''Bibliothèque'' *bcat &odobnm) + '    ;
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       when type =  'U'          ;   // listes de profils
       srcdta = ' SNDUSRMSG  MSG(''User''  *bcat &oausr ) + '    ;
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       when type =  'M'          ;   // listes de membres
       srcdta = ' SNDUSRMSG  MSG(''Fichier'' *bcat &mbfile *bcat &mbname ) + ';
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       endsl           ;
       srcdta = ' ENDDO                         '         ;
        exsr ecr_clp       ;
       srcdta = ' DLTOVR     FILE(*all)         '         ;
        exsr ecr_clp       ;
       srcdta = ' GOTO FIN                      '         ;
        exsr ecr_clp       ;
       srcdta = ' ERREUR:                       '         ;
        exsr ecr_clp       ;
       srcdta = ' SNDUSRMSG  MSG(''Erreur de génération du fichier'') + '    ;
        exsr ecr_clp       ;
       srcdta = '              MSGTYPE(*INFO)   '         ;
        exsr ecr_clp       ;
       srcdta = ' FIN:                          '         ;
        exsr ecr_clp       ;
       srcdta = '              ENDPGM           '         ;
        exsr ecr_clp       ;
        // fin du programme
        *inlr = *on ;
        //-------------------------------------------
        // Ecriture clp
        //-------------------------------------------
        begsr ecr_clp ;
          srcseq = srcseq + 5 ;
          srcdta = '   ' +srcdta ;
          write Qclsrcf       ;
        endsr  ;
       /end-free
