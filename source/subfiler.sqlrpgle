      *------------------------------------------------------------------------*
      *                                                                        *
      * Ce programme affiche un sous fichier avec un paramétrage défini        *
      * dans le fichier subfile                                                *
      *                                                                        *
      * subfiler                                                               *
      *                                                                        *
      *------------------------------------------------------------------------*
     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
     fsubfilee  cf   e             WORKSTN
     F                                     SFILE(SFL01:CLE01)
     d* variable de travail
     dwpgm01           s            500
     d posparm         s              2  0
     d lenparm         s              2  0
     d possel          s              2  0
     dpag01            s              2  0
     dCLE01            s              4  0
     dCLE01s           s              4  0
     dcmd01            s            142
     dsql01            s            500
     dwhe01            s            400
     dodr01            s            400
     dsqlstm           s            908
     dcmdexec          s           4096
     dtrt01            s             11
     dtype             s              1
     dpgm              s             10
     D* prototypage des procédures
     D SUBFILER        PR
     D                               10
     D                               78    options(*omit)
     D*
     D SUBFILER        PI
     D   Pgm01                       10
     D   Parm                        78    options(*omit)
     d* prototypage pour programme qcmdexc
     DCmd              PR                  EXTPGM('QCMDEXC')
     D PR_CmdStr                   4096A   CONST OPTIONS(*VARSIZE)
     D PR_CmdStrLen                  15P 5 CONST
     d*  prototypage liste des options
     DListe            PR                  EXTPGM('OPTIONR')
     D PR_type                        1A
     D PR_PGM                        10A
      /free
       //
       // initialisation des options de compile sql
       //
         EXEC SQL
                 Set Option
                   Naming    = *Sys,
                   Commit    = *None,
                   UsrPrf    = *User,
                   DynUsrPrf = *User,
                   Datfmt    = *iso,
                   CloSqlCsr = *EndMod;
       // Si liste demandé
         if Pgm01 = '*LISTE' ;
           pgm01 = 'LSTSUB' ;
         endif ;
       // titre
         EXEC SQL
         select texte into :TIT01 from subfile
              where PGM = :PGM01 and LIBEL = 'TITRE' ;
              if sqlcode <> 0  ;
         TIT01 = 'Pas de sous fichier défini'       ;
         else;
       // Programme de pre traitement
         EXEC SQL
         select texte into :CMD01 from subfile
              where PGM = :PGM01 and LIBEL = 'PRE01' ;
         if cmd01 <> ' ' ;
              cmdexec = cmd01 ;
                 monitor                          ;
                 cmd(cmdexec:%LEN(cmdexec))       ;
                 On-error;
                    dsply 'Erreur sur commande pre ';
                 Endmon;
         endif ;
       // Ligne 1
         EXEC SQL
         select texte into :LIG01 from subfile
              where PGM = :PGM01 and LIBEL = 'LIG1' ;
       // Ligne 2
         EXEC SQL
         select texte into :LIG02 from subfile
              where PGM = :PGM01 and LIBEL = 'LIG2' ;
       // Ligne 3
         EXEC SQL
         select texte into :LIG03 from subfile
              where PGM = :PGM01 and LIBEL = 'LIG3' ;
       // where   SQL
         EXEC SQL
         select texte into :whe01 from subfile
              where PGM = :PGM01 and LIBEL = 'WHERE' ;
       // where   ORDER
         EXEC SQL
         select texte into :odr01 from subfile
              where PGM = :PGM01 and LIBEL = 'ORDER' ;
          if whe01 = ' ';
            *in46 = *on ;
          endif ;
       // requete SQL
         EXEC SQL
         select texte into :SQL01 from subfile
              where PGM = :PGM01
                          and LIBEL = 'SQL1'      ;
       // formatage paramètre du where
       // extraction parametre de Trait
         EXEC SQL
         select texte into :WPGm01 from subfile
              where PGM = :PGM01  and LIBEL = 'TRAIT' ;
          if wpgm01 = ' ';
            *in45 = *on ;
          endif ;
       // formatage clause where
              if whe01 <> ' '                     ;
       // test si valeur à passer
          if  %subst(wpgm01: 12: 2) <> ' ' and %parms() > 1 ;
            if %subst(Parm:1:5) <> '*NONE' ;
       // découpage paramètre traitement
            posparm  = %DEC(%subst(wpgm01: 12: 2):2:0  ) ;
            lenparm  = %DEC(%subst(wpgm01: 14: 2):2:0  ) ;
            possel   = %DEC(%subst(wpgm01: 16: 2):2:0  ) ;
          %subst(whe01:possel:lenparm) = %subst(PARM:posparm:lenparm) ;
          endif                               ;
          endif                               ;
              sqlstm  = %trim(sql01) + ' where ' + %trim(whe01) ;
              else                                ;
              sqlstm  = sql01                     ;
          endif ;
          if odr01 <> ' ' ;
              sqlstm  = %trim(sql01) + ' where ' + whe01 +
                                       ' Order by ' + odr01      ;
          endif ;
         // where de l'ecran
         whe02 = whe01 ;
         endif ;
              exsr init                           ;
              exsr char                           ;
              exsr affi                           ;
       // fin de programme
              *inlr = *on                         ;
       //
       // Initialisation
       //
              BEGSR   INIT                        ;
              cle01s = 0                          ;
              num01 = 1                           ;
              cle01 = 0                           ;
              *in40 = *on                         ;
              opt01 = ' '                         ;
              write ctl01                         ;
              *in40 = *off                        ;
              *in48 = *off                        ;
              *in50 = *off                        ;
       // Traitement du curseur
          exec sql
             close curs01                         ;
         exec SQL
           declare curs01     Cursor
             for mainSelect                       ;
          exec sql
           prepare mainSelect
              from :sqlstm                        ;
          exec sql
             open curs01                          ;
              ENDSR                               ;
       //
       // Chargement
       //
              BEGSR   CHAR                        ;
              cle01 = Cle01s                    ;
              pag01 = 0 ;
              dou       pag01 = 11    ;
              pag01 = pag01 + 1                   ;
              exec sql
                fetch next
                  from curs01
                  into :det01                     ;
              if  sqlcode =  0                    ;
       // limite de taille du sous fichier
                  cle01 = Cle01 + 1                 ;
                  write sfl01                       ;
                  cle01s= Cle01                     ;
                else  ;
                  *in50 = *on                     ;
                  leave  ;
                endif         ;
              enddo                               ;
              num01 = cle01                       ;
              ENDSR                               ;
       //
       // Affichage
       //
              BEGSR   AFFI                        ;
              *in41 = *on                         ;
              dou *in03                           ;
              if cle01 > 0                        ;
                *in42 = *on                       ;
              else                                ;
                *in42 = *off                      ;
              endif                               ;
                 write fmt01                      ;
                 exfmt ctl01                      ;
                   if *in03                       ;
                     leave                        ;
                   endif                          ;
                 select                           ;
        // f4 Liste des options
                 when *in04                       ;
                    type= 'A'                    ;
                 Liste(type:pgm01)               ;
        // f5 réafficher
                 when *in05                       ;
                     if whe02 <> ' '                     ;
                       sqlstm  = sql01 +
                       ' where ' + whe02 ;
                     else                                ;
                       sqlstm  = sql01                     ;
                     endif                               ;
                   exsr init                    ;
                   exsr char                    ;
        // f16 Enregister la requete
                 when *in10                       ;
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :WHE02 WHERE PGM=:PGM01
        and LIBEL= 'WHERE';
        // f16 Afficher requete
                 when *in16                       ;
                 exfmt fmt02             ;
        // rollup
                 when *in49                       ;
                   exsr char             ;
                 other                        ;
                   exsr trai                    ;
                 endsl                          ;
              enddo                               ;
              ENDSR                               ;
       //
       // Traitement
       //
              BEGSR   TRAI                        ;
               if cle01 > 0                       ;
                 dou %eof(     )                    ;
                   readc sfl01                      ;
                   if not %eof                      ;
           EXEC SQL
           select texte into :TRT01 from subfile
                where PGM = :PGM01 and LIBEL = 'TRAIT' ;
           if trt01 = ' ' ;
           dsply 'Pas de programme de traitement' ;
           else ;
           // appel du programme si otion existante
         //EXEC SQL
         //SELECT pgm into :pgm FROM optionl
         //  WHERE PGM = :PGM01    and OPT = :opt01;
               if %subst(trt01:1:1) = 'O';
                   cmdexec  =  'CALL  PGM(SUBFILER) PARM(''' +
                 %subst(trt01:2:10) + ''' ''' + opt01 + det01 + ''')'   ;
               else ;
                  cmdexec  =  'CALL  PGM(' + %subst(trt01:2:10) +
                   ')  PARM(''' + opt01 + det01 + ''')'   ;
               endif ;
                   monitor                          ;
                   cmd(cmdexec:%LEN(cmdexec))       ;
                   On-error;
                      Dsply %Status;     // Status = 0202 Command failed
                      dsply 'erreur sur commande ';
                   Endmon;
         //        else ;
         //           Dsply 'Option indisponible' ;
         //        endif ;
                   endif ;
                     opt01 = ' '                    ;
                     num01 = cle01                  ;
                     %subst(DET01:40:30)  = '** Traitement effectué **' ;
                     update sfl01                   ;
                   endif                            ;
                 enddo                              ;
               endif                              ;
              ENDSR                               ;
      /end-free
