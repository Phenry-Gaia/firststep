**FREE
//
// affichage lsoutput fichier de répertoire distant
//
  ctl-opt
    DFTACTGRP(*NO) ;
  dcl-f
    lstrmte   WORKSTN
    SFILE(sfl01:cle01);
  dcl-f
    lsoutput usage(*input) prefix(f)
    rename(lsoutput:lsoutpuf) ;
  Dcl-Pi *N;
  P_RMTSYS         Char(60);
  P_RMTrep         Char(50);
  End-Pi;
  // déclaration SDS
  dcl-ds *N PSDS;
  init_user  CHAR(10) POS(254);
  end-ds;
  dcl-s cle01 PACKED(4 : 0) ;
  dcl-s error ind ;
  dcl-s w_Ret    char(45);
  DCL-PR  Touche_F4 EXTPGM('TOUCHE_F4');
     p_Sql char(1024) ;
     p_Titre char(35);
     p_Ret    char(45);
  END-PR;
  // controle FTP
        // Initialisation du sous fichier
       Init() ;
        // chargement
       Charge() ;
        // Affichage
       Affichage() ;
         // fin du programme
         //
        *inlr = *on;
        //
        //
     dcl-proc init ;
        // initialisation
        if %open(lsoutput );
          close lsoutput  ;
        endif ;
        //
        if not %open(lsoutput ) ;
          open lsoutput  ;
        endif ;
        opt01 = ' ' ;
        *in40 = *on ;
        cle01 = 0   ;
        write ctl01 ;
        *in40 = *off;
     end-proc;
     dcl-proc charge     ;
        dou %eof(lsoutput ) ;
        read   lsoutput  ;
          if not   %eof(lsoutput ) ;
            cle01 = cle01 + 1     ;
        // information du histo
        lsout70 = %subst(flsoutput : 1 : 70) ;
            write     sfl01       ;
          endif                   ;
        enddo                     ;
     end-proc;
     dcl-proc affichage  ;
        *in43 = *on ;
        // affichage
        *in42  = *on ;
          if        cle01  >  0   ;
            *in41 =    *on        ;
          else                    ;
            *in41 = *off          ;
          endif                   ;
        //
          dou  *in03 = *on        ;
            write     fmt01         ;
            exfmt     ctl01         ;
            if not *in03            ;
        // rechargement
              select               ;
              when *in05            ;
                close(e) lsoutput  ;
                open lsoutput     ;
                Init() ;
                Charge() ;
                Affichage() ;
        // création histo
              other ;
                if *in41                ;
                  dou %eof           ;
                    readc sfl01             ;
                    if  %eof                 ;
                      leave                  ;
                    else                   ;
                      Trt_det()            ;
                    opt01 = ' '            ;
                    update  sfl01          ;
                    endif                  ;
                  enddo                   ;
                endif                  ;
              endsl ;
            endif                  ;
          enddo                   ;
     end-proc ;
     //
     // traitement détail
     //
     dcl-proc trt_det        ;
       if opt01 =  '9' ;
       dsply 'proc';
       endif;
      // boucle si pas f12
     end-proc ;
