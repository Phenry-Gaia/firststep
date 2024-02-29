      *----------------------------------------------------------------------------
      *
      *  Ce programme génére une data structure en cl à partir des zones d'un fichier
      *
      *   recoit 2 parametres
      *            fichier 10 alpha
      *            bibliothèque 10 alpha
      *
      *----------------------------------------------------------------------------
     H ALWNULL(*INPUTONLY)
     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
     Fqclsrc    O    E             DISK    rename(qclsrc   :qclsrcf  )
     D* prototypage des procédures
     D gendsclpr       PR
     D                               10
     D                               10
     D gendsclpr       PI
     D   P_file                      10
     D   P_lib                       10
     d* variable de travail
     dsqlstm           s            908
     dw_len            s              8  0
     dw_pos            s              8  0
     d w_fld         e DS                    extname(QADBIFLD)
     d*
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
       //
       //  Génération entete DS
       //
         exec sql
       SELECT  DBIFMT,    sum( DBIILN )
               into :dbifmt , :w_len
         FROM QADBIFLD
         WHERE DBILIB = :P_Lib and DBIFIL = :p_file
         GROUP BY dbifmt ;
         if sqlcode = 0  ;
         srcdta = 'DCL &W_' + dbifmt  + '*char len(' + %char(w_len) + ')' ;
         exsr ecr_clp ;
         w_pos = 1 ;
        //----------------------------------------
        //  Génération détail des zones
        //----------------------------------------
         exec sql
         Declare curs01 cursor for
         SELECT DBIFMT, DBIFLD, DBIITP,
                ifnull(DBIILN, 0) as DBIILN,
                ifnull(DBINSC, 0) as DBINSC
               FROM QADBIFLD
             WHERE  DBILIB = :P_Lib and DBIFIL = :p_file  ;
         exec sql
             open curs01                          ;
          DOU sqlcode <> 0 ;
              exec sql
                fetch
                  from curs01
                  into :DBIFMT, :DBIFLD, :DBIITP, :DBIILN, :DBINSC ;
                if sqlcode <> 0                   ;
                  leave                           ;
                endif                             ;
          //---------------------------------------------
          // ecriture ligne detail
          //---------------------------------------------
          // type alpha
         select ;
         //
         when DBIITP = 'A' ;                      // alpha
           srcdta = 'DCL &W_' + DBIFLD  + '*char len(' + %char(DBIILN) +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')' ;
         //
         when DBIITP = 'P' or   DBIITP = 'S'   ;  // numérique
           srcdta = 'DCL &W_' +   DBIFLD  + '*dec  len(' + %char(  DBIILN) +
           ' ' + %char(DBINSC) +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         when DBIITP = 'L'                     ;  // Date
           srcdta = 'DCL &W_' +   DBIFLD  + '*char len(10' +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         when DBIITP = 'T'                     ;  // Time
           srcdta = 'DCL &W_' +   DBIFLD  + '*char len(08' +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         when DBIITP = 'B'                     ;  // Integer
           srcdta = 'DCL &W_' +   DBIFLD  + '*dec  len(09 0' +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         when DBIITP = '5'                     ;  // Binaire
           srcdta = 'DCL &W_' +   DBIFLD  + '*char len(1' +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         when DBIITP = 'Z'                     ;  // Horodatage
           srcdta = 'DCL &W_' +   DBIFLD  + '*char len(26' +
           ')  STG(*DEFINED)  DEFVAR(&w_' + dbifmt + ' ' + %char(w_pos) + ')'  ;
         //
         other  ;                                 // Autres  cas
           srcdta = '/* TYPE ' +  DBIITP  +
           ' Non traité  zone ' +  DBIFLD + '  */ ';
        //
         endsl ;
         exsr ecr_clp ;
         w_pos = w_pos + DBIILN ;
          enddo ;
          endif ;
        //
        // Fin du programme
        //
         exec sql
             close curs01                          ;
          *inlr = *on ;
        //-----------------------------------------------
        // Ecriture dans le source
        //-----------------------------------------------
        begsr ecr_clp ;
          srcseq = srcseq + 5 ;
          srcdta = '   ' + srcdta ;
          write Qclsrcf       ;
        endsr  ;
      /end-free
