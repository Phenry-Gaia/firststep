     h*-------------------------------------------------------------------
     h*
     h* Programme de mise à jour d'une instance
     h*
     h*-------------------------------------------------------------------
     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
     fsub001E   cf   e             WORKSTN
     D   wPgm01        s             80
     D   Pgm01         s             10
     D   type          s              1
     D   wtype         s              1
     d* prototypage de fonction (interne)
     D SUB001R         PR
     D   Parm                        76
     d* affichage fenetre d'erreur
     D POPUP           PR                  ExtPgm('QUILNGTX')
     D   text                     65535a   const options(*varsize)
     D   length                      10i 0 const
     D   msgid                        7a   const
     D   qualmsgf                    20a   const
     D   errorCode                32783a   options(*varsize)
     d*  prototypage liste des options
     DListe            PR                  EXTPGM('OPTIONR')
     D PR_type                        1A
     D PR_PGM                        10A
     d*
     d*
     D ErrorNull       ds                  qualified
     D   BytesProv                   10i 0 inz(0)
     D   BytesAvail                  10i 0 inz(0)
     D SUB001R         PI
     D   Parm                        76
     D msg             s             76
      /free
       //
       // Option sql de compilation
       //
         if %parms() = 0 ;
              msg  = 'Vous devez passer au moins un paramètre ' ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
         else  ;
         EXEC SQL
                 Set Option
                   Naming    = *Sys,
                   Commit    = *None,
                   UsrPrf    = *User,
                   DynUsrPrf = *User,
                   Datfmt    = *iso,
                   Dlyprp    = *yes,
                   CloSqlCsr = *EndMod;
       //
       // parsing des parametres recus
       //
       type = %subst(parm:1:1)         ;
       pgm01 = %subst(parm:2:10)       ;
       //
       // affichage action
       //
         select ;
           when  type = '1'       ;
       //          clear fmt01             ;
                   texte = '** Création **'     ;
                   *in50 = *off ;
                   trt01 = 'TESTPGM'                     ;
                   tit01 = 'Liste ....'                  ;
                   sql01 = 'Select ...'                  ;
           when  type = '2'       ;
                   *in50 = *on  ;
                   texte = '**  Modification **' ;
           when  type = '4'       ;
                   *in51 = *on  ;
                   texte = '** Suppression **'  ;
         endsl  ;
         EXEC SQL
         // controle existence
         select pgm   into :PGM01 from subfile
              where PGM = :PGM01 and LIBEL = 'TITRE' ;
         //
         // si creation et dej existant
         // ou Modification suppression et existant
         //
         if (sqlcode <> 0 and type = '1' )
           or
           (sqlcode = 0 and type <>  '1') ;
       // titre
       if type <> '1'     ;
         EXEC SQL
         select texte into :TIT01   from subfile
              where PGM = :PGM01 and LIBEL = 'TITRE' ;
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
       // requetes sql
         EXEC SQL
         select texte into :sql01 from subfile
              where PGM = :PGM01 and LIBEL = 'SQL1' ;
       // requetes sql clause where
         EXEC SQL
         select texte into :whe01 from subfile
              where PGM = :PGM01 and LIBEL = 'WHERE' ;
       // requetes sql clause where
         EXEC SQL
         select texte into :WPGm01 from subfile
              where PGM = :PGM01  and LIBEL = 'TRAIT' ;
       // découpage paramètre traitement
          opt01    = %subst(wpgm01:  1: 1) ;
          trt01    = %subst(wpgm01:  2:10) ;
          posparm  = %subst(wpgm01: 12: 2) ;
          lenparm  = %subst(wpgm01: 14: 2) ;
          possel   = %subst(wpgm01: 16: 2) ;
       // programme de pre traitement
         EXEC SQL
         select texte into :WPRE01 from subfile
              where PGM = :PGM01  and LIBEL = 'PRE01' ;
        endif ;
       // fin de programme
              dou *in03  ;
                 exfmt fmt01 ;
                  select       ;
                   when *in03  ;
                     leave ;
        // f4 Liste des options
                   when *in04                       ;
                     wtype= 'M'                    ;
                   Liste(wtype:pgm01)               ;
                   when *in06  ;
                     clear fmt01 ;
                     texte = 'Creation';
                     *in50 = *off;
                     type = '1'   ;
                     trt01 = 'TESTPGM'                     ;
                     tit01 = 'Liste ....'                  ;
                     sql01 = 'Select ...'                  ;
                   other ;
                   *in50 = *on ;
                     exsr ecri ;
                   endsl ;
              enddo ;
           else   ;
       //
       // operation impossible
       //
            if type = '1'   ;
              msg  = 'Programme déjà existant'    ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
            else            ;
              msg  = 'Programme Non existant' ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
            endif           ;
           endif ;
         endif;
              *inlr = *on    ;
       // -------------------------------------
       // Mise à jour
       // -------------------------------------
              BEGSR   ECRI;
                   select ;
        //
        //  Création    du Paramétrage
        //
                   when  type = '1' ;
         EXEC SQL
         select pgm   into :PGM01 from subfile
              where PGM = :PGM01 and LIBEL = 'TITRE' ;
         // si creation et dej existant
         if (sqlcode <> 0) ;
       // titre
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'TITRE', :TIT01) ;
         if (sqlcode <> 0) ;
          msg =  'Erreur de Création'  ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
         else                          ;
       // Ligne 1
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'LIG1 ', :LIG01) ;
       // Ligne 2
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'LIG2 ', :LIG02) ;
       // Ligne 3
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'LIG3 ', :LIG03) ;
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'SQL1 ', :SQL01) ;
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'WHERE', :WHE01) ;
          wpgm01 = opt01 + trt01 + posparm + lenparm + possel ;
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'TRAIT', :Wpgm01) ;
         EXEC SQL
        INSERT INTO SUBFILE VALUES(:PGM01, 'PRE01', :Wpre01) ;
         endif ;
        else ;
        // instance deja existante
        *in52 = *on ;
        endif;
                   when  type = '2' ;
        //
        //  Mise à jour du Paramétrage
        //
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :TIT01    WHERE PGM=:PGM01
        and LIBEL= 'TITRE';
         if (sqlcode <> 0) ;
          msg  = 'Erreur de Modification' + SQLERRMC + SQLERRP    ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
         else                          ;
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :LIG01 WHERE PGM=:PGM01
        and LIBEL= 'LIG1';
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :LIG02 WHERE PGM=:PGM01
        and LIBEL= 'LIG2';
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :LIG03 WHERE PGM=:PGM01
        and LIBEL= 'LIG3';
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :SQL01 WHERE PGM=:PGM01
        and LIBEL= 'SQL1';
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :WHE01 WHERE PGM=:PGM01
        and LIBEL= 'WHERE';
          wpgm01 = opt01 + trt01 + posparm + lenparm + possel ;
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :wpgm01 WHERE PGM=:PGM01
        and LIBEL= 'TRAIT';
         EXEC SQL
        UPDATE SUBFILE SET TEXTE = :wpre01 WHERE PGM=:PGM01
        and LIBEL= 'PRE01';
        endif ;
                   when  type = '4' ;
        //
        //  Supression Paramétrage
        //
         EXEC SQL
        DELETE FROM SUBFILE WHERE PGM = :PGM01;
         if (sqlcode <> 0) ;
          msg =  'Erreur de Supression '  ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
         endif ;
                   endsl ;
              ENDSR  ;
      /end-free
