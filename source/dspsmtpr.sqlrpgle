     h DFTACTGRP(*NO)
     h ACTGRP(*NEW)
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
     d* declaration des zones du curseur
     d*
     dtype_mail        s              3
     dnumero           s             30
     demetteur         s             50
     drecepteur        s             50
     dstatus           s              9
     ddat_mail         s              6  0
     dhre_mail         s              8  0
     djob_mail         s             10
     dpgm_mail         s             10
     dusr_mail         s             10
     d*
     d heure           s             10
     d rep             s              1
     d sortie          s              5
     d cle01           s              4  0
     d* affichage fenetre d'erreur
     D POPUP           PR                  ExtPgm('QUILNGTX')
     D   text                     65535a   const options(*varsize)
     D   length                      10i 0 const
     D   msgid                        7a   const
     D   qualmsgf                    20a   const
     D   errorCode                32783a   options(*varsize)
     d*
     d   msg           s            132a
     D ErrorNull       ds                  qualified
     D   BytesProv                   10i 0 inz(0)
     D   BytesAvail                  10i 0 inz(0)
      * Paramètres  en entrée
     c     *entry        plist
     c                   parm                    sortie
     c                   parm                    DATDEB
     c                   parm                    TIMDEB
     c                   parm                    DATFIN
     c                   parm                    TIMFIN
     c*
     c/free
       exec sql
       select substr(joesd, 79, 25)     into :esmtp
       from logmail
        where substr(joesd, 70, 02) = '88'
        FETCH FIRST ROW ONLY           ;
       // Géneration de la requetes
       exec sql
       declare curs01 cursor for
       SELECT
        'IP'                                                as type_mail,
       cast(substr(a.joesd, 39, 30) as char (30) CCSID 297) as numero,
       cast(replace( substr(B.JOESD, 75, 50), 'à', '@')
                            as char (50) CCSID 297)         as emetteur,
       cast(translate( substr(c.JOESD, 76, 50),  '@ ', 'à>')
                            as char (50) CCSID 297)         as recepteur,
       cast(ifnull(substr(d.JOESD, 73, 06), 'NOT DLVED' )
                             as char (09) CCSID 297)        as status,
        A.JODATE  as dat_mail ,
        A.JOTIME  as hre_mail ,
        A.JOJOB   as job_mail ,
        A.JOPGM   as pgm_mail ,
        A.JOUSER  as usr_mail
        FROM logmail a join logmail b on
       substr(a.joesd, 39, 30) = substr(b.joesd, 39, 30)
       and  substr(b.joesd, 70, 02) = 'C1'
       join logmail c on
       substr(a.joesd, 39, 30) = substr(c.joesd, 39, 30)
       and  substr(c.joesd, 70, 02) = 'C2'
       Left outer join  logmail d on
       substr(a.joesd, 39, 30) = substr(d.joesd, 39, 30)
       and  substr(d.joesd, 70, 02) = '88'
        WHERE a.JOESD
       like('%SNDMAIL TO MSF%')
       union
       -- selection mail SNA
       SELECT
       'SNA'                                                as type_mail,
       cast(substr(a.joesd, 39, 30) as char (30) CCSID 297) as numero,
       cast(replace( substr(B.JOESD, 75, 50), 'à', '@')
                            as char (50) CCSID 297)         as emetteur,
       cast(translate( substr(c.JOESD, 76, 50),  '@ ', 'à>')
                            as char (50) CCSID 297)         as recepteur,
       cast(ifnull(substr(d.JOESD, 73, 06), 'NOT DLVED' )
                             as char (09) CCSID 297)        as status,
        A.JODATE  as dat_mail ,
        A.JOTIME  as hre_mail ,
        A.JOJOB   as job_mail ,
        A.JOPGM   as pgm_mail ,
        A.JOUSER  as usr_mail
        FROM logmail a join logmail b on
       substr(a.joesd, 39, 30) = substr(b.joesd, 39, 30)
       and  substr(b.joesd, 70, 02) = 'C1'
       join logmail c on
       substr(a.joesd, 39, 30) = substr(c.joesd, 39, 30)
       and  substr(c.joesd, 70, 02) = 'C2'
       Left outer join  logmail d on
       substr(a.joesd, 39, 30) = substr(d.joesd, 39, 30)
       and  substr(d.joesd, 70, 02) = '88'
        WHERE a.JOESD
       like('%INTERNETGATEWAY%')
       order by
            dat_mail ,
            hre_mail
               ;
       exec sql
         Open curs01
        ;
        //
        // traitement à L'écran
        //
        if sortie = '*DSP' ;                                         //if01
          // initialisation
          opt01 = ' ' ;
          *in40 = *on ;
          cle01 = 0   ;
          write ctl01 ;
          *in40 = *off;
          // chargement
          dou sqlcode <> 0 ;                                         //do02
         exec sql
           fetch curs01 into  :type_mail,
                              :numero,
                              :emetteur,
                              :recepteur,
                              :status,
                              :dat_mail,
                              :hre_mail,
                              :job_mail,
                              :pgm_mail,
                              :usr_mail
          ;

            if        sqlcod =  0   ;                                //if03
            //mappage des zones
            etype_mail =       type_mail ;
            enumero    =       numero    ;
            eemetteur  =       emetteur  ;
            erecepteur =       recepteur ;
            estatus    =       status    ;
            edat_mail  =       dat_mail  ;
            ehre_mail  =       hre_mail  ;
            //
            // Controle limite du sous fichier
            //
              if cle01 = 9999       ;                                //if04
               chain cle01 sfl01      ;
            etype_mail =       '***' ;
            eemetteur  =       'Trop de'  ;
            erecepteur =       'Sélection ' ;
            estatus    =       'Affinez.';
            edat_mail  =        99999999               ;
            ehre_mail  =        999999   ;
               update sfl01         ;
               *in88 = *on          ;
              leave                 ;
              endif                 ;                                //ei04
             // ecriture de l'enreg
              cle01 = cle01 + 1     ;
              if  estatus = 'DLVED' ;
                *in98=*off          ;
              else                  ;
                *in98=*on           ;
              endif                 ;
              write     sfl01       ;
            endif                   ;                                //ei03
          enddo                     ;                                //ed02
          *in43 = *on ;
          // affichage
          *in42  = *on ;
            if        cle01  >  0   ;                                //if02
              *in41 =    *on        ;
            else                    ;
              *in41 = *off          ;
            endif                   ;                                //ei02
          //
            dou  *in03 = *on        ;                                //do02
              write     fmt01         ;
              exfmt     ctl01         ;
              if not *in03            ;                              //if03
                if *in15              ;                              //if04
                  exsr sortie_fic     ;
              msg  = 'Fichier DSPSMTPP créer dans QTEMP. ' ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
                else                  ;
                if *in41                ;                            //if05
                  dou  not %eof           ;                          //do06
                    readc sfl01             ;
                    if  %eof                 ;                       //if07
                    leave                  ;
                    else                   ;                         //el07
        /end-free
     c                   call      'DSPSMTPR1'                          64
     c                   parm                    enumero
      /free
                    if *in64 ;                                       //if08
                      dsply 'donnée non affichable dans la log' ' ' rep ;
                      leave                                     ;
                    endif                                       ;    //ei08
                    opt01 = ' '            ;
                    update  sfl01          ;
                    endif                  ;                         //ei07
                  enddo                   ;                          //ed06
                endif                  ;                             //ei05
              endif                   ;
              endif                  ;                               //ei04
            enddo                   ;                                //ed03
          else                   ;                                   //el02
        //
        // traitement dans un fichier
        //
              exsr  sortie_fic        ;
              msg  = 'Fichier DSPSMTPP créer dans QTEMP. ' ;
            POPUP   ( msg : %len(msg) : ' ' : ' ' : ErrorNull );
            endif                  ;                                 //ei02
         // fin du programme
       exec sql
         close curs01
        ;
        *inlr = *on;
        //--------------------------------------------------
        // sous programme d'ecriture dans un fichier
        //--------------------------------------------------
        begsr sortie_fic ;
       exec sql
       drop   table qtemp/dspsmtpp ;
              exec sql
       create table qtemp/dspsmtpp as (
       SELECT
        'IP'  as type_mail,
       cast(substr(a.joesd, 39, 30) as char (30) CCSID 297) as numero,
       cast(replace( substr(B.JOESD, 75, 50), 'à', '@')
                            as char (50) CCSID 297)   as emetteur,
       cast(translate( substr(c.JOESD, 76, 50),  '@ ', 'à>')
                            as char (50) CCSID 297)   as recepteur,
       cast(ifnull(substr(d.JOESD, 73, 06), 'NOT DLVED' )
                             as char (09) CCSID 297)   as status,
        A.JODATE  as dat_mail ,
        A.JOTIME  as hre_mail ,
        A.JOJOB   as job_mail ,
        A.JOPGM   as pgm_mail ,
        A.JOUSER  as usr_mail
        FROM logmail a join logmail b on
       substr(a.joesd, 39, 30) = substr(b.joesd, 39, 30)
       and  substr(b.joesd, 70, 02) = 'C1'
       join logmail c on
       substr(a.joesd, 39, 30) = substr(c.joesd, 39, 30)
       and  substr(c.joesd, 70, 02) = 'C2'
       Left outer join  logmail d on
       substr(a.joesd, 39, 30) = substr(d.joesd, 39, 30)
       and  substr(d.joesd, 70, 02) = '88'
        WHERE a.JOESD
       like('%SNDMAIL TO MSF%')
       union
       -- selection mail SNA
       SELECT
       'SNA'  as type_mail,
       cast(substr(a.joesd, 39, 30) as char (30) CCSID 297) as numero,
       cast(replace( substr(B.JOESD, 75, 50), 'à', '@')
                            as char (50) CCSID 297)   as emetteur,
       cast(translate( substr(c.JOESD, 76, 50),  '@ ', 'à>')
                            as char (50) CCSID 297)   as recepteur,
       cast(ifnull(substr(d.JOESD, 73, 06), 'NOT DLVED' )
                             as char (09) CCSID 297)   as status,
        A.JODATE  as dat_mail ,
        A.JOTIME  as hre_mail ,
        A.JOJOB   as job_mail ,
        A.JOPGM   as pgm_mail ,
        A.JOUSER  as usr_mail
        FROM logmail a join logmail b on
       substr(a.joesd, 39, 30) = substr(b.joesd, 39, 30)
       and  substr(b.joesd, 70, 02) = 'C1'
       join logmail c on
       substr(a.joesd, 39, 30) = substr(c.joesd, 39, 30)
       and  substr(c.joesd, 70, 02) = 'C2'
       Left outer join  logmail d on
       substr(a.joesd, 39, 30) = substr(d.joesd, 39, 30)
       and  substr(d.joesd, 70, 02) = '88'
        WHERE a.JOESD
       like('%INTERNETGATEWAY%')
       order by
            dat_mail ,
            hre_mail
       ) with data   ;
        endsr     ;
      /end-free
