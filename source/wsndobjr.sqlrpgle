     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
      *-----------------------------------------------------------
      *
      *-----------------------------------------------------------
     FWsndobjd  cf   e             workstn SFILE(sfl01:cle01)
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
     c/free
        *in05 = *on          ;
        dou not *in05        ;
       exec sql
         select   count(*) into :nbrsnd
         from  wsndobjp       ;
       exec sql
       declare curs03 cursor for
         select   SNDOBJ   ,
                  SNDLIB   ,
                  SNDTYP   ,
                  substr(Sndsys, 1, 12)   ,
                  Sndsys  ,
                  SNDcom  ,
                  sndusr  ,
                  sndlibr
         from  wsndobjp    ;
       exec sql
         Open curs03  ;
        // initialisation
        *in40 = *on ;
        cle01 = 0   ;
        write ctl01 ;
        *in40 = *off;
        // chargement
        dou sqlcode <> 0 ;

       exec sql
         fetch curs03 into
                 :SNDOBJ   ,
                 :SNDLIB   ,
                 :SNDTYP   ,
                 :syt01                  ,
                 :sndsys   ,
                 :SNDcom  ,
                 :sndusr  ,
                 :Sndlibr   ;
          if        sqlcod =  0   ;
          //mappage des zones
            cle01 = cle01 + 1     ;
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
          write(e)  fmt01         ;
         if %error ;
          dsply 'Données incorrectes'         ;
         endif ;
        dou *in03  or *in05   ;
          exfmt     ctl01         ;
         if not *in03 and not *in05 ;
          select  ;
          when *in06 ;
           clear fmt02      ;
           *in65 = *off     ;
           lib02 = 'Création' ;
           exfmt fmt02      ;
           if  not *in12   ;
           sndsys  = sndsys1 + sndsys2;
       exec sql
       INSERT INTO WSNDOBJP VALUES(:SNDcom , :sndsys , :sndusr ,
       :sndobj   ,  :sndlib, :sndtyp, :sndlibr) ;
           endif  ;
          when *in10 ;
           cmdexec = '?wsndobj' ;
           exsr execcmd  ;
          other      ;
           readc sfl01      ;
           if not %eof( ) ;
             exsr Traitement  ;
           endif        ;
          endsl       ;
         endif        ;
        enddo   ;
       exec sql
         close curs03  ;
         enddo ;
        *inlr = *on;
        //
        // sous programme  de traitement
        //
        begsr traitement;
          //
          // calcul du code lieux
          //
           sndsys1 = %subst(sndsys:  1: 40) ;
           sndsys2 = %subst(sndsys: 41: 40) ;
          select ;
           when    opt01  = '4' ;
           *in65 = *on   ;
           lib02 = 'Supression' ;
            exfmt fmt02  ;
           if not *in12    ;
       exec sql
       delete from WSNDOBJP where   SNDcom = :sndcom
                            and     sndsys = :sndsys
                            and     sndobj = :sndobj
                            and     sndlib = :sndlib
                            and     sndtyp = :sndtyp ;
           endif  ;
       sndcom = 'Suppr';
           when    opt01  = '3' ;
           *in65 = *off     ;
           lib02 = 'Dupplication' ;
           exfmt fmt02      ;
           if  not *in12   ;
           sndsys  = sndsys1 + sndsys2;
       exec sql
       INSERT INTO WSNDOBJP VALUES(:SNDcom , :sndsys , :sndusr ,
       :sndobj   ,  :sndlib, :sndtyp, :sndlibr) ;
           endif  ;
          endsl;
          opt01 = ' ' ;
          update sfl01  ;
        endsr      ;
        begsr  execcmd ;
                 monitor                          ;
                 cmd(cmdexec:%LEN(cmdexec))       ;
                 On-error;
                    dsply 'Erreur sur commande ... ';
                 Endmon;
        endsr      ;
      /end-free
