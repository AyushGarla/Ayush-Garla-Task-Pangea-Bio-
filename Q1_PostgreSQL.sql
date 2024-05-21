select compound_name,drug_type,pubchem_cid,iupac_name,smiles,use  from (
select use_category,lower(notes) as use,use_subcategory,drug_type from naeb_uses_table ut
left join (select id,name as drug_type from naeb_use_subcategories_table
	where name ='Analgesic')ust
on ut.use_subcategory = ust.id
	where drug_type ='Analgesic'
	)oo
left join (select np_id,compound_name,iupac_name, pubchem_cid FROM (
	SELECT np_id, LOWER(pref_name) AS compound_name, iupac_name, pubchem_cid FROM npass_compound_table
) oi
	where compound_name like '%ache%' or compound_name like '%pain%' or compound_name like '%cramp%' or compound_name like '%sore%' or compound_name like '%aspi%'  
 )nct
on EXISTS (
        SELECT 1
        FROM generate_series(1, length(oo.use) - 3) AS i
        WHERE nct.compound_name LIKE '%' || SUBSTRING(oo.use FROM i FOR 4) || '%'
    )
    OR
    EXISTS (
        SELECT 1
        FROM generate_series(1, length(nct.compound_name) - 3) AS j
        WHERE oo.use LIKE '%' || SUBSTRING(nct.compound_name FROM j FOR 4) || '%'
    )
left join (select * from npass_structure_table) nst
on nct.np_id=nst.np_id