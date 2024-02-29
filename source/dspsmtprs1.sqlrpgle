     h
      *----------------------------------------------------------------------------*
      * Affichage des envois SMTP interogation du journal de l'as400               *
      *                                                                            *
      * Parametres :                                                               *
      *  Sortie                                                                    *
      *    *DSP  Affichage à l'écran                                               *
      *    *FILE Sortie dans un fichier  DSPSMTPP de qtemp                         *
      *                                                                            *
      *                                                                            *
      *----------------------------------------------------------------------------*
     FDSPSMTPE  cf   e             workstn SFILE(sfl01:cle01)
     d emission        s             29
     d emetteur        s             50
     d recepteur       s             70
     d fichier         s             50
     d avis            s             50
     d date            s             10
     d heure           s             10
     d rep             s              1
     d sortie          s              5
     d cle01           s              4  0
      * Paramètres  en entrée
     c     *entry        plist
     c                   parm                    sortie
     c                   parm                    DATDEB
     c                   parm                    TIMDEB
     c                   parm                    DATFIN
     c                   parm                    TIMFIN
     c*
     c/free
       // generation de la requetes
       exec sql
       declare curs01 cursor for
       with
       T1 (Tranid, Subtype, detail, date, heure) as
       (select substr(joesd, 39, 29),
               substr(joesd, 70, 2),
               translate(substr(joesd, 75, 50), '@', 'à'),
               JODATE,
               jotime
        from          logmail
        where substr(joesd, 70, 2) = 'E1'
       ),
       T2 (Tranid, Subtype, detail) as
       (select substr(joesd, 39, 29),
               substr(joesd, 70, 2),
               translate(substr(joesd, 75, 70), '@ ', 'à>')
        from          logmail
        where substr(joesd, 70, 2) = 'E2'
       ),
       T3 (Tranid, Subtype, detail) as
        (select substr(joesd, 39, 29),
                substr(joesd, 72, 2),
                substr(joesd, 73, 50)
         from          logmail
         where substr(joesd, 70, 2) = 'EX'
        ),
       T4 (Tranid, Subtype, detail) as
       (select substr(joesd, 39, 29),
              substr(joesd, 70, 2) ,
              substr(joesd, 73, 50)
       from          logmail
       where substr(joesd, 70, 2) = '88'
       )
       select          ifnull(T1.Tranid, 'inconnu') as emission,
                       ifnull(T1.detail, 'inconnu') as emetteur ,
                       ifnull(T2.detail, 'inconnu') as recepteur,
                       ifnull(t3.detail, 'inconnu') as fichier  ,
                       ifnull(t4.detail, ' ') as avis     ,
                       ifnull(t1.DATE, '010101') as date ,
                       ifnull(t1.heure, '010101') as heure
       from T1 Left outer join T2         on   T1.Tranid=T2.Tranid
               Left outer join t3         on T1.Tranid=T3.Tranid
               Left outer join t4         on T1.Tranid=T4.Tranid
        ;
       exec sql
         Open curs01
        ;
        //
        // traitement à L'écran
        //
        if sortie = '*DSP' ;
          // initialisation
          opt01 = ' ' ;
          *in40 = *on ;
          cle01 = 0   ;
          write ctl01 ;
          *in40 = *off;
          // chargement
          dou sqlcode <> 0 ;
         exec sql
           fetch curs01 into  :emission,
                              :emetteur,
                              :recepteur,
                              :fichier,
                              :avis,
                              :date,
                              :heure
          ;

            if        sqlcod =  0   ;
            //mappage des zones
            wdate = date            ;
            wheure = heure          ;
            wemetteur =   %SUBST(emetteur : 1 : 20) ;
            wrecepteur =  %SUBST(recepteur : 1 : 20) ;
            wavis      =  %SUBST(avis : 1 : 20) ;
            wid        =  emission              ;
              if cle01 = 9999       ;
               chain cle01 sfl01      ;
                       WDATE      = '999999'    ;
                       WHEURE     = '999999'    ;
                       WEMETTEUR  = 'Trop de' ;
                       WRECEPTEUR = 'Sélection';
                       WAVIS      = 'Affinez'  ;
               update sfl01         ;
               *in88 = *on          ;
              leave                 ;
              endif                 ;
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
          //
            dou  *in03 = *on        ;
              write     fmt01         ;
              exfmt     ctl01         ;
              if not *in03            ;
                if *in15              ;
                  exsr sortie_fic     ;
                if *in41                ;
                  dou  not %eof           ;
                    readc sfl01             ;
                    if  %eof                 ;
                    leave                  ;
                    else                   ;
        /end-free
     c                   call      'DSPSMTPR1'                          64
     c                   parm                    wid
      /free
                    if *in64 ;
                      dsply 'donnée non affichable dans la log' ' ' rep ;
                      leave                                     ;
                    endif                                       ;
                    opt01 = ' '            ;
                    update  sfl01          ;
                    endif                  ;
                  enddo                   ;
                endif                  ;
              endif                  ;
            enddo                   ;
          else                   ;
        //
        // traitement dans un fichier
        //
            begsr sortie_fic        ;
          endif                  ;
         // fin du programme
       exec sql
         close curs01
        ;
        *inlr = *on;
        //
        // sous programme d'ecriture dans un fichier
        //
        begsr sortie_fic ;
       exec sql
          CREATE TABLE QTEMP/DSPSMTPP (
          WDATE CHAR ( 6) NOT NULL WITH DEFAULT,
          WHEURE CHAR ( 6) NOT NULL WITH DEFAULT,
          WEMETTEUR CHAR ( 50) NOT NULL WITH DEFAULT,
          WRECEPTEUR CHAR ( 70) NOT NULL WITH DEFAULT,
          WAVIS CHAR ( 30) NOT NULL WITH DEFAULT)
        ;
        exec sql
          delete  from QTEMP/DSPSMTPP
        ;
          dou sqlcode <> 0 ;
         exec sql
           fetch curs01 into  :emission,       // pas utilise en fichier
                              :emetteur,      //
                              :recepteur,     //
                              :fichier,        //
                              :wavis,          //
                              :wdate,          //
                              :wheure          // pas utilise en fichier
          ;
          if sqlcode = 0 ;
         exec sql
          INSERT INTO QTEMP/DSPSMTPP VALUES(:WDATE, :WHEURE ,
           :EMETTEUR ,  :RECEPTEUR ,  :WAVIS )
        ;
          endif                  ;
          enddo                  ;
        endsr     ;
      /end-free
