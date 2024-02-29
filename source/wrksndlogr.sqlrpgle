     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
      *-----------------------------------------------------------
      *
      *-----------------------------------------------------------
     FWRKSNDLOGDcf   e             workstn SFILE(sfl01:cle01)
     dcmdexec          s           4096
     d cle01           s              4  0
     d sndsys          s             80
     d systemeDS      SDS
     d user                          10     overlay(systemeDS:254)
     d dateexec                       6s 0  overlay(systemeDS:276)
     d heureexec                      6s 0  overlay(systemeDS:282)
     d* prototypage pour programme qcmdexc
     DCmd              PR                  EXTPGM('QCMDEXC')
     D PR_CmdStr                   4096A   CONST OPTIONS(*VARSIZE)
     D PR_CmdStrLen                  15P 5 CONST
     D WRKSNDLOGR      PR
     D                               10
     D WRKSNDLOGR      PI
     D   Puser                       10
     c/free
       if puser <> '*CURRENT' ;
        user = Puser           ;
       endif                  ;
        NUM01 = 1            ;
        *in05 = *on          ;
        dou not *in05        ;
       if puser =  '*ALL' ;
       exec sql
         select   count(*) into :nbrsnd
         from   sndobjp   ;
       else ;
       exec sql
         select   count(*) into :nbrsnd
         from   sndobjp
         where EUSER = :user   ;
       endif;
       if puser =  '*ALL' ;
       exec sql
       declare curs02 cursor for
         select   SNDOBJ   ,
                  SNDLIB   ,
                  SNDTYP   ,
                  SNDDATE  ,
                  EUSER    ,
                  substr(Sndsys, 1, 12)   ,
                  SNDTIME ,
                  Sndsys  ,
                  SNDcom  ,
                  sndusr  ,
                  Sndlibr ,
                   LIB01  ,
                   PSTATUS
         from   sndobjp
         order by snddate desc, sndtime desc  ;
         else  ;
       exec sql
       declare curs03 cursor for
         select   SNDOBJ   ,
                  SNDLIB   ,
                  SNDTYP   ,
                  SNDDATE  ,
                  EUSER    ,
                  substr(Sndsys, 1, 12)   ,
                  SNDTIME ,
                  Sndsys  ,
                  SNDcom  ,
                  sndusr  ,
                  Sndlibr ,
                   LIB01  ,
                   PSTATUS
         from   sndobjp
         where EUSER = :user
         order by snddate desc, sndtime desc ;
         endif ;
       if puser =  '*ALL' ;
       exec sql
         Open curs02  ;
         else         ;
       exec sql
         Open curs03  ;
         endif        ;
        // initialisation
        *in40 = *on ;
        cle01 = 0   ;
        write ctl01 ;
        *in40 = *off;
        // chargement
        dou sqlcode <> 0 ;

       if puser =  '*ALL' ;
       exec sql
         fetch curs02 into
                 :SNDOBJ   ,
                 :SNDLIB   ,
                 :SNDTYP   ,
                 :SNDDATE  ,
                 :EUSER    ,
                 :syt01                  ,
                 :SNDTIME  ,
                 :sndsys   ,
                 :SNDcom  ,
                 :sndusr  ,
                 :Sndlibr ,
                 :LIB01   ,
                 :PSTATUS ;
       else ;
       exec sql
         fetch curs03 into
                 :SNDOBJ   ,
                 :SNDLIB   ,
                 :SNDTYP   ,
                 :SNDDATE  ,
                 :EUSER    ,
                 :syt01                  ,
                 :SNDTIME  ,
                 :sndsys   ,
                 :SNDcom  ,
                 :sndusr  ,
                 :Sndlibr ,
                 :LIB01   ,
                 :PSTATUS ;
       endif ;
          if        sqlcod =  0   ;
          //mappage des zones
            cle01 = cle01 + 1     ;
            if pstatus = 'KO'     ;
            *in64 = *on           ;
            else ;
            *in64 = *off          ;
            endif ;
            write     sfl01       ;
          endif                   ;
        enddo                     ;
        *in43 = *on ;
        // affichage
        *in42  = *on ;
          if        cle01  >  0   ;
            *in41 =    *on        ;
          else                    ;
            *in41 = *off          ;
          endif                   ;
        dou *in03  or *in05   ;
          write(e)  fmt01         ;
          exfmt     ctl01         ;
         if not *in03 and not *in05 ;
          select  ;
          when *in06 ;
           cmdexec = '?SNDLIB' ;
           exsr  execcmd ;
          when *in07 ;
           cmdexec = '?SNDOBJ' ;
           exsr  execcmd ;
          when *in10 ;
           cmdexec = 'SNDLOG' ;
           exsr  execcmd ;
          other      ;
           readc sfl01      ;
           if not %eof( ) ;
             exsr Traitement  ;
           endif        ;
          endsl       ;
         endif        ;
        enddo   ;
       if puser =  '*ALL' ;
       exec sql
         close curs02  ;
       else ;
       exec sql
         close curs03  ;
       endif        ;
         enddo ;
        *inlr = *on;
        //
        // sous programme  de traitement
        //
        begsr traitement;
          //
          // calcul du code lieux
          //
          select ;
           when    opt01  = '5' ;
           sndsys1 = %subst(sndsys:  1: 40) ;
           sndsys2 = %subst(sndsys: 41: 40) ;
            exfmt fmt02  ;
           when    opt01  = '6' ;
           // une bibliothèque
           // si adresse ip
           if %scan('.' : sndsys ) > 0 ;
           sndsys = '''' + %trim(sndsys) + '''' ;
           endif;
           if SNDCOM = 'SNDLIB' ;
           cmdexec = '?SNDLIB SYS('+ sndsys + ') USER(' + sndusr +
                      ') LIB(' + sndlib + ')' ;
           exsr  execcmd ;
           endif ;
           // objet
           if SNDCOM = 'SNDOBJ' ;
           cmdexec = '?SNDOBJ SYS('+ sndsys + ') USER(' + sndusr + ') OBJ('
           + sndobj + ') LIB(' + sndlib + ') TYPE(' + sndtyp
           + ') RSTLIB(' + sndlibr + ')'   ;
           exsr  execcmd ;
           endif ;
          endsl;
          opt01 = ' ' ;
            if pstatus = 'KO'     ;
            *in64 = *on           ;
            else ;
            *in64 = *off          ;
            endif ;
            *in65 = *on           ;
          update sfl01  ;
            *in65 = *off          ;
           NUM01 = cle01          ;
        endsr      ;
        // ---------------------------------
        //  Traitement commande as400
        // ---------------------------------
        begsr  execcmd ;
                 monitor                          ;
                 cmd(cmdexec:%LEN(cmdexec))       ;
                 On-error;
                    dsply 'Erreur sur commande ... ';
                 Endmon;
        endsr      ;
      /end-free
