DROP TRIGGER ware_price_trigger ON ware;
DROP FUNCTION update_ware_price();

DROP TRIGGER check_angeworben_date_trigger ON angeworben;
DROP FUNCTION check_angeworben_date();

drop view AnnualSalesVolume;
drop view AllRecruits;
drop view AllRecruitionSteps;

ALTER TABLE Mitarbeiterin DROP CONSTRAINT fk_filialnr;
ALTER TABLE Filiale DROP CONSTRAINT fk_kassanr ;

DROP TABLE schult;
DROP TABLE angeworben;
DROP TABLE hergestellt;
DROP TABLE enthaelt;
DROP TABLE ware;
DROP TABLE produktion;
DROP TABLE versandlager;
DROP TABLE rechnung;
DROP TABLE kassa;
DROP TABLE filiale;
DROP TABLE mitarbeiterin;

DROP TYPE ModellEnum;

DROP SEQUENCE seq_fnr;
DROP SEQUENCE seq_knr;