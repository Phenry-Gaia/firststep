     hDFTACTGRP(*NO)
     fqclsrc    o    e             disk    rename(qclsrc:qclsrcf)
     fqddssrc   o    e             disk    rename(qddssrc:qddssrcf)
     D GENCLR          PR
     D                               10
     D                               25
     D                               20
     D                               10
     D                                2  0
     D GENCLR          PI
     D  NOMPGM                       10
     D  TITPGM                       25
     D  TXTZON                       20
     D  NOMZON                       10
     D  LENZON                        2  0
      /free
       srcdat = udate ;
       // generation dspf
       srcseq = 0 ;
       srcdta = 'A*-------------------------------------------------------' ;
       exsr ecr_dsp ;
       srcdta = 'A*    Génération par GENCL                               ' ;
       exsr ecr_dsp ;
       srcdta = 'A*-------------------------------------------------------' ;
       exsr ecr_dsp ;
       srcdta = 'A                                      DSPSIZ(24 80 *DS3)' ;
       exsr ecr_dsp ;
       srcdta = 'A          R FMT01                                       ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                      CA03(03)          ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  1  2DATE              ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                      EDTCDE(Y)         ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  1 71USER              ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  2  2TIME              ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  2 26'''
                + titpgm + ''''                                             ;
       exsr ecr_dsp ;
       srcdta = 'A                                      DSPATR(HI)        ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  2 71SYSNAME           ' ;
       exsr ecr_dsp ;
       srcdta = 'A                                  7  5'''
                + txtzon + ' : '''                                          ;
       exsr ecr_dsp ;
       srcdta = 'A            FLD001         2A  B  7 45                  ' ;
                %subst(srcdta:14:10) = nomzon                               ;
                %subst(srcdta:28:02) = %char(lenzon)                        ;
       exsr ecr_dsp ;
       srcdta = 'A  45                                  '
                  + 'ERRMSG(''Vous devez saisir. '' 45)'                    ;
       exsr ecr_dsp ;
       srcdta = 'A                                 23  2''F3=Exit''       ' ;
       exsr ecr_dsp ;
       //
       // generation clp
       //
       srcseq = 0 ;
       srcdta = '/*--------------------------------------------*/ '         ;
        exsr ecr_clp       ;
       srcdta = '/* Génération par GENCLR                      */ '         ;
        exsr ecr_clp       ;
       srcdta = '/*--------------------------------------------*/ '         ;
        exsr ecr_clp       ;
       srcdta = 'PGM                                              '         ;
        exsr ecr_clp       ;
       srcdta = 'DCLF  ' + %trim(nompgm) + 'D                             ' ;
        exsr ecr_clp       ;
       srcdta = '           DOUNTIL    COND(&IN03)                '         ;
        exsr ecr_clp       ;
       srcdta = '           SNDRCVF    RCDFMT(FMT01)              '         ;
        exsr ecr_clp       ;
       srcdta = '           IF         COND(&IN03) THEN(LEAVE)    '         ;
        exsr ecr_clp       ;
       srcdta = '           IF COND(&NOMZONE    *NE   '' '')  THEN(DO) '    ;
                %subst(srcdta:21:10) = %trim(nomzon)                        ;
        exsr ecr_clp       ;
       srcdta = '/* ICI TRAITEMENT  */                            '         ;
        exsr ecr_clp       ;
       srcdta = '           ENDDO                                 '         ;
        exsr ecr_clp       ;
       srcdta = '           ELSE DO                               '         ;
        exsr ecr_clp       ;
       srcdta = '           CHGVAR &IN45 ''1''                    '         ;
        exsr ecr_clp       ;
       srcdta = '           ENDDO                                 '         ;
        exsr ecr_clp       ;
       srcdta = '           ENDDO                                 '         ;
        exsr ecr_clp       ;
       srcdta = 'ENDPGM                                           '         ;
        exsr ecr_clp       ;
        // fin du programme
        *inlr = *on ;
        // ecriture dspf
        begsr ecr_dsp ;
        srcseq  = srcseq + 5 ;
        srcdta = '     ' +srcdta ;
        write QDDSSRCf       ;
        endsr  ;
        // ecriture clp
        begsr ecr_clp ;
        srcseq = srcseq + 5 ;
        srcdta = '   ' +srcdta ;
        write Qclsrcf       ;
        endsr  ;
       /end-free
