--
-- Création du fichiers des sous fichiers
--
DROP TABLE  SUBFILE ;
CREATE TABLE SUBFILE (
  PGM CHAR(10) CCSID 297 NOT NULL DEFAULT '' ,
  LIBEL CHAR(10) CCSID 297 NOT NULL DEFAULT '' ,
  TEXTE CHAR(500) CCSID 297 NOT NULL DEFAULT '' ,
  CONSTRAINT SUBFILEL0  PRIMARY KEY (PGM, LIBEL));

LABEL ON TABLE SUBFILE  IS
'PARAMETRAGE DES SFL';

LABEL ON COLUMN SUBFILE  (
PGM    IS 'Nom                 Programme',
LIBEL  IS 'Libellé             Option   ',
TEXTE  IS 'Données             Texte    ', ) ;
